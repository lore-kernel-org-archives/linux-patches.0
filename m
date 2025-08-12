Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49272FF164;
	Tue, 12 Aug 2025 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023160; cv=none; b=YwARQSZPq8zalbcFszo1rjcQv6RB9YE+PN9/J2n1UNcRtLdjbWs32ZR04fdKazqULFXZu7cTXyKWVucbSr8frTeQTyiYD80uMREBpSodt0IRmw9nOAYVmjxY15/efNIywTQVfLXXMp9X3TXhLqdDATBgSO3L41/MlsS/NDptO1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023160; c=relaxed/simple;
	bh=3s1OiosYkLfWjGv5OCcQfeyO4S+JrchwTD5D53QLoXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUSh/IB/ko5qU+Seth2e/tgfnMipdsa4YemrGOTi/wGCJc1vPAuVL2gvrE2b0pGKVk52P4MzBfUTXc72hhRqxmV28cZ+n1koWXGaEqsRxE5zHywzr7rWteUX+2xHPaujA3MCQlQTtf1iZojgwuX408+1unVDvd8jzCWghnvtuto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylrjshsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylrjshsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F17EC4CEF0;
	Tue, 12 Aug 2025 18:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023160;
	bh=3s1OiosYkLfWjGv5OCcQfeyO4S+JrchwTD5D53QLoXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylrjshsiTTdhHA2cB+BBa8iNYmTVK16Rg9QL1WTfStNXYCbcnEsSYDSVc1kAe8LfY
	 Dq1V+ojjQelaZ1rlA9B0T2Yska/irjfhr+7VLUPlerRuRXxXZ59kUIztDtVnqCtENX
	 TIqqYVfFVgve2qmoFRk2LfLW6guAOswRGA0izx48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>
Subject: [PATCH 6.12 368/369] USB: gadget: f_hid: Fix memory leak in hidg_bind error path
Date: Tue, 12 Aug 2025 19:31:05 +0200
Message-ID: <20250812173030.526502526@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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


