Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99B2361DD2;
	Tue, 16 Dec 2025 12:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887735; cv=none; b=k8tfmZiBLScKOh5xCzvz+W33KtFyHesgB4NqiEj3BaRBh6Z+weW9UPnn/0SbVLChh4p5nO4D8LEJojPQZbT7dz52bE3ogLKQaHu6UFNMoVcK0PKgyp5SGf/D+KvmX3TRpy0y2Pn6m3bxfU/oG3RqybPGzhpQ61/blH8To1n/ah4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887735; c=relaxed/simple;
	bh=A7kGOVvEK4I0vnBZuy09NUk76G6pQhiLNiIZ0e3O8bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tl2IaHSfKwgrfL9+u5nQgw1AdIslWWzjFbquDpwZScdqHf2F1pu/Se/FIVAYo3HvUJXEV1rixjYWbxBnwqjuqW4arNLeOMzl7g+jjTLb7qoYgagUoHMyDabXBHcSKiTIkwNOzxGI3ZcL0FV4j23E85rMGlobtI7tOnUnF1c3q0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/QdPQT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/QdPQT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A61C4CEF1;
	Tue, 16 Dec 2025 12:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887734;
	bh=A7kGOVvEK4I0vnBZuy09NUk76G6pQhiLNiIZ0e3O8bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/QdPQT+zLs6SqoaWSMVopZcA3tutcsbaupLsbMegd7YHLClPU+Xw6Vt71/uVBPws
	 qhsy8XJovPT7eINBu3AVBQUXDz5WgLVrGimJa3SzxBgjadIbxaI44MQqDcIiUE1H9l
	 GT7BdCn5qi8AFh78fixC4jhn/P7zV7NHM+P0pxvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 322/614] drm/msm/a6xx: Flush LRZ cache before PT switch
Date: Tue, 16 Dec 2025 12:11:29 +0100
Message-ID: <20251216111413.030712176@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit 180349b8407f3b268b2ceac0e590b8199e043081 ]

As per the recommendation, A7x and newer GPUs should flush the LRZ cache
before switching the pagetable. Update a6xx_set_pagetable() to do this.
While we are at it, sync both BV and BR before issuing  a
CP_RESET_CONTEXT_STATE command, to match the downstream sequence.

Fixes: af66706accdf ("drm/msm/a6xx: Add skeleton A7xx support")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/688995/
Message-ID: <20251118-kaana-gpu-support-v4-2-86eeb8e93fb6@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index b8f8ae940b55f..6f7ed07670b12 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -224,7 +224,7 @@ static void a6xx_set_pagetable(struct a6xx_gpu *a6xx_gpu,
 		OUT_RING(ring, submit->seqno - 1);
 
 		OUT_PKT7(ring, CP_THREAD_CONTROL, 1);
-		OUT_RING(ring, CP_SET_THREAD_BOTH);
+		OUT_RING(ring, CP_THREAD_CONTROL_0_SYNC_THREADS | CP_SET_THREAD_BOTH);
 
 		/* Reset state used to synchronize BR and BV */
 		OUT_PKT7(ring, CP_RESET_CONTEXT_STATE, 1);
@@ -235,7 +235,13 @@ static void a6xx_set_pagetable(struct a6xx_gpu *a6xx_gpu,
 			 CP_RESET_CONTEXT_STATE_0_RESET_GLOBAL_LOCAL_TS);
 
 		OUT_PKT7(ring, CP_THREAD_CONTROL, 1);
-		OUT_RING(ring, CP_SET_THREAD_BR);
+		OUT_RING(ring, CP_THREAD_CONTROL_0_SYNC_THREADS | CP_SET_THREAD_BOTH);
+
+		OUT_PKT7(ring, CP_EVENT_WRITE, 1);
+		OUT_RING(ring, LRZ_FLUSH);
+
+		OUT_PKT7(ring, CP_THREAD_CONTROL, 1);
+		OUT_RING(ring, CP_THREAD_CONTROL_0_SYNC_THREADS | CP_SET_THREAD_BR);
 	}
 
 	if (!sysprof) {
-- 
2.51.0



