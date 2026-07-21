Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDA346A5F7;
	Tue, 21 Jul 2026 22:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672154; cv=none; b=jsQnyPneNAI6LR52lxP24ahdF8xxUTPtkmyuhwJBvgpdQxd8sPUQLLzgu+zIOj7jJp5OGkllPRTDrNS9RCXWow33GM3H8XhXwWXMLTYWlDa7NVotWVZmkv4OMXTmuRZOPhgGkKNURDjT9zvsR3qx022T7MmpNdIOmOG5/8fNkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672154; c=relaxed/simple;
	bh=6Wv4VRTQRN7u1wH1UkXF8pf3dKBnk/13iuO2w+BeM98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgQXS2/mFEmPBvnojlOUsgDoR001rPlvMCV9Q0lVUllR2GkVbGuw4QSdT7deDFwi5SLv4D5b799+i+UbAXdxCq8Q5Txu+lcNdsFjZfN5KYFLTHPrEQgH5AMkOs5DJxuLKBLzEYFSpP9Lb9O9shOEhoELWRfmWiGFeQggXquzSXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tobw2sK1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tobw2sK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD8A1F00A3E;
	Tue, 21 Jul 2026 22:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672152;
	bh=J5P440fkUmZhxJDgku8saEwNBhJFHpCaKxHgwdc/JXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tobw2sK1KGhFGl70HkL9w+5aqCRZAd4uLSZm+CfDxCeYn9i3gTfhEkSnE2jPgOimE
	 LsrP/FJExOv+gbQ65Pw/NxxDSUhsSsabiSNhFqr9w7jT6t0j05nc+0JXMVGZ5DKfqU
	 O5uBeMt8bh8pnnU9vi5FsXbqEVlbFhxHYKr7euxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 517/843] net: usb: net1080: validate packet_len before pad-byte access in rx_fixup
Date: Tue, 21 Jul 2026 17:22:32 +0200
Message-ID: <20260721152417.661892859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 03f384bc0cb8d4a1301d4f5b0baef2d980258383 ]

For an even packet_len, net1080_rx_fixup() reads the pad byte at
skb->data[packet_len] before the skb->len != packet_len check further
down, and packet_len is only bounded against NC_MAX_PACKET. A malicious
NetChip 1080 device can send a short frame advertising a large even
packet_len (e.g. 0x4000), so the pad-byte read lands past the end of the
skb:

  BUG: KASAN: slab-out-of-bounds in net1080_rx_fixup
  Read of size 1 at addr ffff8880106c83c6 by task ksoftirqd/0/14
   ...
   net1080_rx_fixup (drivers/net/usb/net1080.c:384)
   usbnet_bh (drivers/net/usb/usbnet.c:1589)
   process_one_work (kernel/workqueue.c:3322)
   bh_worker (kernel/workqueue.c:3708)
   tasklet_action (kernel/softirq.c:965)
   handle_softirqs (kernel/softirq.c:622)
   ...

Reject the frame when packet_len >= skb->len before reading.

Fixes: 904813cd8a0b ("[PATCH] USB: usbnet (4/9) module for net1080 cables")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260630045121.1565324-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/net1080.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/net1080.c b/drivers/net/usb/net1080.c
index b0c0c9dd6a028d..8a66549cefa7df 100644
--- a/drivers/net/usb/net1080.c
+++ b/drivers/net/usb/net1080.c
@@ -381,7 +381,7 @@ static int net1080_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	skb_trim(skb, skb->len - sizeof *trailer);
 
 	if ((packet_len & 0x01) == 0) {
-		if (skb->data [packet_len] != PAD_BYTE) {
+		if (packet_len >= skb->len || skb->data[packet_len] != PAD_BYTE) {
 			dev->net->stats.rx_frame_errors++;
 			netdev_dbg(dev->net, "bad pad\n");
 			return 0;
-- 
2.53.0



