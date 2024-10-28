Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A4F2AF07;
	Mon, 28 Oct 2024 06:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098137; cv=none; b=U0ySeU7VeTWz7uJL0+L4mCi4qx68Bu0MyAKFRwWlCteuJbwvSjHITQCsNB1zqcL2a8B8Wtw2zLgh0G55wxgNnUSiUyopQ6KRaIW+KkyKwI/LOyBLbtMm48W/JFJrbWE4/StmhTeCuhzg2clQ3cfIk4Ec7uKEavfg6Cc/NTiEN+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098137; c=relaxed/simple;
	bh=VBt4vOdYlac0fRxnQ5pxYl0nwyjj2aC9mwZznMyn5Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kamv71ISMIhJesO9uSbJcvA0YWf74TB7VbvTuk+wQuIEhSc+SCSshQ/m+v6/SnnXVj2Lk4/X7Y+mK61NfzdU1Q/hAbGWvIuzqQ0MdYyNjFI+G7jxwLTGvNtR/YH4AI/cUZ1n1A9booNH3sbzMoMcrXMuGhvNgS5+i7e3IZHAzgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkTfrvKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkTfrvKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DF5C4CEC3;
	Mon, 28 Oct 2024 06:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098137;
	bh=VBt4vOdYlac0fRxnQ5pxYl0nwyjj2aC9mwZznMyn5Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkTfrvKeXwNwSATDJreZGFenLMmdzqNfIQYYy0IpE5NMU284KsRamlKnw9soqX4Sn
	 QGWGSN2GP6+H/6alOph5ZD4LoRK9YXh8oPREkzOiZbFexAQmKFT0Uxcu8olrQT46e+
	 zBqa6GYEMtXYE29Ftenl4Ozr5T70RL+gx4/fI9q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 092/261] drm/xe: Dont free job in TDR
Date: Mon, 28 Oct 2024 07:23:54 +0100
Message-ID: <20241028062314.336063380@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 82926f52d7a09c65d916c0ef8d4305fc95d68c0c ]

Freeing job in TDR is not safe as TDR can pass the run_job thread
resulting in UAF. It is only safe for free job to naturally be called by
the scheduler. Rather free job in TDR, add to pending list.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2811
Cc: Matthew Auld <matthew.auld@intel.com>
Fixes: e275d61c5f3f ("drm/xe/guc: Handle timing out of signaled jobs gracefully")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241003001657.3517883-3-matthew.brost@intel.com
(cherry picked from commit ea2f6a77d0c40d97f4a4dc93fee4afe15d94926d)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 690f821f8bf5a..dfd809e7bbd25 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1101,10 +1101,13 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 
 	/*
 	 * TDR has fired before free job worker. Common if exec queue
-	 * immediately closed after last fence signaled.
+	 * immediately closed after last fence signaled. Add back to pending
+	 * list so job can be freed and kick scheduler ensuring free job is not
+	 * lost.
 	 */
 	if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &job->fence->flags)) {
-		guc_exec_queue_free_job(drm_job);
+		xe_sched_add_pending_job(sched, job);
+		xe_sched_submission_start(sched);
 
 		return DRM_GPU_SCHED_STAT_NOMINAL;
 	}
-- 
2.43.0



