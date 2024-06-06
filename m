Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531E619AD60;
	Thu,  6 Jun 2024 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683335; cv=none; b=Jlvk2Z47oiYPoJM6hFJNxmDCQ9Y8QwHVnaue8fqVBiVVCBKmaK8k+kMHy3RqmIJ/rTBetsi2vLCgeNzkrpkSUDW8m1x8X5qst3eYPtz+mBQEi+gNOv6AEOEaezDHPpRsnuMSJrk12QFS8Pf/sIF4WOVEu0D/fvRfBEUleILqWBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683335; c=relaxed/simple;
	bh=NJaix6YN262hgv0BiiflH3jLsqVGxxfCWyCu99OAOQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYyV9V6hLa25g18ecIkI9M0kFpnH6klhJ4OuFalO3pyYIUCv1uJHgnO7Ia2VXJu4DO47yLCsAka7tNfa5JluTcPu90qQFuquhKwX8WLp0UuMD+Cy/Vvn6Z+ttgzXeOiAuN3PC4/UGe5wKOWYimGfUBwL3iolZrMyv/NKbl+vazk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLWNth1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLWNth1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BD6C32781;
	Thu,  6 Jun 2024 14:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683335;
	bh=NJaix6YN262hgv0BiiflH3jLsqVGxxfCWyCu99OAOQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLWNth1ovSbbKtlExeplQRYVON4T39yJy+/hbe2Ez+k7GvyMXoI+2BI/I9l9lgVI2
	 fOeTozg3kgyhmM5GF+6HqIbqFfOCHg1t+5FJ0eFwUS8UHV68k6bGn00ZG/9wMU514e
	 /VVzMulq02i1KnwNaTY7sQOCP0vkcWCDhH7gmbIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Marek Vasut <marex@denx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/744] drm/lcdif: Do not disable clocks on already suspended hardware
Date: Thu,  6 Jun 2024 15:59:08 +0200
Message-ID: <20240606131741.241250047@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 172695f145fb4798ab605e8a73f6e87711930124 ]

In case the LCDIF is enabled in DT but unused, the clocks used by the
LCDIF are not enabled. Those clocks may even have a use count of 0 in
case there are no other users of those clocks. This can happen e.g. in
case the LCDIF drives HDMI bridge which has no panel plugged into the
HDMI connector.

Do not attempt to disable clocks in the suspend callback and re-enable
clocks in the resume callback unless the LCDIF is enabled and was in
use before the system entered suspend, otherwise the driver might end
up trying to disable clocks which are already disabled with use count
0, and would trigger a warning from clock core about this condition.

Note that the lcdif_rpm_suspend() and lcdif_rpm_resume() functions
internally perform the clocks disable and enable operations and act
as runtime PM hooks too.

Reviewed-by: Liu Ying <victor.liu@nxp.com>
Fixes: 9db35bb349a0 ("drm: lcdif: Add support for i.MX8MP LCDIF variant")
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240226082644.32603-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/lcdif_drv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mxsfb/lcdif_drv.c b/drivers/gpu/drm/mxsfb/lcdif_drv.c
index 18de2f17e2491..6494e82707569 100644
--- a/drivers/gpu/drm/mxsfb/lcdif_drv.c
+++ b/drivers/gpu/drm/mxsfb/lcdif_drv.c
@@ -340,6 +340,9 @@ static int __maybe_unused lcdif_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
+	if (pm_runtime_suspended(dev))
+		return 0;
+
 	return lcdif_rpm_suspend(dev);
 }
 
@@ -347,7 +350,8 @@ static int __maybe_unused lcdif_resume(struct device *dev)
 {
 	struct drm_device *drm = dev_get_drvdata(dev);
 
-	lcdif_rpm_resume(dev);
+	if (!pm_runtime_suspended(dev))
+		lcdif_rpm_resume(dev);
 
 	return drm_mode_config_helper_resume(drm);
 }
-- 
2.43.0



