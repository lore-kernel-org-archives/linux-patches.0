Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D382750ED;
	Thu, 15 Jan 2026 17:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497209; cv=none; b=V7ThOZmUS8pLpsa7T6aai1tcGZ4ZpoVfSfblS0cVdPue/YdsyJvVlol/2ic3yObpaLllRtiS//TZASJVKmMzaA/RgBfA8ImIgJtBz+zw+igqRkbaPLjZXIKnok3a4u/QSRz5rZlqCUbVatl1NGhv+jk4AXLY0CmpkwuUjcidQO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497209; c=relaxed/simple;
	bh=9zD1lcHYp0s6idq8vu+MRd8SlUhlwhRWlva81SYLoMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBY5ZnFEED+/bdis/QFw9P4e7K8eJnEfS6gKqIhpOPIh5K7XzRw3PFbslpLIkrviRtbhy505mroyELrwK/MWwFeR6RnEZoE7ABB3dboTVQKQGgPkbsunr6TB3MFrnrXEEuDaq5hA7avOCDqY9zKi4S9Qk93t6omfDsVJDUT2DPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZyx5pfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZyx5pfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3076C116D0;
	Thu, 15 Jan 2026 17:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497209;
	bh=9zD1lcHYp0s6idq8vu+MRd8SlUhlwhRWlva81SYLoMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZyx5pfZwKwBZF+dGniMks2Q3lDTROrye/gaKstbq/cZQ51u20awFtnBg9xy/hIMo
	 VULmOez1DZBx8H9uqfgoXHgyPymMl7J0+OR4o6SxWb+O2ElcbJUSzrQCfnmoN+p7Y3
	 bQiM7KtBuiOrH6WYH2vcAJLOyVPYLF4MioW/stxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/72] ALSA: ac97bus: Use guard() for mutex locks
Date: Thu, 15 Jan 2026 17:49:05 +0100
Message-ID: <20260115164145.491140499@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -242,10 +242,9 @@ static ssize_t cold_reset_store(struct d
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
@@ -259,10 +258,9 @@ static ssize_t warm_reset_store(struct d
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
@@ -285,10 +283,10 @@ static const struct attribute_group *ac9
 
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
@@ -312,7 +310,7 @@ static int ac97_add_adapter(struct ac97_
 {
 	int ret;
 
-	mutex_lock(&ac97_controllers_mutex);
+	guard(mutex)(&ac97_controllers_mutex);
 	ret = idr_alloc(&ac97_adapter_idr, ac97_ctrl, 0, 0, GFP_KERNEL);
 	ac97_ctrl->nr = ret;
 	if (ret >= 0) {
@@ -323,13 +321,11 @@ static int ac97_add_adapter(struct ac97_
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
 


