Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE7757C9F;
	Wed, 23 Apr 2025 15:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420561; cv=none; b=UrT6fvLDHHvIHeyk/TRFslfCJDeLFNw0HiflEEufaL5gIZvZ/t5+V1BE75UftUh1PZiAx/6v/pUL4nOWnO5WQ0A1XUgX94HymOKTmpo04e4y9SdoE45mHbVOrIL6r+dYcC7Q7bRO55UYIMaaFqM0z3cRHhWDsVRK5/sXXungMkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420561; c=relaxed/simple;
	bh=uuarIOrZME47UYFhr4NdQYYGXefLM+IhYCoM+ptblXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSiZ/46sum3wmuaSTvQKCVI5XgmmfXwbFOh1dHK5D6hamMvsQbgTrP5gqDA9gQZEbVkGAMYcpwOEAvLyfaC5h1bS5/ylyUb3yBvzTV5HTPNdkhhNP+HLaIfI9YJWClbA3zmVxt5OTOfywL/6Aj8lG5ZpamQ+ikFJO7aojiYUz2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=coiFR7kV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="coiFR7kV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F8CC4CEE2;
	Wed, 23 Apr 2025 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420561;
	bh=uuarIOrZME47UYFhr4NdQYYGXefLM+IhYCoM+ptblXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coiFR7kVOBaHXTkReIufl90h42XJjTtFjFYSf9576eurb2GDoWWRXd27ugFFcbQXK
	 zbVsup7afwKIy2gHEyYFZYUQ3P/uaXZ+9s5edXZ9nCE42trAqqrjVNIbGHssitCbRd
	 eagfBrZmwFafLcChLv/zIAKFHWLeEX1c8shOIuSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/291] drm/bridge: panel: forbid initializing a panel with unknown connector type
Date: Wed, 23 Apr 2025 16:40:49 +0200
Message-ID: <20250423142626.828326598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit b296955b3a740ecc8b3b08e34fd64f1ceabb8fb4 ]

Having an DRM_MODE_CONNECTOR_Unknown connector type is considered bad, and
drm_panel_bridge_add_typed() and derivatives are deprecated for this.

drm_panel_init() won't prevent initializing a panel with a
DRM_MODE_CONNECTOR_Unknown connector type. Luckily there are no in-tree
users doing it, so take this as an opportinuty to document a valid
connector type must be passed.

Returning an error if this rule is violated is not possible because
drm_panel_init() is a void function. Add at least a warning to make any
violations noticeable, especially to non-upstream drivers.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250214-drm-assorted-cleanups-v7-5-88ca5827d7af@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index 7fd3de89ed079..acd29b4f43f84 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -49,7 +49,7 @@ static LIST_HEAD(panel_list);
  * @dev: parent device of the panel
  * @funcs: panel operations
  * @connector_type: the connector type (DRM_MODE_CONNECTOR_*) corresponding to
- *	the panel interface
+ *	the panel interface (must NOT be DRM_MODE_CONNECTOR_Unknown)
  *
  * Initialize the panel structure for subsequent registration with
  * drm_panel_add().
@@ -57,6 +57,9 @@ static LIST_HEAD(panel_list);
 void drm_panel_init(struct drm_panel *panel, struct device *dev,
 		    const struct drm_panel_funcs *funcs, int connector_type)
 {
+	if (connector_type == DRM_MODE_CONNECTOR_Unknown)
+		DRM_WARN("%s: %s: a valid connector type is required!\n", __func__, dev_name(dev));
+
 	INIT_LIST_HEAD(&panel->list);
 	panel->dev = dev;
 	panel->funcs = funcs;
-- 
2.39.5



