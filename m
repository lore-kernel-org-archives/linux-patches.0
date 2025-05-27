Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4455A42A9B;
	Tue, 27 May 2025 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368172; cv=none; b=pA5yT+l+dscHudEUd63P3C5QUJhI7Z0lGmzPJwK4Rmmjng25rrrZgpLrzLNrqu/AF/FRth5L5Wsj7NVHW/XuU3oETH3rL7eBoj8vZJTxD9hASwdnM7WH1CE4vyRuWzpaVE7lLaB7X5bGArHjawJFEglJR0EpE3LqUcGAKTXxVtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368172; c=relaxed/simple;
	bh=galqWBiushc2nQMGgy/IAUA8/QLWNJHM3AZTQrVrrEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cqzwp8poqkQoTqMd2yXM+oAW3q0O30jPlfKhtLcSd3TMh5tGhw3qa8burlpzy3b3J3gai+Pv4WYUiItdggu5ZrYeEq7M0S+JdiyYURnz9ckv6lf2WRWM9p5YQGtSuaSKL8+fTsE/KfffvprfgeAoUicATaciG8TV7zm0IcXzO3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQ+QJSvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQ+QJSvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C654CC4CEE9;
	Tue, 27 May 2025 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368172;
	bh=galqWBiushc2nQMGgy/IAUA8/QLWNJHM3AZTQrVrrEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQ+QJSvPye5Aq3p4fIG6DH51xSZe1c1vi3gayJuqLGCyPrqy/4ucp0jKjesKtxcJh
	 o/fG+9CfgAuahLT1uqJg6RecCVAN5XiK0mKe1ZlgZUR7tn+Y9DKZvAcgtMyWKWpSgY
	 qFxBQsblJJmyRJ0oV7J3kDTK8kz50ZfyshLA7CjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 622/783] drm/xe: Always setup GT MMIO adjustment data
Date: Tue, 27 May 2025 18:26:59 +0200
Message-ID: <20250527162538.483793867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit bbd8429264baf8bc3c40cefda048560ae0eb7890 ]

While we believed that xe_gt_mmio_init() will be called just once
per GT, this might not be a case due to some tweaks that need to
performed by the VF driver during early probe.  To avoid leaving
any stale data in case of the re-run, reset the GT MMIO adjustment
data for the non-media GT case.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241114175955.2299-2-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 150dca2f91033..6b4b9eca2c384 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -650,6 +650,9 @@ void xe_gt_mmio_init(struct xe_gt *gt)
 	if (gt->info.type == XE_GT_TYPE_MEDIA) {
 		gt->mmio.adj_offset = MEDIA_GT_GSI_OFFSET;
 		gt->mmio.adj_limit = MEDIA_GT_GSI_LENGTH;
+	} else {
+		gt->mmio.adj_offset = 0;
+		gt->mmio.adj_limit = 0;
 	}
 
 	if (IS_SRIOV_VF(gt_to_xe(gt)))
-- 
2.39.5



