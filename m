Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F82F1E00AB;
	Wed,  6 Nov 2024 12:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896590; cv=none; b=Gx2sQ3QPkOGIV/+fyI30xWqTlb7fKwduItlkpmSQHQqrBJ2YoH99rNcfExCWtKLy9M7vLj0KGNgwCkXuC59+CRtayzCRYptytM7oZxmZonEz+7UDJ8TTPwg9J566xpgX3vXeuTQ5oA0zPnm8XoylGsltwuRNtiuXwoS88k0l3Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896590; c=relaxed/simple;
	bh=WcgMKb7L5Z3qM29AXJG+xqYA/GjYaJTxQ5kc611Waww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9PHswyyT6GqYpY3XDk+98Ys0RTuyKk19A+Ogxm/kmMkj1pDI3wtsHHjVvxYKu92WOjbQimDDCYy4htcybfE75dM+lyxmWOPip+E0vSLaZjLlE040vFomaGZmGYSyqLZ+y8lhQi7Ku7IQ3v3b/rrC5da+B+Dlb3WXdmbA6Iuo88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PivI/VwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PivI/VwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74172C4CED4;
	Wed,  6 Nov 2024 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896588;
	bh=WcgMKb7L5Z3qM29AXJG+xqYA/GjYaJTxQ5kc611Waww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PivI/VwOSLhYKsj9xtKggdeH5cHrjLeoUwzxXqu9v4fb/4qYBejdLHUx4Dy7sg75u
	 awCFONCdsJGa5rfSO4Y6gYRQdYFoh4Qc0RAbcW6kBJ6JXNdQhYBKgtCSXhSe54JVd/
	 RD/FkFa99tFnx6Qm+Zl2KF3T2coovK2bEKM7Aj9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 243/245] drm/amdgpu/swsmu: default to fullscreen 3D profile for dGPUs
Date: Wed,  6 Nov 2024 13:04:56 +0100
Message-ID: <20241106120325.253208271@linuxfoundation.org>
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

commit ec1aab7816b06c32f42935e34ce3a3040c778afb upstream.

This uses more aggressive hueristics than the the bootup default
profile.  On windows the OS has a special fullscreen 3D mode
where this is used.  Since we don't have the equivalent on Linux
default to this profile for dGPUs.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3618
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1500
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3131
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 336568de918e08c825b3b1cbe2ec809f2fc26d94)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1264,7 +1264,11 @@ static int smu_sw_init(void *handle)
 	smu->workload_prority[PP_SMC_POWER_PROFILE_VR] = 4;
 	smu->workload_prority[PP_SMC_POWER_PROFILE_COMPUTE] = 5;
 	smu->workload_prority[PP_SMC_POWER_PROFILE_CUSTOM] = 6;
-	smu->workload_mask = 1 << smu->workload_prority[PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT];
+
+	if (smu->is_apu)
+		smu->workload_mask = 1 << smu->workload_prority[PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT];
+	else
+		smu->workload_mask = 1 << smu->workload_prority[PP_SMC_POWER_PROFILE_FULLSCREEN3D];
 
 	smu->workload_setting[0] = PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT;
 	smu->workload_setting[1] = PP_SMC_POWER_PROFILE_FULLSCREEN3D;


