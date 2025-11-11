Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E23302CA7;
	Tue, 11 Nov 2025 01:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823149; cv=none; b=cQPcRchMAMsBUBp+n0qIZCYdWYc38u8M/7wyAREAG71bqyY9ZPQbYosMI0FKiITfmylpUFfcFAcUfx7jtTpkPeivd0i8ltrurG9BFO0AObvmWDfYijSymb3NxikbkKTM+J79tyl1Uts6WWotKWN7ijv+BxZ5Jx57I9JHhYp+8/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823149; c=relaxed/simple;
	bh=TFdjAqUvbiBEl+w5+LrX+Z18Fxay6wgre0Yo31D7H9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKKabxUVfuHy2llJVmarDWg15XPT7YS4Y6pReMIilvQuDd2/K4TgBs3Aios0PNMBW1VldH/cftU/yw8514N+tATx5DYnkumWGML8VCtG4M5q6XVgRSjKPh+dwhfCIRWwW86jsbwQxaKoaHrGRwHD7D6FqVP1Z9UW5bwriR73kec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSKlLSEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSKlLSEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A88C116B1;
	Tue, 11 Nov 2025 01:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823149;
	bh=TFdjAqUvbiBEl+w5+LrX+Z18Fxay6wgre0Yo31D7H9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSKlLSEC5gI/+N7skFiI2/TeW1i69GmG/C4w7S+qvcFYPjOlPq9ZOj65QD52V0qDe
	 Z1KKeexpHErGQOsmJpDu4fDr5Tezp+J9s5rs5tR3u1Opog9QD81A3GhMmB04RjnhZ6
	 X0iNwzVKX/mVlBJeR+o6nNrIfQs/QPWllCbxfttY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/565] drm/amdgpu: Avoid rma causes GPU duplicate reset
Date: Tue, 11 Nov 2025 09:40:36 +0900
Message-ID: <20251111004530.980963597@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Ce Sun <cesun102@amd.com>

[ Upstream commit 21c0ffa612c98bcc6dab5bd9d977a18d565ee28e ]

Try to ensure poison creation handle is completed in time
to set device rma value.

Signed-off-by: Ce Sun <cesun102@amd.com>
Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 17 ++++++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h |  1 +
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index f5148027107bc..d9cdc89d4cde1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2927,7 +2927,6 @@ static void amdgpu_ras_do_page_retirement(struct work_struct *work)
 					      page_retirement_dwork.work);
 	struct amdgpu_device *adev = con->adev;
 	struct ras_err_data err_data;
-	unsigned long err_cnt;
 
 	/* If gpu reset is ongoing, delay retiring the bad pages */
 	if (amdgpu_in_reset(adev) || amdgpu_ras_in_recovery(adev)) {
@@ -2939,13 +2938,9 @@ static void amdgpu_ras_do_page_retirement(struct work_struct *work)
 	amdgpu_ras_error_data_init(&err_data);
 
 	amdgpu_umc_handle_bad_pages(adev, &err_data);
-	err_cnt = err_data.err_addr_cnt;
 
 	amdgpu_ras_error_data_fini(&err_data);
 
-	if (err_cnt && amdgpu_ras_is_rma(adev))
-		amdgpu_ras_reset_gpu(adev);
-
 	amdgpu_ras_schedule_retirement_dwork(con,
 			AMDGPU_RAS_RETIRE_PAGE_INTERVAL);
 }
@@ -3008,6 +3003,9 @@ static int amdgpu_ras_poison_creation_handler(struct amdgpu_device *adev,
 	if (total_detect_count)
 		schedule_delayed_work(&ras->page_retirement_dwork, 0);
 
+	if (amdgpu_ras_is_rma(adev) && atomic_cmpxchg(&ras->rma_in_recovery, 0, 1) == 0)
+		amdgpu_ras_reset_gpu(adev);
+
 	return 0;
 }
 
@@ -3043,6 +3041,12 @@ static int amdgpu_ras_poison_consumption_handler(struct amdgpu_device *adev,
 		reset_flags |= msg.reset;
 	}
 
+	/*
+	 * Try to ensure poison creation handler is completed first
+	 * to set rma if bad page exceed threshold.
+	 */
+	flush_delayed_work(&con->page_retirement_dwork);
+
 	/* for RMA, amdgpu_ras_poison_creation_handler will trigger gpu reset */
 	if (reset_flags && !amdgpu_ras_is_rma(adev)) {
 		if (reset_flags & AMDGPU_RAS_GPU_RESET_MODE1_RESET)
@@ -3052,8 +3056,6 @@ static int amdgpu_ras_poison_consumption_handler(struct amdgpu_device *adev,
 		else
 			reset = reset_flags;
 
-		flush_delayed_work(&con->page_retirement_dwork);
-
 		con->gpu_reset_flags |= reset;
 		amdgpu_ras_reset_gpu(adev);
 
@@ -3174,6 +3176,7 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev)
 	mutex_init(&con->recovery_lock);
 	INIT_WORK(&con->recovery_work, amdgpu_ras_do_recovery);
 	atomic_set(&con->in_recovery, 0);
+	atomic_set(&con->rma_in_recovery, 0);
 	con->eeprom_control.bad_channel_bitmap = 0;
 
 	max_eeprom_records_count = amdgpu_ras_eeprom_max_record_count(&con->eeprom_control);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
index 669720a9c60af..7e7521fedafc7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
@@ -510,6 +510,7 @@ struct amdgpu_ras {
 	/* gpu recovery */
 	struct work_struct recovery_work;
 	atomic_t in_recovery;
+	atomic_t rma_in_recovery;
 	struct amdgpu_device *adev;
 	/* error handler data */
 	struct ras_err_handler_data *eh_data;
-- 
2.51.0



