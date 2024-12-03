Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99001DE8A5;
	Tue,  3 Dec 2024 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241030; cv=none; b=uVxs7QH42TRBy0pymAGgIHBgPhwBrN5x00hp35WpA4QnmlWd5SqLk5NialM1//5918DmiaG700niMPhqSYh0pKcgvf0Da74WFPhenKaqG+AAW/mGx4cJGafgpoogcBVUzatYTQHDf8fUXPrluyNFh/+DvzIBKWgOOmier9ejt0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241030; c=relaxed/simple;
	bh=5AFZ5+CgfsHJ4mGoxwTgYa/oPWAFbQH4QlmAANNaxc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RKUZH9fq7rZBg0Z6dJIGtpe1tbbenvczy46m9EfvY3UULiRY1PvOBfxToXZ5H7mnS6fWB9TjIn/fhUeaVIuU2lmySGXEosp1YdhU26gs2A4lURqUL8Y9N7hlSEThasAVe/gntMkQ/IfIYq0QmSdyV4qBvkaqyXkOHW0waeUNjhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10gAnD02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10gAnD02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF02C4CECF;
	Tue,  3 Dec 2024 15:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241030;
	bh=5AFZ5+CgfsHJ4mGoxwTgYa/oPWAFbQH4QlmAANNaxc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10gAnD02xjaAh6upBZ1BvhMrsmOKxbgth8Jp33a8lFRctZp4FVC1eMpK0AeVtaPPR
	 tE9UK/VBGV5AbsnUmarBahJ4B605e+CZxtUtSve0u9om0hocFK4hwqdxEk2nq4e47w
	 FYnMFN0uZ2zCSryPulQkW7aApPbeja8cIVALNrc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/826] drm/panfrost: Add missing OPP table refcnt decremental
Date: Tue,  3 Dec 2024 15:40:30 +0100
Message-ID: <20241203144755.583719360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 043e8afebf6c19abde9da1ac3d5cbf8b7ac8393f ]

Commit f11b0417eec2 ("drm/panfrost: Add fdinfo support GPU load metrics")
retrieves the OPP for the maximum device clock frequency, but forgets to
keep the reference count balanced by putting the returned OPP object. This
eventually leads to an OPP core warning when removing the device.

Fix it by putting OPP objects as many times as they're retrieved.

Also remove an unnecessary whitespace.

Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Fixes: f11b0417eec2 ("drm/panfrost: Add fdinfo support GPU load metrics")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241105205458.1318989-1-adrian.larumbe@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 2d30da38c2c3e..3385fd3ef41a4 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -38,7 +38,7 @@ static int panfrost_devfreq_target(struct device *dev, unsigned long *freq,
 		return PTR_ERR(opp);
 	dev_pm_opp_put(opp);
 
-	err =  dev_pm_opp_set_rate(dev, *freq);
+	err = dev_pm_opp_set_rate(dev, *freq);
 	if (!err)
 		ptdev->pfdevfreq.current_frequency = *freq;
 
@@ -182,6 +182,7 @@ int panfrost_devfreq_init(struct panfrost_device *pfdev)
 	 * if any and will avoid a switch off by regulator_late_cleanup()
 	 */
 	ret = dev_pm_opp_set_opp(dev, opp);
+	dev_pm_opp_put(opp);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "Couldn't set recommended OPP\n");
 		return ret;
-- 
2.43.0



