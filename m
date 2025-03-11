Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1998B25EF86;
	Tue, 11 Mar 2025 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705685; cv=none; b=c+KxZjAZeL5DLPNKkVThxGWjl+KaPxHoVcnXE7JElbSjy40kZzGDK7JImLhqan4eo3ac0gGojubmsUw/5Ba/NelPI7fK5v2GqSwx9Uhu02rirC+mM9dIKYzFt02CPdyPSIifYHMscx9eM2uY0GzBfPun3UjuaB9jBYocdyvnado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705685; c=relaxed/simple;
	bh=5eKu9SJkRZL5KKiOhDrLDJj3txRAYIb5Jm+EZD5zkMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMpiBFqV53wMgkRFGM67LUz7KA6OYjdVy699wjy6gVSZFvdhdFgbORrdbDbzqv+Xs5O09KJl/g0A6GDunjGszgDhLntCVzezAYACQIBtPqs/qWfY+N71e4XswQGGTm21tBxJrJS4rtS7OP546ZqUFoDZ6SsoTZB8gef9fPCm12k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdxuFFMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdxuFFMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A6AC4CEE9;
	Tue, 11 Mar 2025 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705684;
	bh=5eKu9SJkRZL5KKiOhDrLDJj3txRAYIb5Jm+EZD5zkMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdxuFFMDn5+vrUpvx8f7r86AuzRSydhfioZS1mt25ltJ6TCau0Colm61go5tO+DvA
	 z999qBMP2ooud9vGZQeSQa8wINMh3qdEL1yI5fti7pVtqDK8aqT3jHkFcJQfK+hKOz
	 pn/OiQT+IId1R/qTe5JLPhFgzrJyfVQi90UCpq6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 100/328] media: uvcvideo: Only save async fh if success
Date: Tue, 11 Mar 2025 15:57:50 +0100
Message-ID: <20250311145718.866706431@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

commit d9fecd096f67a4469536e040a8a10bbfb665918b upstream.

Now we keep a reference to the active fh for any call to uvc_ctrl_set,
regardless if it is an actual set or if it is a just a try or if the
device refused the operation.

We should only keep the file handle if the device actually accepted
applying the operation.

Cc: stable@vger.kernel.org
Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20241203-uvc-fix-async-v6-1-26c867231118@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

---
 drivers/media/usb/uvc/uvc_ctrl.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1528,7 +1528,9 @@ int uvc_ctrl_begin(struct uvc_video_chai
 }
 
 static int uvc_ctrl_commit_entity(struct uvc_device *dev,
-	struct uvc_entity *entity, int rollback)
+				  struct uvc_fh *handle,
+				  struct uvc_entity *entity,
+				  int rollback)
 {
 	struct uvc_control *ctrl;
 	unsigned int i;
@@ -1572,6 +1574,10 @@ static int uvc_ctrl_commit_entity(struct
 
 		if (ret < 0)
 			return ret;
+
+		if (!rollback && handle &&
+		    ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
+			ctrl->handle = handle;
 	}
 
 	return 0;
@@ -1587,7 +1593,8 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 
 	/* Find the control. */
 	list_for_each_entry(entity, &chain->entities, chain) {
-		ret = uvc_ctrl_commit_entity(chain->dev, entity, rollback);
+		ret = uvc_ctrl_commit_entity(chain->dev, handle, entity,
+					     rollback);
 		if (ret < 0)
 			goto done;
 	}
@@ -1711,9 +1718,6 @@ int uvc_ctrl_set(struct uvc_fh *handle,
 	mapping->set(mapping, value,
 		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
 
-	if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
-		ctrl->handle = handle;
-
 	ctrl->dirty = 1;
 	ctrl->modified = 1;
 	return 0;
@@ -2042,7 +2046,7 @@ int uvc_ctrl_restore_values(struct uvc_d
 			ctrl->dirty = 1;
 		}
 
-		ret = uvc_ctrl_commit_entity(dev, entity, 0);
+		ret = uvc_ctrl_commit_entity(dev, NULL, entity, 0);
 		if (ret < 0)
 			return ret;
 	}


