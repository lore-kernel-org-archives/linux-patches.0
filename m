Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD7830E0DC;
	Fri, 21 Nov 2025 13:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732034; cv=none; b=gKn6Uj2CCZVPyuRGkZFLMhOkos9ymjpSpR1st1iJS7DB02uzXdchP4LA5RDo4csNW5LtbrxmTYqP/7WDR2gNH8UpBmfVRi26nby0eJwwt4GTjuq/+9posIhzhPzJSVZB8kfbzLP3uG/eAsx3zBjEH8qM5iGTnBGpiqXufSQ/UYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732034; c=relaxed/simple;
	bh=YxhcGB0FhaVydds85kxCXZJytVRRp6iSQnzDjxicJYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvoHlC1NMlKZRZ5vP74OK28RsX3jZdca8zVHhMx8g+SlSlbAqfW3Ueo6Lz8ZyXmwMpgXnORNQhCsc6FaMuF09rnDUdwWrgSbLxSdw7DKg2CZA5sURvgDTgAXg9Yj+Do9fxe/yqhK+AYab1p3GXy5+hjCBJXuaUpUpYzWKhS4mD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Om7drd7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Om7drd7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85065C4CEF1;
	Fri, 21 Nov 2025 13:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732033;
	bh=YxhcGB0FhaVydds85kxCXZJytVRRp6iSQnzDjxicJYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Om7drd7nNPveEHi27zVlr1eN7KAroAvThILOqFckXm9x7yn6fwiW1NRVEIFGVMSNo
	 IoNYNaPD80dJeZpCN31LREq1TCfoEIaXMBAFCJPRRs43EfcUetaDyMX64aYoWPKBo1
	 usa70lPJ1iPGeD5woc2vodxpSZExHrj1EFWI0//g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/185] net: netpoll: flush skb pool during cleanup
Date: Fri, 21 Nov 2025 14:13:14 +0100
Message-ID: <20251121130149.906990300@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 6c59f16f1770481a6ee684720ec55b1e38b3a4b2 ]

The netpoll subsystem maintains a pool of 32 pre-allocated SKBs per
instance, but these SKBs are not freed when the netpoll user is brought
down. This leads to memory waste as these buffers remain allocated but
unused.

Add skb_pool_flush() to properly clean up these SKBs when netconsole is
terminated, improving memory efficiency.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20241114-skb_buffers_v2-v3-2-9be9f52a8b69@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 49c8d2c1f94c ("net: netpoll: fix incorrect refcount handling causing incorrect cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -536,6 +536,14 @@ static int netpoll_parse_ip_addr(const c
 	return -1;
 }
 
+static void skb_pool_flush(struct netpoll *np)
+{
+	struct sk_buff_head *skb_pool;
+
+	skb_pool = &np->skb_pool;
+	skb_queue_purge_reason(skb_pool, SKB_CONSUMED);
+}
+
 int netpoll_parse_options(struct netpoll *np, char *opt)
 {
 	char *cur=opt, *delim;
@@ -784,7 +792,7 @@ put_noaddr:
 
 	err = __netpoll_setup(np, ndev);
 	if (err)
-		goto put;
+		goto flush;
 	rtnl_unlock();
 
 	/* Make sure all NAPI polls which started before dev->npinfo
@@ -795,6 +803,8 @@ put_noaddr:
 
 	return 0;
 
+flush:
+	skb_pool_flush(np);
 put:
 	DEBUG_NET_WARN_ON_ONCE(np->dev);
 	if (ip_overwritten)
@@ -842,6 +852,8 @@ void __netpoll_cleanup(struct netpoll *n
 		call_rcu(&npinfo->rcu, rcu_cleanup_netpoll_info);
 	} else
 		RCU_INIT_POINTER(np->dev->npinfo, NULL);
+
+	skb_pool_flush(np);
 }
 EXPORT_SYMBOL_GPL(__netpoll_cleanup);
 


