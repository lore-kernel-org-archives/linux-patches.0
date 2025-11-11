Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB90262FEC;
	Tue, 11 Nov 2025 01:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824403; cv=none; b=YkI6BmlBg8EPU5YKcsONMqm6ispWXPJfdKxAqJVfW7A+YNW/bSlbYnTheXa8uPSmzTRCbtUWPbF1FVYk2Rizrz/iXIeiI8BjGgE5MvHWPN+F1TCHl1aPhNPw6Nv5anYMCN9/OJbANo+TN0I67trd3ujJmBHVWAvgh8Q4OyZvVDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824403; c=relaxed/simple;
	bh=nRCna5ioKCg847gjYyUaw5yhCenL/BIWr1SIsvqyKmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3shbxT6EhqR+XMvvUSc533clMIL1Xtqku/abO9fOnQnirPVNQ8Inl6J+MaGwWquQBWR37vJt60Rd+gli0zxJrfnMg2jfYHZeF0WdRfvhi/+4zulS0PySz3a84DOVa1sLNSEjrT9e0yclcQNR2nWMKSUs5PEWda6jqdu+HKpyrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCL0gdtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCL0gdtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D2EC19421;
	Tue, 11 Nov 2025 01:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824403;
	bh=nRCna5ioKCg847gjYyUaw5yhCenL/BIWr1SIsvqyKmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCL0gdtbnyhhs6v3DURlP1isqN7nNpv8hKyahzebZRrrxfptH9wu2Je0xya5tccQU
	 rO5ZTpulPFmEy6vhRRRkOiSKZlt8GNxjm8VlptdjdzjVDhXaHQL/JZ1est2T57KqBd
	 qgbg+pnaMKMV5OHs2YkaoboxMEkj7T0pp5QgwCXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 488/849] drm/xe/guc: Always add CT disable action during second init step
Date: Tue, 11 Nov 2025 09:40:58 +0900
Message-ID: <20251111004548.238097503@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 955f3bc4af440bb950c7a1567197aaf6aa2213ae ]

On DGFX, during init_post_hwconfig() step, we are reinitializing
CTB BO in VRAM and we have to replace cleanup action to disable CT
communication prior to release of underlying BO.

But that introduces some discrepancy between DGFX and iGFX, as for
iGFX we keep previously added disable CT action that would be called
during unwind much later.

To keep the same flow on both types of platforms, always replace old
cleanup action and register new one.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Link: https://lore.kernel.org/r/20250908102053.539-2-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index ff622628d823f..22eff8476ad48 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -300,12 +300,11 @@ int xe_guc_ct_init_post_hwconfig(struct xe_guc_ct *ct)
 
 	xe_assert(xe, !xe_guc_ct_enabled(ct));
 
-	if (!IS_DGFX(xe))
-		return 0;
-
-	ret = xe_managed_bo_reinit_in_vram(xe, tile, &ct->bo);
-	if (ret)
-		return ret;
+	if (IS_DGFX(xe)) {
+		ret = xe_managed_bo_reinit_in_vram(xe, tile, &ct->bo);
+		if (ret)
+			return ret;
+	}
 
 	devm_release_action(xe->drm.dev, guc_action_disable_ct, ct);
 	return devm_add_action_or_reset(xe->drm.dev, guc_action_disable_ct, ct);
-- 
2.51.0



