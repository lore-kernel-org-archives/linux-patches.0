Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D777F22370A;
	Mon, 23 Jun 2025 22:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717323; cv=none; b=jXv5sRo1Bky+1c6Df8XhyeJH3Mt9aVGjR+lGIc1aKS9S1UM6o9vfDrjoRwuGk3oSz9v3tKQVCFSdCXAN4RqOXkxkRyDwekmXQ6u/zYhZcIVQ0qlyPMqJdda4CKL1/tXBP/alr33t98Tl+ZdtVQmQ/HIeNpFl6GDWi2sr+naeQTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717323; c=relaxed/simple;
	bh=/Ex0yPqQJS8OPxgH1GdT7ODWeAc9ahbslnLU6hddFoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIDt57GwwigDdMBQ7Xz9j+Cu6f93c3N/4ssszzVVIS7rDaevUDSNDrNzsrZuqONXPSlM5TyaOPH0WAjZo8RHTRBiq8tY4SfW+siquA5Rzp2DaIMbZk9Ci1LedG4Im+7CUWtWk94ee5GrklLowzlXcibuPU7/Ugs5zXNHlOu+kfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxUzSXFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxUzSXFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70981C4CEEA;
	Mon, 23 Jun 2025 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717323;
	bh=/Ex0yPqQJS8OPxgH1GdT7ODWeAc9ahbslnLU6hddFoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxUzSXFt/zEMIyWmbn+DRHnQpKGL8kZmanKcF2TiJl/fDWOz9r8P7qMqzbYkEmDyJ
	 kpVWFsK8bM6Nsy+OVKwRSwIG1YOfbFMPm4/A+RUuDYi5u9lnzwf84/oP8IfqVGgxq9
	 H2wLrMUihiNaeX/0utC3A0N6H8NBb14IoarwDrU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 356/414] drm/msm/a7xx: Call CP_RESET_CONTEXT_STATE
Date: Mon, 23 Jun 2025 15:08:13 +0200
Message-ID: <20250623130650.869993348@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Connor Abbott <cwabbott0@gmail.com>

[ Upstream commit 2b520c6104f34e3a548525173c38ebca4402cac3 ]

Calling this packet is necessary when we switch contexts because there
are various pieces of state used by userspace to synchronize between BR
and BV that are persistent across submits and we need to make sure that
they are in a "safe" state when switching contexts. Otherwise a
userspace submission in one context could cause another context to
function incorrectly and hang, effectively a denial of service (although
without leaking data). This was missed during initial a7xx bringup.

Fixes: af66706accdf ("drm/msm/a6xx: Add skeleton A7xx support")
Signed-off-by: Connor Abbott <cwabbott0@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/654924/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index d2189441aa38a..80c78aff96433 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -123,6 +123,20 @@ static void a6xx_set_pagetable(struct a6xx_gpu *a6xx_gpu,
 		OUT_RING(ring, lower_32_bits(rbmemptr(ring, fence)));
 		OUT_RING(ring, upper_32_bits(rbmemptr(ring, fence)));
 		OUT_RING(ring, submit->seqno - 1);
+
+		OUT_PKT7(ring, CP_THREAD_CONTROL, 1);
+		OUT_RING(ring, CP_SET_THREAD_BOTH);
+
+		/* Reset state used to synchronize BR and BV */
+		OUT_PKT7(ring, CP_RESET_CONTEXT_STATE, 1);
+		OUT_RING(ring,
+			 CP_RESET_CONTEXT_STATE_0_CLEAR_ON_CHIP_TS |
+			 CP_RESET_CONTEXT_STATE_0_CLEAR_RESOURCE_TABLE |
+			 CP_RESET_CONTEXT_STATE_0_CLEAR_BV_BR_COUNTER |
+			 CP_RESET_CONTEXT_STATE_0_RESET_GLOBAL_LOCAL_TS);
+
+		OUT_PKT7(ring, CP_THREAD_CONTROL, 1);
+		OUT_RING(ring, CP_SET_THREAD_BR);
 	}
 
 	if (!sysprof) {
-- 
2.39.5



