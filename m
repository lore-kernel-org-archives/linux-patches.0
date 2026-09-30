Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1D83A784F;
	Wed, 30 Sep 2026 17:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788635; cv=none; b=aIhA+xWcZ2tVfLvnXpCn+aamnkgoEaMv9JDGpjeXlBkOpVTzBf2lqM6d2J7cGEDao4x90gMc9JaOEiT8vL4z3IKK/9vrXpvi8gTFTdbS/6KbW4Y5rulH6+CdP89B78ulQSbVjSTnKFt61UPSgl6vWjC5XwTiXu5cuLCUPvKldVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788635; c=relaxed/simple;
	bh=vSl1ciG02/2l9vNo0LGk/JVse/uZSjKIDFZGcReDTSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bk1+2IDHpLKDa2GasWthgeYTRuxAy7dcWvRgejmsSm11Q/Z1YLZFKl91FcUAg7/T4CEZncX9z+dWbGXY2MMCJx/JMIUy7SRroifxrHd3k58kH85tlX0eUIdxmXgYj3LTubJFI2DsHlF10VHJhXeYiPkAKs8OnvlN7D8ecDy5DbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBL+VT9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBL+VT9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AF01F000FF;
	Wed, 30 Sep 2026 17:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788634;
	bh=FKxASQa6VmlK6HRpeIYr4rGRwxZ5yHnzTiBJW2XaDs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBL+VT9Y5MbDWFTxIH5+FpoXfdPDGz1EXOGBnSz/dd+NAVIIoeTaOmWL802P8pUBQ
	 wGZ546qG3TdSeuIL2mw0rpQcL6Q9NoDk4LQxAIzb7iay0YGZvX9qXPRxMGDv47H6Tx
	 7gwJJU7ij3bSa3y/yKcTj49Zje3WcZrzWutFYDjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 193/877] net: wwan: t7xx: validate the netif index in t7xx_ccmni_recv_skb()
Date: Wed, 30 Sep 2026 17:18:24 +0200
Message-ID: <20260930152418.891573746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Guanglei Zhu <zhugl3@xiaopeng.com>

commit c7ead9704249d57d4693a04697e3bbd285138fa9 upstream.

The netif index carried in the DPMAIF PIT header is five bits wide,
but ccmni_inst[] only has room for NIC_DEV_MAX (21) entries.
t7xx_ccmni_recv_skb() indexes the array without a bounds check, so
indexes 21 to 31 read past it.  The out-of-bounds value lands in the
callback table that follows the array, which is never NULL, so the
existing !ccmni check does not catch it and the driver dereferences
whatever sits there as a struct t7xx_ccmni.

Drop the skb when the index is out of range.

Fixes: 05d19bf500f8 ("net: wwan: t7xx: Add WWAN network interface")
Cc: stable@vger.kernel.org
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Verified in a QEMU guest with a fault injector setting the netif
index to 25: the unpatched driver reads a value past ccmni_inst[],
which lands in the callback table, and dereferences it far enough to
queue the skb.  With this check the packet is dropped.  Well-formed
traffic on index 0 is unaffected.

Changes in v2: none.

Link: https://patch.msgid.link/20260911021734.1396599-3-zhugl3@xiaopeng.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_netdev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -420,6 +420,10 @@ static void t7xx_ccmni_recv_skb(struct t
 
 	skb_cb = T7XX_SKB_CB(skb);
 	netif_id = skb_cb->netif_idx;
+	if (netif_id >= NIC_DEV_MAX) {
+		dev_kfree_skb(skb);
+		return;
+	}
 	ccmni = READ_ONCE(ccmni_ctlb->ccmni_inst[netif_id]);
 	if (!ccmni) {
 		dev_kfree_skb(skb);


