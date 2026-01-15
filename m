Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C62B2C028F;
	Thu, 15 Jan 2026 17:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496654; cv=none; b=qjetL6TZdgziO0vxHlrngOoB1H+bGhkUxNF7+Vm42m62JJSR5R5uiOQOPqjI+LbCGtoOTcAy+QUtESlSBrrjqcZir9l5q/93LDAmzRnp+yAS0g+cYfzAHXcnQzLyL3plxxPBVTYauYNa8NOn4dZ9GfC0cXsmsCkEEPc1QXgTVQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496654; c=relaxed/simple;
	bh=la0UByjoOMngQNLL1XhfjFWfv2WSNS69iweLtGYYJ08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2e65VLdYsw1rWVv6Z/DnhsFTuZ/sTEUKSL+2G5Y+nLKwODl1h6haL2Emf8iBl1NBrvFb/3mVbYe34H3LQYP6j0V9TEsUdeTS4o+oG+6czTTAl5S3FLjiDsdxiArIKPk88KbZXBPAbRnM6eHmDuTe/WAb8WY3Nk/ovizd+7weLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqROts+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqROts+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC2AC116D0;
	Thu, 15 Jan 2026 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496654;
	bh=la0UByjoOMngQNLL1XhfjFWfv2WSNS69iweLtGYYJ08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqROts+7BIy+yrUB1Jlmv+IUTwMdYBvUgDLJzftJW9PdsNmQGOxqXDIXGHOCMTWO3
	 MAMAV3MTZKTNOzNCKFHZZFcKqBHgEKj7ERBuVW/ud5cN1QNQua2rG0kKrpp6GwF2DM
	 sDbqpEKhZIqdvwLQFQgBRZjm0FDAJMnSF3fCEsjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/119] ALSA: ac97bus: Use guard() for mutex locks
Date: Thu, 15 Jan 2026 17:48:23 +0100
Message-ID: <20260115164155.125291210@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c07824a14d99c10edd4ec4c389d219af336ecf20 ]

Replace the manual mutex lock/unlock pairs with guard() for code
simplification.

Only code refactoring, and no behavior change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250829151335.7342-18-tiwai@suse.de
Stable-dep-of: 830988b6cf19 ("ALSA: ac97: fix a double free in snd_ac97_controller_register()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/ac97/bus.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/sound/ac97/bus.c
+++ b/sound/ac97/bus.c
@@ -241,10 +241,9 @@ static ssize_t cold_reset_store(struct d
 {
 	struct ac97_controller *ac97_ctrl;
 
-	mutex_lock(&ac97_controllers_mutex);
+	guard(mutex)(&ac97_controllers_mutex);
 	ac97_ctrl = to_ac97_controller(dev);
 	ac97_ctrl->ops->reset(ac97_ctrl);
-	mutex_unlock(&ac97_controllers_mutex);
 	return len;
 }
 static DEVICE_ATTR_WO(cold_reset);
@@ -258,10 +257,9 @@ static ssize_t warm_reset_store(struct d
 	if (!dev)
 		return -ENODEV;
 
-	mutex_lock(&ac97_controllers_mutex);
+	guard(mutex)(&ac97_controllers_mutex);
 	ac97_ctrl = to_ac97_controller(dev);
 	ac97_ctrl->ops->warm_reset(ac97_ctrl);
-	mutex_unlock(&ac97_controllers_mutex);
 	return len;
 }
 static DEVICE_ATTR_WO(warm_reset);
@@ -284,10 +282,10 @@ static const struct attribute_group *ac9
 
 static void ac97_del_adapter(struct ac97_controller *ac97_ctrl)
 {
-	mutex_lock(&ac97_controllers_mutex);
-	ac97_ctrl_codecs_unregister(ac97_ctrl);
-	list_del(&ac97_ctrl->controllers);
-	mutex_unlock(&ac97_controllers_mutex);
+	scoped_guard(mutex, &ac97_controllers_mutex) {
+		ac97_ctrl_codecs_unregister(ac97_ctrl);
+		list_del(&ac97_ctrl->controllers);
+	}
 
 	device_unregister(&ac97_ctrl->adap);
 }
@@ -311,7 +309,7 @@ static int ac97_add_adapter(struct ac97_
 {
 	int ret;
 
-	mutex_lock(&ac97_controllers_mutex);
+	guard(mutex)(&ac97_controllers_mutex);
 	ret = idr_alloc(&ac97_adapter_idr, ac97_ctrl, 0, 0, GFP_KERNEL);
 	ac97_ctrl->nr = ret;
 	if (ret >= 0) {
@@ -322,13 +320,11 @@ static int ac97_add_adapter(struct ac97_
 		if (ret)
 			put_device(&ac97_ctrl->adap);
 	}
-	if (!ret)
+	if (!ret) {
 		list_add(&ac97_ctrl->controllers, &ac97_controllers);
-	mutex_unlock(&ac97_controllers_mutex);
-
-	if (!ret)
 		dev_dbg(&ac97_ctrl->adap, "adapter registered by %s\n",
 			dev_name(ac97_ctrl->parent));
+	}
 	return ret;
 }
 


