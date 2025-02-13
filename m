Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2978A35961;
	Thu, 13 Feb 2025 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460106; cv=none; b=mKPKPY7i0KR+wvMCaeWCCNnkV1o6LtZJzxgWZMwQmrPF6zY0nIadr3+vyPJ+t457C1qXbTYSduOC5sQrve5NXoIrialbTswqGwbq0k3PnrszBVmvvz702hJQbl9O2VgmaZ0ybdBmKDV0JCmpUWNkjKeTvYxn4sW+Zh+6QfxmW7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460106; c=relaxed/simple;
	bh=4K0s/0p4INK39I2K3YMd8sFMBL42+PPwUFlG/WKHaXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqhvWJqbAPrBKghvzltQdZ2Jv5Ebud1+1IA+68Gie6HRH0nvoYe+MzSRT8vjRvUnh8L7JS+lKqgWgtZe7JttTNdvXyItrFZmp9UUs9KXQ79/VutHXCOzMIVAL3Wowcyfg9X/K2Eqk4CZArg3rsZhNZbMhu+67Krqfg9cVYGycYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjrAhdfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjrAhdfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD28C4CEE7;
	Thu, 13 Feb 2025 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460106;
	bh=4K0s/0p4INK39I2K3YMd8sFMBL42+PPwUFlG/WKHaXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjrAhdfyAUGh7dcd9VoWRYEJ3Qhf8mEiHmyfWjpHhvXEgXLVcvWB+SKvVI6YjOUNV
	 XgrskFUULHVtiUP8tnGtUpkNJfXoeSp9yooag3K33lRTLlJPNWdfQC0lpIVj52SXTU
	 nH2fATCKHlIbxDzlu9qxBNMDDb5LcJt+UaeKzc7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/273] drm/exynos: hdmi: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:26:29 +0100
Message-ID: <20250213142408.041545671@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 906133331a442..c234f9245b144 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1643,7 +1643,9 @@ static int hdmi_audio_get_eld(struct device *dev, void *data, uint8_t *buf,
 	struct hdmi_context *hdata = dev_get_drvdata(dev);
 	struct drm_connector *connector = &hdata->connector;
 
+	mutex_lock(&connector->eld_mutex);
 	memcpy(buf, connector->eld, min(sizeof(connector->eld), len));
+	mutex_unlock(&connector->eld_mutex);
 
 	return 0;
 }
-- 
2.39.5



