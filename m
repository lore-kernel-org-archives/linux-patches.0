Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D663E6DFA;
	Mon, 17 Aug 2026 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975042; cv=none; b=m530ucL2+mlOpwFI/PXXeF0OKeBb6sek8vueVaGM39ea0N6/aYRJP0fG07v4rMXmTsjYqfW2GxP7JMdm+EmhWk9U2UHqL9I4PrZ7FmeiNlrFBVULYrS7OXbk1ryN6Kpl4wl69HfUz5HTZYYAAh56ss653bsbUzxpH4UnOHqTr1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975042; c=relaxed/simple;
	bh=Y1qBdYsPMsldDr/KwJuLFTkmz+ipXv6WQHpnmJD1VRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hc80jjniTB7tEJ1+q/VagewKNzhw+GVAYRgU4Pud+vrB1GDb/FK18O7n4QEq3DfRvrJS0xz+Xfjb8XGHJxE5mh0vV7jBgo3HFkcsQsT8u5MM5Gw9OVIcyxSBaEnC99Ukb3jTy7PIaFVMKWSMXNF91LL5ILz9InbUw1oAVcbMCqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8oetwbt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8oetwbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1912A1F000E9;
	Mon, 17 Aug 2026 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975041;
	bh=cl8ZefIHHztSrI88kvXn/ALQJCkH+JdrHsRrJnN1jkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8oetwbtitsYEh2hsKqGoTuE2GogXosEQCPFUkrlmOeq8ZKL+OOUElr50jFR7YhyF
	 4rcnuzhCtEFP2JOc2mj8qzACwA++DkoJt3RqDwz3zOoRYIta/f2hBLVSwfGIQ+A/tB
	 L0Tt/d+4KgAM0bod44L7aweBPjaTo6EJN1l3p2kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 141/250] inet: frags: publish queues before arming timer
Date: Mon, 17 Aug 2026 15:31:42 +0200
Message-ID: <20260817132542.318634582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 653d7ddf6cba867777a3d14c4f83ace008c5ad13 upstream.

inet_frag_create() arms the fragment queue timer before inserting the
queue into the fqdir rhashtable. If the namespace fragment timeout is
zero or negative, the timer can run before the queue is published.

The timer callback then marks the queue complete, tries to remove a node
that is not in the hash table yet, and drops the anticipated hash
reference. Creation can subsequently publish the completed queue without
restoring that reference, leaving a stale hash node after the caller drops
the remaining reference.

Publish the queue first and arm the timer while holding the queue lock.
This makes timer expiry wait until the queue is visible in the hash table,
so inet_frag_kill() can remove the node and balance the hash reference.

Fixes: 648700f76b03 ("inet: frags: use rhashtables for reassembly units")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Link: https://patch.msgid.link/bf66785e7c0c139d7a1900e2f01faeeab344b960.1784948849.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_fragment.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -395,8 +395,8 @@ static struct inet_frag_queue *inet_frag
 		*prev = ERR_PTR(-ENOMEM);
 		return NULL;
 	}
-	mod_timer(&q->timer, jiffies + fqdir->timeout);
 
+	spin_lock_bh(&q->lock);
 	*prev = rhashtable_lookup_get_insert_key(&fqdir->rhashtable, &q->key,
 						 &q->node, f->rhash_params);
 	if (*prev) {
@@ -404,13 +404,13 @@ static struct inet_frag_queue *inet_frag
 		 * we need to cancel what inet_frag_alloc()
 		 * anticipated.
 		 */
-		int refs = 1;
-
 		q->flags |= INET_FRAG_COMPLETE;
-		inet_frag_kill(q, &refs);
-		inet_frag_putn(q, refs);
+		spin_unlock_bh(&q->lock);
+		inet_frag_putn(q, 2);
 		return NULL;
 	}
+	mod_timer(&q->timer, jiffies + fqdir->timeout);
+	spin_unlock_bh(&q->lock);
 	return q;
 }
 


