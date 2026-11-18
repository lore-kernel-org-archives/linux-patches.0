Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038835;
	b=gftd5VIvQo1gBTvF5ldh5bt9GBHX8CiziGWjQophfLredPu1oelcGaWP5s4k+0i3Q1Td
	 aQVWo6jQ1zWSiGbKGub+IUPr5/ixZC94juiExW9KCgn1Ti4gEQ9cBgisEOWjwKN9jq7B5
	 7duT5kCZoSHEV9vQtDWf15jKt5O/+4p1xYtTauBHsbR/4/0N1z+x8/Cnp8iF8KbDfUgYM
	 wznetgUeTmVfbV/paaEseq7mLm67KX5bEwgIxkH299Y6FayisRW3JMcnpKlN4w/nzsE4f
	 kcHzUavT8IrAMQP5k3zFjKre/GYKtilUjrHWcJSzZRa5y/1UaIhxVJNT04foj+D8gzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=163XBoJqGVAeUmo1Md3jaITOP73IvwMrvy0ng/ORlZU=;
	b=XdhS9HP45bK++/i9peuTdfWGPOJ4HiuzfdHcdYxx9CgFISuXZ8W6UILbxTtP6N1f1Poe
	 OM8ukbhnFOlGZ+L0VR2CB0F28fccf2mztyP8tqnomOH0Thsjbpi1RHZ2+JdWetI6KBF1a
	 Syx5bbHjWQA/LaoFQLBcUD3rL0hK0jfmVSn1wNzcBP+QR0V8m745NsqrQcdylT5NAwfic
	 iJzkdOjLERXYptseP+/Gqcs3q5C+oByc3DcTAEvRvo74U7cbPoTBpNGShfXbPrNrPDzS8
	 U9t9ADmeVbTAsRK2CRk68bFnPYMDmU7K2wQFA6vW+W3mXlc6U7RMlFUUfcRTx9ZyY0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQbLBaEY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED11606A31C;
	Wed, 18 Nov 2026 21:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQbLBaEY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1501F000C4;
	Wed, 18 Nov 2026 21:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038835;
	bh=163XBoJqGVAeUmo1Md3jaITOP73IvwMrvy0ng/ORlZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQbLBaEY+J5zcaAeOxwzybhol5BaG8iEfC3yAdColXUFd4A4HbUiWk0eEwQfVqaH0
	 5eF309bcUUYt+sXySLLGMbM0Bp3Vnrg2TbEWnWqH5dkyAgnbAQFgvCaqRKdVepIjWH
	 uxy4bMIqbzUgVYe918oVV3hJ4B1hqY+qSwNqd6Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1885/3318] drm/amdgpu: finish GPU recovery callbacks before restarting schedulers
Date: Wed, 18 Nov 2026 15:41:47 +0100
Message-ID: <20261118150418.543710454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 733389cb31e2c55e355410759fdc68afe74a4582 ]

Run GPU post-reset callbacks, including KFD and display-audio resume,
before restarting DRM scheduler workqueues. IP hardware initialization
already happens inside ASIC recovery; this change orders the remaining
callbacks before new scheduler submissions. Preserve the emergency-stop
and guity job completition path's callbacks without starting schedulers,

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1f6433e2b264e75c56ae95f187788806201bdbc3)
Cc: stable@vger.kernel.org
[ sashal: Adapted helper reordering to inline code in amdgpu_device_gpu_recover() because the upstream recovery helpers are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 47 +++++++++++-----------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 2cdbee6700ecd..41fac9d273622 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5511,7 +5511,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	}
 
 	if (need_emergency_restart)
-		goto skip_sched_resume;
+		goto post_resume;
 
 	/*
 	 * Must check guilty signal here since after this point all old
@@ -5522,7 +5522,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	if (job && dma_fence_is_signaled(&job->hw_fence.base)) {
 		job_signaled = true;
 		dev_info(adev->dev, "Guilty job already signaled, skipping HW reset");
-		goto skip_hw_reset;
+		goto post_resume;
 	}
 
 retry:	/* Rest of adevs pre asic reset from XGMI hive. */
@@ -5567,7 +5567,28 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 			goto recover_end;
 	}
 
-skip_hw_reset:
+post_resume:
+	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
+		/* unlock kfd: SRIOV would do it separately */
+		if (!need_emergency_restart && !amdgpu_sriov_vf(tmp_adev))
+			amdgpu_amdkfd_post_reset(tmp_adev);
+
+		/* kfd_post_reset will do nothing if kfd device is not initialized,
+		 * need to bring up kfd here if it's not be initialized before
+		 */
+		if (!adev->kfd.init_complete)
+			amdgpu_amdkfd_device_init(adev);
+
+		if (audio_suspended)
+			amdgpu_device_resume_display_audio(tmp_adev);
+
+		amdgpu_device_unset_mp1_state(tmp_adev);
+
+		amdgpu_ras_set_error_query_ready(tmp_adev, true);
+	}
+
+	if (need_emergency_restart)
+		goto recover_end;
 
 	/* Post ASIC reset for all devs .*/
 	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
@@ -5603,26 +5624,6 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 		}
 	}
 
-skip_sched_resume:
-	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
-		/* unlock kfd: SRIOV would do it separately */
-		if (!need_emergency_restart && !amdgpu_sriov_vf(tmp_adev))
-			amdgpu_amdkfd_post_reset(tmp_adev);
-
-		/* kfd_post_reset will do nothing if kfd device is not initialized,
-		 * need to bring up kfd here if it's not be initialized before
-		 */
-		if (!adev->kfd.init_complete)
-			amdgpu_amdkfd_device_init(adev);
-
-		if (audio_suspended)
-			amdgpu_device_resume_display_audio(tmp_adev);
-
-		amdgpu_device_unset_mp1_state(tmp_adev);
-
-		amdgpu_ras_set_error_query_ready(tmp_adev, true);
-	}
-
 recover_end:
 	tmp_adev = list_first_entry(device_list_handle, struct amdgpu_device,
 					    reset_list);
-- 
2.53.0



