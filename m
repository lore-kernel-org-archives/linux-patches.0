Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E171548549;
	Wed,  9 Sep 2026 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962188; cv=none; b=qxo3LZB768M+PHTkPa0IeUFOkGoIq2xQfHUYDt1F4/65U3zcaA2azXFvVMD0j85uN0t/hALLBaQ/zlNarXiGfCsQldk8LceqL2mqU4wMYekyIhHqYp76uGAMjsdA1MvHdNrnTVpvFebxC3223KpluFKn3w0SWch1d066ZXmjPcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962188; c=relaxed/simple;
	bh=+S+ASFUY4TM4aCQotZJJsBX+WA6nsHOA8/5TJJX+Uak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKxqeeqZzG65FaG0bu6ZF/7CJro3vVD/ZLsZb5RdCDrEWQU2pO7tGCpdmgLKk//efBP+BY8IsXaWc/n9p9ryjwNRMpe1t6hm+crFfO6xpap30dVUeic1mcTS0sZD+zksdsnh07XudJLq7T/D0CAXiqss+9atRZdxaqf+5wQ4ITk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+QFgGZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+QFgGZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9837F1F00A3A;
	Wed,  9 Sep 2026 13:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962187;
	bh=3k2T4pxHv7/UBnnmlOtFCCV3gjI65DluLZknhAFr+8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+QFgGZEXGijE2j6jkBQUsWYwoqofkU+gcLulZmcH7etuA2X4pxCTnewF3QH9GqTh
	 pm040PL0lq2omvUFfo/3hoqLC+5F+0VfMeH47YTijOKP0YYWndn5ymXj1qAVh+H5iV
	 G9E4QYf3aAGoo6uAi48OGeG8ab20cbczCgQp41bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.2 203/556] batman-adv: mcast: linearize skbuff for packet generation
Date: Wed,  9 Sep 2026 15:38:03 +0200
Message-ID: <20260909134237.532776704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 6a30a59e2660afd03c975f1b8eae6a2301161197 upstream.

batadv_mcast_forw_packet() and batadv_mcast_forw_scrape() is not only
called (indirectly) by the unsharing+linearizing batadv_recv_mcast_packet()
handler. When it is called (indirectly) by batadv_mcast_forw_mcsend() then
it will be unshared but not linearized. The SKB_LINEAR_ASSERT() can
therefore cause a fatal BUG().

The linearization should happen during the expansion of the head because
the scrape function can be hit already during the initial
batadv_mcast_forw_mode() selection code:

* batadv_interface_tx
* batadv_mcast_forw_mode
* batadv_mcast_forw_mode_by_count()
* batadv_mcast_forw_push()
  -> calls batadv_mcast_forw_expand_head() before everything else
* batadv_mcast_forw_push_tvlvs()
* batadv_mcast_forw_push_dests()
* batadv_mcast_forw_push_adjust_padding()
* batadv_mcast_forw_scrape()

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 90039133221e ("batman-adv: mcast: implement multicast packet generation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/multicast_forw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/batman-adv/multicast_forw.c
+++ b/net/batman-adv/multicast_forw.c
@@ -1103,6 +1103,10 @@ static int batadv_mcast_forw_expand_head
 	if (skb_cow(skb, hdr_size) < 0)
 		return -ENOMEM;
 
+	/* batadv_mcast_forw_scrape() + batadv_mcast_forw_packet() require linearized skb */
+	if (skb_linearize(skb) < 0)
+		return -ENOMEM;
+
 	return 0;
 }
 


