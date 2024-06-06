Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DEF197A9B;
	Thu,  6 Jun 2024 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683312; cv=none; b=g5fIF7aapY4jLoRw9JulyFzmFFLcFlIcBL2reISmuTHYzdz0/H2CluZ9pHFT32CuY30uFcRjLUZ3UgSHbnpTFSCR+AiJ4exuIGhpa3diIzoQ/sMZYaIx1ddiAz8pLqn7qn3Yy6DSIsbQ5UEZRlBEn2jscR1sDljI8mghOpuuiSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683312; c=relaxed/simple;
	bh=MIvAoAwXFrU6vlaCmjrh7IsinO4mCrmewNoPfO9duGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDcUxa+4VmqfeqQlrT/4wydTPz5QcKJFbILxEkK5ArX4VT/PelGaGrxo7DhMkHNIHvikrv8hj+UXDjdWcKLT0V8b9NXNKz0/wXOapgvs8sZbWrvobXlvdzVpXmFtvAT8rxnUZcSOdwLIg5X2HjrWfQeg/jb2HF5/EMLag1BySFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OM/zOPaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OM/zOPaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117EFC2BD10;
	Thu,  6 Jun 2024 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683312;
	bh=MIvAoAwXFrU6vlaCmjrh7IsinO4mCrmewNoPfO9duGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OM/zOPaYWaGShQonsCvW3yjR5MVKRyaE3FulmGU5LWm5FESTf2ico3znu39MkxjhZ
	 6kl266rOHpJYj7p4cFCUQVmlZpeWFwQSm3o7x0+imJ65bxqd5s3kJABWBZyEUMBJqV
	 QpdU4BE3H6dQfeIUqfxNoD/WNoCNxrW0+q19qXH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Marek Vasut <marex@denx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/473] drm/lcdif: Do not disable clocks on already suspended hardware
Date: Thu,  6 Jun 2024 16:02:01 +0200
Message-ID: <20240606131706.293372095@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 075002ed6fb09..43d316447f387 100644
--- a/drivers/gpu/drm/mxsfb/lcdif_drv.c
+++ b/drivers/gpu/drm/mxsfb/lcdif_drv.c
@@ -290,6 +290,9 @@ static int __maybe_unused lcdif_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
+	if (pm_runtime_suspended(dev))
+		return 0;
+
 	return lcdif_rpm_suspend(dev);
 }
 
@@ -297,7 +300,8 @@ static int __maybe_unused lcdif_resume(struct device *dev)
 {
 	struct drm_device *drm = dev_get_drvdata(dev);
 
-	lcdif_rpm_resume(dev);
+	if (!pm_runtime_suspended(dev))
+		lcdif_rpm_resume(dev);
 
 	return drm_mode_config_helper_resume(drm);
 }
-- 
2.43.0



