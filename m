Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DF827BF8D;
	Tue, 27 May 2025 17:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368125; cv=none; b=G5ocFIJaeZmT0V2hYYkgtCMgu/ZShfqBwGQEm/cosRYAURzDvQC5khnDxgertSvZ0UxSU5wOBBQ09dJmjmLRuyB0rL78yfG7DaLcvl+caO034meYQ2MN79a2px87al9MGjXCbU3iU0VJpWHf/sOyj3rAEtCHf+HDIS08Rtk9/qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368125; c=relaxed/simple;
	bh=luJDcoXGYAT/QXTaazPeAes9gltzg6eYT7/DkTroDXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cBgpIM3JaM0XgsjRMsqZTwtW3h/5LZPbONpFNBwFcACWOICTp5IdvoPmTPRC+GVQj34ziZiusiQtJYWyX/CsPnJjodojl25ya8WYHLXHxlpBATYfLiWcqL3RdOAlqcj8CMjZXoli6bRVE0yIV2AkcrVD1AB7JLF1GFnl/6cjeqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UK13yBGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UK13yBGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04328C4CEEA;
	Tue, 27 May 2025 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368125;
	bh=luJDcoXGYAT/QXTaazPeAes9gltzg6eYT7/DkTroDXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UK13yBGe2SpWcbsrZSznv9ToZqWzx40Xy2BZ6ZiFkIklsz3dh+6Nt3U4YzlTYjHxj
	 5VtBj7EdO1G60DyZn00G03yJkgsth6wpNr828OQr+f3h/3d3o6JV/wPWc3YyAXce0m
	 f552O1HDjRE0zRNUJOzG2mFJ71IByuBohefbI8h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 605/783] drm/xe/pf: Reset GuC VF config when unprovisioning critical resource
Date: Tue, 27 May 2025 18:26:42 +0200
Message-ID: <20250527162537.794140045@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 33f17e2cbd930a2a00eb007d9b241b6db010a880 ]

GuC firmware counts received VF configuration KLVs and may start
validation of the complete VF config even if some resources where
unprovisioned in the meantime, leading to unexpected errors like:

 $ echo 1 | sudo tee /sys/kernel/debug/dri/0000:00:02.0/gt0/vf1/contexts_quota
 $ echo 0 | sudo tee /sys/kernel/debug/dri/0000:00:02.0/gt0/vf1/contexts_quota
 $ echo 1 | sudo tee /sys/kernel/debug/dri/0000:00:02.0/gt0/vf1/doorbells_quota
 $ echo 0 | sudo tee /sys/kernel/debug/dri/0000:00:02.0/gt0/vf1/doorbells_quota
 $ echo 1 | sudo tee /sys/kernel/debug/dri/0000:00:02.0/gt0/vf1/ggtt_quota
 tee: '/sys/kernel/debug/dri/0000:00:02.0/gt0/vf1/ggtt_quota': Input/output error

To mitigate this problem trigger explicit VF config reset after
unprovisioning any of the critical resources (GGTT, context or
doorbell IDs) that GuC is monitoring.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Michał Winiarski <michal.winiarski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129195947.764-3-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c | 37 +++++++++++++++++++---
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
index aaca54b40091f..27f309e3a76e6 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
@@ -336,6 +336,26 @@ static int pf_push_full_vf_config(struct xe_gt *gt, unsigned int vfid)
 	return err;
 }
 
+static int pf_push_vf_cfg(struct xe_gt *gt, unsigned int vfid, bool reset)
+{
+	int err = 0;
+
+	xe_gt_assert(gt, vfid);
+	lockdep_assert_held(xe_gt_sriov_pf_master_mutex(gt));
+
+	if (reset)
+		err = pf_send_vf_cfg_reset(gt, vfid);
+	if (!err)
+		err = pf_push_full_vf_config(gt, vfid);
+
+	return err;
+}
+
+static int pf_refresh_vf_cfg(struct xe_gt *gt, unsigned int vfid)
+{
+	return pf_push_vf_cfg(gt, vfid, true);
+}
+
 static u64 pf_get_ggtt_alignment(struct xe_gt *gt)
 {
 	struct xe_device *xe = gt_to_xe(gt);
@@ -432,6 +452,10 @@ static int pf_provision_vf_ggtt(struct xe_gt *gt, unsigned int vfid, u64 size)
 			return err;
 
 		pf_release_vf_config_ggtt(gt, config);
+
+		err = pf_refresh_vf_cfg(gt, vfid);
+		if (unlikely(err))
+			return err;
 	}
 	xe_gt_assert(gt, !xe_ggtt_node_allocated(config->ggtt_region));
 
@@ -757,6 +781,10 @@ static int pf_provision_vf_ctxs(struct xe_gt *gt, unsigned int vfid, u32 num_ctx
 			return ret;
 
 		pf_release_config_ctxs(gt, config);
+
+		ret = pf_refresh_vf_cfg(gt, vfid);
+		if (unlikely(ret))
+			return ret;
 	}
 
 	if (!num_ctxs)
@@ -1054,6 +1082,10 @@ static int pf_provision_vf_dbs(struct xe_gt *gt, unsigned int vfid, u32 num_dbs)
 			return ret;
 
 		pf_release_config_dbs(gt, config);
+
+		ret = pf_refresh_vf_cfg(gt, vfid);
+		if (unlikely(ret))
+			return ret;
 	}
 
 	if (!num_dbs)
@@ -2085,10 +2117,7 @@ int xe_gt_sriov_pf_config_push(struct xe_gt *gt, unsigned int vfid, bool refresh
 	xe_gt_assert(gt, vfid);
 
 	mutex_lock(xe_gt_sriov_pf_master_mutex(gt));
-	if (refresh)
-		err = pf_send_vf_cfg_reset(gt, vfid);
-	if (!err)
-		err = pf_push_full_vf_config(gt, vfid);
+	err = pf_push_vf_cfg(gt, vfid, refresh);
 	mutex_unlock(xe_gt_sriov_pf_master_mutex(gt));
 
 	if (unlikely(err)) {
-- 
2.39.5



