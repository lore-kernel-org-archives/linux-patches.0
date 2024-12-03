Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D006E5336E;
	Tue,  3 Dec 2024 15:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240827; cv=none; b=YVheBtCGh+MfQg6kpxOgQSO45x5fBbhxWWm4wqZoyPTbJ8Zq+/NJfvmGZnqWe+SY5CR0orOubD0PbuAsXQfQXEpXLNJuINvgPErXthRx8y3A90KpkSHsbN/BpG2U4D3oxSXPDtli1r6h8OcZbuEbgFjMB3ItFmF6+repE4bv28g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240827; c=relaxed/simple;
	bh=kqkJ366qg2BY6Z0cR5+B56q3CXP07dL2FD5nsWM/+pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJB0ARHXHvhFTVdbOzkARef8skVrGwITwBq8Ufvu2ZK6GBGcVxKRDXvAxnwhd2y/psgmIZ9YHPTbHiJL+wU0wJL3cbJzo73tV3DpCymS9SP7COfhjU1Ff09OYGPKb+FEpXvsSrq7M2+tEgyrv+zULUoWytRrea7HuCszXbJ4SlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLy1HYgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLy1HYgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEB6C4CECF;
	Tue,  3 Dec 2024 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240827;
	bh=kqkJ366qg2BY6Z0cR5+B56q3CXP07dL2FD5nsWM/+pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLy1HYgbbQZEzePqIPkiGcSxbsaCD0JWTRBm1pN5SKQjmExStvR30lXQWASl1xNPx
	 T87AfrvlcblaLsFSxCD4wqpfsXzZUO60DzQyda64z/v1K9uvb0eNr0d9sJ59Ea+Vvw
	 gksmSnxvkfPNCbjRBu1g4qYIRjDyvPFHpxjBCT6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/826] drm/vc4: Match drm_dev_enter and exit calls in vc4_hvs_lut_load
Date: Tue,  3 Dec 2024 15:39:26 +0100
Message-ID: <20241203144753.089465155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit cf1c87d978d47339a39bfa7a6133ecd3f8f87525 ]

Commit 52efe364d196 ("drm/vc4: hvs: Don't write gamma luts on 2711")
added a return path to vc4_hvs_lut_load that had called
drm_dev_enter, but not drm_dev_exit.

Ensure we call drm_dev_exit.

Fixes: 52efe364d196 ("drm/vc4: hvs: Don't write gamma luts on 2711")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/dri-devel/37051126-3921-4afe-a936-5f828bff5752@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008-drm-vc4-fixes-v1-1-9d0396ca9f42@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 3787c070d15e3..15e4c888c4afd 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -225,7 +225,7 @@ static void vc4_hvs_lut_load(struct vc4_hvs *hvs,
 		return;
 
 	if (hvs->vc4->gen == VC4_GEN_4)
-		return;
+		goto exit;
 
 	/* The LUT memory is laid out with each HVS channel in order,
 	 * each of which takes 256 writes for R, 256 for G, then 256
@@ -242,6 +242,7 @@ static void vc4_hvs_lut_load(struct vc4_hvs *hvs,
 	for (i = 0; i < crtc->gamma_size; i++)
 		HVS_WRITE(SCALER_GAMDATA, vc4_crtc->lut_b[i]);
 
+exit:
 	drm_dev_exit(idx);
 }
 
-- 
2.43.0



