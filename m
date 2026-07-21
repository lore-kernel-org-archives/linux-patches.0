Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A15347BC6;
	Tue, 21 Jul 2026 22:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674222; cv=none; b=SFz1z2xodUG2tfZOAafEalrup59H3R21yMWs+YkC6UJ6FxNBQnQ8MmDpoDmZdOxdMISdB2OnXGsDfrxrCxopK2nJ8c2pKTS7v6+LBklFbRsX88JkpeVcZvL7lGj5AXLIjXd03IYmZ1POgPeo3hcJj+EXnSC/qqdaOyXAT8fliQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674222; c=relaxed/simple;
	bh=FRHYM2RDbwBW/cOqN+E36pALhM+cVZFq7DZF61UPu7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUHYnLfA+StgqffR7MuYYl8oSoApLRRJlfA7SDS3vafIRidLSpA1yr+wup2hbuSP7jUZmNPRa5y4hBCgI7hCMuOZwntrZKpjGesjP+nv3yFtfKu/4u+zXlZoe6XkGfedWmPtIbHRR1zBx8F4HclN/wbBwv7opwuP2N93HLH7CWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucEAAl6K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucEAAl6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620A01F000E9;
	Tue, 21 Jul 2026 22:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674220;
	bh=ktRPwFYRj5CQaf1N2ACI6kYxCtXlTzzpRsp56YZYUS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ucEAAl6KJqyVA/XQ268zpnWrYRetJM+OW7MCL5nTL2ysUyzVcLBUWgxYfL7IKtWwP
	 ckwbm+srqj64TjE647SlbW3GGWBzXhrUm1KjOs2opXjCabb6joCh7IC2aVfwAE67c7
	 q/yNbxevM4tkG9iq16/4NgKd+nyQPZj/n7YEY06g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 460/699] batman-adv: access unicast_ttvn skb->data only after skb realloc
Date: Tue, 21 Jul 2026 17:23:39 +0200
Message-ID: <20260721152406.074359124@linuxfoundation.org>
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

commit 7141990add3f75436f2933cb310654cad3b1e3e9 upstream.

The pskb_may_pull() called by batadv_get_vid() could reallocate the buffer
behind the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

This was done correctly for the ethernet header but missed for the
unicast_packet pointer.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: c018ad3de61a ("batman-adv: add the VLAN ID attribute to the TT entry")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -822,8 +822,8 @@ static bool batadv_check_unicast_ttvn(st
 	if (skb_cow(skb, sizeof(*unicast_packet)) < 0)
 		return false;
 
-	unicast_packet = (struct batadv_unicast_packet *)skb->data;
 	vid = batadv_get_vid(skb, hdr_len);
+	unicast_packet = (struct batadv_unicast_packet *)skb->data;
 	ethhdr = (struct ethhdr *)(skb->data + hdr_len);
 
 	/* do not reroute multicast frames in a unicast header */


