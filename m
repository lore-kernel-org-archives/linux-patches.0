Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083ED215F6C;
	Tue, 29 Apr 2025 17:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949415; cv=none; b=t0UhzNC2Jh7dP7jD/7fYAbSnRd86vtXXkAuVTgWwnnrI3V0SMF52fIKvRQwNFF3/XtjkQuDO02VvKZltGXwsuXzSJk+FqMhUJyx70YMtvlUGeAEswczLfWhB57vqmdyeM67haE2tPu6QA5gh86zhgihp9HA/Xz3J1hHvjIAwwCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949415; c=relaxed/simple;
	bh=AJXmOuzYpWWrj41lYIvlE68Uax9CUgobD6rV0BiRG/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1FKddL5ihXZTrfMb6Pk0E+5IlVwxMG2bfWIWtqFiGe0FvDFct8chq70jirpf/wwyVSy/rRhmxPSmh2BdfDJ6TFqWUgAlGNEAiUV2Mw4JVuAakEYe++d6nf570LGfoNZkcw0n5A/iCWZ9TE74S5w7SWzDD0Fs7UzbEGs6D8Et9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBr/xVxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBr/xVxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629C1C4CEE9;
	Tue, 29 Apr 2025 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949414;
	bh=AJXmOuzYpWWrj41lYIvlE68Uax9CUgobD6rV0BiRG/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBr/xVxy1fhJ3nsuWrREB4gZnO4dwKlCAbDSE6L5wEjDStujdeuKMRB/pJJ1Kdlsj
	 IsoyktksnV0YDDf+G9b26VqruWBqbSNLqEAF//GFl+0LrzZCQVg4R5gJoKsrvCIF4E
	 TyzcqUGgIxhhVSje/htYFHvaX947ZZrdXMMcI40w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/373] drm/msm/a6xx: Handle GMU prepare-slumber hfi failure
Date: Tue, 29 Apr 2025 18:42:40 +0200
Message-ID: <20250429161134.753218009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit d6463fd4e97545ef4f7069d13a5fa3ac0924dae2 ]

When prepare-slumber hfi fails, we should follow a6xx_gmu_force_off()
sequence.

Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/498401/
Link: https://lore.kernel.org/r/20220819015030.v5.7.I54815c7c36b80d4725cd054e536365250454452f@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: f561db72a663 ("drm/msm/a6xx: Fix stale rpmh votes from GPU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index db19f3dee6f2b..65ba58c712c93 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1082,7 +1082,11 @@ static void a6xx_gmu_shutdown(struct a6xx_gmu *gmu)
 		a6xx_bus_clear_pending_transactions(adreno_gpu);
 
 		/* tell the GMU we want to slumber */
-		a6xx_gmu_notify_slumber(gmu);
+		ret = a6xx_gmu_notify_slumber(gmu);
+		if (ret) {
+			a6xx_gmu_force_off(gmu);
+			return;
+		}
 
 		ret = gmu_poll_timeout(gmu,
 			REG_A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS, val,
-- 
2.39.5



