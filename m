Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18F47C0A0;
	Wed, 21 Feb 2024 14:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524027; cv=none; b=E6C5GBFXHINubdYbSZo1Ax3M3oG1ThVROYFU+7HLfveOCaJuxeoRM/fsouG3Yf0svEUy8+8mY70BoAnMyVnV1nGyVvKNkKLqRILWuylNpORnLI7Gn4BtntklUxp616rQBRZ2unSM26nHeyChw/xBPrND7UDsoxDmEZwp9kGxaIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524027; c=relaxed/simple;
	bh=oXjUBZ0RqPA17Yt1XsnmsmKDBPE6Z+Saa1hmHLvhAe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kysNwXwJa3YtLAlcdu3UO/36b4EJCZ43YAxD/GaHIR/MPmvvCbKiz/Qt5pRzOsql5xZs2N8y5B1SSyaqmFtoMss7QHljIzIbuYpXU2SlwYlGcmKUR4J2I1j0MpYl9KrCiQV4fXqkQ6EtmZInx7M5fLb1yIzdff6061/1cecj+G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CU9gAgyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CU9gAgyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBCCC433F1;
	Wed, 21 Feb 2024 14:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524025;
	bh=oXjUBZ0RqPA17Yt1XsnmsmKDBPE6Z+Saa1hmHLvhAe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CU9gAgyxEAeIeVRbgE0Zq2jfWahKfaqbbyly2+uCpkdS7ukjdkG7+WHhoakIZ39nQ
	 ryEmZ2d74KIYd4TfZP5VeJhwUCvTJxddLonu6QA3V5bkW8nEbY8xTTh1rtcw4Niap/
	 oA8MUpWQqPkRZ+cKBAhm5gRideld1RdOpqXxMpq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/379] drm/exynos: gsc: minor fix for loop iteration in gsc_runtime_resume
Date: Wed, 21 Feb 2024 14:04:34 +0100
Message-ID: <20240221125957.733947711@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



