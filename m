Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62868346771;
	Tue, 21 Jul 2026 22:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673461; cv=none; b=OF2zXPZNrRO+s2c5YiKV7UHwhm1d5qIzAbVu75hfQPK+vatw2YOWDR/l+dYWTbOB8Q62KjQUd655Cr7VsWS8ZnU9HW0gp8GK+ZeUT6zksrSAJHnpEt8t9h/BmOFlJbEyJ1MsBoyu+PSbSLL7adWMo+yX6kT9EzXZSEaieAFvFwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673461; c=relaxed/simple;
	bh=Ku4t2av/7P+DXq7DVaxYQZtD1cvC+rb1nXcwoB8zfQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maCJWID9sHF0rBozciQasHL+g2PA6obR/JqsjGXlUILUH7CqC/htQlBxniiWbzFzXOSMU69AQJRSI9zGNnwilPorgdkHFlsJD3O3oJe2saHrPwZbZEipKpHAZaJV6Hm1z8CHOd6mx6lnEQ3a4dBLaF1aqvS2gFgd22U9aovNwtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xn9B3F0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xn9B3F0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35EE1F000E9;
	Tue, 21 Jul 2026 22:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673460;
	bh=fVyci9vChKaAMlzYbKEZ522t64yk5pmGVUjd8XDIXoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xn9B3F0okE4hyQrGbZCPdzB+/wWyDa4zjIQcWEdDo0VMmoDrF+iS4G+xE0VA46Msv
	 IaVmpkxWm4m4x40JZAV8jC7TRJ9hWCX/WmszE+fZH3I72uvMrhJuaAFjM4BDDzTwfo
	 N8bt/uc+hGifv/nYqtvAmzGiLQEt+pUESOarFvEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/699] drm/tidss: Drop extra drm_mode_config_reset() call
Date: Tue, 21 Jul 2026 17:18:48 +0200
Message-ID: <20260721152359.514913594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f468fef38716f667e805e0fa2c497c6b9c325bb9 ]

We are calling drm_mode_config_reset() twice at probe time. There's no
reason for this and the second call can be removed, reducing work at
probe time slightly.

Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260311-tidss-minor-fixes-v2-1-cb4479784458@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_kms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_kms.c b/drivers/gpu/drm/tidss/tidss_kms.c
index 09485c7f0d6fcc..48e72862c7144a 100644
--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -277,8 +277,6 @@ int tidss_modeset_init(struct tidss_device *tidss)
 	if (ret)
 		return ret;
 
-	drm_mode_config_reset(ddev);
-
 	dev_dbg(tidss->dev, "%s done\n", __func__);
 
 	return 0;
-- 
2.53.0



