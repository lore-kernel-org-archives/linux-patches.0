Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF98E3DDAFC;
	Wed, 30 Sep 2026 19:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796419; cv=none; b=NgF+n+DCIFIis1KIMQcDDWvAZoa1qnd8tZOsoZc/YPVAnJ5PiEU+/vV52m6aprKP57CqCufenwrB0F7oO+HL7hHuuF2lzJowwKc9ewrNX2XIHHxM6GD7BkacBdc902s4jg+HTAdeFZjcELMz5lAzrORM3RFgd3bUBQ3Y5oiai2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796419; c=relaxed/simple;
	bh=YeAcvhOfKjQC8Lvf/KvMDAtP1IUe2GwgDbRzyhGZk0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bj+7ekAEEd/+icJnoQZbduXhpCZcK2iWFJKdu9mz94Ss4BJmag8sO8f1ef5c6lUKlZCSfyuOX9h5QpIzVTuNATyKYSOTmjtNHMNJnJvxQIwxzVd/ZH9ghRTRLcXyJ7BMlDmR4lYXtTwVb+brIlUic/EaPdIF/KUqg47+A1GHe1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8/Ba5ZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8/Ba5ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC5F1F000FF;
	Wed, 30 Sep 2026 19:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796417;
	bh=Edu3PH3Ck7eFDCSf1Eztoy0s13yBecX/+7hH93QMmiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8/Ba5ZKaDBQY9hMS15IaYpETmFmkvi3eUNRBjWQ31dggepSf+Ko2tCylijZJHxJJ
	 JI39GkGmPAXu91JwW5ciC+V/MxFmvkx6AdbiC2+2JFPrX72DJlqbC/bHzlTbnLRlLz
	 WhYsatWW1/xc2CUUyAM+ntdrjXHA91X+aUG8xQuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0861/1193] net: wwan: t7xx: validate the netif index in t7xx_ccmni_recv_skb()
Date: Wed, 30 Sep 2026 17:25:45 +0200
Message-ID: <20260930152453.362835915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -414,6 +414,10 @@ static void t7xx_ccmni_recv_skb(struct t
 
 	skb_cb = T7XX_SKB_CB(skb);
 	netif_id = skb_cb->netif_idx;
+	if (netif_id >= NIC_DEV_MAX) {
+		dev_kfree_skb(skb);
+		return;
+	}
 	ccmni = READ_ONCE(ccmni_ctlb->ccmni_inst[netif_id]);
 	if (!ccmni) {
 		dev_kfree_skb(skb);


