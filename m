Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CB325DD02;
	Tue, 11 Mar 2025 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705623; cv=none; b=eWErmBuwGJHMERxKGZMPAwUQGwdKFQyyVwZkGjkbGGplcA51R6KHKtIgulI3ChEzghr1efc/IXs0Qt7iTSFjS3Y9CbJC87/Y3VlTIICM3vw28qH4UE53Yrpj404lkkicNLoVzXCyNH/E+QzhcQPBYkqm9eoTQWaL3suNOEvEVnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705623; c=relaxed/simple;
	bh=togxUCCNKdOUFs9Lp9Drv+EiyFKGqg08drJTonMoh98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OENkgMQs20roCWcgFG2K0Saxx8IWyrJ/lDw8hshcK01OdBu3evZxw9LHisqLUnvFTuW3NfxjCKwK02mhE2FdHVizvdhxVhpR6n22/6sL12GO8sEgYecxxmvpdVTQ1/DGzHfkgbivDoS0WmQBdH9AS8gneVhgjDinD6PrFk5+pn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzbIPehm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzbIPehm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB68C4CEE9;
	Tue, 11 Mar 2025 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705622;
	bh=togxUCCNKdOUFs9Lp9Drv+EiyFKGqg08drJTonMoh98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzbIPehmInqzBT00c0E26DIWItqVv14arXO7thyE47qvDsR4174LSUWtZOVRrf6AT
	 F5xbMykt5vuDLvWDgPUgsMPdimIT5GNEgupqNRFm5Syy+voSYDLjf7adWT2Vdwjthb
	 IbKJAF3/AmEKwJDzLHiX9QHBvsuhzo7njdgKgQAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 080/328] media: uvcvideo: Fix double free in error path
Date: Tue, 11 Mar 2025 15:57:30 +0100
Message-ID: <20250311145718.067130572@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit c6ef3a7fa97ec823a1e1af9085cf13db9f7b3bac upstream.

If the uvc_status_init() function fails to allocate the int_urb, it will
free the dev->status pointer but doesn't reset the pointer to NULL. This
results in the kfree() call in uvc_status_cleanup() trying to
double-free the memory. Fix it by resetting the dev->status pointer to
NULL after freeing it.

Fixes: a31a4055473b ("V4L/DVB:usbvideo:don't use part of buffer for USB transfer #4")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241107235130.31372-1-laurent.pinchart@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_status.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -269,6 +269,7 @@ int uvc_status_init(struct uvc_device *d
 	dev->int_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (dev->int_urb == NULL) {
 		kfree(dev->status);
+		dev->status = NULL;
 		return -ENOMEM;
 	}
 


