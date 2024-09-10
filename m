Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D9317BB01;
	Tue, 10 Sep 2024 09:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961790; cv=none; b=ZrmEUP8/xl4F/IiXvF2LgHY58Vb4tS2X2GWAvTuS/e17ARsdaVeTixOnIZ50IO91/ldufEP/x7czVCl4lvvqnaHn1RWVhFBYFvi2XWWv1o+SOv/ABbgML9Z2Ea0SAv5aPpr/ohOnh6n0n+ie5DJDTMJvBCiR4R8FrRAGr6UUgMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961790; c=relaxed/simple;
	bh=S0h3WZ4F0ppAKiX4YAuBt8ckkwwWgh/0t4I7D/nIkLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVvoRpdqGna+Q88roEA4m+AEZ9ZywrMd8VGT0Bwpu5ja5Z8xvBW2PLiRJFk0gLwxyCgZDTWqGhmrJ2w8pwctsiCCmzXPuWSm4xEYlqE6ZrSuq2Ww4lKhq2MbGr8HunWzXne+fdL9HztJ4OV8IEnc24e44MMmLYO50OkN26sP0VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmzfNgok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmzfNgok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEE6C4CEC3;
	Tue, 10 Sep 2024 09:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961790;
	bh=S0h3WZ4F0ppAKiX4YAuBt8ckkwwWgh/0t4I7D/nIkLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmzfNgokOyS1oE4t77GLRW/cd/hZ8x/Ch0njC4U/Jb7UFp/8ZQuJUjmBQDL7h5qgw
	 6UjDgGMfaRExD4GZ7yI+fRAe120p/XW4jYVgwjob71CQb9w/z/2qKgTVv949Fc2LDi
	 w/PcAIiZr3yfKEdKFUSkMiDKdQ0AIdmjsyxmH6W8=
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
Subject: [PATCH 6.10 189/375] bpf, net: Fix a potential race in do_sock_getsockopt()
Date: Tue, 10 Sep 2024 11:29:46 +0200
Message-ID: <20240910092628.838567579@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index fb3c3e7181e6..ce91d9b2acb9 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -390,14 +390,6 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
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
@@ -518,7 +510,6 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_DEVICE_CGROUP(atype, major, minor, access) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_SYSCTL(head,table,write,buf,count,pos) ({ 0; })
-#define BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, \
 				       optlen, max_optlen, retval) ({ retval; })
 #define BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sock, level, optname, optval, \
diff --git a/net/socket.c b/net/socket.c
index e416920e9399..b5a003974058 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2350,7 +2350,7 @@ INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 		       int optname, sockptr_t optval, sockptr_t optlen)
 {
-	int max_optlen __maybe_unused;
+	int max_optlen __maybe_unused = 0;
 	const struct proto_ops *ops;
 	int err;
 
@@ -2359,7 +2359,7 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 		return err;
 
 	if (!compat)
-		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+		copy_from_sockptr(&max_optlen, optlen, sizeof(int));
 
 	ops = READ_ONCE(sock->ops);
 	if (level == SOL_SOCKET) {
-- 
2.43.0



