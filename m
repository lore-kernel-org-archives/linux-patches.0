Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED5A281507;
	Wed, 23 Apr 2025 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420163; cv=none; b=L/DFAJzQJZQn/gXS4VeHEaJDbLZJ8d71odDKdOwjgt2ktj8iWTr4+Z8w1EM3O5Qx6InwsCOLZcdAm6rUAutPav2MNH3L64nV8YSg3JmyBFlCmJZtYzHE5hZFACzoZt4XmVCRilb+w3GvWAlUWaDEaavH147t+Qitedw9qJBMsIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420163; c=relaxed/simple;
	bh=xF94jkyPCtgIAwrcMxAVt0+x/eUjMiVhRtYg7kw+7eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwZIxKmAFdu7E0qk8kbmk+N+7YpSW1GefbOhsZy+jbkkC7y72AhPD8POLKBq3C8RZyng6qMmUDO51yfvX76mG2Ny2KA4zlR5QN0pXX5Q4RSTNjFd6xNcN8He9S0n07hoXsX4ARiIWZkTKYV7/GHDLwBnPvK+emIqDiJ9J1VKA3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giAurJaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giAurJaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC82C4CEE3;
	Wed, 23 Apr 2025 14:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420163;
	bh=xF94jkyPCtgIAwrcMxAVt0+x/eUjMiVhRtYg7kw+7eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giAurJaJB96c4MOqNp9nGraMGDJSGrwRbrXRLWkx8/mVCW/FdzPCej3bHltQ/yzOh
	 pjECZoOFKmf93icOx6Y1DPMmGBMpwOEZe1Jp0CHeruU9VcZFQt/dCjzHlMsTOcegu4
	 fTdDtUTc7b+aqHKwBEwosEy0tWqKk+Dt4FmoXWEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/223] drm/msm/a6xx+: Dont let IB_SIZE overflow
Date: Wed, 23 Apr 2025 16:42:57 +0200
Message-ID: <20250423142621.388448836@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 9d78f02503227d3554d26cf8ca73276105c98f3e ]

IB_SIZE is only b0..b19.  Starting with a6xx gen3, additional fields
were added above the IB_SIZE.  Accidentially setting them can cause
badness.  Fix this by properly defining the CP_INDIRECT_BUFFER packet
and using the generated builder macro to ensure unintended bits are not
set.

v2: add missing type attribute for IB_BASE
v3: fix offset attribute in xml

Reported-by: Connor Abbott <cwabbott0@gmail.com>
Fixes: a83366ef19ea ("drm/msm/a6xx: add A640/A650 to gpulist")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/643396/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c               | 8 ++++----
 drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml | 7 +++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 702b8d4b34972..d903ad9c0b5fb 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -233,10 +233,10 @@ static void a6xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 				break;
 			fallthrough;
 		case MSM_SUBMIT_CMD_BUF:
-			OUT_PKT7(ring, CP_INDIRECT_BUFFER_PFE, 3);
+			OUT_PKT7(ring, CP_INDIRECT_BUFFER, 3);
 			OUT_RING(ring, lower_32_bits(submit->cmd[i].iova));
 			OUT_RING(ring, upper_32_bits(submit->cmd[i].iova));
-			OUT_RING(ring, submit->cmd[i].size);
+			OUT_RING(ring, A5XX_CP_INDIRECT_BUFFER_2_IB_SIZE(submit->cmd[i].size));
 			ibs++;
 			break;
 		}
@@ -319,10 +319,10 @@ static void a7xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 				break;
 			fallthrough;
 		case MSM_SUBMIT_CMD_BUF:
-			OUT_PKT7(ring, CP_INDIRECT_BUFFER_PFE, 3);
+			OUT_PKT7(ring, CP_INDIRECT_BUFFER, 3);
 			OUT_RING(ring, lower_32_bits(submit->cmd[i].iova));
 			OUT_RING(ring, upper_32_bits(submit->cmd[i].iova));
-			OUT_RING(ring, submit->cmd[i].size);
+			OUT_RING(ring, A5XX_CP_INDIRECT_BUFFER_2_IB_SIZE(submit->cmd[i].size));
 			ibs++;
 			break;
 		}
diff --git a/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml b/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml
index cab01af55d222..c6cdc5c003dc0 100644
--- a/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml
+++ b/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml
@@ -2264,5 +2264,12 @@ opcode: CP_LOAD_STATE4 (30) (4 dwords)
 	</reg32>
 </domain>
 
+<domain name="CP_INDIRECT_BUFFER" width="32" varset="chip" prefix="chip" variants="A5XX-">
+	<reg64 offset="0" name="IB_BASE" type="address"/>
+	<reg32 offset="2" name="2">
+		<bitfield name="IB_SIZE" low="0" high="19"/>
+	</reg32>
+</domain>
+
 </database>
 
-- 
2.39.5



