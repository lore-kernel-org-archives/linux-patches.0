Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A195385D97;
	Wed, 30 Sep 2026 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783743; cv=none; b=si19FN9H5LQ+iRIjmsx/P+RMEpEhMBY+hAt7xnr6ekzVP/7vm1fZdOHdq3Q1kUClvuEtoUzvtQU+fVP2JZGFOdFnPOTSK7iZPxr0vLhD3SnRHHCRGrb0A1s95/eMGxMF6R91M4qybUDijunUny+NKNZuctwQzIqstrzf/RGApAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783743; c=relaxed/simple;
	bh=tcQz/wQdTkE4XdpVRySF5Xbk98v2FE4zDtjC1HrzijY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3bLzzpz/63DyGtij6GKLbLXexJn59ndbBEdm2L1Gb8MvMnlr9pRmgisoHPIZPTP8wWyCFGFn52vcFa4jCTaluDtYdHQHn0Ltmf1cL3cHzg7ngYb8/uKIGoNA18XVGKn/whfd7TzzT/UWezpZfRShi4oa3rNrDQaQ0dw79v/P1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqolRfpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqolRfpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCE81F00899;
	Wed, 30 Sep 2026 15:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783738;
	bh=eT2WiuK+JUpXp4nLSndodu+SvoXjzPS3xFL5unhTJLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqolRfpV8m5ovoxTl1C6mOWvmfdINZQ/P3XgK31bsiEgXO8BehgFS1He0g5Wv6Emd
	 fezZiMOleNFV1vdtqW0e17QPd6jXGwOXBdDiyxNZGMG2YDyl3+u2LxMY8SJHgsJfTS
	 6XIrhvxjePuZ0t6zI3z1DaQm5Bwm3fp+QONZM/Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 506/595] net: usb: catc: bound the RX packet length in catc_rx_done()
Date: Wed, 30 Sep 2026 17:26:39 +0200
Message-ID: <20260930152358.582390523@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit 9d565b6b72fe3f41fd43636e143072848105189f ]

catc_rx_done() walks a multi-packet URB, reading a two-byte length from
each packet header. Its bound, pkt_len > urb->actual_length, ignores the
header offset and compares against the whole transfer rather than the
bytes left from pkt_start, so a crafted packet header makes
skb_copy_to_linear_data() read past the buffer.

A length below ETH_HLEN is also accepted, including zero, and
eth_type_trans() then reads a MAC header from the uninitialised tailroom
of a shorter skb. The is_f5u011 branch takes its length straight from
the transfer, so a zero-length URB reaches the same path.

Track the bytes remaining from the current packet, and reject a header
that does not fit, a length past what is left, and a length below an
Ethernet header.

A transfer shorter than an Ethernet header, including a zero-length one,
previously became a runt skb passed to netif_rx() and counted as
received; it is now counted in rx_length_errors and ends the walk.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/AS8P251MB00015FD7716F38C345619B56C8BB2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/catc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index 38951608dc572..2983ea88a7614 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -239,17 +239,26 @@ static void catc_rx_done(struct urb *urb)
 	}
 
 	do {
-		if(!catc->is_f5u011) {
-			pkt_len = le16_to_cpup((__le16*)pkt_start);
-			if (pkt_len > urb->actual_length) {
+		int remaining = urb->actual_length -
+				(pkt_start - (u8 *)urb->transfer_buffer);
+
+		if (!catc->is_f5u011) {
+			if (remaining < pkt_offset) {
 				catc->netdev->stats.rx_length_errors++;
 				catc->netdev->stats.rx_errors++;
 				break;
 			}
+			pkt_len = le16_to_cpup((__le16 *)pkt_start);
 		} else {
 			pkt_len = urb->actual_length;
 		}
 
+		if (pkt_len < ETH_HLEN || pkt_len + pkt_offset > remaining) {
+			catc->netdev->stats.rx_length_errors++;
+			catc->netdev->stats.rx_errors++;
+			break;
+		}
+
 		if (!(skb = dev_alloc_skb(pkt_len)))
 			return;
 
-- 
2.53.0



