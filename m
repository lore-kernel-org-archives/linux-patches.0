Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8CE1DF992;
	Wed,  6 Nov 2024 12:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896565; cv=none; b=MTjkqBmYNoo7FSLhpuApqaP02Ssc25bQK/EpKkme4D3iaJU7VkF3HQHNRmiRHLyq6sl3/8QGOcpZ5T+YgGfD6nSF5oQ58dRj8BgVCJeNGvxVOmY7xhK+VZYLkC56oAzfahl0Nmh+Y4lnzImkIR0N0ivL3tyMdAiNGJBrbhNUT68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896565; c=relaxed/simple;
	bh=ZIcg5deJz95cjLrw/Jm6ksG/YxH/gyBWioMDyyNGIjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iq9oSZv43ZqNAV7/vS77sUlX0OMbHFDLbEVleQUK9vfnK+HmUGWWDsuFNcaZEIQ9c9PpJZ13lPA2LoG6Dlhp943mjKsLJDVg+y1ioj2XmzyCjmun3GV1WGvAdFAdWIjAhbRLV22cozKpH4hYpuErZoFiHT4zldUAZW0XHKsTZ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gz9DOFnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gz9DOFnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AC8C4CECD;
	Wed,  6 Nov 2024 12:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896565;
	bh=ZIcg5deJz95cjLrw/Jm6ksG/YxH/gyBWioMDyyNGIjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gz9DOFnx2AvJfmGlfvnlLjnho0TOQa+jRkEl1T+rr5eLCgZ+Tr5lINJHXBLzZ4Z+g
	 TIklMHgOTmalo7Sti4VC3jtJnaxC7aTmAd7aih/XNDgnUxo1ZPkvIlEdft3TlCCalw
	 1GG7GumhNkCt+cFK2v3oDvvZATRFakrc0cVNXGeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>
Subject: [PATCH 6.11 245/245] drm/amdgpu: handle default profile on on devices without fullscreen 3D
Date: Wed,  6 Nov 2024 13:04:58 +0100
Message-ID: <20241106120325.302774561@linuxfoundation.org>
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

commit 7c210ca5a2d72868e5a052fc533d5dcb7e070f89 upstream.

Some devices do not support fullscreen 3D.

v2: Make the check generic.

Fixes: ec1aab7816b0 ("drm/amdgpu/swsmu: default to fullscreen 3D profile for dGPUs")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Kenneth Feng <kenneth.feng@amd.com>
Cc: Lijo Lazar <lijo.lazar@amd.com>
(cherry picked from commit 1cdd67510e54e3832f14a885dbf5858584558650)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1234,6 +1234,14 @@ static void smu_init_xgmi_plpd_mode(stru
 	}
 }
 
+static bool smu_is_workload_profile_available(struct smu_context *smu,
+					      u32 profile)
+{
+	if (profile >= PP_SMC_POWER_PROFILE_COUNT)
+		return false;
+	return smu->workload_map && smu->workload_map[profile].valid_mapping;
+}
+
 static int smu_sw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1265,7 +1273,8 @@ static int smu_sw_init(void *handle)
 	smu->workload_prority[PP_SMC_POWER_PROFILE_COMPUTE] = 5;
 	smu->workload_prority[PP_SMC_POWER_PROFILE_CUSTOM] = 6;
 
-	if (smu->is_apu)
+	if (smu->is_apu ||
+	    !smu_is_workload_profile_available(smu, PP_SMC_POWER_PROFILE_FULLSCREEN3D))
 		smu->workload_mask = 1 << smu->workload_prority[PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT];
 	else
 		smu->workload_mask = 1 << smu->workload_prority[PP_SMC_POWER_PROFILE_FULLSCREEN3D];


