Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254F32A1D1;
	Thu, 13 Feb 2025 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458753; cv=none; b=sL7VoM6R4MQPb8iLgFHUgf2xtAElTB56PhcEnkUqJ3FkOSA54/0DvqhVJCTtkpq3jDLtdO/whhWvmH3hOTqMeZS2zUpDbYXRMgXWbwf+icpWvKB7TgIdfsPCzPeUPbJWefC+b4HtslzmPugBz+DaaKP97XE7pdJTUXMHxmvdW5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458753; c=relaxed/simple;
	bh=26QyT4345GbqL+FS9Ub39mdm10NdmCKo1u4QEI6Gqt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rqx41yVEuAifjyfAd1m0rd0PsbHOBQVz0WLMArEH1V6fJQ9aI32Bd/QuioMIUZtzcXfbr3J1s8IgF0b5VJ8ZS+XLVQcyaakWb1ysT5kCpcEYe6F7wf1IvpvZxYxk5YbCLGVXlADmxucKp5DzZHUHpVQaFnXpZ/mvIBUITW3xGQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWiZ1Epr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWiZ1Epr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8788DC4CED1;
	Thu, 13 Feb 2025 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458753;
	bh=26QyT4345GbqL+FS9Ub39mdm10NdmCKo1u4QEI6Gqt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWiZ1EprAZlil78qCxGlSnDqHgFDLnbfwOPwBUB8q82aFulP3HaEI8JLCbdeE3bdp
	 JgfUZbg2/H3DBXzikPXIkMOYLH0cV8GIX7p+BoWITCP0YZd96/iDGoIwxlqNq6H+UR
	 Ws4RaovKR2x0/v/F3AmlLYFyCpYd724+sudUEdVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 036/443] drm/exynos: hdmi: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:21 +0100
Message-ID: <20250213142442.018784629@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5e8436d334ed7f6785416447c50b42077c6503e0 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-5-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 466a9e514aa1c..7a57d4a23e410 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1648,7 +1648,9 @@ static int hdmi_audio_get_eld(struct device *dev, void *data, uint8_t *buf,
 	struct hdmi_context *hdata = dev_get_drvdata(dev);
 	struct drm_connector *connector = &hdata->connector;
 
+	mutex_lock(&connector->eld_mutex);
 	memcpy(buf, connector->eld, min(sizeof(connector->eld), len));
+	mutex_unlock(&connector->eld_mutex);
 
 	return 0;
 }
-- 
2.39.5



