Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E983644C1;
	Wed, 30 Sep 2026 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788865; cv=none; b=suQbfUMleoJo8orlFjss1fbOI3oNg4aH9LdS/gT57+G/bVenCFM1pKRQ4h9vs5qMgZrbAXJuH224cffwgwNVVuk115R7QdKBxgIAlOiOe/YoXomAiDqTopDBi/uFBXxP3h8/OVu2zZmT9j8clBU2peYXooSBMXjoUnacnSXCGRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788865; c=relaxed/simple;
	bh=rVbMKACZEr866pHz+aQ9su/bPlF4dFhf4wwCWR+/g3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqybWeXKHS+no0UieKqgrM7ayBd8yvVEeJwYqA4NafhO1/4TPmiFSE+W6JLCdrJo49mTKXvafxVQn3evhP28Z464plOlNAZb6VA0qu7FSXp56fP7y+jxXt3Zg8b7mci916vD5d2idrjLdLQh/pMwfuQbDgPFjYr1Q6U4wPLUxQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tI2kK54K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tI2kK54K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDE21F000FF;
	Wed, 30 Sep 2026 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788863;
	bh=yyhKYP2ZO5GMOZSYjXb8NXQaKHR6arpSGb54VCJhmKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tI2kK54Kq4lK8+pnZPc9BiA0+hKmiOUyUuy9EFOwHOPfB/2WBxEGWjNVuMQLxqWcR
	 jZgGoXxVd3jyxI3n3oAXXRcJayspvaAwsR8Jxdh3UrhfnyJxdl7sx6z2aHCHu73+G8
	 uqMmCZy5HumeDtsPtskcsLLopbtceTthisItF4H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.12 275/877] drm/msm/hdmi_phy: fix runtime PM cleanup on probe failure
Date: Wed, 30 Sep 2026 17:19:46 +0200
Message-ID: <20260930152420.654992675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit f4fae975db08a9aeec0b15e145c7d4d0fe02a0ec upstream.

msm_hdmi_phy_probe() enables runtime PM before enabling the PHY
resources and initializing the PLL, but failures from either operation
return without calling the matching pm_runtime_disable().

The remove path disables runtime PM, but it is not called when probe
fails. As a result, runtime PM remains enabled after an unsuccessful
probe.

Route failures after pm_runtime_enable() through a common error path
and disable runtime PM before returning.

This issue was found by manual code inspection.

Fixes: 15b4a4523859 ("drm/msm/hdmi: Create a separate HDMI PHY driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/753043/
Link: https://lore.kernel.org/r/20260913085814.1509352-1-lgs201920130244@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
@@ -164,13 +164,13 @@ static int msm_hdmi_phy_probe(struct pla
 
 	ret = msm_hdmi_phy_resource_enable(phy);
 	if (ret)
-		return ret;
+		goto err_pm_disable;
 
 	ret = msm_hdmi_phy_pll_init(pdev, phy->cfg->type);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "couldn't init PLL\n");
 		msm_hdmi_phy_resource_disable(phy);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	msm_hdmi_phy_resource_disable(phy);
@@ -178,6 +178,10 @@ static int msm_hdmi_phy_probe(struct pla
 	platform_set_drvdata(pdev, phy);
 
 	return 0;
+
+err_pm_disable:
+	pm_runtime_disable(dev);
+	return ret;
 }
 
 static void msm_hdmi_phy_remove(struct platform_device *pdev)


