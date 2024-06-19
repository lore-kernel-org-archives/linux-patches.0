Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6706143C58;
	Wed, 19 Jun 2024 13:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802753; cv=none; b=i6RvtRRcZE9A3M5pnImMjCV7m/QNL9JqAItFhKl+A/pfHnI8fNn3z5vooknawIyjVFD5/mACW1Rmor33BXOjBfPAl2VcYU5P24/O+Hx2zbjBSjq8xE1AflN9XDC281NXOLoTFFz658UqTtNRDtFrAQ08OX+MyF89nI5gpNGbPuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802753; c=relaxed/simple;
	bh=aMd9KQYVvw2G8r6N8XdRihiyAGMBPaSSkLK5EkCiFaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYKufSHH0jFxsl73ZWiOKJFNobh1Ofh2AZslVBKaJIsi16NmAFXt+V8pWRa7mCanUvHoBkpW67+nlYeYa3JYgp8zsrkkDCLRs0wgJFfS6JfETbDed655k/CptgbpexYYdDqfWD+FbMDOHuHl0QoA0d1GylZMeJfxn2Y2FWMAi4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GblmtiXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GblmtiXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3C5C2BBFC;
	Wed, 19 Jun 2024 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802753;
	bh=aMd9KQYVvw2G8r6N8XdRihiyAGMBPaSSkLK5EkCiFaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GblmtiXNR4pyKfBlEa7BG8j2BjDQ179ZErPAjN7bfj8hJgT6lGcQFvslum+BAkmGz
	 tJhm81EwmZA8VyV/gXcO4T8vnsci2TPPtsSha/FSXjCKMzCF4rtgPhpoNzxcLxwtSp
	 agjX6ACugWngVvp6CG1MfZB3S/SZM86XyE85erXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ab78ff125b7979e45f9@syzkaller.appspotmail.com,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 035/281] bpf: Set run context for rawtp test_run callback
Date: Wed, 19 Jun 2024 14:53:14 +0200
Message-ID: <20240619125611.201170044@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 61efeadaff8db..4cd29fb490f7c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -719,10 +719,16 @@ static void
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



