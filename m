Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCDC4E780D;
	Wed, 30 Sep 2026 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786618; cv=none; b=tplvDoUvXtYbhCvRLsEgsK6dgWxE7UotnauAo3BBAms/98o+UVoED/+UlxXxrZrMBZfScrbFRL7d4zqRJk0uvRsEhg/Cvmge5rhwtoNAum4ujpflelbrWrmGSh49rXNO+wWrkzJk6V164atUQoKgoe6QiFqpVMTN3ap6SLdo0Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786618; c=relaxed/simple;
	bh=pCy1oqVTqlZG+gouElcW0VARJGNQZyqkPjbWbSkiNsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7v6DpxNSznfOSwAeJrc50DxedZenwHL7P03t3+GajTgne5Z3ULXy70LWcGFl8gmcdtmdfu70gCWV7/aPrJxvVYJZHMBeqg1p9QX078w6RpsaCJBwhWetFh7d6nkg+rqEebTFIGCVLj6Elk4HDBWSc1fFPSvYFywg76gVIpPnhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cItw9w5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cItw9w5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F5F1F00898;
	Wed, 30 Sep 2026 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786616;
	bh=4ACNLoLEdRQdU/j1mNtMTlsA68DJc1OIDTLcquiVOO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cItw9w5dw+x/ros3mPTNMsQxp1cAgnLd/HWFDdrh5X6w27svaGdbizRkIDkJbq5aS
	 04QMo4PUnuSFAhg9RaN9LqZDETdYd6dcOiFGRDWV4tDXHOLYzxFFjk4VBmPaJrDAhz
	 PE6I/QXI/RaPJ6rYkMTMKbKg60EwNz1J8ieVesfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 923/982] net: wwan: t7xx: validate the netif index in t7xx_ccmni_recv_skb()
Date: Wed, 30 Sep 2026 17:27:39 +0200
Message-ID: <20260930152436.568541971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Link: https://patch.msgid.link/20260911021734.1396599-3-zhugl3@xiaopeng.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_netdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index f71d3bc3b237c..2eea9997b8fda 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -321,6 +321,10 @@ static void t7xx_ccmni_recv_skb(struct t7xx_pci_dev *t7xx_dev, struct sk_buff *s
 
 	skb_cb = T7XX_SKB_CB(skb);
 	netif_id = skb_cb->netif_idx;
+	if (netif_id >= NIC_DEV_MAX) {
+		dev_kfree_skb(skb);
+		return;
+	}
 	ccmni = t7xx_dev->ccmni_ctlb->ccmni_inst[netif_id];
 	if (!ccmni) {
 		dev_kfree_skb(skb);
-- 
2.53.0



