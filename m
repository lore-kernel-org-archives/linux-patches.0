Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF3A1DFC7;
	Wed,  3 Jul 2024 11:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005324; cv=none; b=tcmBPM2UMICsSmAUnLtZUBJErCd5dH/KmH4uE7fnxdlJVmujF6vfj4U8LaqGP63U5kas2NhkvCs2Jv7gbLMR4JuX8Bs/S4z3u0pm768L+wMPudguqkrZCy/i/ssjIvrKlYr22m6x6pDa1whRP31JgwmiBDlfWSUZUWCufiqKBsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005324; c=relaxed/simple;
	bh=aX5pPlyf1LMs3s5D5VvgDhzaXCTnhWi9JBG0pYjc850=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BILWXSvAGTZOP7YT3DwWp2qbkV5fupOMOuLY8UBKXHAarw5WBHBJsPd4IELVpZAfdqDHCZ9B5Na2nAu8BxvIdl4dhO3MBBMT3wr6OlO0UBhFOy9Ozt4aUnu71Qkw5AFrk3PffAjs/AUJIH7fNugQ4kDlDNaIeIPWo9r1rv8HH6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWrPho7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWrPho7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E91C2BD10;
	Wed,  3 Jul 2024 11:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005324;
	bh=aX5pPlyf1LMs3s5D5VvgDhzaXCTnhWi9JBG0pYjc850=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWrPho7wamMW/Qq02fhhRszHE/XRaFHZ6kbLJFDox9l5/7GzoVGmm3/+nJVdLdRV1
	 E+o5ZFX8GmhgLBoC+F1W5RVLyri7SlwDfCBNTeOUwfZOhOSUSXEblrp4S1KS40pdvs
	 2GdeTTgsG/eoNPVwddIll+znu9YR4BKXd+zRW8vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ab78ff125b7979e45f9@syzkaller.appspotmail.com,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/356] bpf: Set run context for rawtp test_run callback
Date: Wed,  3 Jul 2024 12:35:49 +0200
Message-ID: <20240703102913.601526124@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 11d254ce3581c..a0d75c33b5d6a 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -326,10 +326,16 @@ static void
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



