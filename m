Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515663DDB03;
	Tue, 21 Jul 2026 22:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674219; cv=none; b=HEPVuFLOe73xWwxO+jqSZzrlHnZhs3Cb1Dqz6ccGI3CJVv4d/6/dXsHPfil/hzNJoWzGUY+W53VE3JAOeGs3v5nACyLPu7It2TgZLUkrcKkNewP7DHwIJe0J8mjSTLxTT9R+t6G9zPIUU4x74y5pmpGn7UsFrjXNpzbpq0xOGfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674219; c=relaxed/simple;
	bh=8etBJ8b7hys9+aRwNLHlTlct+6quhyrFUWeK9dDqgHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csv+gyV+jJcuWzFTn/XN+1ruq5IErG7cs1PMiuEe42HzWGspw0Fdg2RmEOfcBc6OqOtiEBG7/YgsxjwP5sOcWmEmZU3DyFDuUE8lKVoFx7CkCMwWSIzTMKlY4OYKMB+3YfdnUBEBtQCgOcP/KZbWqn2lgRrn6E2O6rl+bFDz6h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpMsq820; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpMsq820"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73481F000E9;
	Tue, 21 Jul 2026 22:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674218;
	bh=kEMf3igTe8f2n8tdGDxAdI1n7aOdpCw5nGu43f7ZIbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpMsq8207cn4kD8TgDp+sc8BGJOfdxYlHTnkbW7YdwpgGD9a9IiWqxjfrcwLkkUnV
	 Mh73La9SV0EaRMs2m11LdClTrZ/7tmjraGN/vxC3jkreo6QR8M4lgZnan4hjXfOVwV
	 uSeZ11AAWGR6fnoIBrbXNGmQmQ3dtOq3evpTP9kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 459/699] batman-adv: gw: acquire ethernet header only after skb realloc
Date: Tue, 21 Jul 2026 17:23:38 +0200
Message-ID: <20260721152406.052644163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -741,12 +741,13 @@ bool batadv_gw_out_of_range(struct batad
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


