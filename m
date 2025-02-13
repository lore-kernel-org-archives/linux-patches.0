Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE4D70805;
	Thu, 13 Feb 2025 15:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460642; cv=none; b=TBxksTkku0m0yCIYL8bIt3QYXyZsLsGpkzZZXC9F1khlrjA1tBB8+BaY3oANEIUYYcojagVQOdg2eF0bM++cG8v3nnWg0yYfqcJVLOi5Ioj9Icwk8MluPHa43XodVZPgm+iL53U1MhMRlHPs3iGi7rHBGNWISTExS9DB+48CkEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460642; c=relaxed/simple;
	bh=AdPCh8HsSyEq3DDthl8DL+4hA2NVOYtgPAOAW+xCWts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeA1T1G3LjcRK7bBcvW3rD62HEegHKeXUS1IBClqrNi2b2Xp+in7O9pQGpjURLFVA7uhQ3Rqhb0V8dCvo5pTl1Y4yz3S5m7LBaYOzSDclfEoz2ayKjpji8kD2dESUn49P6t2Vc+qDnDcvqerVVFkSm/phIgqLyINczw2RkdznYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0cbi9s2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0cbi9s2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E977CC4CED1;
	Thu, 13 Feb 2025 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460642;
	bh=AdPCh8HsSyEq3DDthl8DL+4hA2NVOYtgPAOAW+xCWts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0cbi9s2JNVViFQrtz9Pb7jcoDGIQULhQpg1uI1Tc/1qv0g3USa2pDjEzslaLms6d
	 0ojV/L/dFChmHPlDXorFQbLBbmhO/0/h5vzNSEg+7IwSm2X9D+nkTodSc5+YYQzJpI
	 /HpkPz5ZZ86qlY/1lRvBd1aqVzke2gAGqYnINqh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 139/273] usbnet: ipheth: refactor NCM datagram loop
Date: Thu, 13 Feb 2025 15:28:31 +0100
Message-ID: <20250213142412.831075866@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Foster Snowhill <forst@pen.gy>

commit 2a9a196429e98fcc64078366c2679bc40aba5466 upstream.

Introduce an rx_error label to reduce repetitions in the header
signature checks.

Store wDatagramIndex and wDatagramLength after endianness conversion to
avoid repeated le16_to_cpu() calls.

Rewrite the loop to return on a null trailing DPE, which is required
by the CDC NCM spec. In case it is missing, fall through to rx_error.

This change does not fix any particular issue. Its purpose is to
simplify a subsequent commit that fixes a potential OoB read by limiting
the maximum amount of processed DPEs.

Cc: stable@vger.kernel.org # 6.5.x
Signed-off-by: Foster Snowhill <forst@pen.gy>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c | 42 ++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index c385623596d2..069979e2bb6e 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -213,9 +213,9 @@ static int ipheth_rcvbulk_callback_ncm(struct urb *urb)
 	struct usb_cdc_ncm_ndp16 *ncm0;
 	struct usb_cdc_ncm_dpe16 *dpe;
 	struct ipheth_device *dev;
+	u16 dg_idx, dg_len;
 	int retval = -EINVAL;
 	char *buf;
-	int len;
 
 	dev = urb->context;
 
@@ -227,39 +227,43 @@ static int ipheth_rcvbulk_callback_ncm(struct urb *urb)
 	ncmh = urb->transfer_buffer;
 	if (ncmh->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN) ||
 	    /* On iOS, NDP16 directly follows NTH16 */
-	    ncmh->wNdpIndex != cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16))) {
-		dev->net->stats.rx_errors++;
-		return retval;
-	}
+	    ncmh->wNdpIndex != cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16)))
+		goto rx_error;
 
 	ncm0 = urb->transfer_buffer + sizeof(struct usb_cdc_ncm_nth16);
-	if (ncm0->dwSignature != cpu_to_le32(USB_CDC_NCM_NDP16_NOCRC_SIGN)) {
-		dev->net->stats.rx_errors++;
-		return retval;
-	}
+	if (ncm0->dwSignature != cpu_to_le32(USB_CDC_NCM_NDP16_NOCRC_SIGN))
+		goto rx_error;
 
 	dpe = ncm0->dpe16;
-	while (le16_to_cpu(dpe->wDatagramIndex) != 0 &&
-	       le16_to_cpu(dpe->wDatagramLength) != 0) {
-		if (le16_to_cpu(dpe->wDatagramIndex) < IPHETH_NCM_HEADER_SIZE ||
-		    le16_to_cpu(dpe->wDatagramIndex) >= urb->actual_length ||
-		    le16_to_cpu(dpe->wDatagramLength) > urb->actual_length -
-		    le16_to_cpu(dpe->wDatagramIndex)) {
+	while (true) {
+		dg_idx = le16_to_cpu(dpe->wDatagramIndex);
+		dg_len = le16_to_cpu(dpe->wDatagramLength);
+
+		/* Null DPE must be present after last datagram pointer entry
+		 * (3.3.1 USB CDC NCM spec v1.0)
+		 */
+		if (dg_idx == 0 && dg_len == 0)
+			return 0;
+
+		if (dg_idx < IPHETH_NCM_HEADER_SIZE ||
+		    dg_idx >= urb->actual_length ||
+		    dg_len > urb->actual_length - dg_idx) {
 			dev->net->stats.rx_length_errors++;
 			return retval;
 		}
 
-		buf = urb->transfer_buffer + le16_to_cpu(dpe->wDatagramIndex);
-		len = le16_to_cpu(dpe->wDatagramLength);
+		buf = urb->transfer_buffer + dg_idx;
 
-		retval = ipheth_consume_skb(buf, len, dev);
+		retval = ipheth_consume_skb(buf, dg_len, dev);
 		if (retval != 0)
 			return retval;
 
 		dpe++;
 	}
 
-	return 0;
+rx_error:
+	dev->net->stats.rx_errors++;
+	return retval;
 }
 
 static void ipheth_rcvbulk_callback(struct urb *urb)
-- 
2.48.1



