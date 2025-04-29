Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC411DF73C;
	Tue, 29 Apr 2025 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946227; cv=none; b=Z8uQYHjPm7cuUrJtcbehneBOO7cjKF04LUjdE4So83N2OG/kW633ZMpGvCEfYfhiLtQyhy8q/GVW1vdMa7UR09BwSPdOwToLX4d3cm5Aj9qYwv2UDYULOCBqgLOUJcwouF25O1fHy+YGiYY78+39yBbPOt4vzf1CtONYZHhonJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946227; c=relaxed/simple;
	bh=xN5MwScdJXpZJWm74hIx/PxBfbwvrJSWC1B91KoWtSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlTFpKK3R7Oowb7HBLwV+cE9gwl5oJJkM1U+QVzplsb26P7l1t6rxN2dB2RfxcfZ5mRUTEZbaCB+tQy7GXwnlXpmdnHGU+FAr1VRn282ddFV71johaDv9+X38/YGtPfpjgPNO2S+llF5Ah+mkSScaHRlJ0mZ7RBrGMDMw60hdT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsQ9aLrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsQ9aLrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033F4C4CEE3;
	Tue, 29 Apr 2025 17:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946227;
	bh=xN5MwScdJXpZJWm74hIx/PxBfbwvrJSWC1B91KoWtSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsQ9aLrFtEjVYYJ+HCEsJTRFwc81bxoNRIG2iCUGhhdU4aSVVHLn95vP43nKFrAfF
	 w4O2KgfGKfmkhq5GQ8PKtxJQbK9Z6WKmGo1PQuNgltmTcW2mSeBCHxQWUnVruIQ3Gk
	 0+WqD1TpplO/oqgUgddTpwMl+BFm0ctRrIBE+Q8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 198/311] staging: gpib: Use min for calculating transfer length
Date: Tue, 29 Apr 2025 18:40:35 +0200
Message-ID: <20250429161129.124134505@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 76d54fd5471b10ee993c217928a39d7351eaff5c ]

In the accel read and write functions the transfer length
was being calculated by an if statement setting it to
the lesser of the remaining bytes to read/write and the
fifo size.

Replace both instances with min() which is clearer and
more compact.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202501182153.qHfL4Fbc-lkp@intel.com/
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250120145030.29684-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/agilent_82350b/agilent_82350b.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/gpib/agilent_82350b/agilent_82350b.c b/drivers/staging/gpib/agilent_82350b/agilent_82350b.c
index c62407077d37f..cd7fe7d814cea 100644
--- a/drivers/staging/gpib/agilent_82350b/agilent_82350b.c
+++ b/drivers/staging/gpib/agilent_82350b/agilent_82350b.c
@@ -66,10 +66,7 @@ int agilent_82350b_accel_read(gpib_board_t *board, uint8_t *buffer, size_t lengt
 		int j;
 		int count;
 
-		if (num_fifo_bytes - i < agilent_82350b_fifo_size)
-			block_size = num_fifo_bytes - i;
-		else
-			block_size = agilent_82350b_fifo_size;
+		block_size = min(num_fifo_bytes - i, agilent_82350b_fifo_size);
 		set_transfer_counter(a_priv, block_size);
 		writeb(ENABLE_TI_TO_SRAM | DIRECTION_GPIB_TO_HOST,
 		       a_priv->gpib_base + SRAM_ACCESS_CONTROL_REG);
@@ -200,10 +197,7 @@ int agilent_82350b_accel_write(gpib_board_t *board, uint8_t *buffer, size_t leng
 	for (i = 1; i < fifotransferlength;) {
 		clear_bit(WRITE_READY_BN, &tms_priv->state);
 
-		if (fifotransferlength - i < agilent_82350b_fifo_size)
-			block_size = fifotransferlength - i;
-		else
-			block_size = agilent_82350b_fifo_size;
+		block_size = min(fifotransferlength - i, agilent_82350b_fifo_size);
 		set_transfer_counter(a_priv, block_size);
 		for (j = 0; j < block_size; ++j, ++i) {
 			// load data into board's sram
-- 
2.39.5



