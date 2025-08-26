Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6972BF3E2;
	Tue, 26 Aug 2025 11:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207629; cv=none; b=AwCN15JRS251vTQP6zW8JNoyS3oYSeqiaoKdd1drCR7eOoenebIwSMq/sKAhPZbuMdc4AlUYFAxBP+ZsOJkcRnRrfH4cRbYjCNYJk3Pi+BjjnV7Aly40vBAQjjTUFu3ERJM4lfoI3j5x98KSf0Ip31Kg1J6nKhq2P8MimwMDZ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207629; c=relaxed/simple;
	bh=GClQlMFMRexvYzso33zMNzOxQijUfrrILnac3gEnCEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKzmJUmU263+Ubf2uo9sUyGlsqicobxGDn/k9h01AcL18C6DeeL0q2sKrJPvFc93zsFDyfWX7QhB9PoBpaoWEg7xD66M95ANDP+fJw0BbHVgK9mysHzPmxX82PJSXOFpeB6G+kU/VFiuFtBEQ2jYiNg3LYFLAU+peSyTUHsFG1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cR0pkQ0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cR0pkQ0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EC2C4CEF1;
	Tue, 26 Aug 2025 11:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207629;
	bh=GClQlMFMRexvYzso33zMNzOxQijUfrrILnac3gEnCEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cR0pkQ0g0jFhTdcQR03csN604YI+7qGQZ7r3YdpkpfIuQTH8lMRpmMJvxejFp2+k5
	 w57h6cX9hMzKb6mGQkhzqbPVSdvFpnzSDAwCHb7AtXu09QUzyXI8/zF7IJAAPPc/U+
	 b1AOpqSyAa1XpXHVS5EqfnZq4HVauqtWLAe/B9ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 257/457] drm/amdgpu/swm14: Update power limit logic
Date: Tue, 26 Aug 2025 13:09:01 +0200
Message-ID: <20250826110943.707704849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 79e25cd06e85105c75701ef1773c6c64bb304091 upstream.

Take into account the limits from the vbios.  Ported
from the SMU13 code.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4352
Reviewed-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 203cc7f1dd86f2c8de5c3c6182f19adac7c9c206)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |   30 +++++++++++++++----
 1 file changed, 25 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -1689,9 +1689,11 @@ static int smu_v14_0_2_get_power_limit(s
 				       uint32_t *min_power_limit)
 {
 	struct smu_table_context *table_context = &smu->smu_table;
+	struct smu_14_0_2_powerplay_table *powerplay_table =
+		table_context->power_play_table;
 	PPTable_t *pptable = table_context->driver_pptable;
 	CustomSkuTable_t *skutable = &pptable->CustomSkuTable;
-	uint32_t power_limit;
+	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
 	uint32_t msg_limit = pptable->SkuTable.MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
 
 	if (smu_v14_0_get_current_power_limit(smu, &power_limit))
@@ -1704,11 +1706,29 @@ static int smu_v14_0_2_get_power_limit(s
 	if (default_power_limit)
 		*default_power_limit = power_limit;
 
-	if (max_power_limit)
-		*max_power_limit = msg_limit;
+	if (powerplay_table) {
+		if (smu->od_enabled &&
+		    smu_v14_0_2_is_od_feature_supported(smu, PP_OD_FEATURE_PPT_BIT)) {
+			od_percent_upper = pptable->SkuTable.OverDriveLimitsBasicMax.Ppt;
+			od_percent_lower = pptable->SkuTable.OverDriveLimitsBasicMin.Ppt;
+		} else if (smu_v14_0_2_is_od_feature_supported(smu, PP_OD_FEATURE_PPT_BIT)) {
+			od_percent_upper = 0;
+			od_percent_lower = pptable->SkuTable.OverDriveLimitsBasicMin.Ppt;
+		}
+	}
 
-	if (min_power_limit)
-		*min_power_limit = 0;
+	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
+					od_percent_upper, od_percent_lower, power_limit);
+
+	if (max_power_limit) {
+		*max_power_limit = msg_limit * (100 + od_percent_upper);
+		*max_power_limit /= 100;
+	}
+
+	if (min_power_limit) {
+		*min_power_limit = power_limit * (100 + od_percent_lower);
+		*min_power_limit /= 100;
+	}
 
 	return 0;
 }


