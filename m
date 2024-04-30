Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A2D17592;
	Tue, 30 Apr 2024 11:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476445; cv=none; b=sHlGEvAAAwzfUxTGHX9DxNSzBCBmDlV9d10B4e8ZWc+T63XyNa7YGtEOhcuyz3vuxGoXoWt64oqHVO/cBjlgLdgV6i/QrLMCDFpfgS7md4f3PT4m5bt/QXAnDOFQTbiOVqyUsc0s8NVk7/7RNy8dmnWwQSrPFqhwkoUGrV0BO5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476445; c=relaxed/simple;
	bh=VXGkVtYtRAPDAhCEVRS3QeKY93HcHWQ2cp2eyi2rJ2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUi+KxuxIalOylQh24OVDirbjCDQ8hDO5Cb1lfMXl8JVHpHKL9EJ9SQQNxXtuZJpWp0vMRz3uafDfK9Z5vBNzeEO8tuit+cXGJ/6DLuWEOZuTd9GJagOo8ISfi8E4DGh4iH6zI6f8+nMAd1RvPBEjqqehPdgBokxfwYp4gIZqck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z50m99ji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z50m99ji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE9AC2BBFC;
	Tue, 30 Apr 2024 11:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476445;
	bh=VXGkVtYtRAPDAhCEVRS3QeKY93HcHWQ2cp2eyi2rJ2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z50m99jiUYV6IXgpPMmVW5SqnbkM1+CliKRzVuudnzZbW1E+bzf61EEKsLbPhNNGl
	 +2qf3mogyBd5SBzCO/UhyaJFlvGzOinjSfFKlGOZYsvRLczdCaFkaRr9SdpFtFRKvb
	 54/jLiYX42TBO1nD6IohU3pKbfLOnYJz7rNwvBKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Li <adamli@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@linux.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/110] net: make SK_MEMORY_PCPU_RESERV tunable
Date: Tue, 30 Apr 2024 12:40:03 +0200
Message-ID: <20240430103048.575884108@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Adam Li <adamli@os.amperecomputing.com>

[ Upstream commit 12a686c2e761f1f1f6e6e2117a9ab9c6de2ac8a7 ]

This patch adds /proc/sys/net/core/mem_pcpu_rsv sysctl file,
to make SK_MEMORY_PCPU_RESERV tunable.

Commit 3cd3399dd7a8 ("net: implement per-cpu reserves for
memory_allocated") introduced per-cpu forward alloc cache:

"Implement a per-cpu cache of +1/-1 MB, to reduce number
of changes to sk->sk_prot->memory_allocated, which
would otherwise be cause of false sharing."

sk_prot->memory_allocated points to global atomic variable:
atomic_long_t tcp_memory_allocated ____cacheline_aligned_in_smp;

If increasing the per-cpu cache size from 1MB to e.g. 16MB,
changes to sk->sk_prot->memory_allocated can be further reduced.
Performance may be improved on system with many cores.

Signed-off-by: Adam Li <adamli@os.amperecomputing.com>
Reviewed-by: Christoph Lameter (Ampere) <cl@linux.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3584718cf2ec ("net: fix sk_memory_allocated_{add|sub} vs softirqs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/sysctl/net.rst | 5 +++++
 include/net/sock.h                       | 5 +++--
 net/core/sock.c                          | 1 +
 net/core/sysctl_net_core.c               | 9 +++++++++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 6394f5dc2303d..e3894c928118c 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -205,6 +205,11 @@ Will increase power usage.
 
 Default: 0 (off)
 
+mem_pcpu_rsv
+------------
+
+Per-cpu reserved forward alloc cache size in page units. Default 1MB per CPU.
+
 rmem_default
 ------------
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 60577751ea9e8..6ef6ce43a2edc 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1483,6 +1483,7 @@ sk_memory_allocated(const struct sock *sk)
 
 /* 1 MB per cpu, in page units */
 #define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
+extern int sysctl_mem_pcpu_rsv;
 
 static inline void
 sk_memory_allocated_add(struct sock *sk, int amt)
@@ -1491,7 +1492,7 @@ sk_memory_allocated_add(struct sock *sk, int amt)
 
 	preempt_disable();
 	local_reserve = __this_cpu_add_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
-	if (local_reserve >= SK_MEMORY_PCPU_RESERVE) {
+	if (local_reserve >= READ_ONCE(sysctl_mem_pcpu_rsv)) {
 		__this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
 		atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
 	}
@@ -1505,7 +1506,7 @@ sk_memory_allocated_sub(struct sock *sk, int amt)
 
 	preempt_disable();
 	local_reserve = __this_cpu_sub_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
-	if (local_reserve <= -SK_MEMORY_PCPU_RESERVE) {
+	if (local_reserve <= -READ_ONCE(sysctl_mem_pcpu_rsv)) {
 		__this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
 		atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
 	}
diff --git a/net/core/sock.c b/net/core/sock.c
index c8803b95ea0da..550af616f5359 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -279,6 +279,7 @@ __u32 sysctl_rmem_max __read_mostly = SK_RMEM_MAX;
 EXPORT_SYMBOL(sysctl_rmem_max);
 __u32 sysctl_wmem_default __read_mostly = SK_WMEM_MAX;
 __u32 sysctl_rmem_default __read_mostly = SK_RMEM_MAX;
+int sysctl_mem_pcpu_rsv __read_mostly = SK_MEMORY_PCPU_RESERVE;
 
 /* Maximal space eaten by iovec or ancillary data plus some space */
 int sysctl_optmem_max __read_mostly = sizeof(unsigned long)*(2*UIO_MAXIOV+512);
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 5b1ce656baa1d..d281d5343ff4a 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -29,6 +29,7 @@ static int int_3600 = 3600;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
+static int min_mem_pcpu_rsv = SK_MEMORY_PCPU_RESERVE;
 
 static int net_msg_warn;	/* Unused, but still a sysctl */
 
@@ -348,6 +349,14 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_rcvbuf,
 	},
+	{
+		.procname	= "mem_pcpu_rsv",
+		.data		= &sysctl_mem_pcpu_rsv,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &min_mem_pcpu_rsv,
+	},
 	{
 		.procname	= "dev_weight",
 		.data		= &weight_p,
-- 
2.43.0



