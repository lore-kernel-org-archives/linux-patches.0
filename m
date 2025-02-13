Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C4328137F;
	Thu, 13 Feb 2025 14:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457791; cv=none; b=uvmI8C/FPJrPNGR+nhGTvX5syPHUEAN3S/PsqKReDk9Os1Q4BLOEVMMarM9FfWzh0ZOpjxtSdWC8QKthkO/RfPVHh/HlJenbvk6H7BcRkx8RN7lIHlOiUKPPxUpnNIbttWwKD/VF9IETN0I9cARr7GgCFCcmuIX3gYQlRvq0+Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457791; c=relaxed/simple;
	bh=NIEkrQnvdAJuclO2hOlrlSo5KBVU+14qktyvjAGzP4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ly5Q3NsrYwVRBB5+yrNdGM0PiLHTEK73o/V6XBP+2k4za1egcipO+AVCHxIgB5y80fJCntalQ3KWyd+QaDToFm/ZT6/jPAL6ANyn1JRVT2kh7AL8yDGLj76aFF25DuT/r6oZnmKXi0xKhP4u4SEXmbj5EI7GkCIXM3rPxPQwfAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXZytnDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXZytnDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9AAC4CED1;
	Thu, 13 Feb 2025 14:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457790;
	bh=NIEkrQnvdAJuclO2hOlrlSo5KBVU+14qktyvjAGzP4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXZytnDtWUmVYvFHRrEVUmOMHmaFnNTyZCQ9EegxZRQjD0IxWLtr9WdGVUW2gmZeR
	 BgcKgPBt5zcwfxTQrFky7Cv/MxG65LRMHBP9vjyPHXKGU+cVVoOJ5WO3N476PBQlY3
	 hPFdrINNxgbztTVQKQagKPpFdnL0MMo6YuDEIdSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 213/422] usbnet: ipheth: use static NDP16 location in URB
Date: Thu, 13 Feb 2025 15:26:02 +0100
Message-ID: <20250213142444.757659103@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Foster Snowhill <forst@pen.gy>

commit 86586dcb75cb8fd062a518aca8ee667938b91efb upstream.

Original code allowed for the start of NDP16 to be anywhere within the
URB based on the `wNdpIndex` value in NTH16. Only the start position of
NDP16 was checked, so it was possible for even the fixed-length part
of NDP16 to extend past the end of URB, leading to an out-of-bounds
read.

On iOS devices, the NDP16 header always directly follows NTH16. Rely on
and check for this specific format.

This, along with NCM-specific minimal URB length check that already
exists, will ensure that the fixed-length part of NDP16 plus a set
amount of DPEs fit within the URB.

Note that this commit alone does not fully address the OoB read.
The limit on the amount of DPEs needs to be enforced separately.

Fixes: a2d274c62e44 ("usbnet: ipheth: add CDC NCM support")
Cc: stable@vger.kernel.org
Signed-off-by: Foster Snowhill <forst@pen.gy>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -226,15 +226,14 @@ static int ipheth_rcvbulk_callback_ncm(s
 
 	ncmh = urb->transfer_buffer;
 	if (ncmh->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN) ||
-	    le16_to_cpu(ncmh->wNdpIndex) >= urb->actual_length) {
+	    /* On iOS, NDP16 directly follows NTH16 */
+	    ncmh->wNdpIndex != cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16))) {
 		dev->net->stats.rx_errors++;
 		return retval;
 	}
 
-	ncm0 = urb->transfer_buffer + le16_to_cpu(ncmh->wNdpIndex);
-	if (ncm0->dwSignature != cpu_to_le32(USB_CDC_NCM_NDP16_NOCRC_SIGN) ||
-	    le16_to_cpu(ncmh->wHeaderLength) + le16_to_cpu(ncm0->wLength) >=
-	    urb->actual_length) {
+	ncm0 = urb->transfer_buffer + sizeof(struct usb_cdc_ncm_nth16);
+	if (ncm0->dwSignature != cpu_to_le32(USB_CDC_NCM_NDP16_NOCRC_SIGN)) {
 		dev->net->stats.rx_errors++;
 		return retval;
 	}


