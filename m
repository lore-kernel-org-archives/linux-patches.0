Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D49400E0D;
	Wed, 20 May 2026 18:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302886; cv=none; b=r+fbne4VkwyogBIUazrugY9tIqcXkyNfHzmEyjlGfVXhmfGq26zKkFWYaMQjDQSH/x8w6lIDTjmXWo0QdNCmT1aNSo1AL8m5oXEO2rpdknP5tDgdsd1jXFyX47N3/QxveltXyPlEftw1/1hJLuCKwoiVFrYEuxnVFL5W4D0wZT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302886; c=relaxed/simple;
	bh=wbk+14nutiIPNxn1Z2zLN03NPQp070XgxRRRvVXpoiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cu8tHWuE1K5syZA+WSziy4ApdM1JL1B56k2yx+7fbz3giP+EZ6NoxOGN2AYYekZXdpd8Qkke9NQRGo9h+gPBL0awY7LJgYDce7Jf0fK+v5s0ml6cvDhG2A05cEx0ntZ+1VeCAgoN3w03tKGvjo1IjTdsYx+hAJ5+b11e3GhLKMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiuwbmpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiuwbmpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6211F000E9;
	Wed, 20 May 2026 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302885;
	bh=bMkoKxhnOE9tMDmVttFABNgVZ+0ki9XD9tvpAYI9BpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiuwbmpMQ//2h8zEyTkH5v+3nehiEcu2VHXjKBoB9H4Vttpt8QZ0PpJz52abQqSJv
	 2bOpPC7nv6G7ew+7CGrO2ou/7fwn9EYj0oAntnXWcprNmdQQXJFNgQHBV1c3iJfbN2
	 xKFEe/TqRTh4OSfw9i2y+zFQz8fJdN9OmASELIU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 395/508] neigh: let neigh_xmit take skb ownership
Date: Wed, 20 May 2026 18:23:38 +0200
Message-ID: <20260520162107.173946337@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4438113be604ee67a7bf4f81da6e1cca41332ce4 ]

neigh_xmit always releases the skb, except when no neighbour table is
found. But even the first added user of neigh_xmit (mpls) relied on
neigh_xmit to release the skb (or queue it for tx).

sashiko reported:
 If neigh_xmit() is called with an uninitialized neighbor table (for
 example, NEIGH_ND_TABLE when IPv6 is disabled), it returns -EAFNOSUPPORT
 and bypasses its internal out_kfree_skb error path.  Because the return
 value of neigh_xmit() is ignored here, does this leak the SKB?

Assume full ownership and remove the last code path that doesn't
xmit or free skb.

Fixes: 4fd3d7d9e868 ("neigh: Add helper function neigh_xmit")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260424145843.74055-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8f45692265ce3..bc9690a3d60e9 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3164,8 +3164,10 @@ int neigh_xmit(int index, struct net_device *dev,
 
 		rcu_read_lock();
 		tbl = rcu_dereference(neigh_tables[index]);
-		if (!tbl)
-			goto out_unlock;
+		if (!tbl) {
+			rcu_read_unlock();
+			goto out_kfree_skb;
+		}
 		if (index == NEIGH_ARP_TABLE) {
 			u32 key = *((u32 *)addr);
 
@@ -3181,7 +3183,6 @@ int neigh_xmit(int index, struct net_device *dev,
 			goto out_kfree_skb;
 		}
 		err = READ_ONCE(neigh->output)(neigh, skb);
-out_unlock:
 		rcu_read_unlock();
 	}
 	else if (index == NEIGH_LINK_TABLE) {
@@ -3191,11 +3192,10 @@ int neigh_xmit(int index, struct net_device *dev,
 			goto out_kfree_skb;
 		err = dev_queue_xmit(skb);
 	}
-out:
 	return err;
 out_kfree_skb:
 	kfree_skb(skb);
-	goto out;
+	return err;
 }
 EXPORT_SYMBOL(neigh_xmit);
 
-- 
2.53.0



