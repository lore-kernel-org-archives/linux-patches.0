Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949B9338F51;
	Tue, 26 Aug 2025 14:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216898; cv=none; b=gTuBwIf2rXABJbEsoiJjZ8JRAn4tBHgxANUsg60Jv8WM876Q13tvYOTKYr0kaGnOKEr5JX3wEtbPcoV9LYYyJ4cAwTyutIKc5JSQLZd8ughoEBrwLWC7ZXFoB4FJi7UJjM/bzSyf+KG0C7x+XCO4LYv8vo8DxxNuX2EPEpGesTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216898; c=relaxed/simple;
	bh=1sdUX26wuyTlCprdjEVcaabsePPT0CQtRlrxA8Ih96A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dd+oU2ybXtV1ErPX7N+i3qRkl66pGlUJy6WBrEQ7jM7x3slegWgGaD6qUmwgD3SskDK3v4C7HFGWTYKe2nf5Fe1Cc4v2PAfBNPiwUVTYYpqL2ocgmM1LKX0uaGakMYyvX40w59KLQITuiQj9lsKHgjkowjjeY3HG8fo57faCt8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XL3R1FK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XL3R1FK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DFFC4CEF1;
	Tue, 26 Aug 2025 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216898;
	bh=1sdUX26wuyTlCprdjEVcaabsePPT0CQtRlrxA8Ih96A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XL3R1FK8Ns2yzlRtbizs8OzjvWd45/2YL2S1z2iImF+pNvJdbyL/OnW/qJQlD0ems
	 lVl3uSvnZcBI3oHKsJI6/3MTTL+6qT1V4Ii9xjpnPOntzmweF7SezrSzA1uOKrdzzl
	 EYwiuWjwYA+FCpbr5YyiH+7VY8VbDzKMG6F1KQC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 585/644] usb: core: hcd: fix accessing unmapped memory in SINGLE_STEP_SET_FEATURE test
Date: Tue, 26 Aug 2025 13:11:16 +0200
Message-ID: <20250826111001.032066401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 8fe06185e11ae753414aa6117f0e798aa77567ff upstream.

The USB core will unmap urb->transfer_dma after SETUP stage completes.
Then the USB controller will access unmapped memory when it received
device descriptor. If iommu is equipped, the entire test can't be
completed due to the memory accessing is blocked.

Fix it by calling map_urb_for_dma() again for IN stage. To reduce
redundant map for urb->transfer_buffer, this will also set
URB_NO_TRANSFER_DMA_MAP flag before first map_urb_for_dma() to skip
dma map for urb->transfer_buffer and clear URB_NO_TRANSFER_DMA_MAP
flag before second map_urb_for_dma().

Fixes: 216e0e563d81 ("usb: core: hcd: use map_urb_for_dma for single step set feature urb")
Cc: stable <stable@kernel.org>
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250806083955.3325299-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2183,7 +2183,7 @@ static struct urb *request_single_step_s
 	urb->complete = usb_ehset_completion;
 	urb->status = -EINPROGRESS;
 	urb->actual_length = 0;
-	urb->transfer_flags = URB_DIR_IN;
+	urb->transfer_flags = URB_DIR_IN | URB_NO_TRANSFER_DMA_MAP;
 	usb_get_urb(urb);
 	atomic_inc(&urb->use_count);
 	atomic_inc(&urb->dev->urbnum);
@@ -2247,9 +2247,15 @@ int ehset_single_step_set_feature(struct
 
 	/* Complete remaining DATA and STATUS stages using the same URB */
 	urb->status = -EINPROGRESS;
+	urb->transfer_flags &= ~URB_NO_TRANSFER_DMA_MAP;
 	usb_get_urb(urb);
 	atomic_inc(&urb->use_count);
 	atomic_inc(&urb->dev->urbnum);
+	if (map_urb_for_dma(hcd, urb, GFP_KERNEL)) {
+		usb_put_urb(urb);
+		goto out1;
+	}
+
 	retval = hcd->driver->submit_single_step_set_feature(hcd, urb, 0);
 	if (!retval && !wait_for_completion_timeout(&done,
 						msecs_to_jiffies(2000))) {


