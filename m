Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50F146D2C7;
	Tue, 21 Jul 2026 17:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654263; cv=none; b=HIREkQ40u3c+UYfCc7rjKurDC8mXvE3fZ6Hsx9X3S3P/EWVBkNy/1vMgJbUh5li84ZmVltqCsUFjxTTlVQFiKal02i6ibSWVfF/XpGTIF3WGFY3bKQEj7ZPWXpWSKI6k6h9CTa4AJDdTlEqBle1YuWwz+2wBvfmDiRHBdpa6yvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654263; c=relaxed/simple;
	bh=boXrxVud/gBJS8ewBxAq4th6PZph4s0B1Y2zEnMofJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDgqHmpPC4HsABOdYqpGJrnvpGUzf+N/AVqkcH84qYEfTHfdqrHthRvu2Z3Lpg/Ge1cQpSk220KlZhj6GGM1tFd3myAyYIAtpp3JTF500oA9IGJ6VyoIXPAu1DP/uO+hnMMbKlaNMEiNZaASHQ+AnsTvCmWsBOEn/GqMq4dmp+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzVNIKQ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzVNIKQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481F91F000E9;
	Tue, 21 Jul 2026 17:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654261;
	bh=pENF77ThLInPWXbvv2DX9z6J8FewbRRg7DK48GEU7UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzVNIKQ7ootThtizoHqbK/SKp6i4t7+mzj6uDSZl/TSOWUGhr96n1wUYesOazS/Q8
	 1zr10H15sLN3fBUZILVmgokWsDCSrUnrxC80zfck0nIwkrzkuzGqZrcqewCQySITw6
	 55nyYj2gqiG/wq6vvri3x34KqBbgEdcV7JCyefEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1638/2077] batman-adv: gw: acquire ethernet header only after skb realloc
Date: Tue, 21 Jul 2026 17:21:51 +0200
Message-ID: <20260721152631.385907969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 77880a3be88d378d60cc1e8f8ec70430e2ed0518 upstream.

The pskb_may_pull() called by batadv_get_vid() could reallocate the buffer
behind the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

Cc: stable@vger.kernel.org
Fixes: 6c413b1c22a2 ("batman-adv: send every DHCP packet as bat-unicast")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/gateway_client.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -683,12 +683,13 @@ bool batadv_gw_out_of_range(struct batad
 	struct batadv_gw_node *gw_node = NULL;
 	struct batadv_gw_node *curr_gw = NULL;
 	struct batadv_neigh_ifinfo *curr_ifinfo, *old_ifinfo;
-	struct ethhdr *ethhdr = (struct ethhdr *)skb->data;
+	struct ethhdr *ethhdr;
 	bool out_of_range = false;
 	u8 curr_tq_avg;
 	unsigned short vid;
 
 	vid = batadv_get_vid(skb, 0);
+	ethhdr = (struct ethhdr *)skb->data;
 
 	if (is_multicast_ether_addr(ethhdr->h_dest))
 		goto out;


