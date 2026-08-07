Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C399347A876;
	Fri,  7 Aug 2026 15:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117571; cv=none; b=CWv6rrSAObZbueLVmjurnge2dyK6/bQ/kpDUFkFfgNjCIId3Iej0w+SjBsG45eFnkLZWObb1OJ5mxswBiIe0IAprttqeSHEd5+Dk9Y8evZHWX3n0kC9uPzWjG6SII24+NCIj5ugSldsLVs5xnaDrwxoLjp+lBcV5ZFalYEoNJgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117571; c=relaxed/simple;
	bh=nh/Gy0KPJlC3NaoTqgHz+TPmmYPAH7WOdv3KgyhrIQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXUpGNuwo+1lE1tSwI9I1z9kKtPSjVGX2VxhrATJh1+gx7Wojo54mflt03ge9T7mjgDY7mHcXilP16cMdlC97sZB3wB1SYUQIGU31mE8gPl+kEq6q6ysFcNTKWPc+VA9m6IZ/SDWE2ob4W9ZFgy+jZd4EkDlfclKiCqdrFIu4io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUiPXo+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUiPXo+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043C71F000E9;
	Fri,  7 Aug 2026 15:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117569;
	bh=dVWHnTxN0fOK5z3jHsDrfsYquZp9586Z7uyqeGeB2cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUiPXo+07MEHDhlPMGEPp2cm81uGOBTOVt5h5srN0ghQAC/tla2KgOkmFcQl+M4Vz
	 HQ0gC+MOPrTfJmP3UglOY8iLRsV2u8j+GGv/mFj/YBDLegQAdlYBE3Wc2ZzLSd+5TB
	 8+1mNIxQK5fpANObLpq8pAWTL8OoQ6dybJhXfwt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.1 366/438] can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure
Date: Fri,  7 Aug 2026 16:39:22 +0200
Message-ID: <20260807143435.775998522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 68c5724ecd159992f76edb7b57dc508a44c8b7da upstream.

If the allocation of the SKB in gs_usb_receive_bulk_callback() fails, the
driver returns from the callback without resubmitting the URB in order to
receive further USB in URBs.

This results in a silent performance degradation which, if it occurs
repeatedly, results in starvation of USB in traffic.

Instead of returning immediately, try to resend the URB. If this also
fails, this is logged as an info message.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Fixes: 26949ac935e3 ("can: gs_usb: add CAN-FD support")
Link: https://patch.msgid.link/20260709-gs_usb-resubmit-urb-v1-1-4dd40030cc84@pengutronix.de
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -674,7 +674,7 @@ static void gs_usb_receive_bulk_callback
 		if (hf->flags & GS_CAN_FLAG_FD) {
 			skb = alloc_canfd_skb(netdev, &cfd);
 			if (!skb)
-				return;
+				goto resubmit_urb;
 
 			cfd->can_id = le32_to_cpu(hf->can_id);
 			cfd->len = data_length;
@@ -687,7 +687,7 @@ static void gs_usb_receive_bulk_callback
 		} else {
 			skb = alloc_can_skb(netdev, &cf);
 			if (!skb)
-				return;
+				goto resubmit_urb;
 
 			cf->can_id = le32_to_cpu(hf->can_id);
 			can_frame_set_cc_len(cf, hf->can_dlc, dev->can.ctrlmode);


