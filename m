Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367817BAE6;
	Mon,  4 Mar 2024 21:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587863; cv=none; b=VFW5iFoURGBV9YTajYK9xEHQOezxP+Jwv4LAKYUhKukP+XYd+IpMd2TzIjep255nZmHAUOEx4uTcr+SeiuX4IPjCKipS8YGLIOVKCdjhceLMOFoCXQzGOCFYhICcUrE4A6N5nGiC7UIPSm95Dhr/dkHtah26uR18eyoyCdjNMkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587863; c=relaxed/simple;
	bh=LbmuggYAQ6sbiyoVyvVlpD0YSJbX+08Qe1u/YUra64I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Re3eQfn7Uu2bpMoFLyuLPTNIDLtvsFSA9j3gaBef8/gpAoIWiuZeWS59gz7AzoIlN1qEgY7b5wofgJL4IRe+SbBT2QvEOyuSpQxWFD2JsqfrGV6WWL+m3I7VvJDigd15kd2EJ+TzxR+vYLD/cm4azcrL4z6g1t1QNDEDEtO90lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhHunPv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhHunPv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE2CC433F1;
	Mon,  4 Mar 2024 21:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587863;
	bh=LbmuggYAQ6sbiyoVyvVlpD0YSJbX+08Qe1u/YUra64I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhHunPv8Qu94Xjkrte3npI/eCrfJsQarnRb26AaRWDqJNN/UhZQK3MwEa2LdIQw7T
	 SiHdeyr4SlnxK0CcDkIq2utnmgfbkGDW7krKGUV8WtXsiDdmbSDlI+5vku73yFadwa
	 2XRe61/yQW6PvJ09WQFxLtA6nuLxCyJnO6WWRyjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.7 094/162] soc: qcom: pmic_glink: Fix boot when QRTR=m
Date: Mon,  4 Mar 2024 21:22:39 +0000
Message-ID: <20240304211554.859280809@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

commit f79ee78767ca60e7a2c89eacd2dbdf237d97e838 upstream.

We need to bail out before adding/removing devices if we are going to
-EPROBE_DEFER. Otherwise boot can get stuck in a probe deferral loop due
to a long-standing issue in driver core (see commit fbc35b45f9f6 ("Add
documentation on meaning of -EPROBE_DEFER")).

Deregistering the altmode child device can potentially also trigger bugs
in the DRM bridge implementation, which does not expect bridges to go
away.

[DB: slightly fixed commit message by adding the word 'commit']
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20231213210644.8702-1-robdclark@gmail.com
[ johan: rebase on 6.8-rc4, amend commit message and mention DRM ]
Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Cc: <stable@vger.kernel.org>      # 6.3
Cc: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240217150228.5788-5-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/pmic_glink.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -268,10 +268,17 @@ static int pmic_glink_probe(struct platf
 	else
 		pg->client_mask = PMIC_GLINK_CLIENT_DEFAULT;
 
+	pg->pdr = pdr_handle_alloc(pmic_glink_pdr_callback, pg);
+	if (IS_ERR(pg->pdr)) {
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(pg->pdr),
+				    "failed to initialize pdr\n");
+		return ret;
+	}
+
 	if (pg->client_mask & BIT(PMIC_GLINK_CLIENT_UCSI)) {
 		ret = pmic_glink_add_aux_device(pg, &pg->ucsi_aux, "ucsi");
 		if (ret)
-			return ret;
+			goto out_release_pdr_handle;
 	}
 	if (pg->client_mask & BIT(PMIC_GLINK_CLIENT_ALTMODE)) {
 		ret = pmic_glink_add_aux_device(pg, &pg->altmode_aux, "altmode");
@@ -284,17 +291,11 @@ static int pmic_glink_probe(struct platf
 			goto out_release_altmode_aux;
 	}
 
-	pg->pdr = pdr_handle_alloc(pmic_glink_pdr_callback, pg);
-	if (IS_ERR(pg->pdr)) {
-		ret = dev_err_probe(&pdev->dev, PTR_ERR(pg->pdr), "failed to initialize pdr\n");
-		goto out_release_aux_devices;
-	}
-
 	service = pdr_add_lookup(pg->pdr, "tms/servreg", "msm/adsp/charger_pd");
 	if (IS_ERR(service)) {
 		ret = dev_err_probe(&pdev->dev, PTR_ERR(service),
 				    "failed adding pdr lookup for charger_pd\n");
-		goto out_release_pdr_handle;
+		goto out_release_aux_devices;
 	}
 
 	mutex_lock(&__pmic_glink_lock);
@@ -303,8 +304,6 @@ static int pmic_glink_probe(struct platf
 
 	return 0;
 
-out_release_pdr_handle:
-	pdr_handle_release(pg->pdr);
 out_release_aux_devices:
 	if (pg->client_mask & BIT(PMIC_GLINK_CLIENT_BATT))
 		pmic_glink_del_aux_device(pg, &pg->ps_aux);
@@ -314,6 +313,8 @@ out_release_altmode_aux:
 out_release_ucsi_aux:
 	if (pg->client_mask & BIT(PMIC_GLINK_CLIENT_UCSI))
 		pmic_glink_del_aux_device(pg, &pg->ucsi_aux);
+out_release_pdr_handle:
+	pdr_handle_release(pg->pdr);
 
 	return ret;
 }


