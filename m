Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84111AAA29;
	Thu, 13 Feb 2025 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458743; cv=none; b=O7X+H4G2m4o72/blXAzuCRPWQfyopvD8kdTWKHOYgqP3bR4Vr/NtGyFy9ycoJmrPAkqZYdTc8ETP8yyonp4vPcb7cw8DjsUppPFe+0eq2k/CI7N6dNxe0Zs95emFPPZRmCcUkxzf4M3BcqiF9NFY4roSH0HXWN3Zrote9+E04nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458743; c=relaxed/simple;
	bh=nYBAW0L+iWnuhGESdMBgQWb6GxKXU/+a34bMrOCXMag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp5WiwNGbiyOrOmlwtrI5kSy/r/gwVdOnpSs8HvHCGZmeECF0olVVJsKlQQTRFm6uEEeoPhoh8wiZv0v5gb5hunqhcuAO7McyzNJ74SbYxGAsZa37ppDlKqGGY2kH1LHMnohp9UFfaCj2Rz1dkTibuugVq2rZCUMEPMABrg/Qbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiBCSggF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiBCSggF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50128C4CED1;
	Thu, 13 Feb 2025 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458742;
	bh=nYBAW0L+iWnuhGESdMBgQWb6GxKXU/+a34bMrOCXMag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiBCSggFtqllG4LfcjbNA+xaFGLjc8/pV5dWSZxQkTN3OiCfYdf/ihRxB4TccGmRu
	 Za7LaFtksgeel/R16yvLKeQmVyB3YgVLRtV4OLq6Fq3D0y/DX6B0SspFdgxiRQw1hF
	 sQCDO8jWMD7/RE97iK/nD1cr+dJsk8y20GAbsl7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 033/443] drm/bridge: anx7625: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:18 +0100
Message-ID: <20250213142441.903955463@linuxfoundation.org>
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

[ Upstream commit e72bf423a60afd744d13e40ab2194044a3af5217 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-2-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index a2675b121fe44..c036bbc92ba96 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -2002,8 +2002,10 @@ static int anx7625_audio_get_eld(struct device *dev, void *data,
 		memset(buf, 0, len);
 	} else {
 		dev_dbg(dev, "audio copy eld\n");
+		mutex_lock(&ctx->connector->eld_mutex);
 		memcpy(buf, ctx->connector->eld,
 		       min(sizeof(ctx->connector->eld), len));
+		mutex_unlock(&ctx->connector->eld_mutex);
 	}
 
 	return 0;
-- 
2.39.5



