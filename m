Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33063229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00317C4339C;
	Mon, 30 Jan 2023 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088340;
	bh=u0n9NZ4jo00qux4YYb48cj2+ZzRuRyVk1GCkKeK4zdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoWA6GnL2JDKRsj/yrlgqmhfrntBetu5zkO4N6gBPvwIgY1H48EmMbd7kXOtBm3GO
	 XoUV1pHZIWbVIfwuAOs+6MNGzsZ5vp9a+A0rLU5b+9SzQbz0llEsg7JOVbij2Hx7AF
	 b18P+BKpzJ6kc0DEqAwlPCmy0aZJMaswMzJZ8LU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/204] net: mctp: mark socks as dead on unhash, prevent re-add
Date: Mon, 30 Jan 2023 14:52:36 +0100
Message-Id: <20230130134324.959799091@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit b98e1a04e27fddfdc808bf46fe78eca30db89ab3 ]

Once a socket has been unhashed, we want to prevent it from being
re-used in a sk_key entry as part of a routing operation.

This change marks the sk as SOCK_DEAD on unhash, which prevents addition
into the net's key list.

We need to do this during the key add path, rather than key lookup, as
we release the net keys_lock between those operations.

Fixes: 4a992bbd3650 ("mctp: Implement message fragmentation & reassembly")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 1 +
 net/mctp/route.c   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index cbbde0f73a08..a77fafbc31cf 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -288,6 +288,7 @@ static void mctp_sk_unhash(struct sock *sk)
 
 		kfree_rcu(key, rcu);
 	}
+	sock_set_flag(sk, SOCK_DEAD);
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 
 	synchronize_rcu();
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 6aebb4a3eded..89e67399249b 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -135,6 +135,11 @@ static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
 
 	spin_lock_irqsave(&net->mctp.keys_lock, flags);
 
+	if (sock_flag(&msk->sk, SOCK_DEAD)) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+
 	hlist_for_each_entry(tmp, &net->mctp.keys, hlist) {
 		if (mctp_key_match(tmp, key->local_addr, key->peer_addr,
 				   key->tag)) {
@@ -148,6 +153,7 @@ static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
 		hlist_add_head(&key->sklist, &msk->keys);
 	}
 
+out_unlock:
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 
 	return rc;
-- 
2.39.0



