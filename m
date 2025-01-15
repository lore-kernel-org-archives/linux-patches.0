Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B88248BA6;
	Wed, 15 Jan 2025 10:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937894; cv=none; b=cSiHFGfHUycKvhdINf8UGapLL0bLeIw3nRBeGLFxQjPSZKnpfiR2ogQUyjvKQzwiNOa2nYZEoiUXW7pogNx1+pctiBHSbAlPkmzVvlbvV14WMGGhq+138J06HCC4lAo7qy99aDuMhhF4rnochWdinpM/h6nfAds3dt/tSg680x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937894; c=relaxed/simple;
	bh=m+blj6m/0Ve+v1JnIZ3HM/6NDU8vjNIrIj6/0wZv9LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INbZX4f9nP6QPcxtB3EHf7fA4fFXGvh/5ta96nPcUSTl1HiJs5nDLZZM5Z818pQIopHe9tpVL7s6UMcjGdk14ceYfNd2JxXHLLIaCzvHlGb3WJxy74CXp+QWpZdZ/fzEsa47UP9i1mjgqnj1sTcRQ80vba3ssM1SwrIfE5Urb/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAezYlq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAezYlq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D088BC4CEDF;
	Wed, 15 Jan 2025 10:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937894;
	bh=m+blj6m/0Ve+v1JnIZ3HM/6NDU8vjNIrIj6/0wZv9LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAezYlq2JDHjozc6ACHnQmeleihrTVmIm8HxGyqACxp85aWEOGOdDOb7ArosX8uXe
	 Dcg35VMQhz0TNmIX5tf+8v8uMyRDezTAkIJbO+OPRA0Hz+aFw98qES+QeJfJClTv/l
	 jJ+ZCAYLBnfc2XFEtcufCDL5Y2uMzD+wTfsIJY78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/189] ASoC: mediatek: disable buffer pre-allocation
Date: Wed, 15 Jan 2025 11:35:18 +0100
Message-ID: <20250115103607.243897641@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 32c9c06adb5b157ef259233775a063a43746d699 ]

On Chromebooks based on Mediatek MT8195 or MT8188, the audio frontend
(AFE) is limited to accessing a very small window (1 MiB) of memory,
which is described as a reserved memory region in the device tree.

On these two platforms, the maximum buffer size is given as 512 KiB.
The MediaTek common code uses the same value for preallocations. This
means that only the first two PCM substreams get preallocations, and
then the whole space is exhausted, barring any other substreams from
working. Since the substreams used are not always the first two, this
means audio won't work correctly.

This is observed on the MT8188 Geralt Chromebooks, on which the
"mediatek,dai-link" property was dropped when it was upstreamed. That
property causes the driver to only register the PCM substreams listed
in the property, and in the order given.

Instead of trying to compute an optimal value and figuring out which
streams are used, simply disable preallocation. The PCM buffers are
managed by the core and are allocated and released on the fly. There
should be no impact to any of the other MediaTek platforms.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20241219105303.548437-1-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/common/mtk-afe-platform-driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/common/mtk-afe-platform-driver.c b/sound/soc/mediatek/common/mtk-afe-platform-driver.c
index 9b72b2a7ae91..6b6330583941 100644
--- a/sound/soc/mediatek/common/mtk-afe-platform-driver.c
+++ b/sound/soc/mediatek/common/mtk-afe-platform-driver.c
@@ -120,8 +120,8 @@ int mtk_afe_pcm_new(struct snd_soc_component *component,
 	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(component);
 
 	size = afe->mtk_afe_hardware->buffer_bytes_max;
-	snd_pcm_set_managed_buffer_all(pcm, SNDRV_DMA_TYPE_DEV,
-				       afe->dev, size, size);
+	snd_pcm_set_managed_buffer_all(pcm, SNDRV_DMA_TYPE_DEV, afe->dev, 0, size);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mtk_afe_pcm_new);
-- 
2.39.5



