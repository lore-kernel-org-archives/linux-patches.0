Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0F418FDBD;
	Tue, 10 Sep 2024 10:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964803; cv=none; b=sY6BuUfwFrHRcyBAKq4TcRL1UDTncjXCDIIFLUXr5Qqmfr+h0LL1nEvqU0EmVqQGC4Jer7xoRBIQdQIMsgbU70+i9qM0uYbGquzl+ri29eqIRrccFwb5ZbxfYTS15YEjYoWcDHLnVYIJ0YjeP9QiOqqbewCO+oZ1hCkNy5JImKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964803; c=relaxed/simple;
	bh=QHg7T3ddPDj3LL/8COs4C1xFoNQ9ofGK/RHSNlnMh0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cpBfQsLZoX4uX15/Io0ilnTgPpjlc7TfKN2zSA7W1GKEOyYlN1swieFcfgk5fra5xTV437PLQvWYvWbSDqaLwx9ryPxJF9KLsD9zdTnfWkTX9A0Hupp1mGfs63DbL8cF4isLxMoI5cqifGfdSXnjXD0p2sft3nt/o3Bn9a21DBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sar9KE2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sar9KE2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091C8C4CEC6;
	Tue, 10 Sep 2024 10:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964803;
	bh=QHg7T3ddPDj3LL/8COs4C1xFoNQ9ofGK/RHSNlnMh0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sar9KE2iIIp+y9O6hxPb1ElkN1NXGXbkpnj3ydrUKR3neuLZGKbOFPCh4/u+knNer
	 LPiwpkxD2ZbeLoTB2NxawzNEN3WLhd+Qdk3sUgKyRNwU15myfvK5dcJVDStCKe1dLw
	 p4q6iOFT30PYjGH9yAMgtd6iZ1ZBKbwNr2psukiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/186] drm/amd/pm: fix uninitialized variable warning for smu8_hwmgr
Date: Tue, 10 Sep 2024 11:31:44 +0200
Message-ID: <20240910092555.045097338@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 86df36b934640866eb249a4488abb148b985a0d9 ]

Clear warnings that using uninitialized value level when fails
to get the value from SMU.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c   | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
index 35d0ff57a596..e85a90b989b5 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
@@ -584,6 +584,7 @@ static int smu8_init_uvd_limit(struct pp_hwmgr *hwmgr)
 				hwmgr->dyn_state.uvd_clock_voltage_dependency_table;
 	unsigned long clock = 0;
 	uint32_t level;
+	int ret;
 
 	if (NULL == table || table->count <= 0)
 		return -EINVAL;
@@ -591,7 +592,9 @@ static int smu8_init_uvd_limit(struct pp_hwmgr *hwmgr)
 	data->uvd_dpm.soft_min_clk = 0;
 	data->uvd_dpm.hard_min_clk = 0;
 
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxUvdLevel, &level);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxUvdLevel, &level);
+	if (ret)
+		return ret;
 
 	if (level < table->count)
 		clock = table->entries[level].vclk;
@@ -611,6 +614,7 @@ static int smu8_init_vce_limit(struct pp_hwmgr *hwmgr)
 				hwmgr->dyn_state.vce_clock_voltage_dependency_table;
 	unsigned long clock = 0;
 	uint32_t level;
+	int ret;
 
 	if (NULL == table || table->count <= 0)
 		return -EINVAL;
@@ -618,7 +622,9 @@ static int smu8_init_vce_limit(struct pp_hwmgr *hwmgr)
 	data->vce_dpm.soft_min_clk = 0;
 	data->vce_dpm.hard_min_clk = 0;
 
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxEclkLevel, &level);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxEclkLevel, &level);
+	if (ret)
+		return ret;
 
 	if (level < table->count)
 		clock = table->entries[level].ecclk;
@@ -638,6 +644,7 @@ static int smu8_init_acp_limit(struct pp_hwmgr *hwmgr)
 				hwmgr->dyn_state.acp_clock_voltage_dependency_table;
 	unsigned long clock = 0;
 	uint32_t level;
+	int ret;
 
 	if (NULL == table || table->count <= 0)
 		return -EINVAL;
@@ -645,7 +652,9 @@ static int smu8_init_acp_limit(struct pp_hwmgr *hwmgr)
 	data->acp_dpm.soft_min_clk = 0;
 	data->acp_dpm.hard_min_clk = 0;
 
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxAclkLevel, &level);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxAclkLevel, &level);
+	if (ret)
+		return ret;
 
 	if (level < table->count)
 		clock = table->entries[level].acpclk;
-- 
2.43.0



