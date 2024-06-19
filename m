Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FA014A0A7;
	Wed, 19 Jun 2024 13:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803531; cv=none; b=heNllOKJjjveKfEzrF3+Za5vqZ3zWixmGvgVNcpQk3SrdHcmubPeNtcy0F9vgmW1njfDtcfOdHaovqyTpqQyZom1cc9IE5sTfY2mVnC68SO7hhoYP6Ec1qJHlDakzzV4auLvpZUoYufmEBvYP1RV+a65zBjIsQrNvnFhlrrceRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803531; c=relaxed/simple;
	bh=oiB2hvtKPZKlLELQZzKeWe/sI9l48KzWgtgb93G7Fn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8CJmc0PyrhBxZYKOpDPLKsvrrFQpcbBuPWCOcto+A/FW0Z5feqqgykAivOUGK/cx9qzVc6EkQIAYEW9zBWOTCsnaPULXcAFGSrPnDbd256nP8Hh4oQ4Si28jTT6FJ0CElFp8Hhf8TPTH9HGBgU112/MXDqeXRL/eKacqDFJZOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUdB+DMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUdB+DMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1978BC4AF49;
	Wed, 19 Jun 2024 13:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803530;
	bh=oiB2hvtKPZKlLELQZzKeWe/sI9l48KzWgtgb93G7Fn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUdB+DMp24GdCpLEdg+ejhgPBqHBDzBX7fFvXjdwz0m8mzPBX2D3fyHX9xnjVjPDK
	 kYYWQl3XSap4mzQ5osUwDlou1+N3kGJkUGrh/k1zjKnDpwGmk7ScxsgLQhPJ6VNh/k
	 tbB3Nm0Z/iah+tv4oybuBGfaO1mR5QBIN/IqrMTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ab78ff125b7979e45f9@syzkaller.appspotmail.com,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/217] bpf: Set run context for rawtp test_run callback
Date: Wed, 19 Jun 2024 14:54:20 +0200
Message-ID: <20240619125557.308127898@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit d0d1df8ba18abc57f28fb3bc053b2bf319367f2c ]

syzbot reported crash when rawtp program executed through the
test_run interface calls bpf_get_attach_cookie helper or any
other helper that touches task->bpf_ctx pointer.

Setting the run context (task->bpf_ctx pointer) for test_run
callback.

Fixes: 7adfc6c9b315 ("bpf: Add bpf_get_attach_cookie() BPF helper to access bpf_cookie value")
Reported-by: syzbot+3ab78ff125b7979e45f9@syzkaller.appspotmail.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Closes: https://syzkaller.appspot.com/bug?extid=3ab78ff125b7979e45f9
Link: https://lore.kernel.org/bpf/20240604150024.359247-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 6094ef7cffcd2..64be562f0fe32 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -841,10 +841,16 @@ static void
 __bpf_prog_test_run_raw_tp(void *data)
 {
 	struct bpf_raw_tp_test_run_info *info = data;
+	struct bpf_trace_run_ctx run_ctx = {};
+	struct bpf_run_ctx *old_run_ctx;
+
+	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 
 	rcu_read_lock();
 	info->retval = bpf_prog_run(info->prog, info->ctx);
 	rcu_read_unlock();
+
+	bpf_reset_run_ctx(old_run_ctx);
 }
 
 int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
-- 
2.43.0



