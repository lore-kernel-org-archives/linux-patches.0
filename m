Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D09E29AB1A;
	Fri,  7 Aug 2026 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116644; cv=none; b=Sd7kw1s//85EKPTyVDVLxEJ0ulDvATRyDU++lCUr6ETcIe23LpPKPQTRF2kmcQHAPGx/m2qaT0HuNxW6PJuSEGszRrco1Rwc2H/AyFxRb2ioBbr13Us9zTPH3EXhDjFcbBra+KacXqJTQZyfk1QCaYETPliyJn3hjDUFH+Z3kZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116644; c=relaxed/simple;
	bh=L90jC27e/jSCs0lVXqY1Kc3texsz5xtnnQ+bgGtJJi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJU6E8ywBaHCc6/xMDnB9ollV3kHdwM9Af7ibKAU/X31RAIt2NlZesqhiAlng7252xey3OJrqjSQygUl4tXywgo3jxD4hJh9Y/QWtRZfoqsm+vzqhukh5FVugZBBBbyYY0ZG/ScYtpj/oIfZqoBDogChex5ZzpGHmijbBmiM2hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaSdKCUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaSdKCUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2421F000E9;
	Fri,  7 Aug 2026 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116643;
	bh=pbBqN0RkbrqDB1MOUb+IJVj/9LrTipGc0ZCy4m9xMJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LaSdKCUOOtsxREkThVjo3+g1MIF8T0LWjL00OE9YpFzrC3XOEm6RqTt6CQHQIC2fe
	 W7OGzEc0bAUcWBM4S9jU2AsZLHDCUVuXBp3f/AGewx99sdfLX8b9oSJGvRuTXtTGNA
	 LqtACEje2ieuzPrvtW+aYc97/GOwbmWv83oQIRVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 040/438] drm/mediatek: Check CRTC state before freeing
Date: Fri,  7 Aug 2026 16:33:56 +0200
Message-ID: <20260807143428.856335845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 233a4d3a39fc1585f5e271b2adab43c6af025ae0 ]

mtk_crtc_reset() destroys the current CRTC state only when crtc->state
is non-NULL, but it always converts crtc->state to struct mtk_crtc_state
and passes the result to kfree().

When reset is called without an existing state, container_of(NULL, ...)
does not produce NULL. Keep the mtk state free in the same crtc->state
guard as the helper state destruction.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 2d267b81898e ("drm/mtk: Use __drm_atomic_helper_crtc_reset")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260707150528.2270739-1-ruoyuw560@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_crtc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.c b/drivers/gpu/drm/mediatek/mtk_crtc.c
index fcb16f3f7b23b..b01162a7df7fa 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.c
@@ -153,10 +153,10 @@ static void mtk_crtc_reset(struct drm_crtc *crtc)
 {
 	struct mtk_crtc_state *state;
 
-	if (crtc->state)
+	if (crtc->state) {
 		__drm_atomic_helper_crtc_destroy_state(crtc->state);
-
-	kfree(to_mtk_crtc_state(crtc->state));
+		kfree(to_mtk_crtc_state(crtc->state));
+	}
 	crtc->state = NULL;
 
 	state = kzalloc_obj(*state);
-- 
2.53.0



