Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BD6235BFF;
	Mon, 10 Mar 2025 18:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630517; cv=none; b=Brx6r4fQIUJ+ihtsO31YfJ3PCQleQanUllrHdvFj26IYv5v5IzpC1KR9O05aFKhy7RKr+IPpXe4PqVY3zDKbflsybgjQgwZ6yya0JdQwI1d5I8vdVatgVzOJvjaH7s0gOv6C7YG5/hZu841gFZsUKUERCgLDpK5blEz/0C1LDGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630517; c=relaxed/simple;
	bh=vzvrSyqn6DJjUIxws5xS9TDyA2751Ep1ig0ZZJZcS6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CccKUSuDvATT7qdXmZFSv2zZOKpA8ltTSk5C9IzSqdG6fdoGaW/DROdMSo/3H6//zG4+xF1h5GzkGLUttIh2MeFMi99XLz0iQn6/vVXqACK/OttmoHiM2gSobbdtKSybNKEMvJJUzObNHwpTEj80vn/xwT68HFa2oK/LFKKwWlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awRXIwAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awRXIwAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573F9C4CEE5;
	Mon, 10 Mar 2025 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630516;
	bh=vzvrSyqn6DJjUIxws5xS9TDyA2751Ep1ig0ZZJZcS6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awRXIwASt6IM3fvoJMk4Djw8panTo+rxZVnNeA8VV4Y+c6PJE1og6Q9JM96VhqCsu
	 ZEE2EFu8XUpTS+eol+cVEGRTtL61JjM0oUwy5nW5b37ltPRNsbBLsCbgVmvy4wKfOY
	 xLhrmMt6x6crzR99T3GvUWT+EhAr84zuywaM/hhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Chris Zhong <zyw@rock-chips.com>,
	Guenter Roeck <groeck@chromium.org>,
	Sandy Huang <hjc@rock-chips.com>,
	=?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
	Andy Yan <andy.yan@rock-chips.com>,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/620] drm/rockchip: cdn-dp: Use drm_connector_helper_hpd_irq_event()
Date: Mon, 10 Mar 2025 18:04:47 +0100
Message-ID: <20250310170603.006059216@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 666e1960464140cc4bc9203c203097e70b54c95a ]

The code for detecting and updating the connector status in
cdn_dp_pd_event_work() has a number of problems.

- It does not aquire the locks to call the detect helper and update
the connector status. These are struct drm_mode_config.connection_mutex
and struct drm_mode_config.mutex.

- It does not use drm_helper_probe_detect(), which helps with the
details of locking and detection.

- It uses the connector's status field to determine a change to
the connector status. The epoch_counter field is the correct one. The
field signals a change even if the connector status' value did not
change.

Replace the code with a call to drm_connector_helper_hpd_irq_event(),
which fixes all these problems.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 81632df69772 ("drm/rockchip: cdn-dp: do not use drm_helper_hpd_irq_event")
Cc: Chris Zhong <zyw@rock-chips.com>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Sandy Huang <hjc@rock-chips.com>
Cc: "Heiko Stübner" <heiko@sntech.de>
Cc: Andy Yan <andy.yan@rock-chips.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241105133848.480407-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/cdn-dp-core.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/cdn-dp-core.c b/drivers/gpu/drm/rockchip/cdn-dp-core.c
index b9ef35a35c857..af1e361da8df9 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -916,9 +916,6 @@ static void cdn_dp_pd_event_work(struct work_struct *work)
 {
 	struct cdn_dp_device *dp = container_of(work, struct cdn_dp_device,
 						event_work);
-	struct drm_connector *connector = &dp->connector;
-	enum drm_connector_status old_status;
-
 	int ret;
 
 	mutex_lock(&dp->lock);
@@ -980,11 +977,7 @@ static void cdn_dp_pd_event_work(struct work_struct *work)
 
 out:
 	mutex_unlock(&dp->lock);
-
-	old_status = connector->status;
-	connector->status = connector->funcs->detect(connector, false);
-	if (old_status != connector->status)
-		drm_kms_helper_hotplug_event(dp->drm_dev);
+	drm_connector_helper_hpd_irq_event(&dp->connector);
 }
 
 static int cdn_dp_pd_event(struct notifier_block *nb,
-- 
2.39.5



