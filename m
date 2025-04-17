Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF204254B12;
	Thu, 17 Apr 2025 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912860; cv=none; b=ozZ4Ml42qeBDyM7avVprEPQ7MnRXuPwZjkqQyN7RDk5UwNmjttURpLgGS7jy4tGUVg38+idL/vlF37HlnHDdJ5rsG6LVXJfNMTLAIQk5q97uyQ7nRVSony3RQkjts9F0CpLh1IapkM1anlEF4ubJYTIniBsOTXcbHoy/DpTyTak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912860; c=relaxed/simple;
	bh=2SkmMk7CzLW0iwziXArd73tyx9CaD//cvdX+N/QDLHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KB3d5RZ8pdTFPyzISThPBxP5NzmlasTbXixGSQEnQvR/Crmbv5zb8o40YUluZ+kgH5bHPRVcz1XFlEXBpIqFDqChK/V1wITi+6QvudcyPFCBaDD6ij/Dp+6AiwQ04q5nesdB2Lr4rzGbgEA5COBg0nzkpUiu2zhpiV43L0TrhFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwLs2gfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwLs2gfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6620CC4CEE4;
	Thu, 17 Apr 2025 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912860;
	bh=2SkmMk7CzLW0iwziXArd73tyx9CaD//cvdX+N/QDLHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwLs2gfQMqCQGIThBHUaUeIVqrYDqrL/5HSRmytGX2kG0aciXR8eFfTr2su8cMx0g
	 bW0T+s7YCUnWfU1DVQjGull5ccpcKfC3sZbcx1uR251SQfjP5t+J0+DyZNVHLIrbkm
	 jD29RjRYWmHa1MKgAlLFd5a3XEP9N57Px8ePABNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 149/449] drm/xe/pf: Dont send BEGIN_ID if VF has no context/doorbells
Date: Thu, 17 Apr 2025 19:47:17 +0200
Message-ID: <20250417175123.972039638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

[ Upstream commit 21ccac0e22aaf27b767f9de4bf573e7c47f619c8 ]

It turned out that GuC validates VF configuration immediately
after receiving "some" set of configuration KLVs and complains
if one of the critical, from GuC understanding, resource is left
unprovisioned, even if PF should be still allowed to make late VF
config adjustments, since VF was not yet started.

This issue was discovered after we decided to asynchronously
re-send configuration KLVs after GT reset/resume, as then fair
VF auto-provisioning could already allocate some of the resources,
which was a prerequiste for sending those config KLVs:

 # fair GGTT provisioning
 [] xe 0000:00:02.0: [drm] GT0: PF: pushed VF1 config with 2 KLVs:
 [] xe 0000:00:02.0: [drm] GT0: { key 0x0001 : 64b value 0x176a000 } # ggtt_start
 [] xe 0000:00:02.0: [drm] GT0: { key 0x0002 : 64b value 0xfd696000 } # ggtt_size
 [] xe 0000:00:02.0: [drm] GT0: PF: VF1 provisioned with 4251541504 (3.96 GiB) GGTT
 # re-provisioning worker
 [] xe 0000:00:02.0: [drm] *ERROR* GT0: H2G request 0x5503 failed: error 0x60 hint 0x0
 [] xe 0000:00:02.0: [drm] GT0: PF: Failed to push VF1 14 config KLVs (-EIO)
 [] xe 0000:00:02.0: [drm] GT0: { key 0x0001 : 64b value 0x176a000 } # ggtt_start
 [] xe 0000:00:02.0: [drm] GT0: { key 0x0002 : 64b value 0xfd696000 } # ggtt_size
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a0b : 32b value 0 } # begin_ctx_id
 [] xe 0000:00:02.0: [drm] GT0: { key 0x0004 : 32b value 0 } # num_contexts
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a0a : 32b value 0 } # begin_db_id
 [] xe 0000:00:02.0: [drm] GT0: { key 0x0006 : 32b value 0 } # num_doorbells
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a01 : 32b value 0 } # exec_quantum
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a02 : 32b value 0 } # preempt_timeout
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a03 : 32b value 0 } # cat_error_count
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a04 : 32b value 0 } # engine_reset_count
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a05 : 32b value 0 } # page_fault_count
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a06 : 32b value 0 } # guc_time_us
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a07 : 32b value 0 } # irq_time_us
 [] xe 0000:00:02.0: [drm] GT0: { key 0x8a08 : 32b value 0 } # doorbell_time_us
 [] xe 0000:00:02.0: [drm] GT0: PF: Failed to push VF1 configuration (-EIO)

To avoid such errors stop sending BEGIN_CONTEXT/DOORBELL_ID KLVs
if no GuC context/doorbell IDs were provisioned to VF.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4176
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Michał Winiarski <michal.winiarski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129195947.764-2-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
index 878e96281c035..4bd255adfb401 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
@@ -262,7 +262,7 @@ static u32 encode_config(u32 *cfg, const struct xe_gt_sriov_config *config, bool
 
 	n += encode_config_ggtt(cfg, config, details);
 
-	if (details) {
+	if (details && config->num_ctxs) {
 		cfg[n++] = PREP_GUC_KLV_TAG(VF_CFG_BEGIN_CONTEXT_ID);
 		cfg[n++] = config->begin_ctx;
 	}
@@ -270,7 +270,7 @@ static u32 encode_config(u32 *cfg, const struct xe_gt_sriov_config *config, bool
 	cfg[n++] = PREP_GUC_KLV_TAG(VF_CFG_NUM_CONTEXTS);
 	cfg[n++] = config->num_ctxs;
 
-	if (details) {
+	if (details && config->num_dbs) {
 		cfg[n++] = PREP_GUC_KLV_TAG(VF_CFG_BEGIN_DOORBELL_ID);
 		cfg[n++] = config->begin_db;
 	}
-- 
2.39.5



