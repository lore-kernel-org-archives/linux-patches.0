Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E07397958;
	Fri,  7 Aug 2026 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113814; cv=none; b=GRJLGmJ47TFf+Fbk19mRcqvEuQD4PgDLKmlKAQvvnR4x26NbaVKn2HwT90fmF4SfO5FNzrBjPIBkbGNo6hEm/+bCg8NhwiHhGZPCDxcW6zNJ+4wnPRgWGK9IdzArHhol1ewHmWUS0VxmYeNRUW9dAcoI2pbHsadrKXTI80WkY+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113814; c=relaxed/simple;
	bh=c66AQg8Riupg6jk3YmDXJiY6bsMozF3P2rDRBWNmJ/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPWON+3aPQvp1ZgdEE8CrIBgyf+aYan43i5ncPhKv6k7lrWrrLo5LFE5enITLkqdNr2kf1zl/nFO/9gsMO51KL0wqSlYRibthSDcSpBSVkgTIsIKBlTjqU+2hDE7EX8mDDNmSMDna1Iq8YmnK/9tMeQPujAVmVUjrzbGCcy/qv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Njf32zz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Njf32zz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A11E1F000E9;
	Fri,  7 Aug 2026 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113797;
	bh=GtY0bXYwMdJIyWqTJHyZw1gH1tU1MDqITEwshcPwk0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Njf32zz42Y2wYJ6qpwARrEimiZuSBp1fF5TLfkMhFrc3epccimXisllUBZyROEVDx
	 yiRHmM1Zg6r/CLMxTqhCF1n5Qv/4EF4isyc5lGyT+w5V3D2GiaaspTWllfveCH/Xaq
	 cCoJX1WGpp4NlmVxjPF4NvgeE1695ee34ADCLcFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/337] drm/mediatek: Check CRTC state before freeing
Date: Fri,  7 Aug 2026 16:34:02 +0200
Message-ID: <20260807143419.363482797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c4c6d0249df56..aa8e6f6ddcd32 100644
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
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-- 
2.53.0



