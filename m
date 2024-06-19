Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD19146016;
	Wed, 19 Jun 2024 12:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801948; cv=none; b=BXogua2DoNCQTMLOQAK0UgskbbzkH4tUk7lM1syagLkpfFyBrHf94Zq5fV9OgYrxKLtUNoFWvVDsxOt0EJlUWb3pHuN+SRDJWbsWI81S1+jedFaas61kf60Xy6ZoGOfSB9FAK/iBUxtdn4MP2bB3CuZBdlkkm9eCgKy1tjruekM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801948; c=relaxed/simple;
	bh=B7juaJO7hOscMxH16SWFWAKREQZ+o0BOhS7XchZWax0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RV80cyldYM4jU0WdrqGVV6QTFIa/VAcqaCEStyyzqB0UNvrCFsNAO3gYF0Oac6Zy3IuqXI1hQLapX/2JQlVXlf52TUV9G7mdo7iJJhVrQMDcP8Njis6TfDEJILxQK+C/cP/h7xp+0TezVYDQaUtf7WRLD5dva7l5im9UtSwQVGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2WrjRsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2WrjRsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA62C2BBFC;
	Wed, 19 Jun 2024 12:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801948;
	bh=B7juaJO7hOscMxH16SWFWAKREQZ+o0BOhS7XchZWax0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2WrjRsQcy2TX0gOimsmZFI9C24gWv4YSaAxh8D8WvleBo45DAJ+/lOnWas7JIScA
	 HdvnPnO4OKXk7PvWK5jjV4LCfXWMfjOaBpt443Vw7wcXSzcP9xkvEnUaR5OLUm8Nl2
	 UUK+zYOwjpy23juMBSll+OgUER3BAzS3pLyCPjKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ab78ff125b7979e45f9@syzkaller.appspotmail.com,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/267] bpf: Set run context for rawtp test_run callback
Date: Wed, 19 Jun 2024 14:53:02 +0200
Message-ID: <20240619125607.558754217@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 478ee7aba85f3..12a2934b28ffb 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -707,10 +707,16 @@ static void
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



