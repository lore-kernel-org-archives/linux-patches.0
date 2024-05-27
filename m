Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6754D17E90E;
	Mon, 27 May 2024 19:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837025; cv=none; b=X1lE4I1JsPzJi2DtIQafhZTqj6myDBF9O2emb50yEFT1GaYigA2KbSfhttj4MEwh2bqPIAk10ZlL2P2Chxi13r/scrEIQuUO6IEWVkxv/bZRAbqhr2Akfh/ZBHq47Q3KtvX86M9NH+IKlQVJzX/C6QRLSLU0ALHz/6ktg17AcqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837025; c=relaxed/simple;
	bh=BlGYgpZti3gd4/Y9hZqnc5teXTrLH59HpG3qQYtIsDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFf1opT8FucUm2gu13ZPpl1cTjOg84AhsplhLuROwRyd/+3zrZ2oB+MACvGbAaX/NgNoeOo30usgfXbVpTu6PysD6FGl7WVpitA7PqkNMwTE4fAZrMuOZVHYLmx/79PugDrM7tTmkWgB8PA2EiBzfJu0dMpTAR+KKWZrRpU1Mno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pn3680Mr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pn3680Mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC759C2BBFC;
	Mon, 27 May 2024 19:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837025;
	bh=BlGYgpZti3gd4/Y9hZqnc5teXTrLH59HpG3qQYtIsDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pn3680Mr1kag+lTI3XGJLwog8US/IR8GaCIcOtmAXE7UH/x3mrz3/bS3ojRbeMd1D
	 YMBALYSP2E8Z6mRHQnFLETi9dtq+gD+V4vOcsVEQeQvSV5+ifY+qYmzV7joH053O7h
	 qf9mzvQ7de69BnhVa7nYzFkkNzKgHL1tHQVfLykU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Marek Vasut <marex@denx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 282/427] drm/lcdif: Do not disable clocks on already suspended hardware
Date: Mon, 27 May 2024 20:55:29 +0200
Message-ID: <20240527185628.868804163@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ea10bf81582e9..0f895b8a99d62 100644
--- a/drivers/gpu/drm/mxsfb/lcdif_drv.c
+++ b/drivers/gpu/drm/mxsfb/lcdif_drv.c
@@ -343,6 +343,9 @@ static int __maybe_unused lcdif_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
+	if (pm_runtime_suspended(dev))
+		return 0;
+
 	return lcdif_rpm_suspend(dev);
 }
 
@@ -350,7 +353,8 @@ static int __maybe_unused lcdif_resume(struct device *dev)
 {
 	struct drm_device *drm = dev_get_drvdata(dev);
 
-	lcdif_rpm_resume(dev);
+	if (!pm_runtime_suspended(dev))
+		lcdif_rpm_resume(dev);
 
 	return drm_mode_config_helper_resume(drm);
 }
-- 
2.43.0



