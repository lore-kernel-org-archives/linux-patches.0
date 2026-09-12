Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B67A369D56;
	Sat, 12 Sep 2026 09:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205254; cv=none; b=UY11RFj8IefLRnK/oav3mYruoyiqZbRkCjWs/g7oFkbBtyVNWJg1ytqCF5R4VByjpqjq5IK9MKs/QiVfKOiluc/e5eJdI8vBZB9lfHLL0VPh2Ufs9EV52aQdiP7VhI5t9i7Aua6B5cS24T22w7UDh3CRnNHPSOdjW8/kwvVY8O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205254; c=relaxed/simple;
	bh=kfvcPIMJeNKmkkSL5v4TimAQJ2+3M4GK8v1PuGkTWa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT8iPsc6Dbt8WAnRDAe1M3MonAF6dQy9sz0MqjKwgsURKTYfFXnf4g/4nk3Ydrs7gmS1TS/2XjfNK2jrmTUp8489tKNzwKEVRIDYMVz2fvYnKiQQjEklla2Xf4baSmvDZKPqhiYnBvVx7TU3q/fnixI2/nhOYm2MXwGch4BloFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezwT3CkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezwT3CkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FC71F000FF;
	Sat, 12 Sep 2026 09:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205253;
	bh=enrP0fzc90vcH4D4+HbrtnVMQVhQkWLnkdcCf2SzSGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezwT3CkRDUGs3w9UzYi4jH0/XKPwLIiTowvggJRfKaTsY3B8F6MSyTgkTXNxcySDW
	 tWo/LhkTPz1r3mBKZtl9xJxHb6+XGlAwUnTJBHzsZJBpDxx4fJPySp3nbjxbowmoyN
	 oKSYmvcVyxwQRKti316kOqMoXwS8e5f9pbvKM3vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci <abaci@linux.alibaba.com>,
	Yifei Chu <Chuyf26@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1778/1815] net/smc: release the internal TCP sock on IPPROTO_SMC socket creation failure
Date: Sat, 12 Sep 2026 08:58:48 +0200
Message-ID: <20260912065730.757943093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Chu <Chuyf26@linux.alibaba.com>

[ Upstream commit cec261b0b4c5c0b044165303198d10ffcdf3414c ]

IPPROTO_SMC sockets create an internal TCP sock ("clcsock") from the
proto->init hook. When socket creation fails after proto->init has
run - e.g. a cgroup BPF program attached to BPF_CGROUP_INET_SOCK_CREATE
denies the socket - sk_common_release() only invokes sk_prot->destroy
if it is set, but neither smc_inet_prot nor smc_inet6_prot defines it,
and smc_destruct() returns early unless sk_state is SMC_CLOSED. As a
result, every failing socket(AF_INET, SOCK_STREAM, IPPROTO_SMC) call
leaks one tcp_sock, so an unprivileged task able to attach a deny-all
BPF_CGROUP_INET_SOCK_CREATE program to its own cgroup can grow kernel
memory unboundedly.

Add a .destroy hook to both protos that releases the clcsock via
smc_clcsock_release(). smc_sk_init() hashes the sock into the smc
hashinfo before the clcsock is created, and smc_diag dumps walk that
hash dereferencing smc->clcsock without taking clcsock_release_lock,
while sk_common_release() calls .destroy before .unhash. Unhash the
sock before releasing the clcsock, as __smc_release() does, so a
concurrent dump cannot observe the release; the second unhash in
sk_common_release() is a no-op.

Fixes: d25a92ccae6b ("net/smc: Introduce IPPROTO_SMC")
Reported-by: Abaci <abaci@linux.alibaba.com>
Assisted-by: abaci:qwen3.8-max
Signed-off-by: Yifei Chu <Chuyf26@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/178753843966.342810.566471390946765094@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_inet.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/smc/smc_inet.c b/net/smc/smc_inet.c
index a94084b4a498e..520b666fdd8fa 100644
--- a/net/smc/smc_inet.c
+++ b/net/smc/smc_inet.c
@@ -15,13 +15,16 @@
 
 #include "smc_inet.h"
 #include "smc.h"
+#include "smc_close.h"
 
 static int smc_inet_init_sock(struct sock *sk);
+static void smc_inet_destroy_sock(struct sock *sk);
 
 static struct proto smc_inet_prot = {
 	.name		= "INET_SMC",
 	.owner		= THIS_MODULE,
 	.init		= smc_inet_init_sock,
+	.destroy	= smc_inet_destroy_sock,
 	.hash		= smc_hash_sk,
 	.unhash		= smc_unhash_sk,
 	.release_cb	= smc_release_cb,
@@ -68,6 +71,7 @@ static struct proto smc_inet6_prot = {
 	.name		= "INET6_SMC",
 	.owner		= THIS_MODULE,
 	.init		= smc_inet_init_sock,
+	.destroy	= smc_inet_destroy_sock,
 	.hash		= smc_hash_sk,
 	.unhash		= smc_unhash_sk,
 	.release_cb	= smc_release_cb,
@@ -116,6 +120,18 @@ static int smc_inet_init_sock(struct sock *sk)
 	return smc_create_clcsk(net, sk, sk->sk_family);
 }
 
+static void smc_inet_destroy_sock(struct sock *sk)
+{
+	/* The sock is hashed and smc_diag dumps dereference smc->clcsock
+	 * without clcsock_release_lock, while sk_common_release() calls
+	 * .destroy before .unhash. Unhash first, as __smc_release() does,
+	 * so no dump can observe the clcsock being released; the second
+	 * unhash is a no-op.
+	 */
+	sk->sk_prot->unhash(sk);
+	smc_clcsock_release(smc_sk(sk));
+}
+
 int __init smc_inet_init(void)
 {
 	int rc;
-- 
2.53.0



