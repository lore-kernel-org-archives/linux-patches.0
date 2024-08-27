Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A061CDA37;
	Tue, 27 Aug 2024 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772402; cv=none; b=DZomxXaikXrk6+CAFP/O7vbfhMJbMrNRJz/vmGBGRBg4bgYMN3yX1+iy1/wBBfb+6nGYcxnqTWtxqtVcufSR++pT8iqGt6ozVC5AcPVmq/m2K2MK21H072hN5Qh7ZOTs57vvMrdWr6YD8JwJcWj8fI5MS9UagZnxJObxgLY2CIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772402; c=relaxed/simple;
	bh=WgjVbHepYknzpwK4sZnUp9IW/V+S9HuAfwi2QR4C97Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDU1urQh1pUErRoPP4CCSTv/9GOj/8ZvDeUwAaGsJwrR95O3G6wHH6qcojcOtVIPw1D/JzwENK8KLQcGX4pF/OvH/JZMr4l3tp8NuXbqvUEedyqE4T596OF8v0nM+rSSj9MyZnj17KzY3bWoQgQOpFTYjsts0MGKf3clwx/B3tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnP3CcR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnP3CcR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D02C4DE12;
	Tue, 27 Aug 2024 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772402;
	bh=WgjVbHepYknzpwK4sZnUp9IW/V+S9HuAfwi2QR4C97Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnP3CcR0zlgllqsMSVHO10tp1UNuefATTokQXPEFddgwoVOOikA7jZwRApRq5oF89
	 6ARPoi04/vGkeh31ZoVXmnbwACtfYyMtfZgcsixfDN/6DnQV0TIgxTODZAwIltcBJq
	 MsUUroguspvBJ59yDy1o28Zo8wg22EYyd2gy7eac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/321] netlink: hold nlk->cb_mutex longer in __netlink_dump_start()
Date: Tue, 27 Aug 2024 16:38:01 +0200
Message-ID: <20240827143844.817145674@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b5590270068c4324dac4a2b5a4a156e02e21339f ]

__netlink_dump_start() releases nlk->cb_mutex right before
calling netlink_dump() which grabs it again.

This seems dangerous, even if KASAN did not bother yet.

Add a @lock_taken parameter to netlink_dump() to let it
grab the mutex if called from netlink_recvmsg() only.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index e9b81cba1e2b4..8d26bd2ae3d55 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -130,7 +130,7 @@ static const char *const nlk_cb_mutex_key_strings[MAX_LINKS + 1] = {
 	"nlk_cb_mutex-MAX_LINKS"
 };
 
-static int netlink_dump(struct sock *sk);
+static int netlink_dump(struct sock *sk, bool lock_taken);
 
 /* nl_table locking explained:
  * Lookup and traversal are protected with an RCU read-side lock. Insertion
@@ -1953,7 +1953,7 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	if (READ_ONCE(nlk->cb_running) &&
 	    atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf / 2) {
-		ret = netlink_dump(sk);
+		ret = netlink_dump(sk, false);
 		if (ret) {
 			WRITE_ONCE(sk->sk_err, -ret);
 			sk_error_report(sk);
@@ -2163,7 +2163,7 @@ static int netlink_dump_done(struct netlink_sock *nlk, struct sk_buff *skb,
 	return 0;
 }
 
-static int netlink_dump(struct sock *sk)
+static int netlink_dump(struct sock *sk, bool lock_taken)
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
 	struct netlink_ext_ack extack = {};
@@ -2175,7 +2175,8 @@ static int netlink_dump(struct sock *sk)
 	int alloc_min_size;
 	int alloc_size;
 
-	mutex_lock(nlk->cb_mutex);
+	if (!lock_taken)
+		mutex_lock(nlk->cb_mutex);
 	if (!nlk->cb_running) {
 		err = -EINVAL;
 		goto errout_skb;
@@ -2330,9 +2331,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	WRITE_ONCE(nlk->cb_running, true);
 	nlk->dump_done_errno = INT_MAX;
 
-	mutex_unlock(nlk->cb_mutex);
-
-	ret = netlink_dump(sk);
+	ret = netlink_dump(sk, true);
 
 	sock_put(sk);
 
-- 
2.43.0



