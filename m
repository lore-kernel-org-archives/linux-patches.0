Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74FA3FFAD7;
	Sat, 12 Sep 2026 08:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202081; cv=none; b=AWViJM863Q43jXc3W3EdkcESa5y/X51cut2Af0C+rvvSu2YCr478+yDEICCNfJFP3SOWlA8yz4sq8itQ5NnUNifzqsXJdUupF8cnUmODAkbYyJ8fKY+neG+KHVoYQbZRAztQf8CX85n5xyBnRgHWO+T3T5BGfCptOIjFEBvm1/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202081; c=relaxed/simple;
	bh=Zc0YXiDDdMD2/8BhhVcmhDSjVqd51ugb1SnOUU9KTdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDn65UVDLqAx+RWcMOh0cyP1GLuPmMC4+PB54gD+5Kz1AH9askv7C6LBBh7Ci24nua6/oAU1/S/5lNuh7Z9hoXBq9W5zknn3CaxYLC3N4krGcL9Mno0bEPKTGOvT7zHkOp0oKpahQk4mVJnwtwtowqAsiAMQHvF2m0+WNj+kYOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkdOhJIx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkdOhJIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BA81F000FF;
	Sat, 12 Sep 2026 08:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202075;
	bh=ibkY+67o1lGtZh3oU1s7SJ+43oOIkMjCZAbAuBgqkNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkdOhJIxyHxYjyi4owbMJ9v82T+6EdiAU2bgpngmTPiNWPb1chmEGJzGbLMM7wRsi
	 /Qf4+YAIpnez+3KWcpxUJfdPso0tx72/zW7nVfpVvg8iMUlnXT9aZj6gAZRpW1mAHC
	 8/79ccN8/X2Vq9LruDMvY8NJfVD2WHJYdy2q00tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1127/1815] drm/sun4i: vi scaler: Restore opaque alpha in video modes
Date: Sat, 12 Sep 2026 08:47:57 +0200
Message-ID: <20260912065715.480784309@linuxfoundation.org>
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

[ Upstream commit 583d99165a85c3aaee924078c0f03c72e25644ac ]

The DE3 mixer initialization clears the entire mixer register space. This
also clears VSU_GLOBAL_ALPHA, despite its hardware reset value being 0xff.

The VI scaler uses Video Normal mode for subsampled YUV formats. In this
mode, VSU_GLOBAL_ALPHA provides the scaler output alpha. Leaving the
register at zero causes the scaler to produce fully transparent output.

Set VSU_GLOBAL_ALPHA to 0xff whenever configuring a DE3 or newer VI
scaler. The register is ignored in UI scaling mode.

Fixes: c50519e6db4d ("drm/sun4i: Add basic support for DE3")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/c48ba85b9e4478d51afde4f36839fd1c1d363b23.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.c | 2 ++
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
index d4412a62c2f07..a5cc99981006a 100644
--- a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
@@ -975,6 +975,8 @@ void sun8i_vi_scaler_setup(struct sun8i_layer *layer,
 
 		regmap_write(layer->regs,
 			     SUN50I_SCALER_VSU_SCALE_MODE(base), val);
+		regmap_write(layer->regs,
+			     SUN50I_SCALER_VSU_GLB_ALPHA(base), 0xff);
 	}
 
 	regmap_write(layer->regs,
diff --git a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.h b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.h
index 245fe2f431c3c..d89c0cbe188dd 100644
--- a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.h
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.h
@@ -36,6 +36,7 @@
 #define SUN50I_SCALER_VSU_EDSCL_CTRL(base)		((base) + 0x28)
 #define SUN50I_SCALER_VSU_ANGLE_THR(base)		((base) + 0x2c)
 #define SUN8I_SCALER_VSU_OUTSIZE(base)		((base) + 0x40)
+#define SUN50I_SCALER_VSU_GLB_ALPHA(base)	((base) + 0x44)
 #define SUN8I_SCALER_VSU_YINSIZE(base)		((base) + 0x80)
 #define SUN8I_SCALER_VSU_YHSTEP(base)		((base) + 0x88)
 #define SUN8I_SCALER_VSU_YVSTEP(base)		((base) + 0x8c)
-- 
2.53.0



