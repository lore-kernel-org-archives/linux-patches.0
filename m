Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4982918FC72;
	Tue, 10 Sep 2024 10:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964282; cv=none; b=JzIDXzNWOghUtWG02cTWvn906MK/DHTp8+nMt2R0iYcUdKxH7YY/ISVXqbm1Z0COV9qk5NgNRGaf7+fTxGmZSi5LGsfeB5xb7etCvWhleyvK4VPfbff5UO+X/9K6Mz0+AgQrBEj4rfYaQjogkymrUY3CyLoQ/qxis46VQrYGeZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964282; c=relaxed/simple;
	bh=kjkFbMKwTR5hC/LPuo0motOxixG+vydoK+U9Km2bvZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqzhv26Qel06o+S2hQu2bdu2gcg1VNqA/CxpwO0t57IfVxv+dZ6hPV2zf1w4CqrzTnmjxyHEbOqzLmfUGKGLHYRWyefDHusoKKUEbvDd+B58pkPW7VPKzR5dAjlsXHbBBKhbMpovKnQ/DjQxoIVcVcuHzZFklmFluavRebHJMLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+4hAD9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+4hAD9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4267C4CEC3;
	Tue, 10 Sep 2024 10:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964282;
	bh=kjkFbMKwTR5hC/LPuo0motOxixG+vydoK+U9Km2bvZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+4hAD9ZmrtKtvcQB1NkZ6D5EW0lDxAZHQT+tdUac2nqfNPi1Q0unu77y2zTU8QXI
	 rC1viVMOsjt1FJgr0rv4DvDksdKZH7fiNhJTPDro0nOoKG/6WjMGxgGfp3Q/mOF/1f
	 fD43Xvvt5auk6avYpFHZZGPikHWWO2zJ1fxyXH5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanghui Li <yanghui.li@mediatek.com>,
	Cheng-Jui Wang <cheng-jui.wang@mediatek.com>,
	Tze-nan Wu <Tze-nan.Wu@mediatek.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/269] bpf, net: Fix a potential race in do_sock_getsockopt()
Date: Tue, 10 Sep 2024 11:31:57 +0200
Message-ID: <20240910092612.820612939@linuxfoundation.org>
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

From: Tze-nan Wu <Tze-nan.Wu@mediatek.com>

[ Upstream commit 33f339a1ba54e56bba57ee9a77c71e385ab4825c ]

There's a potential race when `cgroup_bpf_enabled(CGROUP_GETSOCKOPT)` is
false during the execution of `BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN`, but
becomes true when `BPF_CGROUP_RUN_PROG_GETSOCKOPT` is called.
This inconsistency can lead to `BPF_CGROUP_RUN_PROG_GETSOCKOPT` receiving
an "-EFAULT" from `__cgroup_bpf_run_filter_getsockopt(max_optlen=0)`.
Scenario shown as below:

           `process A`                      `process B`
           -----------                      ------------
  BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN
                                            enable CGROUP_GETSOCKOPT
  BPF_CGROUP_RUN_PROG_GETSOCKOPT (-EFAULT)

To resolve this, remove the `BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN` macro and
directly uses `copy_from_sockptr` to ensure that `max_optlen` is always
set before `BPF_CGROUP_RUN_PROG_GETSOCKOPT` is invoked.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Co-developed-by: Yanghui Li <yanghui.li@mediatek.com>
Signed-off-by: Yanghui Li <yanghui.li@mediatek.com>
Co-developed-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Signed-off-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20240830082518.23243-1-Tze-nan.Wu@mediatek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup.h | 9 ---------
 net/socket.c               | 4 ++--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2aa82b7aed89..d4f2c8706042 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -375,14 +375,6 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
 	__ret;								       \
 })
 
-#define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen)			       \
-({									       \
-	int __ret = 0;							       \
-	if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT))			       \
-		copy_from_sockptr(&__ret, optlen, sizeof(int));		       \
-	__ret;								       \
-})
-
 #define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, optlen,   \
 				       max_optlen, retval)		       \
 ({									       \
@@ -500,7 +492,6 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_DEVICE_CGROUP(atype, major, minor, access) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_SYSCTL(head,table,write,buf,count,pos) ({ 0; })
-#define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, \
 				       optlen, max_optlen, retval) ({ retval; })
 #define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval, \
diff --git a/net/socket.c b/net/socket.c
index d275f5f14882..9db33cd4a71b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2355,7 +2355,7 @@ INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 		       int optname, sockptr_t optval, sockptr_t optlen)
 {
-	int max_optlen __maybe_unused;
+	int max_optlen __maybe_unused = 0;
 	const struct proto_ops *ops;
 	int err;
 
@@ -2364,7 +2364,7 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 		return err;
 
 	if (!compat)
-		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+		copy_from_sockptr(&max_optlen, optlen, sizeof(int));
 
 	ops = READ_ONCE(sock->ops);
 	if (level == SOL_SOCKET) {
-- 
2.43.0



