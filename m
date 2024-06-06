Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC79198858;
	Thu,  6 Jun 2024 14:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683337; cv=none; b=O6gCINSQe7D/Ypvlo25q5YRQ4HPG4qT6kpyZ5jLhLhC67hr3MxQBPsCCq5waUSmGntU8mEqchTz4lkDhnTPVRVbvpEcQ/b7BWOTjeN1nTRODBjsjvobM2hOkEd15AMYZLJj4KxXI7rD3deGw3vJ8CSw4k4FDn+wfHNIyRvekBms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683337; c=relaxed/simple;
	bh=DOUuonQvaDQLlJWk85u6NAUhbO5mFTzj/R+x2U5suHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Geo2LNu0t4QDQw6YPPlAgDy1t+LxntXkpgMhUGU11gJJRXB46D+OIkNhmVx6fBdCmXkFzt4DKNLLWkh7cGKWDfIQlg5stX4HPttfZpJ3qQMInWpS5tVYpvkv4Ykpb5TWqmTu6G1+0S+qkpuzcksHCO4cTw9gCOqHUWEXZq+8dmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAeHW1pU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAeHW1pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CACC2BD10;
	Thu,  6 Jun 2024 14:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683337;
	bh=DOUuonQvaDQLlJWk85u6NAUhbO5mFTzj/R+x2U5suHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAeHW1pUyxLiRsILnHNPTm3REzjlkFbTpWx+hjpiTh1z2iIOi3JN83hGZojOSdL5e
	 dz6cMWDtwwAxJQyNhmnJ7y0fRwwboljI8bA7/wz1Ku7p0idj6Y4RXAqXfnVEq3txcw
	 tHpZH2ik89lVu9c2ITey+VQDqtIKy5Vi5PC1gcb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 278/744] drm/panel: atna33xc20: Fix unbalanced regulator in the case HPD doesnt assert
Date: Thu,  6 Jun 2024 15:59:10 +0200
Message-ID: <20240606131741.311012993@linuxfoundation.org>
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



