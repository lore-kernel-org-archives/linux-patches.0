Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5FD4FECF0;
	Tue, 13 Oct 2026 12:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895965; cv=none; b=ASl4bjDHAs8OfUbm6jTAVGSn4Je57EaFA4wj1D/stqdXMZmsBFM0lJXd3+zYqdcWdfH9JW92cVRg44zl820XMy864JMeZ59uGxSjetvyD2KFMYXTY64AGWUgxhJngygqsoAjYWTT5kD/QSdVx7nE8KntR/3DgZmOArENXWYbTu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895965; c=relaxed/simple;
	bh=l+SKliiQKBWY2FbzPklAOTb/cNGv9jcGQqGx4T3kLpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TB17eO1+7ObgxmyOVEylTsZJkPiCO4R0y+QnL0aGDab55pMsP6L3w8bMQcf2AUZft1t3+99ErjjrWy9s+dQg6DoADbG91jfzC+SnmkCbZ+d7Bz0PrOKpYE4cXS9UjM68QOytv4E2ITgL+Sh66PwrVmLRMwb3I/gzPHejeEQ+4Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vq1UH9mc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vq1UH9mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15831F000FF;
	Tue, 13 Oct 2026 12:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895964;
	bh=daq5dP33G5pxXAXDGzWnylvN7cX5XaADZfO5EjTMEz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vq1UH9mcqBitP4lBUFZSkmq1vxHYG3l6jPCcg3SbJQ8lY8Fgfly7EqhzBhKD4P1Ki
	 eddZ7h7Z2YXOUaTijJlQHrwrIrUA3IcS3ioL/wFdFolTYbHnRBOB2wv5P4ZDzVkzpR
	 HdeeZfJaBzsshrnWDM28jYfk9cEEKg/b/+SH/Qcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 451/497] drm/dp: dont mark the AUX backlight enabled when enabling failed
Date: Tue, 13 Oct 2026 13:40:18 +0200
Message-ID: <20261013112918.587299615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Oleg Keri <okerixx@gmail.com>

[ Upstream commit 707ce102521496c67860d81221b20c56d8255f2f ]

If drm_edp_backlight_enable() fails, dp_aux_backlight_update_status()
still marks the backlight as enabled. From then on every brightness
change only updates the level and the enable is never retried, so the
panel stays dark until something blanks and unblanks the backlight.

Return the error instead, so the next update tries to enable again.

Fixes: 10f7b40e4f30 ("drm/panel: add basic DP AUX backlight support")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260925132558.27518-1-okerixx@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 2ba6d10247f4f..eede78685176e 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -4060,7 +4060,9 @@ static int dp_aux_backlight_update_status(struct backlight_device *bd)
 
 	if (!backlight_is_blank(bd)) {
 		if (!bl->enabled) {
-			drm_edp_backlight_enable(bl->aux, &bl->info, brightness);
+			ret = drm_edp_backlight_enable(bl->aux, &bl->info, brightness);
+			if (ret)
+				return ret;
 			bl->enabled = true;
 			return 0;
 		}
-- 
2.53.0



