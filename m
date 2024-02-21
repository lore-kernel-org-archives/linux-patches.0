Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1062F4C62;
	Wed, 21 Feb 2024 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525081; cv=none; b=MwOith2gg2NdZQPibAXgsCSUKPkSaELTkSqEfsE50zwoihs6x3JnKC02vgyTX56s8gf2Ae/W83HIRcfE5jM6XweDud0Wko3k7gxA4QoQuw7HBJuTNP4qe5lDHWy27ViELLHiArMi10Cy+tr7BIlAE0YTrY2s571SXtYlbneDatQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525081; c=relaxed/simple;
	bh=dTyrfBhwwblB1bRAj/061aSoa7V0ACBTrfTFSC00Nv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3gNBRVBg2fMsDNvvHPUt5B+dUf+R5QnxHAWK0cvQHaHeVaISLkDNN4AUOMipjw7Ia8xnYc5yz6jnyl/2EOlrqw5jaYoIGoGjz18+TZ/UTV/Y6Pj7RqI4imz8naXcayrCn+u4dkqPrvnU7T1Dv16fqjU0MVsNNkkSfcWS9NFwWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xM1DutKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xM1DutKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC4BC433C7;
	Wed, 21 Feb 2024 14:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525080;
	bh=dTyrfBhwwblB1bRAj/061aSoa7V0ACBTrfTFSC00Nv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xM1DutKtpv4l3OxZeuBN4uvFJ6A/y9pAgXq/b0a/rWiBU4LhQdV47wf1FW3lHmx0v
	 jm1BdQl/wcx5NHhLiEJJw3COzUw2G+/U1z9G+3JkhJzaaD27dMp+csFrc/L09mj1Up
	 fIuw712Wxz9qaexSnL1tmxcKQiVOFmLxAoORTzBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/267] drm/exynos: gsc: minor fix for loop iteration in gsc_runtime_resume
Date: Wed, 21 Feb 2024 14:06:36 +0100
Message-ID: <20240221125941.741884826@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 4050957c7c2c14aa795dbf423b4180d5ac04e113 ]

Do not forget to call clk_disable_unprepare() on the first element of
ctx->clocks array.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 8b7d3ec83aba ("drm/exynos: gsc: Convert driver to IPP v2 core API")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 45e9aee8366a..bcf830c5b8ea 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1344,7 +1344,7 @@ static int __maybe_unused gsc_runtime_resume(struct device *dev)
 	for (i = 0; i < ctx->num_clocks; i++) {
 		ret = clk_prepare_enable(ctx->clocks[i]);
 		if (ret) {
-			while (--i > 0)
+			while (--i >= 0)
 				clk_disable_unprepare(ctx->clocks[i]);
 			return ret;
 		}
-- 
2.43.0



