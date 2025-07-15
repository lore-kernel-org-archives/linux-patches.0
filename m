Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDCA2EE99B;
	Tue, 15 Jul 2025 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587799; cv=none; b=LG+oF+83f2j0t3SV5aVf7CUB90Lt3qdlFRZaAofr6y9D3EiFhgxxpd8u+2JaRGxR8r/3xRQQk/JeVhCUk9nsc81VEp9jti4dGt4T76L9Y88gq2ukUGOTgUrU8ZuIO1G1EhKuCowPBm9NmxDs2JWoglu1e9F3Xqcd+4iEF83Bako=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587799; c=relaxed/simple;
	bh=ISvSzp7k6w1EHjImUGwkNcmxQT5unboit2ZlRb5lKXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDjgXRAWDQ9863XDWZBj4u3aaBGpe5jvt94idWAUjP/UIy7o0uqpDAcGTPTnCUYx+Rg2BSPBGilDixo5HSl6Atg37lfcOEA7MZwtO1TxrDrLNluauzRNSf3bnnCDVmpbA9Gh4r2nd9+/l+T39lKt7sO/px5rsLlNgcXbxwtH0LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAcpCFuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAcpCFuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73053C4CEE3;
	Tue, 15 Jul 2025 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587798;
	bh=ISvSzp7k6w1EHjImUGwkNcmxQT5unboit2ZlRb5lKXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAcpCFujFjXYNefX6raAeqLpP0UHh3R3rKmyvsG1F0Zn0C/wvw3NhGfO286K2wl0e
	 WXLerU6g9eU50IiEaOZ6yBoL72Xs9Mlq0sxynyQsh2u5kNDo02uwzL4LcryR5q5Nls
	 qFJ7qMncFCDOPKl02erBP4PvsUACGT+Iq6bnVzig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 130/208] media: uvcvideo: Send control events for partial succeeds
Date: Tue, 15 Jul 2025 15:13:59 +0200
Message-ID: <20250715130816.147872967@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

commit 5c791467aea6277430da5f089b9b6c2a9d8a4af7 upstream.

Today, when we are applying a change to entities A, B. If A succeeds and B
fails the events for A are not sent.

This change changes the code so the events for A are send right after
they happen.

Cc: stable@kernel.org
Fixes: b4012002f3a3 ("[media] uvcvideo: Add support for control events")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Message-ID: <20250224-uvc-data-backup-v2-2-de993ed9823b@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1429,7 +1429,9 @@ static bool uvc_ctrl_xctrls_has_control(
 }
 
 static void uvc_ctrl_send_events(struct uvc_fh *handle,
-	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
+				 struct uvc_entity *entity,
+				 const struct v4l2_ext_control *xctrls,
+				 unsigned int xctrls_count)
 {
 	struct uvc_control_mapping *mapping;
 	struct uvc_control *ctrl;
@@ -1440,6 +1442,9 @@ static void uvc_ctrl_send_events(struct
 		u32 changes = V4L2_EVENT_CTRL_CH_VALUE;
 
 		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
+		if (ctrl->entity != entity)
+			continue;
+
 		if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
 			/* Notification will be sent from an Interrupt event. */
 			continue;
@@ -1638,10 +1643,11 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 					     rollback);
 		if (ret < 0)
 			goto done;
+		else if (ret > 0 && !rollback)
+			uvc_ctrl_send_events(handle, entity, xctrls,
+					     xctrls_count);
 	}
 
-	if (!rollback)
-		uvc_ctrl_send_events(handle, xctrls, xctrls_count);
 	ret = 0;
 done:
 	mutex_unlock(&chain->ctrl_mutex);


