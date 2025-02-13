Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD84201113;
	Thu, 13 Feb 2025 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458895; cv=none; b=JVpBYeNNk0BWTE7agFNWHE45vnVDVlUyaF/V8ZNP281XPrdl8Oxqz8byu8Ve3xU7KfXTr2OF7FqzQ1QDFrPmY2TiyZSbEAEPKmKECCvMKoP+8p32QzEpMP1I/z8xBvdromKYr0Xs4bxRYrWpy9IsWJH60K+1guSAY6nQOM2mG0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458895; c=relaxed/simple;
	bh=OI9vxFP+iuZwWrZ7U0WM79dQmG6Tr0bBU23ruDJLcQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC+bHKeiSgmDq4MH9lNC+K9s6DTHjbIgqu9//B31XWAo8EwJEqPWmw86XNXXpxQhFNw86EIFRL2CjCLjPIF5UkblREjOt39Sb00eYOfTTyMIw3j+NJo3NMBFTFdzldFU6C5t95X/3le0c9XwhN46iNKKpUJ9eLv3MBa4Ca4lw48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYLCoIv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYLCoIv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23E3C4CED1;
	Thu, 13 Feb 2025 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458895;
	bh=OI9vxFP+iuZwWrZ7U0WM79dQmG6Tr0bBU23ruDJLcQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYLCoIv5lII5pkLci+pktUseLNjqh0kHPo1hXK7z67gYM4xLGu9Gt+pfJK8lU7iIL
	 HoWA6t9UL2IiHKDfzVip0+Q2Z4ncgCUpTckYzKdBTfDRCD8Ux3NtUcmwItzXN5YXuy
	 QO2HH67VazuNIIjvUOFls72VHq7uYuIJVNcbv9SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Farblos <farblos@vodafonemail.de>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 109/443] gpu: drm_dp_cec: fix broken CEC adapter properties check
Date: Thu, 13 Feb 2025 15:24:34 +0100
Message-ID: <20250213142444.816242464@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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
 drivers/gpu/drm/display/drm_dp_cec.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_dp_cec.c b/drivers/gpu/drm/display/drm_dp_cec.c
index 007ceb281d00d..56a4965e518cc 100644
--- a/drivers/gpu/drm/display/drm_dp_cec.c
+++ b/drivers/gpu/drm/display/drm_dp_cec.c
@@ -311,16 +311,6 @@ void drm_dp_cec_attach(struct drm_dp_aux *aux, u16 source_physical_address)
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
@@ -337,7 +327,9 @@ void drm_dp_cec_attach(struct drm_dp_aux *aux, u16 source_physical_address)
 		num_las = CEC_MAX_LOG_ADDRS;
 
 	if (aux->cec.adap) {
-		if (aux->cec.adap->capabilities == cec_caps &&
+		/* Check if the adapter properties have changed */
+		if ((aux->cec.adap->capabilities & CEC_CAP_MONITOR_ALL) ==
+		    (cec_caps & CEC_CAP_MONITOR_ALL) &&
 		    aux->cec.adap->available_log_addrs == num_las) {
 			/* Unchanged, so just set the phys addr */
 			cec_s_phys_addr(aux->cec.adap, source_physical_address, false);
-- 
2.39.5



