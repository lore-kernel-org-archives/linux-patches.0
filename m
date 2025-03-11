Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E432A1CAA8F;
	Tue, 11 Mar 2025 15:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707666; cv=none; b=IzhPU7p05Kj8CFGsWQyPLeLDVGBU7xUXqwXvMe0qhM6AXEMCrZOgMQ8xj9qIJ0b9EmHDvzh1+1ntz2bbae1qqK6HROwV+KIbjQcnx4lAnGGpKGKteyDULkFV9Lii5op6UySiQOUZ9rpvN6LGXqFY+Mr38cWd8UnrJdRDo8mPKG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707666; c=relaxed/simple;
	bh=6HOQwr+dOgHljKIC+g7eRcmDY21UyAUTeTyFTAwnQGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhQdPf76RUH/j/WoReKoth+HpeLkWlQEZKVJJPWX+R0A8Yec20wXMh0vctQIFjUqyck7fWfhM/9MCDUeQdc14sb5DOdfdTzVtYpH4teGO6OrMsyp0ytXJLfu5lslTxCL8mJzC/IQj7lFHq4SwUcFENAK87jniW+vdUhAftCrKWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d28IzUji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d28IzUji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A91FC4CEE9;
	Tue, 11 Mar 2025 15:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707665;
	bh=6HOQwr+dOgHljKIC+g7eRcmDY21UyAUTeTyFTAwnQGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d28IzUji+R8/Kk+VkyOUd9WVutOeVL6apLfuvucU8FICigQRlYlnRssZe4YB74++1
	 eIQsvJ4lho+PqCIPO4npvz86PTMryDEayN940Xh2Y423PgsDTCiz5C3DC0wGM8Mwix
	 iuus+r8A490njzL370jrbpfSaT7auNU98cbKJG/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Sikora <sikora.tomus@gmail.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 451/462] Revert "media: uvcvideo: Require entities to have a non-zero unique ID"
Date: Tue, 11 Mar 2025 16:01:57 +0100
Message-ID: <20250311145816.137163142@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 8004d635f27bbccaa5c083c50d4d5302a6ffa00e upstream.

This reverts commit 3dd075fe8ebbc6fcbf998f81a75b8c4b159a6195.

Tomasz has reported that his device, Generalplus Technology Inc. 808 Camera,
with ID 1b3f:2002, stopped being detected:

$ ls -l /dev/video*
zsh: no matches found: /dev/video*
[    7.230599] usb 3-2: Found multiple Units with ID 5

This particular device is non-compliant, having both the Output Terminal
and Processing Unit with ID 5. uvc_scan_fallback, though, is able to build
a chain. However, when media elements are added and uvc_mc_create_links
call uvc_entity_by_id, it will get the incorrect entity,
media_create_pad_link will WARN, and it will fail to register the entities.

In order to reinstate support for such devices in a timely fashion,
reverting the fix for these warnings is appropriate. A proper fix that
considers the existence of such non-compliant devices will be submitted in
a later development cycle.

Reported-by: Tomasz Sikora <sikora.tomus@gmail.com>
Fixes: 3dd075fe8ebb ("media: uvcvideo: Require entities to have a non-zero unique ID")
Cc: stable@vger.kernel.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20250114200045.1401644-1-cascardo@igalia.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |   63 ++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 39 deletions(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1029,27 +1029,14 @@ error:
 	return ret;
 }
 
-static struct uvc_entity *uvc_alloc_new_entity(struct uvc_device *dev, u16 type,
-					       u16 id, unsigned int num_pads,
-					       unsigned int extra_size)
+static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
+		unsigned int num_pads, unsigned int extra_size)
 {
 	struct uvc_entity *entity;
 	unsigned int num_inputs;
 	unsigned int size;
 	unsigned int i;
 
-	/* Per UVC 1.1+ spec 3.7.2, the ID should be non-zero. */
-	if (id == 0) {
-		dev_err(&dev->udev->dev, "Found Unit with invalid ID 0.\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	/* Per UVC 1.1+ spec 3.7.2, the ID is unique. */
-	if (uvc_entity_by_id(dev, id)) {
-		dev_err(&dev->udev->dev, "Found multiple Units with ID %u\n", id);
-		return ERR_PTR(-EINVAL);
-	}
-
 	extra_size = roundup(extra_size, sizeof(*entity->pads));
 	if (num_pads)
 		num_inputs = type & UVC_TERM_OUTPUT ? num_pads : num_pads - 1;
@@ -1059,7 +1046,7 @@ static struct uvc_entity *uvc_alloc_new_
 	     + num_inputs;
 	entity = kzalloc(size, GFP_KERNEL);
 	if (entity == NULL)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	entity->id = id;
 	entity->type = type;
@@ -1130,10 +1117,10 @@ static int uvc_parse_vendor_control(stru
 			break;
 		}
 
-		unit = uvc_alloc_new_entity(dev, UVC_VC_EXTENSION_UNIT,
-					    buffer[3], p + 1, 2 * n);
-		if (IS_ERR(unit))
-			return PTR_ERR(unit);
+		unit = uvc_alloc_entity(UVC_VC_EXTENSION_UNIT, buffer[3],
+					p + 1, 2*n);
+		if (unit == NULL)
+			return -ENOMEM;
 
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];
@@ -1244,10 +1231,10 @@ static int uvc_parse_standard_control(st
 			return -EINVAL;
 		}
 
-		term = uvc_alloc_new_entity(dev, type | UVC_TERM_INPUT,
-					    buffer[3], 1, n + p);
-		if (IS_ERR(term))
-			return PTR_ERR(term);
+		term = uvc_alloc_entity(type | UVC_TERM_INPUT, buffer[3],
+					1, n + p);
+		if (term == NULL)
+			return -ENOMEM;
 
 		if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA) {
 			term->camera.bControlSize = n;
@@ -1303,10 +1290,10 @@ static int uvc_parse_standard_control(st
 			return 0;
 		}
 
-		term = uvc_alloc_new_entity(dev, type | UVC_TERM_OUTPUT,
-					    buffer[3], 1, 0);
-		if (IS_ERR(term))
-			return PTR_ERR(term);
+		term = uvc_alloc_entity(type | UVC_TERM_OUTPUT, buffer[3],
+					1, 0);
+		if (term == NULL)
+			return -ENOMEM;
 
 		memcpy(term->baSourceID, &buffer[7], 1);
 
@@ -1327,10 +1314,9 @@ static int uvc_parse_standard_control(st
 			return -EINVAL;
 		}
 
-		unit = uvc_alloc_new_entity(dev, buffer[2], buffer[3],
-					    p + 1, 0);
-		if (IS_ERR(unit))
-			return PTR_ERR(unit);
+		unit = uvc_alloc_entity(buffer[2], buffer[3], p + 1, 0);
+		if (unit == NULL)
+			return -ENOMEM;
 
 		memcpy(unit->baSourceID, &buffer[5], p);
 
@@ -1352,9 +1338,9 @@ static int uvc_parse_standard_control(st
 			return -EINVAL;
 		}
 
-		unit = uvc_alloc_new_entity(dev, buffer[2], buffer[3], 2, n);
-		if (IS_ERR(unit))
-			return PTR_ERR(unit);
+		unit = uvc_alloc_entity(buffer[2], buffer[3], 2, n);
+		if (unit == NULL)
+			return -ENOMEM;
 
 		memcpy(unit->baSourceID, &buffer[4], 1);
 		unit->processing.wMaxMultiplier =
@@ -1383,10 +1369,9 @@ static int uvc_parse_standard_control(st
 			return -EINVAL;
 		}
 
-		unit = uvc_alloc_new_entity(dev, buffer[2], buffer[3],
-					    p + 1, n);
-		if (IS_ERR(unit))
-			return PTR_ERR(unit);
+		unit = uvc_alloc_entity(buffer[2], buffer[3], p + 1, n);
+		if (unit == NULL)
+			return -ENOMEM;
 
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];


