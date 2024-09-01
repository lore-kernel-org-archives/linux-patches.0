Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9C21DFD1;
	Sun,  1 Sep 2024 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209509; cv=none; b=AWwLa924lfw0SeXC64M/jWqOKL8UJBUrP3K6n+07RhWu7GZ8+XdjqrkS9YDs45ezVW5KS2sK+k+kMLaXP+8Y2MgviuoGwElpIC+MwB6e2yCMTI3RHJcSyDH5JecZVDZ1BTvWEysnZdIh4zxkj2fZQEhVUe7TrXoQjrj5dWg2Jrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209509; c=relaxed/simple;
	bh=MBRQALCTGTLAKk7Su7LzG+cx/ZLGeSQvON8GNd+IBdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZ9t4o2qdfvScc3VLYlGpQwMeN/ZUOZXA927N3HCeVi8eAxeUNUYTi4yQkWwabq4dQLXqH9M/NI1kYATnWHL0+i1cmPCehkYUq+aW339JJ11S+hmXC02rtsNtJyknRabtyd/YNNnrcrhVEK63+v1vgko+T4O5c34ukgyjbwix4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXguvQW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXguvQW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1660C4CEC3;
	Sun,  1 Sep 2024 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209509;
	bh=MBRQALCTGTLAKk7Su7LzG+cx/ZLGeSQvON8GNd+IBdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXguvQW9J5eWKtlhkuvQa3OYXrhi34fYPMfIBPseOumJ5MtB6o4evuNS0cdXdf37k
	 GpLsbtY0XdSPFnaZeaTiDefrRXyzQ7zxE66YEipcD7/XvJAr296sz/QkxmQiXnwzfM
	 HCCv/SJJwrG6QIGMHo8uld9CgtLDNG4RMzgWLoqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/151] netlink: hold nlk->cb_mutex longer in __netlink_dump_start()
Date: Sun,  1 Sep 2024 18:16:57 +0200
Message-ID: <20240901160816.263537470@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ac3678d2d6d52..4f2a3d46554ff 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -126,7 +126,7 @@ static const char *const nlk_cb_mutex_key_strings[MAX_LINKS + 1] = {
 	"nlk_cb_mutex-MAX_LINKS"
 };
 
-static int netlink_dump(struct sock *sk);
+static int netlink_dump(struct sock *sk, bool lock_taken);
 
 /* nl_table locking explained:
  * Lookup and traversal are protected with an RCU read-side lock. Insertion
@@ -1996,7 +1996,7 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	if (READ_ONCE(nlk->cb_running) &&
 	    atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf / 2) {
-		ret = netlink_dump(sk);
+		ret = netlink_dump(sk, false);
 		if (ret) {
 			sk->sk_err = -ret;
 			sk->sk_error_report(sk);
@@ -2206,7 +2206,7 @@ static int netlink_dump_done(struct netlink_sock *nlk, struct sk_buff *skb,
 	return 0;
 }
 
-static int netlink_dump(struct sock *sk)
+static int netlink_dump(struct sock *sk, bool lock_taken)
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
 	struct netlink_ext_ack extack = {};
@@ -2218,7 +2218,8 @@ static int netlink_dump(struct sock *sk)
 	int alloc_min_size;
 	int alloc_size;
 
-	mutex_lock(nlk->cb_mutex);
+	if (!lock_taken)
+		mutex_lock(nlk->cb_mutex);
 	if (!nlk->cb_running) {
 		err = -EINVAL;
 		goto errout_skb;
@@ -2374,9 +2375,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	WRITE_ONCE(nlk->cb_running, true);
 	nlk->dump_done_errno = INT_MAX;
 
-	mutex_unlock(nlk->cb_mutex);
-
-	ret = netlink_dump(sk);
+	ret = netlink_dump(sk, true);
 
 	sock_put(sk);
 
-- 
2.43.0



