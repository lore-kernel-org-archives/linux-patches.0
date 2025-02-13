Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2E3645;
	Thu, 13 Feb 2025 15:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459342; cv=none; b=Hy7JcXFGLfzV47ROaNg+fh04lSku+oqMnsMAy5DnqQsasJsnusY3KFygLWXRLZGnCkAYnL6PPJipR0KOAZZg1Mmns41DfBW2EmdeBqZKwHhVRsnYkpP70kxnqVoJSFmoTVTndP+CDmJO9zjZB4DMloIJiTGBc+j6DB0T1yu7iw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459342; c=relaxed/simple;
	bh=r+daqsw3PzsCgkOwv5UuaB1ziBAPJA5Y1QVwOeeZL5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4Sc/yBfALZ96jK+vwOkxIv+LUSkgMdFh8SIcOZeL/OFE6b261Asi9/fVltsjRS3w2GVU9iiLEMPFxqshw2oJKBd3NxwFOaiyyArLlmby6UWw7S2E1suKsHSPjl+tQQaFdaGvdxgXf68JWYixBo8y9YGlsPfQQ9uDi5FyMMvq1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waFdkQ3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waFdkQ3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A384FC4CED1;
	Thu, 13 Feb 2025 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459342;
	bh=r+daqsw3PzsCgkOwv5UuaB1ziBAPJA5Y1QVwOeeZL5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waFdkQ3WXtGPY2PKsu81A+uUQp5GFcavLP1rR8e7hxsJwbqOYWKFamPCXA8EVnwh0
	 qn2Hzz0CkD8ydGEg1wQaWt7eL34QssHmjCgaEyYycE49wWQT5lxNc5e6pjgyxsBcYp
	 lEBPqCziiJ+9QxWP+bHf/DyvbTicuOTk2R4ocD2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.13 235/443] usbnet: ipheth: use static NDP16 location in URB
Date: Thu, 13 Feb 2025 15:26:40 +0100
Message-ID: <20250213142449.681474628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


