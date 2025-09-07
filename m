Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C22C1DE8AF;
	Sun,  7 Sep 2025 20:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277176; cv=none; b=MXiTrmKib+qeNjbVQT1ecJULaNtvCWjFe1EtHz3WkJFBmerl4u/9bCzTXYTHNuY4L4joR+o2pbVUvLzaC73FnzDlXYSBvoARc5ctPqXD4oUN9GEkhs6H+C3r/zn15HndIQ4w9tVYoC5qT5mvOilhcYgKDr/hUeWvHrQAgawrRkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277176; c=relaxed/simple;
	bh=DrG4075r9aCK3lhjAtNJMAeVixflSOQYsXBoqggATEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/q+WVCJZybEmO4I3oKWQ6U/9je8LttK5b1/d93AXAlwzjOy3QcAlJLBE0NW9piZqBDbDOsrJr9Df7iSVIuQu2fysxcoiTErQktAGvxBH9QwNNwZs4NxNBAf9hgwizlRKEOmkgN/PmIaqsMvxY+iPuM/lLa2P7R/IZDz2kcUaeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDurvsG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDurvsG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86E9C4CEF0;
	Sun,  7 Sep 2025 20:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277176;
	bh=DrG4075r9aCK3lhjAtNJMAeVixflSOQYsXBoqggATEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDurvsG8+V+anY4wU8SGb6E4Xu0lXTJU8bFQTEa4V2qSMQ2DVILOvmLeJ4+5uEQgE
	 pjMSNWX++qpfHJwHZLlVquti8ACcCRhGsk61SecAP5xkLcbK76SMkHeAENJUuzyZWG
	 iQAXESZSynFB2oPiRDwA5QOiczDZCCPriE2V0SjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 109/175] wifi: mt76: mt7925u: use connac3 tx aggr check in tx complete
Date: Sun,  7 Sep 2025 21:58:24 +0200
Message-ID: <20250907195617.432912403@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit c22769de25095c6777e8acb68a1349a3257fc955 upstream.

MT7925 is a connac3 device; using the connac2 helper mis-parses
TXWI and breaks AMPDU/BA accounting. Use the connac3-specific
helper mt7925_tx_check_aggr() instead,

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Reported-by: Nick Morrow <morrownr@gmail.com>
Tested-by: Nick Morrow <morrownr@gmail.com>
Tested-on: Netgear A9000 USB WiFi adapter
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250818020203.992338-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1459,7 +1459,7 @@ void mt7925_usb_sdio_tx_complete_skb(str
 	sta = wcid_to_sta(wcid);
 
 	if (sta && likely(e->skb->protocol != cpu_to_be16(ETH_P_PAE)))
-		mt76_connac2_tx_check_aggr(sta, txwi);
+		mt7925_tx_check_aggr(sta, e->skb, wcid);
 
 	skb_pull(e->skb, headroom);
 	mt76_tx_complete_skb(mdev, e->wcid, e->skb);


