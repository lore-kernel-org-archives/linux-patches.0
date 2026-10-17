Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF3A394470;
	Sat, 17 Oct 2026 17:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257362; cv=none; b=EFXK0dfkrL+dhTxMApO23H7yP54xU32IzzPQSOqEGUGDMDhf+t88BnOe9MVgRy76MgjLKH7kQzBvT/EDzKEyUOvIgDA3TrlUe/ZReE0adGuPzEVnHqEIm5eO+B4NCmqzPqY65mGcMrkKqXBIs23beQljxxqiXDcyl2sOcPsvvzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257362; c=relaxed/simple;
	bh=arkRLxq2LQza2zsvsX+kwLV4pb1sbxm2fP7BwxHmXQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAqjzBnNJaKHDeSY6glWJJwGPEPm8m8cJauE693VeW5zxPyuF6q4avj/DcwMFAbFxJ9MxtUZvw8xwTn9gdGkhodlfPHF0YS1o6i0YvJfzw3S+USebmwyVLp05uMTcWt9jraNKS0/IIPkmyApAwXivS4svmw4x70By/YmyIPsmB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cscrTiro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cscrTiro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D863B1F000C4;
	Sat, 17 Oct 2026 17:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257361;
	bh=4d1dqFQXrtLdSzF2ZVhpbSGHDX4x8kXK194pAOUjXPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cscrTirojKczNr2BhYh6m7VF88voChX8Bzmca+8cXpmdXjEY49SpHkxdcn9atdhWs
	 eGHZ/HdQx+jDCP3TEYscE/FLD5KfJWKOMjgygk5vRcDTux0DAo5wO8K5/NZP9ouivD
	 aRtcpb8ab/f5zBUuCGZmLXvcGzG6ZNPiiB3Bokfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0536/1674] drm/dp: dont mark the AUX backlight enabled when enabling failed
Date: Sat, 17 Oct 2026 17:46:48 +0200
Message-ID: <20261017160444.862487693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 24ff1cab4e25e..1a54a52407b11 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -3843,7 +3843,9 @@ static int dp_aux_backlight_update_status(struct backlight_device *bd)
 
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



