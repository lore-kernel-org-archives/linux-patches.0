Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7BC3195E5;
	Wed, 17 Sep 2025 12:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113886; cv=none; b=ndDEpi3Pz1G3a5YtDQ96shk98P/PdsyJa24yUqn8wCZeu0ctyCY6RvnZtUqAy/G0ZnfKrMSxJ1uwOzoubMCjvplAmWnSpnefngEP4lMre2rqGS6qrMSfyge7YoV75DHhL/Il1ERyHkAPxVhVZgpK1+JbSTl9KBHZYL/LDvDXN6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113886; c=relaxed/simple;
	bh=236ZVXxd1JtJWG8CkGvYCDrS/vzdK18qnDi8My27t9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeaNhYleDexPH/bQTRWLPJNlAj4xp+MBp2cUex6Idoydllug9uRybzjhVkTUmCmBLXBqlsC5muWto9zru6Sf1AOToMO+pUO9HvYm7Ws1kPR9gebysmZtoqa0thulHEwsDFhnKh6N3pul/QQveybRek9dklJKst0goaF5/I6uEw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BJtVxQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BJtVxQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93531C4CEF0;
	Wed, 17 Sep 2025 12:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113886;
	bh=236ZVXxd1JtJWG8CkGvYCDrS/vzdK18qnDi8My27t9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BJtVxQ1gIBn06eyy7zQgJgLqh4wwZ9FqOk39TKCsrjFB+9mIk4W+jYyq/UQI/W1S
	 J1eM7Q2nJPe06Qhk0HUvaerokd43unXI4kMI0abMy/jYkrCUHZ9V+2eKZ3mh0MYhjG
	 ceHuravDGErHD+xCUDjj15+LztuytOyRNPsvh5dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/101] dmaengine: ti: edma: Fix memory allocation size for queue_priority_map
Date: Wed, 17 Sep 2025 14:35:07 +0200
Message-ID: <20250917123338.869729213@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit e63419dbf2ceb083c1651852209c7f048089ac0f ]

Fix a critical memory allocation bug in edma_setup_from_hw() where
queue_priority_map was allocated with insufficient memory. The code
declared queue_priority_map as s8 (*)[2] (pointer to array of 2 s8),
but allocated memory using sizeof(s8) instead of the correct size.

This caused out-of-bounds memory writes when accessing:
  queue_priority_map[i][0] = i;
  queue_priority_map[i][1] = i;

The bug manifested as kernel crashes with "Oops - undefined instruction"
on ARM platforms (BeagleBoard-X15) during EDMA driver probe, as the
memory corruption triggered kernel hardening features on Clang.

Change the allocation to use sizeof(*queue_priority_map) which
automatically gets the correct size for the 2D array structure.

Fixes: 2b6b3b742019 ("ARM/dmaengine: edma: Merge the two drivers under drivers/dma/")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Link: https://lore.kernel.org/r/20250830094953.3038012-1-anders.roxell@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index c0fa541324675..f7ddf588b7f9b 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2063,8 +2063,8 @@ static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
 	 * priority. So Q0 is the highest priority queue and the last queue has
 	 * the lowest priority.
 	 */
-	queue_priority_map = devm_kcalloc(dev, ecc->num_tc + 1, sizeof(s8),
-					  GFP_KERNEL);
+	queue_priority_map = devm_kcalloc(dev, ecc->num_tc + 1,
+					  sizeof(*queue_priority_map), GFP_KERNEL);
 	if (!queue_priority_map)
 		return -ENOMEM;
 
-- 
2.51.0



