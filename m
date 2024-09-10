Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E222AF15;
	Tue, 10 Sep 2024 10:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964270; cv=none; b=iRWD3m9YhYlMfKTMHJ4mtPP6Lz0S6P6tnRkD4rtqzbDMmDjvtkQIQzcQlZS+xyj5UOOeNmTn6LPkbzo5oOSxzJcGqCIX2Whi4TJL1zM1X1j75oGzYJgM97OGiZcX62qyUyz/fRFwQEnOhCtGtq2/ARfZ+mJyuNoqgm0aiSVXIEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964270; c=relaxed/simple;
	bh=KjHDXRXXZsEsNB4lUckAx2bQHUkBOb2oX6iYCi4pfuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPI2O0tvbMhQMiXC1nuZEfVaCXg1NUIhxUKoW1xD6USEg1EB04f/ZVApu9zZZ3zdVo+2ONxRXT+bLbZoBydRXtayUitydNug5qQoOs3xgXhJBoE/IHw2GgHQ96yT9SFEhztl1sPL7tzbb/oJCQl6on3/a/zUahT5sTznmeAG8G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMfHHu7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMfHHu7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8DEC4CEC3;
	Tue, 10 Sep 2024 10:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964270;
	bh=KjHDXRXXZsEsNB4lUckAx2bQHUkBOb2oX6iYCi4pfuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMfHHu7G0YZ38/nUjSeLryCin5fFE4Cicz3z4R26r5qjecUJWx/S707tR8xZURt77
	 WwTkrkkXeOvtNg3ehnCNnrIeX/LzzyH6FzjAD3k6immU+TxsoGu6NKvp/v/EiPC9bG
	 1PUtHquumfCC1X3M7YgHgYxiG0YAtiFbb1Gzv2WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/269] bpf: Add sockptr support for getsockopt
Date: Tue, 10 Sep 2024 11:31:53 +0200
Message-ID: <20240910092612.666745092@linuxfoundation.org>
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

[ Upstream commit a615f67e1a426f35366b8398c11f31c148e7df48 ]

The whole network stack uses sockptr, and while it doesn't move to
something more modern, let's use sockptr in getsockptr BPF hooks, so, it
could be used by other callers.

The main motivation for this change is to use it in the io_uring
{g,s}etsockopt(), which will use a userspace pointer for *optval, but, a
kernel value for optlen.

Link: https://lore.kernel.org/all/ZSArfLaaGcfd8LH8@gmail.com/

Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20231016134750.1381153-2-leitao@debian.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 33f339a1ba54 ("bpf, net: Fix a potential race in do_sock_getsockopt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup.h |  5 +++--
 kernel/bpf/cgroup.c        | 20 +++++++++++---------
 net/socket.c               |  5 +++--
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 31561e789715..c4956a48ab3e 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -140,9 +140,10 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 int __cgroup_bpf_run_filter_setsockopt(struct sock *sock, int *level,
 				       int *optname, char __user *optval,
 				       int *optlen, char **kernel_optval);
+
 int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
-				       int optname, char __user *optval,
-				       int __user *optlen, int max_optlen,
+				       int optname, sockptr_t optval,
+				       sockptr_t optlen, int max_optlen,
 				       int retval);
 
 int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ac37bd53aee0..caae07cc885e 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1889,8 +1889,8 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 }
 
 int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
-				       int optname, char __user *optval,
-				       int __user *optlen, int max_optlen,
+				       int optname, sockptr_t optval,
+				       sockptr_t optlen, int max_optlen,
 				       int retval)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -1917,8 +1917,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		 * one that kernel returned as well to let
 		 * BPF programs inspect the value.
 		 */
-
-		if (get_user(ctx.optlen, optlen)) {
+		if (copy_from_sockptr(&ctx.optlen, optlen,
+				      sizeof(ctx.optlen))) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1929,8 +1929,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		}
 		orig_optlen = ctx.optlen;
 
-		if (copy_from_user(ctx.optval, optval,
-				   min(ctx.optlen, max_optlen)) != 0) {
+		if (copy_from_sockptr(ctx.optval, optval,
+				      min(ctx.optlen, max_optlen))) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1944,7 +1944,8 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	if (ret < 0)
 		goto out;
 
-	if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
+	if (!sockptr_is_null(optval) &&
+	    (ctx.optlen > max_optlen || ctx.optlen < 0)) {
 		if (orig_optlen > PAGE_SIZE && ctx.optlen >= 0) {
 			pr_info_once("bpf getsockopt: ignoring program buffer with optlen=%d (max_optlen=%d)\n",
 				     ctx.optlen, max_optlen);
@@ -1956,11 +1957,12 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	}
 
 	if (ctx.optlen != 0) {
-		if (optval && copy_to_user(optval, ctx.optval, ctx.optlen)) {
+		if (!sockptr_is_null(optval) &&
+		    copy_to_sockptr(optval, ctx.optval, ctx.optlen)) {
 			ret = -EFAULT;
 			goto out;
 		}
-		if (put_user(ctx.optlen, optlen)) {
+		if (copy_to_sockptr(optlen, &ctx.optlen, sizeof(ctx.optlen))) {
 			ret = -EFAULT;
 			goto out;
 		}
diff --git a/net/socket.c b/net/socket.c
index 8d83c4bb163b..b2d75d5661be 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2375,8 +2375,9 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 
 	if (!in_compat_syscall())
 		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
-						     optval, optlen, max_optlen,
-						     err);
+						     USER_SOCKPTR(optval),
+						     USER_SOCKPTR(optlen),
+						     max_optlen, err);
 out_put:
 	fput_light(sock->file, fput_needed);
 	return err;
-- 
2.43.0



