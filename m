Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218FA7E769;
	Wed, 21 Feb 2024 13:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522372; cv=none; b=Y5SpP3QSdk0Khl9b1e8d2pz7tfDSvZRe/RNXilhSv8uHXXrBZ1GTLKoC+lQi+cKQYUOhKa0kdLUzUjvjMz+3U8zXAahgmBfpQHCQW2n57SabS2A+hCeP1k3ktF/RkmCPOAvteiYuCOcgFegu3wc3yboR3NgOVX+t2HQmJ3qjaA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522372; c=relaxed/simple;
	bh=8ZE2rNPsG5oM/gJS1yq9fosQWgMzovxBFWxN1kocAX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLv+T5cVJWqr78PcSAC0PJfNmp9aaAFhtbVp+d6+bqmTYmmNKozvB0QFzToaEi0EYPoVbNPXJgRiHqFUpFHbl9IjwEVDWHknvjnUqZoHAIhZ6FHxjaHzjtNw2gar992aEyT05HarPo4+XRUNlz6shohYYkUGZXNwqneosvKXaXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NylOjCsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NylOjCsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49327C433F1;
	Wed, 21 Feb 2024 13:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522371;
	bh=8ZE2rNPsG5oM/gJS1yq9fosQWgMzovxBFWxN1kocAX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NylOjCsO9UUoVRQicVG5cr9PrCFk3jarDEyZGk/RLIYj8dZlf9G5KWjWGzYAObAi1
	 jRGtYZtLAp1JnjOpQjZVO/6sL8ux9Q8OH+RLfIbPLkZcKoUxgTjC+NSqpIdq/0licX
	 o59VXe/umsSRM3TCA5m58OeJYWUITTBqv4g0laYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/476] drm/exynos: gsc: minor fix for loop iteration in gsc_runtime_resume
Date: Wed, 21 Feb 2024 14:02:49 +0100
Message-ID: <20240221130012.355879774@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 166a80262896..8c090354fd8a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1346,7 +1346,7 @@ static int __maybe_unused gsc_runtime_resume(struct device *dev)
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



