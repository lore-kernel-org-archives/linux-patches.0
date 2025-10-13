Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EABC3164B4;
	Mon, 13 Oct 2025 15:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370364; cv=none; b=euZ2CqsL15E74/AJowZirCK4rHoty7X85uku3CXLAR/8WoYYlhHiWhdghSKH94oSSv3bTOZO0k2OGugwPIR8FpAkEGrdVqZbdEBgCEt24W8gQZdF1OX2tOu2gD0fqwj8DxpTd32YrD1EW0BrDXFXLIqItEJv3Li+AoQ9i8j91og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370364; c=relaxed/simple;
	bh=Ls+47A2BT7JPes9El0pM/kxxmq2hIkPM/bYBbZGT050=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKoRFUzi0W1VWbkqAC6Y5BmeD1FbovOx4GQ7shqbZkWAWf82if2xkwYUwIledbc1q7OdLFQCfrtb9xlYbw7/sPG87wQ93p+e3LHiRV/DFUPtG8d6zZLtd0uvh/+tLKG0tLiverbVUuVj7gbLaaNqvEl5L1VroU1416VW6DltPtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBmg3Zq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBmg3Zq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C13AC4CEE7;
	Mon, 13 Oct 2025 15:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370363;
	bh=Ls+47A2BT7JPes9El0pM/kxxmq2hIkPM/bYBbZGT050=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBmg3Zq0ai+rMm9r0cXhtmlmvcYyjkWBx2K2hApcm6prS9msInm/cEuY21XkZ+bi8
	 ISoQY4oUWpxP3CcP/WsPbt/5Xt6lkMNZvOKrYLE6VpWm8d2afAx1bxz3YwGHtaKA+I
	 bt6J+cmkJEOD/WnJo+Y1jHBYDIqm9QWgv1DXHGUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 563/563] drm/amdgpu/vcn: Fix double-free of vcn dump buffer
Date: Mon, 13 Oct 2025 16:47:04 +0200
Message-ID: <20251013144431.699634481@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 1a0e57eb96c3fca338665ffd7d9b59f351e5fea7 upstream.

The buffer is already freed as part of amdgpu_vcn_reg_dump_fini(). The
issue is introduced by below patch series.

Fixes: de55cbff5ce9 ("drm/amdgpu/vcn: Add regdump helper functions")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |    1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c   |    1 -
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c |    2 --
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c |    2 --
 4 files changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -1573,6 +1573,7 @@ int amdgpu_vcn_reg_dump_init(struct amdg
 static void amdgpu_vcn_reg_dump_fini(struct amdgpu_device *adev)
 {
 	kfree(adev->vcn.ip_dump);
+	adev->vcn.ip_dump = NULL;
 	adev->vcn.reg_list = NULL;
 	adev->vcn.reg_count = 0;
 }
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -361,7 +361,6 @@ static int vcn_v3_0_sw_fini(struct amdgp
 			return r;
 	}
 
-	kfree(adev->vcn.ip_dump);
 	return 0;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -287,8 +287,6 @@ static int vcn_v4_0_3_sw_fini(struct amd
 			return r;
 	}
 
-	kfree(adev->vcn.ip_dump);
-
 	return 0;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -284,8 +284,6 @@ static int vcn_v4_0_5_sw_fini(struct amd
 			return r;
 	}
 
-	kfree(adev->vcn.ip_dump);
-
 	return 0;
 }
 


