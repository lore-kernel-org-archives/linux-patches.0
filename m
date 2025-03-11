Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF13D846D;
	Tue, 11 Mar 2025 15:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706658; cv=none; b=oHpUWVlgCmrCSYYRX9jd3foyUaBj6hTK+g4hvJFRlzRJb4OTv9vVMzHSXKVF1JRCo9GWu1d9PL0N23OUOUTL5aQEYTSt+KkIKYzILSLIH/eRoy+xt0LNdUbhXghr9kO5LUuynkA5Gx6+Lkuu9bo6zphtfeke+qvpTeVfLfaUQPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706658; c=relaxed/simple;
	bh=drpMQzY6N48WDutJ6T4wgmq/W+5ORgwLwWEps5NS9cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QReHZTEuLF0vNa3Agqq49amdV7+ecoAFQGC8O1X6811JqWt6E1QQM5hls9YlZjmFF6Q9a4JIOS8+Ma9qeTnxwPoLzGmWX++aUh41XrQWuYZ+teCDvgOX6A30Pe9I0WReSDTx7bSI1kdVaLZ9jq0yKBTlGyQ42PYeJPVIX/rhoYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anLzABcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anLzABcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0988C4CEE9;
	Tue, 11 Mar 2025 15:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706658;
	bh=drpMQzY6N48WDutJ6T4wgmq/W+5ORgwLwWEps5NS9cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anLzABcFNxNYpVZpGFivc9amdbHsh00grep1oTYYbSVFmp+gjiT4XU6kh9Lpx8ttx
	 09rIOUCmdVH/u2nGhfTQTAKBw2sFK7+gON7f8BTA73U4E4YxRkmhhIQV8qjq8QHZQt
	 xIUtSRHcgenbVsRJwF3f/oAwhxWERYs3emK/VoyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 123/462] media: uvcvideo: Fix double free in error path
Date: Tue, 11 Mar 2025 15:56:29 +0100
Message-ID: <20250311145803.219918116@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


