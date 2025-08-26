Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8E3279788;
	Tue, 26 Aug 2025 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215199; cv=none; b=gOyw3Bzxst1wqagdD3cFV9nPZReXyGgCw3YSvd1u3QcoI/SLz1Eo73lPVO/e4n6CND9utqN13dvZsDvTLAh64OZDbOxQ8LAmjcinVMXQQPk87z50yn5TgIYG+euyT0iKktlvaUReoz6cwpklTB+VLclCCCs+tFlOKYsGSFMshII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215199; c=relaxed/simple;
	bh=sgKzZScs3iLZfnccpiL32pmXVCerxPJrX3MZy4sfG8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQtoM/sMecaZfMdzs4+oj7JzTHFEEn2rS1F9e6JzqoHs6OJbiyKXm1CU8JUwKqY2KybTH6+8JShndCGC1v+opg/a2E5UwIO2yzzchtk5+fgIVCebqhdRlCyzweEM3Kfukwo3VYEejcE7+czQFzHxf5uTTtCrlc6MJ49eekqeNOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXqLdZJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXqLdZJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0136AC4CEF1;
	Tue, 26 Aug 2025 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215199;
	bh=sgKzZScs3iLZfnccpiL32pmXVCerxPJrX3MZy4sfG8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXqLdZJ3hAlsxAjnnBq1zC5IjTF4jHvwRyQqTYEauDDHTOIiVxFv88iwxTvMrwYij
	 OFRh8GpXAS6CwNEYNjO3LfNAhDcYEkuicn//9ZLfEJioo+qsrdJV/7H3KbrHvBG4m4
	 pPnpx9eTYLAA9SwmYespNp4OOD4lDr+Cg7bx0AZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 417/482] usb: core: hcd: fix accessing unmapped memory in SINGLE_STEP_SET_FEATURE test
Date: Tue, 26 Aug 2025 13:11:10 +0200
Message-ID: <20250826110941.129330951@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2177,7 +2177,7 @@ static struct urb *request_single_step_s
 	urb->complete = usb_ehset_completion;
 	urb->status = -EINPROGRESS;
 	urb->actual_length = 0;
-	urb->transfer_flags = URB_DIR_IN;
+	urb->transfer_flags = URB_DIR_IN | URB_NO_TRANSFER_DMA_MAP;
 	usb_get_urb(urb);
 	atomic_inc(&urb->use_count);
 	atomic_inc(&urb->dev->urbnum);
@@ -2241,9 +2241,15 @@ int ehset_single_step_set_feature(struct
 
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


