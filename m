Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE692566DA;
	Thu, 17 Apr 2025 18:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914214; cv=none; b=uTXsHtdCmf73qclhHxh2eq0WTL+o1zmnOMaUFUzzogFWF83SsHZVOYnmUFZLM1ZANKDACrJjEDCqd+LtYqgFZf/WSXdXDuOxbgQfREI8OX8mYewIGtrBKKihGRSXdYtofwkb8UByQn0TpcdPASXw0RD7S9glF9vuj6BE1N7hjo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914214; c=relaxed/simple;
	bh=RckKuUcDjlN3/1y1VZdazwbHGox9GB0Icde4gopr4Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUFJ6LEyStzhav+wKVUCdg8lpzdlGYe8KH9DFxYMSZVMXyOAFpkIBOJLRNt+0frDIs2ERvBiczcSWoXF4kVQ9G3P6upoTNUXdIta/nwKNPoLCTMAYrlacW21fyOmY6BVfubU9oYijotfj287+dmv7PX6M/JvNX4+P6k9ndYuHvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXThWHFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXThWHFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B3CC4CEE7;
	Thu, 17 Apr 2025 18:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914214;
	bh=RckKuUcDjlN3/1y1VZdazwbHGox9GB0Icde4gopr4Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXThWHFKL2jnIlueDPjIS4KY1O38IlNDWL0HWUOh/w+lws7fN8KRgMzCY26O2Bs9e
	 9TZvt+pGDNXyiK2UJ7TYBagdgPzQHX3Hwg3PEjK8KRYfOa/5JQymoyfwSHXw8We1tn
	 7N7XuPAzC72vfIuqCQUICOLTmx+/ecSy6RzsRElM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 142/414] drm/bridge: panel: forbid initializing a panel with unknown connector type
Date: Thu, 17 Apr 2025 19:48:20 +0200
Message-ID: <20250417175117.141605389@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 19ab0a794add3..fd8fa2e0ef6fa 100644
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
 	INIT_LIST_HEAD(&panel->followers);
 	mutex_init(&panel->follower_lock);
-- 
2.39.5



