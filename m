Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF85145A03;
	Thu, 13 Feb 2025 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460109; cv=none; b=Y56O2gKNS2c09CaLGPBfuevqmGGqqrFdSHsh/XdIt8+DaRtLouRihMAB6khkz88e4PvZ5eK7dZ8Z3ERa6olYSogKEQWmA1gXKiUiFXOISCYrdUJlebhJmCl7UkxrL27WmTdxdU8enhsFJ/TI6cPK28KLvTN9QrEvDd8YA+eRt2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460109; c=relaxed/simple;
	bh=Wol0u8ZIWi510SVpHkhHM3fjU4o34muiAc01cJh8dFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoOtIZQg8wWD5+gHuvMYitnsoRDshurn4gnaP+oguCNtFOP9Uu+hLg/bEFCzQ0JCgofZ150j4WVYXOLgm9Zjfma5nCw2W/G5wksfCiuKXFZC91PrIi+WLxireBUY41puxONmC1JMzByx5FOc6LrDc4l8QfEeXV/t3ctQQI6eeWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9R0FUnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9R0FUnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11636C4CED1;
	Thu, 13 Feb 2025 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460109;
	bh=Wol0u8ZIWi510SVpHkhHM3fjU4o34muiAc01cJh8dFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9R0FUnbO7KIbP+1y8EQgrpndrAS8Y2GgdfMnIHS7puHVx54HgMmlf1UGKp5S9NSH
	 ab5sjPDKKKUl4BL6pX0NG2aMKw5luMW740XZLuAbqoK1C1GybYeEr+NJuGrVbyqQya
	 w75X1jXR35WiApsl4oVgNRAjlMB45Nf8SroYsyMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/273] drm/radeon: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:26:30 +0100
Message-ID: <20250213142408.083839814@linuxfoundation.org>
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

[ Upstream commit b54c14f82428c8a602392d4cae1958a71a578132 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-8-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_audio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_audio.c b/drivers/gpu/drm/radeon/radeon_audio.c
index fc22fe709b9c1..da37a827337bc 100644
--- a/drivers/gpu/drm/radeon/radeon_audio.c
+++ b/drivers/gpu/drm/radeon/radeon_audio.c
@@ -773,8 +773,10 @@ static int radeon_audio_component_get_eld(struct device *kdev, int port,
 		if (!dig->pin || dig->pin->id != port)
 			continue;
 		*enabled = true;
+		mutex_lock(&connector->eld_mutex);
 		ret = drm_eld_size(connector->eld);
 		memcpy(buf, connector->eld, min(max_bytes, ret));
+		mutex_unlock(&connector->eld_mutex);
 		break;
 	}
 
-- 
2.39.5



