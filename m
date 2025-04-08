Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D17C17A311;
	Tue,  8 Apr 2025 12:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116308; cv=none; b=NTWYnIMOAlTsNbMaZPR12DbcwlaI9WMeMBIWhdf8DZ0OqCfGWY1BvZPZ4SYKrPuUOFL8F4DvessEXUhmyAo7KfBS9t7Qk3xYK0d6P4iZt1Zfq2ttxV9XZMTDH14aXHBjhiVgnIDu9SKK0Q1hKgIh0YOKBU2lCtscp2XUkmisv+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116308; c=relaxed/simple;
	bh=LseAnPphlQtWa6MoJYi64x+f/1U9q8DOEF4ZgG+y6Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPlZ+6mraVsASRPQdASJx4GUHMmyQI4Un7C2Hw/ebwmaOsCc/RJ8OG6oiLvcUL87IcFVp1O8MU5p7SDrKecpA3+eCuuhXbEzY4L2gSX9dVz5GamGqyZQfky1q0E25MM3ITlNJcW96gvMxKURBOVGa/i0izPrUvB4TITNmSEgCVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVC52gD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVC52gD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09D7C4CEE5;
	Tue,  8 Apr 2025 12:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116308;
	bh=LseAnPphlQtWa6MoJYi64x+f/1U9q8DOEF4ZgG+y6Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVC52gD1WlB3Sn6nQdV8eKKuuo/JvzBIR6W3OnQERJwkqAEmYR3QJ61oQiU6YFWUu
	 Ru4RxEKcZzO+pI6pBzFh85sHH6y6AAsAyGC1TMKkZdIhLMNxkjQ/2TzMl5phVXbiFY
	 NAO2i6dA7+DRNfy7kyqS6NCa0CWmPPIOaoRVlpsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hermes Wu <Hermes.wu@ite.com.tw>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/423] drm/bridge: it6505: fix HDCP V match check is not performed correctly
Date: Tue,  8 Apr 2025 12:46:18 +0200
Message-ID: <20250408104846.959788548@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Hermes Wu <Hermes.wu@ite.com.tw>

[ Upstream commit a5072fc77fb9e38fa9fd883642c83c3720049159 ]

Fix a typo where V compare incorrectly compares av[] with av[] itself,
which can result in HDCP failure.

The loop of V compare is expected to iterate for 5 times
which compare V array form av[0][] to av[4][].
It should check loop counter reach the last statement "i == 5"
before return true

Fixes: 0989c02c7a5c ("drm/bridge: it6505: fix HDCP CTS compare V matching")
Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250121-fix-hdcp-v-comp-v4-1-185f45c728dc@ite.com.tw
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index faee8e2e82a05..967aa24b7c537 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2042,12 +2042,13 @@ static bool it6505_hdcp_part2_ksvlist_check(struct it6505 *it6505)
 			continue;
 		}
 
-		for (i = 0; i < 5; i++) {
+		for (i = 0; i < 5; i++)
 			if (bv[i][3] != av[i][0] || bv[i][2] != av[i][1] ||
-			    av[i][1] != av[i][2] || bv[i][0] != av[i][3])
+			    bv[i][1] != av[i][2] || bv[i][0] != av[i][3])
 				break;
 
-			DRM_DEV_DEBUG_DRIVER(dev, "V' all match!! %d, %d", retry, i);
+		if (i == 5) {
+			DRM_DEV_DEBUG_DRIVER(dev, "V' all match!! %d", retry);
 			return true;
 		}
 	}
-- 
2.39.5



