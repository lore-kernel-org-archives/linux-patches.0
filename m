Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551042236EB;
	Tue, 30 Sep 2025 15:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245074; cv=none; b=YT3dOPbBZ9rYxt3oBqJvqrf4L8388fs3sHCfqdtvkd9tUC27q8u12psnvHONn4oJSMvCEbb01Ni5MtnykSXUjpgddlQHV3zcdm/Fi98QC2KyXKllwRyvZ1J6vK+ixEuX4ALL3Kb8xGhliBWdj/KUmnYNtzioIHXEdAc5K372VpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245074; c=relaxed/simple;
	bh=uJCDTy39SFJTbFT/rhtboaC+V7BO93s4/QQFvxcZNIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Seetl/4xxHY8ACmMUeYJUbLPgwx+EXvZ5lCcslYI/D5JbBdmV0DerSxynOryazXhSXFL3Wgb9E5sjg5kBAO/08aRPzyNi8wDp0sg9xDNk6LiiRSxqJ5MUTtJHzpY7rWRzDi/ZyYNO59l+iphILZPS3dWN+IJfomovRXCErivoMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsE1H+vc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsE1H+vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90EAC4CEF0;
	Tue, 30 Sep 2025 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245074;
	bh=uJCDTy39SFJTbFT/rhtboaC+V7BO93s4/QQFvxcZNIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsE1H+vc+3oRbd8KiGh/hBrI+vv+mMhXozBoBy4/5RNF+BSMDMoivJjOAm/aLuqtj
	 arqmhJ8iJU2MUC20sThCo6VwO38+2f0UEkfKh5SFvoB5jAoi26G39iM06DeIZFDMDr
	 1rEpQzQGdCbac7MVftkhTMge0HUI8kwdQVSeagn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/151] dmaengine: ti: edma: Fix memory allocation size for queue_priority_map
Date: Tue, 30 Sep 2025 16:46:22 +0200
Message-ID: <20250930143829.679326575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 560fe658b8942..c555b0991ad10 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2121,8 +2121,8 @@ static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
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



