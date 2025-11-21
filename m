Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FCF2F3632;
	Fri, 21 Nov 2025 13:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731190; cv=none; b=UBKmWTt59ywH6UDEpEXDsPHcqilmkSsa+GYbYt2RHfu4AwpWYxlSAyHdOKimiYikSGfR+S9BZ+m8jLIqBa+rJt3hnDEi1CjPIocAb4oo9h0rRmUB8IMcF5euDzWxQ9xjOOxTrfv8i0EEF4fsVGvd1ZwNHkO3SVT+SqIrGqjHmc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731190; c=relaxed/simple;
	bh=m8Y9bVod5Ks5Wh0u75DsiG1l7TQutwUKMi6zdM61BHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHujtVKtQuo+rdtxBJfIDAlZpcm9HjdY/0NQ0ap1LiyXW2huEvr6PfNySA9ddbZMnFOLh5X0AXomVDFZP5EuXzzNCeHT33Kqp1rRVrshGC61JIYiGdIvGZVi4p/hZUWMaIWDVuVHbOtcYAE+lM7pEAdguWvtS6klgmHdWHq+JYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHz46aR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHz46aR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E47C4CEF1;
	Fri, 21 Nov 2025 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731190;
	bh=m8Y9bVod5Ks5Wh0u75DsiG1l7TQutwUKMi6zdM61BHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHz46aR2gZClpPiKtp+0hHuBmLTNTWX5dly3AnbbAt+rfHyl3kpYgSJWEfN1vQ2Og
	 cWWHvKQqI82Fm3Pkl4hmjorxrDEMq/QPUqrFW9d/1sPJmahpvQy2VDYNpQ0mKQhh66
	 KjeFUn8lfS5XCJlvXkLDrCrlXWFySj4KUbCUjRv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Maurer <fmaurer@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 087/247] hsr: Follow standard for HSRv0 supervision frames
Date: Fri, 21 Nov 2025 14:10:34 +0100
Message-ID: <20251121130157.717176659@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Maurer <fmaurer@redhat.com>

[ Upstream commit b2c26c82f7a94ec4da096f370e3612ee14424450 ]

For HSRv0, the path_id has the following meaning:
- 0000: PRP supervision frame
- 0001-1001: HSR ring identifier
- 1010-1011: Frames from PRP network (A/B, with RedBoxes)
- 1111: HSR supervision frame

Follow the IEC 62439-3:2010 standard more closely by setting the right
path_id for HSRv0 supervision frames (actually, it is correctly set when
the frame is constructed, but hsr_set_path_id() overwrites it) and set a
fixed HSR ring identifier of 1. The ring identifier seems to be generally
unused and we ignore it anyways on reception, but some fixed identifier is
definitely better than using one identifier in one direction and a wrong
identifier in the other.

This was also the behavior before commit f266a683a480 ("net/hsr: Better
frame dispatch") which introduced the alternating path_id. This was later
moved to hsr_set_path_id() in commit 451d8123f897 ("net: prp: add packet
handling support").

The IEC 62439-3:2010 also contains 6 unused bytes after the MacAddressA in
the HSRv0 supervision frames. Adjust a TODO comment accordingly.

Fixes: f266a683a480 ("net/hsr: Better frame dispatch")
Fixes: 451d8123f897 ("net: prp: add packet handling support")
Signed-off-by: Felix Maurer <fmaurer@redhat.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/ea0d5133cd593856b2fa673d6e2067bf1d4d1794.1762876095.git.fmaurer@redhat.com
Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c  |  2 +-
 net/hsr/hsr_forward.c | 22 +++++++++++++++-------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 1235abb2d79fa..492cbc78ab75a 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -337,7 +337,7 @@ static void send_hsr_supervision_frame(struct hsr_port *port,
 	}
 
 	hsr_stag->tlv.HSR_TLV_type = type;
-	/* TODO: Why 12 in HSRv0? */
+	/* HSRv0 has 6 unused bytes after the MAC */
 	hsr_stag->tlv.HSR_TLV_length = hsr->prot_version ?
 				sizeof(struct hsr_sup_payload) : 12;
 
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index c67c0d35921de..339f0d2202129 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -262,15 +262,23 @@ static struct sk_buff *prp_fill_rct(struct sk_buff *skb,
 	return skb;
 }
 
-static void hsr_set_path_id(struct hsr_ethhdr *hsr_ethhdr,
+static void hsr_set_path_id(struct hsr_frame_info *frame,
+			    struct hsr_ethhdr *hsr_ethhdr,
 			    struct hsr_port *port)
 {
 	int path_id;
 
-	if (port->type == HSR_PT_SLAVE_A)
-		path_id = 0;
-	else
-		path_id = 1;
+	if (port->hsr->prot_version) {
+		if (port->type == HSR_PT_SLAVE_A)
+			path_id = 0;
+		else
+			path_id = 1;
+	} else {
+		if (frame->is_supervision)
+			path_id = 0xf;
+		else
+			path_id = 1;
+	}
 
 	set_hsr_tag_path(&hsr_ethhdr->hsr_tag, path_id);
 }
@@ -304,7 +312,7 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
 	else
 		hsr_ethhdr = (struct hsr_ethhdr *)pc;
 
-	hsr_set_path_id(hsr_ethhdr, port);
+	hsr_set_path_id(frame, hsr_ethhdr, port);
 	set_hsr_tag_LSDU_size(&hsr_ethhdr->hsr_tag, lsdu_size);
 	hsr_ethhdr->hsr_tag.sequence_nr = htons(frame->sequence_nr);
 	hsr_ethhdr->hsr_tag.encap_proto = hsr_ethhdr->ethhdr.h_proto;
@@ -330,7 +338,7 @@ struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
 			(struct hsr_ethhdr *)skb_mac_header(frame->skb_hsr);
 
 		/* set the lane id properly */
-		hsr_set_path_id(hsr_ethhdr, port);
+		hsr_set_path_id(frame, hsr_ethhdr, port);
 		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
 	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
 		return skb_clone(frame->skb_std, GFP_ATOMIC);
-- 
2.51.0



