Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB2117E90E;
	Mon, 27 May 2024 19:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837027; cv=none; b=LmZtDZMCLcHkNIwNC7MQsIIu/QPZfI+cIoYVA56b1a5b4A1kdltXkmq70lz7BTECevPRGIoJPqwLSgzS67RgkXk2MeshWvOe1WmsuohTnHNqekl0emuRNsUlqEWJAqk6Ye4DtOCP+l0BM8XHqF+xgyRB/sHhFx638QnNBIwuE/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837027; c=relaxed/simple;
	bh=HgLMdFcBzijp5ifP3v+xdZcjt8cfdxDEADy8xcoulII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ0J700hf4pDCvUe4Gm4mBZrBkp55bcRIigUsvRVBENfOeFVG0OdpBCaG5466ApzIxRKhu9Utur1ZJTjJlj9H446+WX9xCZmHmp/nd7GALTcz2hfsBY79MchG6v2iCRpCrp+EKJwmfaAbTq0U3qmjac7Gu/yUXo14B9jTqW2kH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+3AI61Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+3AI61Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DA2C2BBFC;
	Mon, 27 May 2024 19:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837027;
	bh=HgLMdFcBzijp5ifP3v+xdZcjt8cfdxDEADy8xcoulII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+3AI61Y68zc1ONmExDimEiQMN477tIJOQHLoUHQ4/GLojt18ntwp8yPHgpmHfk02
	 M3WZP53lA0siLLYnaOJdMaDYg+mIEI3gd0/iYl9YZNQ/VxujAWVDYRwh8a7/1cDeLe
	 WlQT5eKnndTuCc4fQjkTb+Rnhi/Sy0UgEB1CG1xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 283/427] drm/panel: atna33xc20: Fix unbalanced regulator in the case HPD doesnt assert
Date: Mon, 27 May 2024 20:55:30 +0200
Message-ID: <20240527185628.949426962@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 5e842d55bad7794823a50f24fd645b58f2ef93ab ]

When the atna33xc20 driver was first written the resume code never
returned an error. If there was a problem waiting for HPD it just
printed a warning and moved on. This changed in response to review
feedback [1] on a future patch but I accidentally didn't account for
rolling back the regulator enable in the error cases. Do so now.

[1] https://lore.kernel.org/all/5f3cf3a6-1cc2-63e4-f76b-4ee686764705@linaro.org/

Fixes: 3b5765df375c ("drm/panel: atna33xc20: Take advantage of wait_hpd_asserted() in struct drm_dp_aux")
Acked-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240313-homestarpanel-regulator-v1-1-b8e3a336da12@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/panel/panel-samsung-atna33xc20.c  | 22 +++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c b/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c
index 76c2a8f6718c8..9c336c71562b9 100644
--- a/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c
+++ b/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c
@@ -109,19 +109,17 @@ static int atana33xc20_resume(struct device *dev)
 		if (hpd_asserted < 0)
 			ret = hpd_asserted;
 
-		if (ret)
+		if (ret) {
 			dev_warn(dev, "Error waiting for HPD GPIO: %d\n", ret);
-
-		return ret;
-	}
-
-	if (p->aux->wait_hpd_asserted) {
+			goto error;
+		}
+	} else if (p->aux->wait_hpd_asserted) {
 		ret = p->aux->wait_hpd_asserted(p->aux, HPD_MAX_US);
 
-		if (ret)
+		if (ret) {
 			dev_warn(dev, "Controller error waiting for HPD: %d\n", ret);
-
-		return ret;
+			goto error;
+		}
 	}
 
 	/*
@@ -133,6 +131,12 @@ static int atana33xc20_resume(struct device *dev)
 	 * right times.
 	 */
 	return 0;
+
+error:
+	drm_dp_dpcd_set_powered(p->aux, false);
+	regulator_disable(p->supply);
+
+	return ret;
 }
 
 static int atana33xc20_disable(struct drm_panel *panel)
-- 
2.43.0



