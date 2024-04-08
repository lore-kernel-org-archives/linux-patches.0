Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025257B3E5;
	Mon,  8 Apr 2024 13:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582113; cv=none; b=Q+HNJRUJ2ew3Up2d27wdxdXVPOsvl5pxY1WBeI0zV4cOoaSgEacNxXhvF5EPvYvw/KzYHM4v6lxtrCZ1kemIQ5CyrzGgOlY92Rw2nmKqc1PnA85WfDfJT311S/cwqBVSX6TtqPfpOx69diW5pHdGjmW5qBd3vJiFu5zvipnqU3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582113; c=relaxed/simple;
	bh=g32IY/klt5O9Ji3XXqcbOcyE8QHvprkXHdr01Lthukk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AP5mmhxQAc2KJbwzPxGxT7V+XXK860d3xLSYJFn7+aF+IFTOlev7X0u7WF2onDqjLfIteu5fuI8E7zJ/BRa+NGfSyMW6rNb8+pDy0zVnzVyLweM2fwbviZHYLXQw7b0Y3pXhazUWI8Ys5yaf2Lzv/prePPurhKWVhXED4hs0ky4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeUpRll4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeUpRll4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8011AC433C7;
	Mon,  8 Apr 2024 13:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582112;
	bh=g32IY/klt5O9Ji3XXqcbOcyE8QHvprkXHdr01Lthukk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeUpRll4w3009fl4gR2/BwbeRtmZUiZOe6tGFrqmDbVfQYGMolSAwwudbPD6e5e4v
	 W9tYahSGhQqfffAzfyaPSq4EaHztx9B+YDB0lvQGSansOq82w5p+z3m/PpJuFpZ1I8
	 MWQnnx8jU+muuvLdy4Czx5v3ctCe0WSsL4MpSQSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH 6.1 079/138] tcp: Fix bind() regression for v6-only wildcard and v4(-mapped-v6) non-wildcard addresses.
Date: Mon,  8 Apr 2024 14:58:13 +0200
Message-ID: <20240408125258.684268968@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit d91ef1e1b55f730bee8ce286b02b7bdccbc42973 ]

Jianguo Wu reported another bind() regression introduced by bhash2.

Calling bind() for the following 3 addresses on the same port, the
3rd one should fail but now succeeds.

  1. 0.0.0.0 or ::ffff:0.0.0.0
  2. [::] w/ IPV6_V6ONLY
  3. IPv4 non-wildcard address or v4-mapped-v6 non-wildcard address

The first two bind() create tb2 like this:

  bhash2 -> tb2(:: w/ IPV6_V6ONLY) -> tb2(0.0.0.0)

The 3rd bind() will match with the IPv6 only wildcard address bucket
in inet_bind2_bucket_match_addr_any(), however, no conflicting socket
exists in the bucket.  So, inet_bhash2_conflict() will returns false,
and thus, inet_bhash2_addr_any_conflict() returns false consequently.

As a result, the 3rd bind() bypasses conflict check, which should be
done against the IPv4 wildcard address bucket.

So, in inet_bhash2_addr_any_conflict(), we must iterate over all buckets.

Note that we cannot add ipv6_only flag for inet_bind2_bucket as it
would confuse the following patetrn.

  1. [::] w/ SO_REUSE{ADDR,PORT} and IPV6_V6ONLY
  2. [::] w/ SO_REUSE{ADDR,PORT}
  3. IPv4 non-wildcard address or v4-mapped-v6 non-wildcard address

The first bind() would create a bucket with ipv6_only flag true,
the second bind() would add the [::] socket into the same bucket,
and the third bind() could succeed based on the wrong assumption
that ipv6_only bucket would not conflict with v4(-mapped-v6) address.

Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
Diagnosed-by: Jianguo Wu <wujianguo106@163.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20240326204251.51301-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f7832d4253820..8407098a59391 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -289,6 +289,7 @@ static bool inet_bhash2_addr_any_conflict(const struct sock *sk, int port, int l
 	struct sock_reuseport *reuseport_cb;
 	struct inet_bind_hashbucket *head2;
 	struct inet_bind2_bucket *tb2;
+	bool conflict = false;
 	bool reuseport_cb_ok;
 
 	rcu_read_lock();
@@ -301,18 +302,20 @@ static bool inet_bhash2_addr_any_conflict(const struct sock *sk, int port, int l
 
 	spin_lock(&head2->lock);
 
-	inet_bind_bucket_for_each(tb2, &head2->chain)
-		if (inet_bind2_bucket_match_addr_any(tb2, net, port, l3mdev, sk))
-			break;
+	inet_bind_bucket_for_each(tb2, &head2->chain) {
+		if (!inet_bind2_bucket_match_addr_any(tb2, net, port, l3mdev, sk))
+			continue;
 
-	if (tb2 && inet_bhash2_conflict(sk, tb2, uid, relax, reuseport_cb_ok,
-					reuseport_ok)) {
-		spin_unlock(&head2->lock);
-		return true;
+		if (!inet_bhash2_conflict(sk, tb2, uid, relax, reuseport_cb_ok,	reuseport_ok))
+			continue;
+
+		conflict = true;
+		break;
 	}
 
 	spin_unlock(&head2->lock);
-	return false;
+
+	return conflict;
 }
 
 /*
-- 
2.43.0



