Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31051A9F89;
	Tue, 12 Aug 2025 19:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026930; cv=none; b=Qc/frYGTi3nktvT7Oqprx91jUQ4GVvzpFBd/SlfWzcd5+CjrmbQrk96qqxqhSSgl0GyiScXPBx+vioaXvK1grjD04/5ZcBMl3EoVDgZo1otz5oCqq7wfy9GptF4sXDdVWJ2ujQZ4gTtumSI3rtu2WMK3O5BpQyVmSbWei/SirIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026930; c=relaxed/simple;
	bh=TSQMPMK5W7rRSsVSOYJG+MwDjEF+f+MJHBOTx/HReUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0DglcjfKASNQXVLD9maFAXY6xs06w/KcqZ47cL8zj9KBJuDRbQdToq15QtyoqluR4R5/qdnwJ+rIMIT54JWdG9h4uprGmGetyiFcWM5FnojvS8h/R9zHzirPsAdwS4gsAcqyzg9cydilpcLcFw2NFuhYc2aX+XiZ3TRt30JR08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPDRPYdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPDRPYdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FD0C4CEF4;
	Tue, 12 Aug 2025 19:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026930;
	bh=TSQMPMK5W7rRSsVSOYJG+MwDjEF+f+MJHBOTx/HReUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPDRPYdMVFSZsYBvqhbJBgXB2M1SxsVaoC7vr7N/JYuwVWT4hHJBksP3EPtCxMDya
	 nmI9PQse408s/ZNijO2OhX/eFbmUXqyAymLdWN3wfUj2rt1RvQtZHCHnLoaIGFNwB3
	 Pwo8I0vnQUOm+y65T27Nv3A5fVO8GABsI3ZI3aKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>
Subject: [PATCH 6.15 476/480] USB: gadget: f_hid: Fix memory leak in hidg_bind error path
Date: Tue, 12 Aug 2025 19:51:24 +0200
Message-ID: <20250812174417.005457652@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuhao Jiang <danisjiang@gmail.com>

commit 62783c30d78aecf9810dae46fd4d11420ad38b74 upstream.

In hidg_bind(), if alloc_workqueue() fails after usb_assign_descriptors()
has successfully allocated the USB descriptors, the current error handling
does not call usb_free_all_descriptors() to free the allocated descriptors,
resulting in a memory leak.

Restructure the error handling by adding proper cleanup labels:
- fail_free_all: cleans up workqueue and descriptors
- fail_free_descs: cleans up descriptors only
- fail: original cleanup for earlier failures

This ensures that allocated resources are properly freed in reverse order
of their allocation, preventing the memory leak when alloc_workqueue() fails.

Fixes: a139c98f760ef ("USB: gadget: f_hid: Add GET_REPORT via userspace IOCTL")
Cc: stable@vger.kernel.org
Signed-off-by: Yuhao Jiang <danisjiang@gmail.com>
Link: https://lore.kernel.org/r/20250623094844.244977-1-danisjiang@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1275,18 +1275,19 @@ static int hidg_bind(struct usb_configur
 
 	if (!hidg->workqueue) {
 		status = -ENOMEM;
-		goto fail;
+		goto fail_free_descs;
 	}
 
 	/* create char device */
 	cdev_init(&hidg->cdev, &f_hidg_fops);
 	status = cdev_device_add(&hidg->cdev, &hidg->dev);
 	if (status)
-		goto fail_free_descs;
+		goto fail_free_all;
 
 	return 0;
-fail_free_descs:
+fail_free_all:
 	destroy_workqueue(hidg->workqueue);
+fail_free_descs:
 	usb_free_all_descriptors(f);
 fail:
 	ERROR(f->config->cdev, "hidg_bind FAILED\n");


