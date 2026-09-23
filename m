Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE103AE198;
	Wed, 23 Sep 2026 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174054; cv=none; b=p1965nzgfyYWZw9C0HbGrMX8MRF+Pf6mhhezyNq2bJcesP0T0JLAeer0TTZ5r5ezjYf4PO+zObFaoRmYvzdikhmF4IutihaYqOPHXCHv+8mnIj5Hy/dTzRGxTP4XIJkEnV+9+bTZXAFnO07jAMzIfPaK3XzST500OWQNXd1KQXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174054; c=relaxed/simple;
	bh=YfZgKlsDLOFTGMLPeEqt7Y7e4JJYnts4opdxw0+3cNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNtB/M8SdWwHvbuq06LLz6qcUcRQT0A9EDP7G5TCOEA/sRHdWgp4jDpVBW/CmkhccfxZaho4ydJWNR+spDZ6fbxSnBqFVTDE5qXBTyt7HK4swGE4XMr12sOQB8U1RAKhquIFjcpbg4DvBQVWMrNlzz7a6lwk/Q79wnOg+4yQY0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5H2w4X+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5H2w4X+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D1C1F000FF;
	Wed, 23 Sep 2026 14:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174053;
	bh=3B6SKyAWj6iTfdMowunaaJh/X+VstIhHAQb1MbQrkpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5H2w4X+643HYCt/OOUpUBsiYGRjACbLM6+K10PGhvuMxZ7CpxRJTXicV6kFmhnWZ
	 iS7bgs4g/bR3DVhp8FTOCtXWIkgNC+NoQdCBhY3G169eh9sg3vez/dN6xVkeJ5I77Z
	 6q8wAtyDDWwyo0SOkFmby97Nj9hhan84QVFjbyfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saim Shujah <saimzst@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 7.2 403/438] drm/msm/dpu: clear pending peripheral flush state
Date: Wed, 23 Sep 2026 16:07:04 +0200
Message-ID: <20260923140655.340305385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Saim Shujah <saimzst@gmail.com>

commit a5b5cc909931572aec446e129c035b76b3f0c1fa upstream.

dpu_hw_ctl_clear_pending_flush() resets the cached per-block state after a
flush transaction, but misses pending_periph_flush_mask.

The peripheral flush updater accumulates interface bits in this mask. A
later transaction which sets the top-level peripheral flush bit can write
stale interface bits to CTL_PERIPH_FLUSH together with the current state.

Peripheral flush support was added after the helper started clearing every
individual pending flush mask. Clear the peripheral mask together with the
other cached child masks.

Fixes: 64f7b81f0358 ("drm/msm/dpu: add support of new peripheral flush mechanism")
Cc: stable@vger.kernel.org
Signed-off-by: Saim Shujah <saimzst@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/748968/
Link: https://lore.kernel.org/r/20260828065440.140410-1-saimzst@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -118,6 +118,7 @@ static inline void dpu_hw_ctl_clear_pend
 	ctx->pending_intf_flush_mask = 0;
 	ctx->pending_wb_flush_mask = 0;
 	ctx->pending_cwb_flush_mask = 0;
+	ctx->pending_periph_flush_mask = 0;
 	ctx->pending_merge_3d_flush_mask = 0;
 	ctx->pending_dsc_flush_mask = 0;
 	ctx->pending_cdm_flush_mask = 0;


