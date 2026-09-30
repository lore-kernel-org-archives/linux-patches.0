Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9405221E0;
	Wed, 30 Sep 2026 17:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790356; cv=none; b=AZ4URwoDDpNaw1GfXFJwFEK37q19owbyzM0+PbAvfAL+lw/P4TsbAW3TDB9fZKNARGP9MGFuDgeIS0Bxz27chDn/R00mwtGcuU6hOJBMLDhd/aDphS8z9AdpM1J0HmYPwjk00B3nQmdaoAhHLEmem5KPOZBgRLfYAciEzHPFpfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790356; c=relaxed/simple;
	bh=kVUeS2CWMJjFJ36oPGxPKMNRtCNa7X6xqg757RKShk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyWWhP0awKBR7hXXfaMQweFA9wGgOB6LrDbnMLssES16WLm1SiNz8k1kukoJwRUuO3Jf78I6BYaOcyssdDRelAj7/Flcl1dkooBKCo3fH5KtdrRK887RBG5/YbQGEEA8aZmr+Xy9HRQ89HoHh8oeF9IaRUPGKI5gCpbyq/1cAwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLSyWoxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLSyWoxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73231F00898;
	Wed, 30 Sep 2026 17:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790355;
	bh=ypzC413Hywsl8ICfKzhtHHJRBsskDAs4ssqxjwSpDtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLSyWoxd3IvS3aVxa6K/yeL4D8J8/5Ad/ZLDXtHV+R95aFu0aogxZhspOLmFRMuC7
	 t+YCjgHtChnKmrNPide1GFYwMMimRFwTd4HCLz1Un93NgGQT20gTgGqjvjBj/73ev2
	 E+/jlP+oYlpX1oIaoemWpKplLkjwQ0SCdYPPNGYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saim Shujah <saimzst@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 800/877] drm/msm/dpu: clear pending peripheral flush state
Date: Wed, 30 Sep 2026 17:28:31 +0200
Message-ID: <20260930152431.980478396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Saim Shujah <saimzst@gmail.com>

[ Upstream commit a5b5cc909931572aec446e129c035b76b3f0c1fa ]

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
[ Adjusted context due to the missing pending_cwb_flush_mask field in Linux 6.12. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -110,6 +110,7 @@ static inline void dpu_hw_ctl_clear_pend
 	ctx->pending_flush_mask = 0x0;
 	ctx->pending_intf_flush_mask = 0;
 	ctx->pending_wb_flush_mask = 0;
+	ctx->pending_periph_flush_mask = 0;
 	ctx->pending_merge_3d_flush_mask = 0;
 	ctx->pending_dsc_flush_mask = 0;
 	ctx->pending_cdm_flush_mask = 0;


