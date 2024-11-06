Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BB51DFE33;
	Wed,  6 Nov 2024 13:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898891; cv=none; b=qKXuDdBtawi9u8RZw8ZNq2c7SzDIZQjqj8uTZpi2Mu6KTZBT2BZQ0W3ZEV3jUA5JcWGBAm+qtTYrwSDOYbXYK3IM8eTy5JVrqhdrmVCwkfxKehcLpIGZ1HQlWzu89GHbRxw5rvjm3ECkxFp81z9MwUNhjkH+7vDlVA3bvqia1Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898891; c=relaxed/simple;
	bh=Zu+nTqfZXABYJPOelE5+72bWzRM2p0Yv5N+PpGg4p6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xfi4rfF+4UEnUsflwwrn6dGQDlABIL9prPzaYZ1ivAmPoQesKGsABkpZxg1uILhOl4XcA/3NXvoG+KYxPjIb3J1mG16aCdkznGVxvIbGeW6o9+cb7miz7/iG30HfhGPgmCJfqNRCr5D3hu3TiuCVJHM/B++O/qYh98pNnPi0ch4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFIe8g1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFIe8g1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE72C4CED3;
	Wed,  6 Nov 2024 13:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898890;
	bh=Zu+nTqfZXABYJPOelE5+72bWzRM2p0Yv5N+PpGg4p6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFIe8g1IWCmFSS/L05bvZq+qQT8xdS7f6MNFT6AD/vluW0ioPHyDIZBgonGS/AgwG
	 EiyL68T4iC6Aa++6yhRELfxJaDyRW6rMe0TDFU69BifTnYF9cAIa3IsDGzAOvxhoGC
	 DuTDYr31vvsuDBZHwvAiTJCYEhxN/CkjtpK++ow4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	"David S. Miller" <davem@davemloft.net>,
	Bruno VERNAY <bruno.vernay@se.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.4 343/462] CDC-NCM: avoid overflow in sanity checking
Date: Wed,  6 Nov 2024 13:03:56 +0100
Message-ID: <20241106120339.996824714@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 8d2b1a1ec9f559d30b724877da4ce592edc41fdc upstream.

A broken device may give an extreme offset like 0xFFF0
and a reasonable length for a fragment. In the sanity
check as formulated now, this will create an integer
overflow, defeating the sanity check. Both offset
and offset + len need to be checked in such a manner
that no overflow can occur.
And those quantities should be unsigned.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Bruno VERNAY <bruno.vernay@se.com>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ncm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1707,10 +1707,10 @@ int cdc_ncm_rx_fixup(struct usbnet *dev,
 {
 	struct sk_buff *skb;
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
-	int len;
+	unsigned int len;
 	int nframes;
 	int x;
-	int offset;
+	unsigned int offset;
 	union {
 		struct usb_cdc_ncm_ndp16 *ndp16;
 		struct usb_cdc_ncm_ndp32 *ndp32;
@@ -1782,8 +1782,8 @@ next_ndp:
 			break;
 		}
 
-		/* sanity checking */
-		if (((offset + len) > skb_in->len) ||
+		/* sanity checking - watch out for integer wrap*/
+		if ((offset > skb_in->len) || (len > skb_in->len - offset) ||
 				(len > ctx->rx_max) || (len < ETH_HLEN)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "invalid frame detected (ignored) offset[%u]=%u, length=%u, skb=%p\n",


