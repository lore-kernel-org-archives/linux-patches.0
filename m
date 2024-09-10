Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B741C2AF15;
	Tue, 10 Sep 2024 10:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964273; cv=none; b=A63V6BA6mABiL6EeBTcAVBoKGen6aetz50NqTB7KwbURP5yux/7rYSpxcnrguNKN2bWItRN7Gp0B6VzXWlCD7ykICLMMlTK7OWUgneKTL443tGeR43TlwLpos1wST1/Sqc8tIe9z0dceTjx61hXnEPwVyL4rHJiI7JscuZFirQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964273; c=relaxed/simple;
	bh=3BB2ts86mbrYhDY/LXbQ/EAQLSyVZAOZNJ726BfOYwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIIHjBwe8cxrNdHYtIJLiOwzUK++3TfeDFNxeVpyIndEEBs9FVBGaw7Tly9CnbV/+5E6/pspLTevwkRHpxjrBGauzfh8D6w4wqBgl/psRGXwsTL8C4atuncPRh3nJcxLTMPBh/4od3EJZauwzY+0NvBXxyiDDtYSteGXp5G0l2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STbG5ACN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STbG5ACN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB503C4CEC3;
	Tue, 10 Sep 2024 10:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964273;
	bh=3BB2ts86mbrYhDY/LXbQ/EAQLSyVZAOZNJ726BfOYwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STbG5ACNWyS5SNQbJLn0Cg8PQhkSL3LOkePXRxL8zr15jSu3PHhHHAdtbjqx9aWeo
	 z5QoyeeVEzzEYmtqnxYHSHb+6VbaNZtrjRPaVeKHxl6T/Ertwe9210YvI1KspF/mPo
	 8sngvZEE/4qqWKPOAuk9NBzdrtW1e3J3aLtkR064=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/269] bpf: Add sockptr support for setsockopt
Date: Tue, 10 Sep 2024 11:31:54 +0200
Message-ID: <20240910092612.701288228@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3f31e0d14d44ad491a81b7c1f83f32fbc300a867 ]

The whole network stack uses sockptr, and while it doesn't move to
something more modern, let's use sockptr in setsockptr BPF hooks, so, it
could be used by other callers.

The main motivation for this change is to use it in the io_uring
{g,s}etsockopt(), which will use a userspace pointer for *optval, but, a
kernel value for optlen.

Link: https://lore.kernel.org/all/ZSArfLaaGcfd8LH8@gmail.com/

Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20231016134750.1381153-3-leitao@debian.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 33f339a1ba54 ("bpf, net: Fix a potential race in do_sock_getsockopt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup.h | 2 +-
 kernel/bpf/cgroup.c        | 5 +++--
 net/socket.c               | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index c4956a48ab3e..ebfd3c5a776a 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -138,7 +138,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 				   enum cgroup_bpf_attach_type atype);
 
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sock, int *level,
-				       int *optname, char __user *optval,
+				       int *optname, sockptr_t optval,
 				       int *optlen, char **kernel_optval);
 
 int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index caae07cc885e..913a6a7e62ca 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1799,7 +1799,7 @@ static bool sockopt_buf_allocated(struct bpf_sockopt_kern *ctx,
 }
 
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
-				       int *optname, char __user *optval,
+				       int *optname, sockptr_t optval,
 				       int *optlen, char **kernel_optval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -1822,7 +1822,8 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 	ctx.optlen = *optlen;
 
-	if (copy_from_user(ctx.optval, optval, min(*optlen, max_optlen)) != 0) {
+	if (copy_from_sockptr(ctx.optval, optval,
+			      min(*optlen, max_optlen))) {
 		ret = -EFAULT;
 		goto out;
 	}
diff --git a/net/socket.c b/net/socket.c
index b2d75d5661be..f0f087004728 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2307,7 +2307,7 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 
 	if (!in_compat_syscall())
 		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
-						     user_optval, &optlen,
+						     optval, &optlen,
 						     &kernel_optval);
 	if (err < 0)
 		goto out_put;
-- 
2.43.0



