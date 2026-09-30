Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB10D51597D;
	Wed, 30 Sep 2026 16:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787238; cv=none; b=Lew5AYI8f0OhLiUt80oTw/QjwMdwkBDsxbWJmbN/x/cq6BKPrSDueyuY7yVvnWIMCeFsn/cPxKUZaD0MlylwavxPGTOFAjnKT9pK9mK2dLkHRwhtCB7DGbJfUgdFflHbv+TcRk0Fb4DZpoyIDEJaw1Ug+1wI3nwObbGS/NxIgUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787238; c=relaxed/simple;
	bh=qw7wgfLP5yUXUh+w4LP6QWb4ytIWPFkGzTAeefcqfo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbQDugV9t3wbnLjhitjEECUy73JJ2BDO6fhlKmG1RhfHjr9losTjywpnkSMc/Jz7hQJ0nYaMGLmUuWVSiQwEAyhyP5Qro7Gwdvm6ANx6mkXcLAjdQOUoI8ZClrT0NQ7y5t7I4EhdwW+8h0AhcYymS8zoyy+YSZqO41UhYRtHStE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=za+6X51K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="za+6X51K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C311F000FF;
	Wed, 30 Sep 2026 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787237;
	bh=PboRzsTUC/ojKflG412BP8Y+nduNBCbwpnNZpBlZXR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=za+6X51KvZ5ZN6Vz2xfJpmsbd5nuKqIOwDH+YPj/nH7qs5yyjg/hPFLI9VujL5osj
	 rFPusAqXz4cMfrkW9oXxrX4aXqXT4E+9Ra3TRmZb/7fUzhvzQcWYC06x7InDTnd9OV
	 981DDZPnZMIUpDev8hk/v9GY8guDrgAVN9QVMshA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 105/457] net: usb: catc: bound the RX packet length in catc_rx_done()
Date: Wed, 30 Sep 2026 17:23:30 +0200
Message-ID: <20260930152348.317964690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index 96e82f94edcf8..39b678f175dd9 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -233,17 +233,26 @@ static void catc_rx_done(struct urb *urb)
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



