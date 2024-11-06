Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0735A1DFE34;
	Wed,  6 Nov 2024 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896586; cv=none; b=c0xAVuGcUl+e3UJUHAkyEkzCEoITTiytgx1q06EsV79MszA9jdnVLpu4n8w3jvg1vqL3QxRGpfnWcARzg6BVpYpk1PhQeblOVH+7fUrWR4VXgeM57XwXzP5fhjgz/9h6ECqIV3L+CPNw41Y1vd/P+pu1MtpK5wJ66md1kinwDAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896586; c=relaxed/simple;
	bh=Sy8DeK9o28pwcnXB3fPbe1H9HLaL4BnB7kvTo7YavFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDLJP3HkRQR5l84wlH2MLEM3v/6KjWt3+DUjJ6XqQOZ/vF4MFMl9ac+BHp27ny9rS7VYg4OvNMKw8r769kHvQwSNSM6DERHYBH3AUKxoTAUh9ro/rx+FN86rT8XwgcW0eun+Nq9UZUDe7he81nXKjh2RUsZ4BoppP6XaJGPTkNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O81u2m2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O81u2m2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FD7C4CED3;
	Wed,  6 Nov 2024 12:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896585;
	bh=Sy8DeK9o28pwcnXB3fPbe1H9HLaL4BnB7kvTo7YavFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O81u2m2Zt8DFUUrJu8QEJQfblz3Jh0oP9gJPJs/3py9rzZm94M7YQv8agJWbk4yiK
	 ezy4FlnUdiDwexiuU4Lkq3N9wg0/UwecxpEfynLyLewAsibKLYJt0ieEOxu982rMO9
	 M+vMR1E+HKyjNM0jetAEeLrFUt5PTILsyk1lllG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 242/245] drm/amdgpu/swsmu: fix ordering for setting workload_mask
Date: Wed,  6 Nov 2024 13:04:55 +0100
Message-ID: <20241106120325.228469649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit b932d5ad9257f262a0bfd1bd7146120b0adc11a7 upstream.

No change in functionality for the current code, but we
need to set the index properly before changing it if we
ever use a non-0 index.

Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1257,7 +1257,6 @@ static int smu_sw_init(void *handle)
 	atomic_set(&smu->smu_power.power_gate.vpe_gated, 1);
 	atomic_set(&smu->smu_power.power_gate.umsch_mm_gated, 1);
 
-	smu->workload_mask = 1 << smu->workload_prority[PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT];
 	smu->workload_prority[PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT] = 0;
 	smu->workload_prority[PP_SMC_POWER_PROFILE_FULLSCREEN3D] = 1;
 	smu->workload_prority[PP_SMC_POWER_PROFILE_POWERSAVING] = 2;
@@ -1265,6 +1264,7 @@ static int smu_sw_init(void *handle)
 	smu->workload_prority[PP_SMC_POWER_PROFILE_VR] = 4;
 	smu->workload_prority[PP_SMC_POWER_PROFILE_COMPUTE] = 5;
 	smu->workload_prority[PP_SMC_POWER_PROFILE_CUSTOM] = 6;
+	smu->workload_mask = 1 << smu->workload_prority[PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT];
 
 	smu->workload_setting[0] = PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT;
 	smu->workload_setting[1] = PP_SMC_POWER_PROFILE_FULLSCREEN3D;


