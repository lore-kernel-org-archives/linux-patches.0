Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03D028E5F8;
	Wed, 23 Apr 2025 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420796; cv=none; b=Myni+BZYFTuaX2DrablCzD9BrvalHfpB+G+Oq5nOmDJ1VsqiTS+Mzv49bqt1G7YEyMdz3fuUXoCFYUhmEX3kWNlz6m54QJO7y0PQAzQlomX47V1qru8Svpn2QpIhEgzOYup+5fEpSfdxRwelo2iLtrXn3W34pZgh79CPxvF7stQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420796; c=relaxed/simple;
	bh=Hns5VpGqDtrqEEnJLJF+5JlqFpyB6S9mpjV7qYXXFVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf+kHRF9nEwmpvfO+AifhbXAR5N2ini+46SuraKsfKEd/cE6/8gbYEq49gDk4l/XffeA/6Njrg1szyo9BCndIuFnP7RNfkmtrxuckXBM6pbZZDYlwiX1Zt0i2lz4QtXJnlWTr1ekLbG0KGNSdbaF3JpyEaY5Hm5u+JdmEAvK8E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdbM3tGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdbM3tGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6994BC4CEE2;
	Wed, 23 Apr 2025 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420795;
	bh=Hns5VpGqDtrqEEnJLJF+5JlqFpyB6S9mpjV7qYXXFVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdbM3tGOYTeVvJa2tKenPyx5ttxqfLGcqNPX826xcQR6DUZIXQkcPTDwAAsvLiLT0
	 mLIvbp8Tyn2Fk7U7eqlsZpHSJ3XtteZJJ49HobSI012hVuOYirsvin4zdaEsaWLruY
	 X0tPkc7c9MvP/NhJ+BKdzA2PdJNvsa6yJQ9r+/6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Shaoyun.liu" <Shaoyun.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 163/223] drm/amdgpu/mes12: optimize MES pipe FW version fetching
Date: Wed, 23 Apr 2025 16:43:55 +0200
Message-ID: <20250423142623.807785160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 34779e14461cf715238dec5fd43a1e11977ec115 upstream.

Don't fetch it again if we already have it.  It seems the
registers don't reliably have the value at resume in some
cases.

Fixes: 785f0f9fe742 ("drm/amdgpu: Add mes v12_0 ip block support (v4)")
Reviewed-by: Shaoyun.liu <Shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9e7b08d239c2f21e8f417854f81e5ff40edbebff)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -1225,17 +1225,20 @@ static int mes_v12_0_queue_init(struct a
 		mes_v12_0_queue_init_register(ring);
 	}
 
-	/* get MES scheduler/KIQ versions */
-	mutex_lock(&adev->srbm_mutex);
-	soc21_grbm_select(adev, 3, pipe, 0, 0);
+	if (((pipe == AMDGPU_MES_SCHED_PIPE) && !adev->mes.sched_version) ||
+	    ((pipe == AMDGPU_MES_KIQ_PIPE) && !adev->mes.kiq_version)) {
+		/* get MES scheduler/KIQ versions */
+		mutex_lock(&adev->srbm_mutex);
+		soc21_grbm_select(adev, 3, pipe, 0, 0);
 
-	if (pipe == AMDGPU_MES_SCHED_PIPE)
-		adev->mes.sched_version = RREG32_SOC15(GC, 0, regCP_MES_GP3_LO);
-	else if (pipe == AMDGPU_MES_KIQ_PIPE && adev->enable_mes_kiq)
-		adev->mes.kiq_version = RREG32_SOC15(GC, 0, regCP_MES_GP3_LO);
+		if (pipe == AMDGPU_MES_SCHED_PIPE)
+			adev->mes.sched_version = RREG32_SOC15(GC, 0, regCP_MES_GP3_LO);
+		else if (pipe == AMDGPU_MES_KIQ_PIPE && adev->enable_mes_kiq)
+			adev->mes.kiq_version = RREG32_SOC15(GC, 0, regCP_MES_GP3_LO);
 
-	soc21_grbm_select(adev, 0, 0, 0, 0);
-	mutex_unlock(&adev->srbm_mutex);
+		soc21_grbm_select(adev, 0, 0, 0, 0);
+		mutex_unlock(&adev->srbm_mutex);
+	}
 
 	return 0;
 }


