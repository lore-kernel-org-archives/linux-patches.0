Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD89B400978;
	Sat, 12 Sep 2026 08:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202071; cv=none; b=q/jY0Xto5+SvItXQscmnW7VIqEOaVuzx9OD31Ur60XLDC3QW/0AQF05hO1sYp1Yet4BA0eAWD5MAsYJ5iE3Njyt+/+SHIyAnbtPck7m1xTIBQdENzO/M9zaH5Mbw9OnMC7kBYDy8wVXrz4lEy4jzMys/HmRCQuKc8tpprsalAt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202071; c=relaxed/simple;
	bh=9QYq5QUFLTreFTkBPBDmiJ4FWLUB2Nsx22xL1gjO6C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAoKZTK19yLjiGsPYqTutxTKwGZF35MeNy4vc4C+Qo5s19lanmfZXfyU+eA2FcIEVgv6johBlMhlQ6dOkGJKQlYYFJNACJ4/zp6PL/V/LRlY5E8t3S6c3m90irxef2L+lqFwSpCc3HhxJXnwqsPy5Ka/76kxu1SSbSdeYDPMOlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXJhwzRc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXJhwzRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75E41F000FF;
	Sat, 12 Sep 2026 08:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202065;
	bh=9RlAD9T7atNDJDdOm6D2JgZ9shNMz/cTN0j5WPsKl+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXJhwzRcJb+gd6kSUTcHAfwZx5PxKtWrmtrxp1KztLM0m3HDLUygo+urD2+bW9Ou8
	 1P8fCAkjziTxgEPyw8vzlAqfqf5JzcA6aMTlEI5alcNHrg5r/GYmKKK4wyhyRNI0D9
	 QQ9UDwXzZBr84zB5SuAY8jxOTF3QTAes/Cflte4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1125/1815] drm/sun4i: Fix V3s YUV scanline size
Date: Sat, 12 Sep 2026 08:47:55 +0200
Message-ID: <20260912065715.430964342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit abffce8b1eb5e119efccc51fc6a18ba38e2f6db6 ]

The VI scaler line buffer on V3s can hold 1024 pixels for subsampled
formats, not 2048 as currently claimed. Since coarse horizontal scaling
is engaged only once the source width exceeds that limit, YUV layers
wider than 1024 pixels are passed to the scaler unchanged and the
output is corrupted.

Use the value from the vendor driver.

Fixes: 2586de70c15c ("drm/sun4i: Add VI scaler line size quirk for DE2/DE3")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/75ad4947981f2dc33fd42c05ae0b0cedda7647bd.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_mixer.c b/drivers/gpu/drm/sun4i/sun8i_mixer.c
index 4e42262950104..b6cd7352e76c5 100644
--- a/drivers/gpu/drm/sun4i/sun8i_mixer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.c
@@ -785,7 +785,7 @@ static const struct sun8i_mixer_cfg sun8i_v3s_mixer_cfg = {
 		.de_type	= SUN8I_MIXER_DE2,
 		.vi_scaler_num	= 2,
 		.scaler_mask	= 0x3,
-		.scanline_yuv	= 2048,
+		.scanline_yuv	= 1024,
 	},
 	.de_type	= SUN8I_MIXER_DE2,
 	.mod_rate	= 150000000,
-- 
2.53.0



