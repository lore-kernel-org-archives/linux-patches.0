Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870C82D023;
	Mon, 10 Mar 2025 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629287; cv=none; b=Bgl7HRiWC4IYvAiJJ8QF9QjpaED/ff/GMGOcFgVPamElH7GWfqmCiMVO1OTSfq46LeWDV2CogZ+4hg83UMua/yDYOIdfULLS+f1YPaXKbXns6YvUi+WYCFpT9dPhiJNFOKj/eS8QBVDTTsaB2ZOlmVJX/4AGhwdUAYnnvTtRqEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629287; c=relaxed/simple;
	bh=91JC+oDlxVGOCSdmWaGVcqI2PzZT3WxTMdTmTAh7M+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8bgBAPlb/tZ9oMQA8hlZRlsZMdePBXYw5n38fcNMwf5tgUxU4kbByzrluI92NrE2za2wUKwy0zNdHlfLwj3ZPsX3wdPC+Sc1Bq7PP7kCRwRsSYLx8WbudFBWGn+HoiWXKU5rxCKYZkyjUBHRsRGh5KmrQAvuHml+vrh4nU2+gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L39kOpfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L39kOpfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA9FC4CEE5;
	Mon, 10 Mar 2025 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629287;
	bh=91JC+oDlxVGOCSdmWaGVcqI2PzZT3WxTMdTmTAh7M+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L39kOpfCgZFkryCAdcTQiwVBcqtVgr14bQjrDZce+BMxO6UykKXQc1ggkwC2oWWE3
	 Ld5VQKE45gaR4TAblJ5/GiZRkK1yC+dky515pY+Cy/9DZCY8fVJT01sloa2iEtor36
	 nS/ZYcc9s43anIJVl2nMXLblh/BEYxhaIJnCbpk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Farblos <farblos@vodafonemail.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/620] gpu: drm_dp_cec: fix broken CEC adapter properties check
Date: Mon, 10 Mar 2025 18:01:28 +0100
Message-ID: <20250310170555.184014482@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit 6daaae5ff7f3b23a2dacc9c387ff3d4f95b67cad ]

If the hotplug detect of a display is low for longer than one second
(configurable through drm_dp_cec_unregister_delay), then the CEC adapter
is unregistered since we assume the display was disconnected. If the
HPD went low for less than one second, then we check if the properties
of the CEC adapter have changed, since that indicates that we actually
switch to new hardware and we have to unregister the old CEC device and
register a new one.

Unfortunately, the test for changed properties was written poorly, and
after a new CEC capability was added to the CEC core code the test always
returned true (i.e. the properties had changed).

As a result the CEC device was unregistered and re-registered for every
HPD toggle. If the CEC remote controller integration was also enabled
(CONFIG_MEDIA_CEC_RC was set), then the corresponding input device was
also unregistered and re-registered. As a result the input device in
/sys would keep incrementing its number, e.g.:

/sys/devices/pci0000:00/0000:00:08.1/0000:e7:00.0/rc/rc0/input20

Since short HPD toggles are common, the number could over time get into
the thousands.

While not a serious issue (i.e. nothing crashes), it is not intended
to work that way.

This patch changes the test so that it only checks for the single CEC
capability that can actually change, and it ignores any other
capabilities, so this is now safe as well if new caps are added in
the future.

With the changed test the bit under #ifndef CONFIG_MEDIA_CEC_RC can be
dropped as well, so that's a nice cleanup.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reported-by: Farblos <farblos@vodafonemail.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 2c6d1fffa1d9 ("drm: add support for DisplayPort CEC-Tunneling-over-AUX")
Tested-by: Farblos <farblos@vodafonemail.de>
Link: https://patchwork.freedesktop.org/patch/msgid/361bb03d-1691-4e23-84da-0861ead5dbdc@xs4all.nl
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_cec.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
index 3ab2609f9ec74..3ec770d602da6 100644
--- a/drivers/gpu/drm/drm_dp_cec.c
+++ b/drivers/gpu/drm/drm_dp_cec.c
@@ -310,16 +310,6 @@ void drm_dp_cec_set_edid(struct drm_dp_aux *aux, const struct edid *edid)
 	if (!aux->transfer)
 		return;
 
-#ifndef CONFIG_MEDIA_CEC_RC
-	/*
-	 * CEC_CAP_RC is part of CEC_CAP_DEFAULTS, but it is stripped by
-	 * cec_allocate_adapter() if CONFIG_MEDIA_CEC_RC is undefined.
-	 *
-	 * Do this here as well to ensure the tests against cec_caps are
-	 * correct.
-	 */
-	cec_caps &= ~CEC_CAP_RC;
-#endif
 	cancel_delayed_work_sync(&aux->cec.unregister_work);
 
 	mutex_lock(&aux->cec.lock);
@@ -336,7 +326,9 @@ void drm_dp_cec_set_edid(struct drm_dp_aux *aux, const struct edid *edid)
 		num_las = CEC_MAX_LOG_ADDRS;
 
 	if (aux->cec.adap) {
-		if (aux->cec.adap->capabilities == cec_caps &&
+		/* Check if the adapter properties have changed */
+		if ((aux->cec.adap->capabilities & CEC_CAP_MONITOR_ALL) ==
+		    (cec_caps & CEC_CAP_MONITOR_ALL) &&
 		    aux->cec.adap->available_log_addrs == num_las) {
 			/* Unchanged, so just set the phys addr */
 			cec_s_phys_addr_from_edid(aux->cec.adap, edid);
-- 
2.39.5



