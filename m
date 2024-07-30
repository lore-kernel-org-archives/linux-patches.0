Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956481A619E;
	Tue, 30 Jul 2024 16:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358357; cv=none; b=HoV3RyWhd+Vi+PK94bs/wi4sNfj8K0wx5lElkDb3sIDl+S/Ai1q+Z5zi1YhNS43NrTVF2gXY4be7mehAqj9zXiNQwBtGuC39jZtUbIPxuXZraNqeemVDc+55P9E7f5uxiIe8Yb0vUi4Tts4a5b4m5CURh3BMsQ+XrEp0zWXkqMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358357; c=relaxed/simple;
	bh=kHxy8q3tli3S824rO+hWbL35/AAhsKaBZAYr2nvWQG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oE9n11A7XGUwzS021sih9XpEDuw/obktcfU5vyzCs4YqNk8ocwGnEc299FYos1WQrVwx0SfuekU4a4qunDNBNvVhoH3mN4F7Z9daGhKlH+uPmjil0vbLLN2KmXk4AdfTHwAEYaGiBbdQAxtraX+G6wKwRIrVdN4H/KNXPHuogJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLy8iPbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLy8iPbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C76C4AF0C;
	Tue, 30 Jul 2024 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358357;
	bh=kHxy8q3tli3S824rO+hWbL35/AAhsKaBZAYr2nvWQG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLy8iPbhQvGE6Bve9NpnbUey0l+yXF3xDgfEtKWvTYpjqMyXgJLKhLO46FR7ZcL/T
	 NX4v9bqWItsQ/78rH/k2z0CXu/b09Hzy5WCoE3f85X4VfBCGbaLcjAS5xKBg1xPnxr
	 zYXOqma9BRQaAi7al4LZdi//YUGe2V28QCeBrGHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	syzbot+08ba1e474d350b613604@syzkaller.appspotmail.com,
	=?UTF-8?q?Sergio=20Gonz=C3=A1lez=20Collado?= <sergio.collado@gmail.com>
Subject: [PATCH 6.1 383/440] bpf: Synchronize dispatcher update with bpf_dispatcher_xdp_func
Date: Tue, 30 Jul 2024 17:50:16 +0200
Message-ID: <20240730151630.767677214@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 4121d4481b72501aa4d22680be4ea1096d69d133 upstream.

Hao Sun reported crash in dispatcher image [1].

Currently we don't have any sync between bpf_dispatcher_update and
bpf_dispatcher_xdp_func, so following race is possible:

 cpu 0:                               cpu 1:

 bpf_prog_run_xdp
   ...
   bpf_dispatcher_xdp_func
     in image at offset 0x0

                                      bpf_dispatcher_update
                                        update image at offset 0x800
                                      bpf_dispatcher_update
                                        update image at offset 0x0

     in image at offset 0x0 -> crash

Fixing this by synchronizing dispatcher image update (which is done
in bpf_dispatcher_update function) with bpf_dispatcher_xdp_func that
reads and execute the dispatcher image.

Calling synchronize_rcu after updating and installing new image ensures
that readers leave old image before it's changed in the next dispatcher
update. The update itself is locked with dispatcher's mutex.

The bpf_prog_run_xdp is called under local_bh_disable and synchronize_rcu
will wait for it to leave [2].

[1] https://lore.kernel.org/bpf/Y5SFho7ZYXr9ifRn@krava/T/#m00c29ece654bc9f332a17df493bbca33e702896c
[2] https://lore.kernel.org/bpf/0B62D35A-E695-4B7A-A0D4-774767544C1A@gmail.com/T/#mff43e2c003ae99f4a38f353c7969be4c7162e877

Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20221214123542.1389719-1-jolsa@kernel.org
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reported-by: syzbot+08ba1e474d350b613604@syzkaller.appspotmail.com
Signed-off-by: Sergio González Collado <sergio.collado@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/dispatcher.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -125,6 +125,11 @@ static void bpf_dispatcher_update(struct
 
 	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
 
+	/* Make sure all the callers executing the previous/old half of the
+	 * image leave it, so following update call can modify it safely.
+	 */
+	synchronize_rcu();
+
 	if (new)
 		d->image_off = noff;
 }


