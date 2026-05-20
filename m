Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A984E35DA78;
	Wed, 20 May 2026 17:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298179; cv=none; b=D4h7Eb6oahKypj3+apb2Rb4V59UIGfBJ9wbtar9FgfqodRwTxGapBix5bwU96lzByQBdfWQlD6NryqR3C4363V3sGlr29OqaOr+Fd5+mMUibCZMsBGUatjS3DYp3WLvx6wqqQDyXioyDwoThZ4PXJb3W23cO4mnejlOB5/TZ7qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298179; c=relaxed/simple;
	bh=UMh4O8ErTUR2G9UA1VC8zTEhk1n13tLiGou+0TnIx1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U+2aGFOgCeuZozCr2+lEIYbMPZSBTcDkrJuHEdRdx/NdYEVgevnZuknCaK7YXWNTY4i6nV3bVuxwrYfETegfUb6sTr2W1KhyX3FMBurth2017eTWazAQY5ce+uFkIv5010TcvVVBJoJYi2RXqa5RnTqBR5oQ83edPNAevc91Pzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5Sahxfa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5Sahxfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92AB1F000E9;
	Wed, 20 May 2026 17:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298178;
	bh=kxQ4gGsC1qpRu8XnCo2J+eQ5yXn6oFkYV4/zHwx8MMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5SahxfalY2g2ZNAgkTi1GTAnsKJZVOnUziBOODtS7ecZ5ibUUUhBQSOJ9wavxSGY
	 O5U9YNk6heB8GkPtjSY0KYNT5/iyGPhGPpaVIVL3sjp1bBw1TvAxCHHURYUfTncu+L
	 pqUHHCbVYC9ujuq8DxMNOFTYtY4/qP7jf3naz36A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 260/957] drm/amd/pm/ci: Use highest MCLK on CI when MCLK DPM is disabled
Date: Wed, 20 May 2026 18:12:23 +0200
Message-ID: <20260520162140.183593262@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 894f0d34d66cb47fe718fe2ae5c18729d22c5218 ]

When MCLK DPM is disabled for any reason, populate the MCLK
table with the highest MCLK DPM level, so that the ASIC can
use the highest possible memory clock to get good performance
even when MCLK DPM is disabled.

Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
index 0cb7eaaba3844..71b1dad34926e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1322,6 +1322,14 @@ static int ci_populate_all_memory_levels(struct pp_hwmgr *hwmgr)
 			return result;
 	}
 
+	if (data->mclk_dpm_key_disabled && dpm_table->mclk_table.count) {
+		/* Populate the table with the highest MCLK level when MCLK DPM is disabled */
+		for (i = 0; i < dpm_table->mclk_table.count - 1; i++) {
+			levels[i] = levels[dpm_table->mclk_table.count - 1];
+			levels[i].DisplayWatermark = PPSMC_DISPLAY_WATERMARK_HIGH;
+		}
+	}
+
 	smu_data->smc_state_table.MemoryLevel[0].EnabledForActivity = 1;
 
 	dev_id = adev->pdev->device;
-- 
2.53.0



