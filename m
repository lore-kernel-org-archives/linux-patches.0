Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597D43C2C
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BE2C433C8;
	Mon, 19 Jun 2023 10:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170936;
	bh=Qs4dw/siH8p0AYXvbUCCKyGHPJJ2VAgPmMoKxX/bilU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBhN0+xRQ+894bpSrO7Fv8u59MMwRvo6yRXAGPiT9XwXPad6tjQ7mjxs6GPMzC0hv
	 HM2AblijItBHZowg+ME5y/zU08dnfjHigSH9SKoahwjGblsxjbn73unMDZHDA/mPe1
	 4O6LgVu4SuFxaARpfm/VnSI/NmZ7rJnQ1hKswIlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 088/187] drm/amdgpu: Program gds backup address as zero if no gds allocated
Date: Mon, 19 Jun 2023 12:28:26 +0200
Message-ID: <20230619102201.870851420@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiadong Zhu <Jiadong.Zhu@amd.com>

commit 94034b306ddde4a4a9c1a597ae7f61f04b710dc7 upstream.

It is firmware requirement to set gds_backup_addrlo and gds_backup_addrhi
of DE meta both zero if no gds partition is allocated for the frame.

Signed-off-by: Jiadong Zhu <Jiadong.Zhu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.3.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -755,7 +755,7 @@ static void gfx_v9_0_set_rlc_funcs(struc
 static int gfx_v9_0_get_cu_info(struct amdgpu_device *adev,
 				struct amdgpu_cu_info *cu_info);
 static uint64_t gfx_v9_0_get_gpu_clock_counter(struct amdgpu_device *adev);
-static void gfx_v9_0_ring_emit_de_meta(struct amdgpu_ring *ring, bool resume);
+static void gfx_v9_0_ring_emit_de_meta(struct amdgpu_ring *ring, bool resume, bool usegds);
 static u64 gfx_v9_0_ring_get_rptr_compute(struct amdgpu_ring *ring);
 static void gfx_v9_0_query_ras_error_count(struct amdgpu_device *adev,
 					  void *ras_error_status);
@@ -5124,7 +5124,8 @@ static void gfx_v9_0_ring_emit_ib_gfx(st
 			gfx_v9_0_ring_emit_de_meta(ring,
 						   (!amdgpu_sriov_vf(ring->adev) &&
 						   flags & AMDGPU_IB_PREEMPTED) ?
-						   true : false);
+						   true : false,
+						   job->gds_size > 0 && job->gds_base != 0);
 	}
 
 	amdgpu_ring_write(ring, header);
@@ -5399,7 +5400,7 @@ static int gfx_v9_0_ring_preempt_ib(stru
 	return r;
 }
 
-static void gfx_v9_0_ring_emit_de_meta(struct amdgpu_ring *ring, bool resume)
+static void gfx_v9_0_ring_emit_de_meta(struct amdgpu_ring *ring, bool resume, bool usegds)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct v9_de_ib_state de_payload = {0};
@@ -5430,8 +5431,10 @@ static void gfx_v9_0_ring_emit_de_meta(s
 				 PAGE_SIZE);
 	}
 
-	de_payload.gds_backup_addrlo = lower_32_bits(gds_addr);
-	de_payload.gds_backup_addrhi = upper_32_bits(gds_addr);
+	if (usegds) {
+		de_payload.gds_backup_addrlo = lower_32_bits(gds_addr);
+		de_payload.gds_backup_addrhi = upper_32_bits(gds_addr);
+	}
 
 	cnt = (sizeof(de_payload) >> 2) + 4 - 2;
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, cnt));


