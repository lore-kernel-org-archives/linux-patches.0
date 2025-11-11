Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D889212DDA1;
	Tue, 11 Nov 2025 00:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822250; cv=none; b=VdLaYtpphyoJsU8BWtOFV21G6Ol+JxY+yPN5N/lBXtIhxLl1fcDCqBK3eho9jE+din2UmqYvFJo+gWswcolyl3GRsql+QxlLw0+EOX4h/pmg1lm9tgp4SKKTPl869tIQFX5KDKXtNvHktx+oCpPxRNOjccdsEQUmyXzVymPCxYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822250; c=relaxed/simple;
	bh=KRCsEYvZ6WbgL3B+viSLfk3P9lz/2tUK+XxpWs4+CQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4qd0wfFmcGSZj1QY7DVPIrcG6CSqi0N6flS0bH8REabqgTfpSXZVXpvU9puZ9TlRT5lS0EnvsUIIREp9awzOgfNPPw6vbG0iTcwhh114p4zUjJpkzQAzHL4b5Ylj7PwE+dNAGzsr0Bp8z9VvTJ4fvs+5qTc1C7LZkbwvKOB+yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOlX1CFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOlX1CFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D02C16AAE;
	Tue, 11 Nov 2025 00:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822249;
	bh=KRCsEYvZ6WbgL3B+viSLfk3P9lz/2tUK+XxpWs4+CQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOlX1CFlb1acqLG5viySzOAyMvtc7jHVd5opcwlyI8FMBnWGO3Y2xgrG0CJActFq9
	 xYDwoE/x8gAgt0+Z/RZMSXPnSz8gcHXkg9OhdGVqEuapUBjTBCbNPE0quhqYHGwPDq
	 c6G4YTiNwAcsjWkU4Ffwtdg1ZpfTaSGAUXutKURk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Gu <yong.g.gu@ericsson.com>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 066/849] bpf: Conditionally include dynptr copy kfuncs
Date: Tue, 11 Nov 2025 09:33:56 +0900
Message-ID: <20251111004538.024235916@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malin Jonsson <malin.jonsson@est.tech>

[ Upstream commit 8ce93aabbf75171470e3d1be56bf1a6937dc5db8 ]

Since commit a498ee7576de ("bpf: Implement dynptr copy kfuncs"), if
CONFIG_BPF_EVENTS is not enabled, but BPF_SYSCALL and DEBUG_INFO_BTF are,
the build will break like so:

  BTFIDS  vmlinux.unstripped
WARN: resolve_btfids: unresolved symbol bpf_probe_read_user_str_dynptr
WARN: resolve_btfids: unresolved symbol bpf_probe_read_user_dynptr
WARN: resolve_btfids: unresolved symbol bpf_probe_read_kernel_str_dynptr
WARN: resolve_btfids: unresolved symbol bpf_probe_read_kernel_dynptr
WARN: resolve_btfids: unresolved symbol bpf_copy_from_user_task_str_dynptr
WARN: resolve_btfids: unresolved symbol bpf_copy_from_user_task_dynptr
WARN: resolve_btfids: unresolved symbol bpf_copy_from_user_str_dynptr
WARN: resolve_btfids: unresolved symbol bpf_copy_from_user_dynptr
make[2]: *** [scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 255
make[2]: *** Deleting file 'vmlinux.unstripped'
make[1]: *** [/repo/malin/upstream/linux/Makefile:1242: vmlinux] Error 2
make: *** [Makefile:248: __sub-make] Error 2

Guard these symbols with #ifdef CONFIG_BPF_EVENTS to resolve the problem.

Fixes: a498ee7576de ("bpf: Implement dynptr copy kfuncs")
Reported-by: Yong Gu <yong.g.gu@ericsson.com>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Malin Jonsson <malin.jonsson@est.tech>
Link: https://lore.kernel.org/r/20251024151436.139131-1-malin.jonsson@est.tech
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 9c750a6a895bf..a12f4fa444086 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3816,6 +3816,7 @@ BTF_ID_FLAGS(func, bpf_iter_kmem_cache_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLE
 BTF_ID_FLAGS(func, bpf_iter_kmem_cache_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_local_irq_save)
 BTF_ID_FLAGS(func, bpf_local_irq_restore)
+#ifdef CONFIG_BPF_EVENTS
 BTF_ID_FLAGS(func, bpf_probe_read_user_dynptr)
 BTF_ID_FLAGS(func, bpf_probe_read_kernel_dynptr)
 BTF_ID_FLAGS(func, bpf_probe_read_user_str_dynptr)
@@ -3824,6 +3825,7 @@ BTF_ID_FLAGS(func, bpf_copy_from_user_dynptr, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_copy_from_user_str_dynptr, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_copy_from_user_task_dynptr, KF_SLEEPABLE | KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_copy_from_user_task_str_dynptr, KF_SLEEPABLE | KF_TRUSTED_ARGS)
+#endif
 #ifdef CONFIG_DMA_SHARED_BUFFER
 BTF_ID_FLAGS(func, bpf_iter_dmabuf_new, KF_ITER_NEW | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_iter_dmabuf_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLEEPABLE)
-- 
2.51.0



