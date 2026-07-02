Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035AE30C15A;
	Thu,  2 Jul 2026 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011474; cv=none; b=U/2bzTqvtDtRQRSQZuMLaMQkcPlkz8Rsuzpx2dM2Sj2fKisklOmWCHBBoDsy/ro4U05Visv+CP0sfaKzMHxezFBvrNRMxEnRgvTffJmIr+GaHi1AV0dOxcudQ3ZjYGCHwQ2w+jkDZ7zIpu5ruGB82el52/E6ufVxax6dwPE2TR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011474; c=relaxed/simple;
	bh=8lubunO4HhhSnRaVayW1OBM3lftJbRauPdxi3ihlUlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JW100LDO0zOenyxGpNR2+jXQqOT6l+VRxZxLGpcoogkcrLhyuYTUfkVCPz1w44H9N3wOgZ6D/vJ7/r3yXjcO/cyXBVr21r6JEf76TyclV/g84k7KT1Wsrs2frduFvn6a++PrCfOu+6yhl/uVtt4DU4g/TS5P9D5t+gJHNRS89ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMMQ08y+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMMQ08y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2335C1F000E9;
	Thu,  2 Jul 2026 16:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011472;
	bh=kmqMHw0F+N7eAqFdmNijbSrCR9WslzTytj9/BDGX8yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HMMQ08y+4njEOF0Ds8SE3uCu0F7FkjsEKvnNPkE5aW3UyhdkXkIetR19DTqmDgBbW
	 w989Ny6+zoDY+6SaavaZ559zVTJRYy6apmQOm/4o/l28xkkoCsX6FGshWl/AMLbBe0
	 0ofJ0EnzT/wDLyEbbCeYcGb7pxf39WwsjseQuMJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 014/120] batman-adv: ensure bcast is writable before modifying TTL
Date: Thu,  2 Jul 2026 18:20:10 +0200
Message-ID: <20260702155113.256615893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

commit 4cd6d3a4b96a8576f1fed8f9f9f17c2dc2978e0c upstream.

Before batman-adv is allowed to write to an skb, it either has to have its
own copy of the skb or used skb_cow() to ensure that the data part is not
shared.

The old implementation used a shared queue and created copies before
attempting to write to it. But with the new implementation, the broadcast
packet is already modified when it gets received. Potentially writing to
shared buffers in this process.

Adding a skb_cow() right before this operation avoids this and can at the
same time prepare it for the modifications required to rebroadcast the
packet.

Cc: stable@kernel.org
Fixes: 3f69339068f9 ("batman-adv: bcast: queue per interface, if needed")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/routing.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 12c16f81cc51df..0672dc30bed3b1 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1191,6 +1191,12 @@ int batadv_recv_bcast_packet(struct sk_buff *skb,
 	if (batadv_is_my_mac(bat_priv, bcast_packet->orig))
 		goto free_skb;
 
+	/* create a copy of the skb, if needed, to modify it. */
+	if (skb_cow(skb, ETH_HLEN) < 0)
+		goto free_skb;
+
+	bcast_packet = (struct batadv_bcast_packet *)skb->data;
+
 	if (bcast_packet->ttl-- < 2)
 		goto free_skb;
 
-- 
2.53.0



