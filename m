Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E58D1B4F0C;
	Wed, 19 Feb 2025 09:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956677; cv=none; b=iqB3aXusy6vTyJiCDYmJt0H5tDAcrn2nF2hxxAHTKvEyvHibKKF+wkRtHKKPWhLSzDoChNFnZnC/5Aj+dHCeDthrmjMvundy8HSHF0zUPZzME6eFp6LLisvGY8V7++pCbL/V5L479yaSFJprSW5Y2PWde8zzTvs5TD/Qbdj06DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956677; c=relaxed/simple;
	bh=CnI65ecwaJpCqZ3ars3pU+yYBmAHFsIyKMrPi0vqMig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdbtQ1vCzqpMyy3kn8nmnS/MYKrjq6ZbaTYUVnXJy7TE41GvovCHqeof5x6T2DIZoptvKMx6JF6rTIehhxw0musp58KVatFbjhXa9COV+8eIgaG+17Dg5pywfDsSXAOLCE7FkOmqX9Y0rehd7reZmpK6CMW1PyQqmGbH+izW7PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsZeuQm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsZeuQm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8986C4CEE8;
	Wed, 19 Feb 2025 09:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956677;
	bh=CnI65ecwaJpCqZ3ars3pU+yYBmAHFsIyKMrPi0vqMig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsZeuQm7z4jgcsYytbGFU9G+Kps46UGJ/DR4HN//gnlHPz/YKIGUA2a9yvIg3Db2U
	 9wSuSm+q4c5FlgOd98eXL33121qXalfEBl95gULth/QURl44drkJ/NgbCaRR1mV5KD
	 v5oXdj9h8wm1vtsCzqP42M/emNS1gwsQOPKW2k/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 262/578] media: uvcvideo: Fix double free in error path
Date: Wed, 19 Feb 2025 09:24:26 +0100
Message-ID: <20250219082703.330407370@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
@@ -267,6 +267,7 @@ int uvc_status_init(struct uvc_device *d
 	dev->int_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (dev->int_urb == NULL) {
 		kfree(dev->status);
+		dev->status = NULL;
 		return -ENOMEM;
 	}
 


