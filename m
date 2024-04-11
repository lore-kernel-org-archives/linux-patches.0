Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3EC1F5FA;
	Thu, 11 Apr 2024 10:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830176; cv=none; b=U+Jn+QQpc8DpMBuRLZ92GwD5jwwNVbkW0OUOLYIRscey7llCghpgBxRNeaL9/niXFull8msO4YwpQNE8ywPABajQwLaZTpxKa4xezyS8DSjucP2sxgXcXexbOZxsBKyS6EsLW5/VdYXw6Pcav+uFnmUMVUA/rKLBFB5A3/nV0co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830176; c=relaxed/simple;
	bh=64rRGBh0U7WPm7dJXLrCU7fWIyklEjCke5RsfDOjpD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GduoG4MiR868x3z89m3OatRL3lwbUgsv7kNLBRNaDQj9955f1WuznOj76UFTGKqoYrurpwwRYj4+KHUbzlY8dGSqh0iucFGSdWg9dxB3zxfCEkMeuB+AydqaUq5Ak41rFdSUYVmjdY7jXizBdVZdv8NcPAu9Bsv2mS3fSq+n8II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTAmlzhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTAmlzhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A53AC433C7;
	Thu, 11 Apr 2024 10:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830175;
	bh=64rRGBh0U7WPm7dJXLrCU7fWIyklEjCke5RsfDOjpD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTAmlzhRkXyXAJSjGLc5E4GZzdEmDlJP3M/4QvTBv6KcpbhEtlKHdgdDQWL+Ki7KU
	 vATz2FjmE22KEG2rur80eWTnSm9Zacdy+eEIvBWaJaRdUja3qCu+OOgVa/eqTIHzb7
	 toeKThKi+7RHreVgAqQNPYAHeGssOzV1NSEiyMc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 053/143] netdev: let netlink core handle -EMSGSIZE errors
Date: Thu, 11 Apr 2024 11:55:21 +0200
Message-ID: <20240411095422.513084889@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0b11b1c5c320555483e8a94c44549db24c289987 ]

Previous change added -EMSGSIZE handling to af_netlink, we don't
have to hide these errors any longer.

Theoretically the error handling changes from:
 if (err == -EMSGSIZE)
to
 if (err == -EMSGSIZE && skb->len)

everywhere, but in practice it doesn't matter.
All messages fit into NLMSG_GOODSIZE, so overflow of an empty
skb cannot happen.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c    | 15 +++------------
 net/core/page_pool_user.c |  2 --
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index fd98936da3aec..918b109e0cf40 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -152,10 +152,7 @@ int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	rtnl_unlock();
 
-	if (err != -EMSGSIZE)
-		return err;
-
-	return skb->len;
+	return err;
 }
 
 static int
@@ -287,10 +284,7 @@ int netdev_nl_napi_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	rtnl_unlock();
 
-	if (err != -EMSGSIZE)
-		return err;
-
-	return skb->len;
+	return err;
 }
 
 static int
@@ -463,10 +457,7 @@ int netdev_nl_queue_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	rtnl_unlock();
 
-	if (err != -EMSGSIZE)
-		return err;
-
-	return skb->len;
+	return err;
 }
 
 static int netdev_genl_netdevice_event(struct notifier_block *nb,
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 278294aca66ab..3a3277ba167b1 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -103,8 +103,6 @@ netdev_nl_page_pool_get_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	mutex_unlock(&page_pools_lock);
 	rtnl_unlock();
 
-	if (skb->len && err == -EMSGSIZE)
-		return skb->len;
 	return err;
 }
 
-- 
2.43.0



