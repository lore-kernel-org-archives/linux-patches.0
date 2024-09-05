Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E706F194AD6;
	Thu,  5 Sep 2024 09:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529578; cv=none; b=eDGJMdmWUrSHnNFx7C8pI4OfG6zLfwGoVu9//ZKfVkcRKsFtmDr4lOTzcdJjyJ7w59gT0/mthhhnRPbnmUz3wvLivfFFsVBlqjsZ7cb7W1DTEnknUhcWzMbSsKAn5g2kgNaJ1tkT0awASd/PaHxMRLKQeCq1EjEkTRCy4wIEGr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529578; c=relaxed/simple;
	bh=H0nCJj1mhfoJxe9fn1x0yC+AUuoHpmnObrYe7scXo98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8EqAQLKqoOMO8DRoQytIP2obU05xIkVJT//FnoTQM4J/QA9hyPEkdivHsMKpSuY6CzM0f23qrPSz/PJIcg6a2ScYZ3IO3KjjQq86pmXKO3me35QQ/DGwlbVRMG2z/ZRT/kwMJs4Xwgyepa0qEDefgxQzZa2BJevWbX3XjtMO+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOQHeQmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOQHeQmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC1DC4CEC3;
	Thu,  5 Sep 2024 09:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529577;
	bh=H0nCJj1mhfoJxe9fn1x0yC+AUuoHpmnObrYe7scXo98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOQHeQmvo57yOnlbgAp2T3YPnZ3+fUYp33GtR4c2e/aqxzM+z4D1C3THMAJnD+Ysn
	 EmJY0GIn+ZaZAVKvSg4aIq28/LB9zM4EN1MEmBQkIpqNsJStuJJJ3X9CpVURyLUEOB
	 UW/DXJIm7E24Lcq/TdflzD/fvy1oLSelg+wxL09k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 077/184] drm/amd/display: Fix writeback job lock evasion within dm_crtc_high_irq
Date: Thu,  5 Sep 2024 11:39:50 +0200
Message-ID: <20240905093735.248319849@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 922c2877827dcc474f3079e464773ab31ac13b79 ]

[Why]
Coverity report LOCK_EVASION warning. Access
acrtc->wb_pending without lock wb_conn->job_lock.

[How]
Lock wb_conn->job_lock before accessing
acrtc->wb_pending.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e3662f646baa..382a41c5b515 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -594,12 +594,14 @@ static void dm_crtc_high_irq(void *interrupt_params)
 	if (!acrtc)
 		return;
 
-	if (acrtc->wb_pending) {
-		if (acrtc->wb_conn) {
-			spin_lock_irqsave(&acrtc->wb_conn->job_lock, flags);
+	if (acrtc->wb_conn) {
+		spin_lock_irqsave(&acrtc->wb_conn->job_lock, flags);
+
+		if (acrtc->wb_pending) {
 			job = list_first_entry_or_null(&acrtc->wb_conn->job_queue,
 						       struct drm_writeback_job,
 						       list_entry);
+			acrtc->wb_pending = false;
 			spin_unlock_irqrestore(&acrtc->wb_conn->job_lock, flags);
 
 			if (job) {
@@ -617,8 +619,7 @@ static void dm_crtc_high_irq(void *interrupt_params)
 							       acrtc->dm_irq_params.stream, 0);
 			}
 		} else
-			DRM_ERROR("%s: no amdgpu_crtc wb_conn\n", __func__);
-		acrtc->wb_pending = false;
+			spin_unlock_irqrestore(&acrtc->wb_conn->job_lock, flags);
 	}
 
 	vrr_active = amdgpu_dm_crtc_vrr_active_irq(acrtc);
-- 
2.43.0



