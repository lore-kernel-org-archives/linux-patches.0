Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3E135961;
	Thu, 13 Feb 2025 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460113; cv=none; b=XLtYkzqzU4+hL0kwJupk9+OiFYGgYNkDTP6jdSMcdp4zb+rj3RTU8qHwq920pz3LehwsFmwO4bSyXLzzs/nZUnzhsb+YA60pLcVBwsCOBonhcPJiCA7uE29kmKBV7YEJhyfvDe3t/30/OZ0jvuKBoIJXxorS74sGSoyHUs94Oik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460113; c=relaxed/simple;
	bh=f742AibO2003wIftzx51aVflfWMFdlMrSAcDuL7efUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXnCilckgt/JuFv2aEyxxlOeHxGj3fJjjAA9GRsCRWlIbWxTC0QrpVYsrqN08HUZVn66sYwsKK4ksZ2IAf1DTmc7UqKZI52MKSEnoCRTP98z+py+79/vHhxQSTH+3+tL3kMBR0ojuQCDF5AohZfL0ragVOZS9TPMMmpZD93VlDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XS7Z1MhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XS7Z1MhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85489C4CED1;
	Thu, 13 Feb 2025 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460113;
	bh=f742AibO2003wIftzx51aVflfWMFdlMrSAcDuL7efUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XS7Z1MhOFIoZ5vrAKgLFAHrc4go5pGyit6d7YBiInyloRjaBmPhN9+dyYYZsuQIge
	 6vFjDRQ6szaWB1YMtoVFJNEEX3dv/cM074Xo214dHtJijHj+yKB2esjGy/DwPxZuLs
	 Ii2FBKXvU8KQrBDPXUVIbQaELWKSnk2Gdcg3gOEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Raphael Gallais-Pou <rgallaispou@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/273] drm/sti: hdmi: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:26:31 +0100
Message-ID: <20250213142408.121700936@linuxfoundation.org>
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

[ Upstream commit e99c0b517bcd53cf61f998a3c4291333401cb391 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Raphael Gallais-Pou <rgallaispou@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-9-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index 500936d5743c5..90c68e0f493fb 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -1221,7 +1221,9 @@ static int hdmi_audio_get_eld(struct device *dev, void *data, uint8_t *buf, size
 	struct drm_connector *connector = hdmi->drm_connector;
 
 	DRM_DEBUG_DRIVER("\n");
+	mutex_lock(&connector->eld_mutex);
 	memcpy(buf, connector->eld, min(sizeof(connector->eld), len));
+	mutex_unlock(&connector->eld_mutex);
 
 	return 0;
 }
-- 
2.39.5



