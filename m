Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D122B168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7100C433EF;
	Mon,  8 May 2023 11:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543983;
	bh=sIFjfpXaToDJy9QADT95WCiqo6fG4/eLfzPBXd22IHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywBgBrIXv0P0MunKsEN6DVmSPSBy25RUOj2n5/eAn3rUPIJXj1c0pe773DAihK4hc
	 SzwHXP91G41A1ideuw0oyr1ASj/XAiGblST5y58vrUYs7ngehFEQYhubNeYyGx9S1f
	 R4E4DcOZYZKxUwkShKg6fNX1nZWodN0fGjezg/zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Randy Dunlap <rdunlap@infradead.org>,
	Rob Clark <robdclark@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 264/694] drm/msm/dpu: Fix bit-shifting UB in DPU_HW_VER() macro
Date: Mon,  8 May 2023 11:41:39 +0200
Message-Id: <20230508094440.842297248@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4760be481dc075cd13f95f4650f5d5b53b4b336d ]

With gcc-5 and CONFIG_UBSAN_SHIFT=y:

    drivers/gpu/drm/msm/msm_mdss.c: In function 'msm_mdss_enable':
    drivers/gpu/drm/msm/msm_mdss.c:296:2: error: case label does not reduce to an integer constant
      case DPU_HW_VER_800:
      ^
    drivers/gpu/drm/msm/msm_mdss.c:299:2: error: case label does not reduce to an integer constant
      case DPU_HW_VER_810:
      ^
    drivers/gpu/drm/msm/msm_mdss.c:300:2: error: case label does not reduce to an integer constant
      case DPU_HW_VER_900:
      ^

This happens because for major revisions 8 or greather, the non-sign bit
of the major revision number is shifted into bit 31 of a signed integer,
which is undefined behavior.

Fix this by casting the major revision number to unsigned int.

Fixes: efcd0107727c4f04 ("drm/msm/dpu: add support for SM8550")
Fixes: 4a352c2fc15aec1e ("drm/msm/dpu: Introduce SC8280XP")
Fixes: 100d7ef6995d1f86 ("drm/msm/dpu: add support for SM8450")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/525152/
Link: https://lore.kernel.org/r/20230306090633.65918-1-geert+renesas@glider.be
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
index e6590302b3bfc..2c5bafacd609c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
@@ -19,8 +19,9 @@
  */
 #define MAX_BLOCKS    12
 
-#define DPU_HW_VER(MAJOR, MINOR, STEP) (((MAJOR & 0xF) << 28)    |\
-		((MINOR & 0xFFF) << 16)  |\
+#define DPU_HW_VER(MAJOR, MINOR, STEP)			\
+		((((unsigned int)MAJOR & 0xF) << 28) |	\
+		((MINOR & 0xFFF) << 16) |		\
 		(STEP & 0xFFFF))
 
 #define DPU_HW_MAJOR(rev)		((rev) >> 28)
-- 
2.39.2



