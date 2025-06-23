Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CD41F7580;
	Mon, 23 Jun 2025 22:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716613; cv=none; b=ckycx8kBRfvtYeB9r/w++I6ptvxMM2NCZIb/CwVgHwa2HX8O+rOevbBihXbj29fbtoJeYSEZaaZ8kTvR6vHeEz8w2vLD2/ftO5Cc76hRt83ZRL5KzVsw2xdsq/i/gzCdOhoBm2DAQhzBz+b3LQ9g+apZ87vjH3/x0nDY4WdMpOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716613; c=relaxed/simple;
	bh=Dmds9ooRpbEAM7A9PI+0v3D/DgPbwtpyNiqCjfJoTRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWIzAQEfDf+EwsEk7oyh0PXvntnNE4txMZfCddOZ+jp0PBftL4fFvtA8qvIfwhcZT1RmBDN/Z94jLB6MiDh8ADKRk7ZztNhG2tvYJDoJo43EIcbyvWtSHbL1PukqR15uzFgVh/+fhf9B8Lr5YmfelFDChLGu4mBXvUxi4O2BKp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATP12G32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATP12G32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD66C4CEEA;
	Mon, 23 Jun 2025 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716612;
	bh=Dmds9ooRpbEAM7A9PI+0v3D/DgPbwtpyNiqCjfJoTRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATP12G32hJPhRKdNy/MheZ0CL9mEAZoVYNvhpZXsnZd5ew7u88cc4oYyuOL3qIgcB
	 XBri3GNRemBC1P7ZCY5WZapiiTkZTJWWz7TqUpSgVHTHOvJ2ogSCq7IXFA2KzTVvjs
	 pKVxGxEg8G46oZEOyd4QGeHXTu4g8Zigh5JDVIyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 269/414] ixgbe: Fix unreachable retry logic in combined and byte I2C write functions
Date: Mon, 23 Jun 2025 15:06:46 +0200
Message-ID: <20250623130648.755643756@linuxfoundation.org>
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

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit cdcb3804eeda24d588348bbab6766cf14fddbeaa ]

The current implementation of `ixgbe_write_i2c_combined_generic_int` and
`ixgbe_write_i2c_byte_generic_int` sets `max_retry` to `1`, which makes
the condition `retry < max_retry` always evaluate to `false`. This renders
the retry mechanism ineffective, as the debug message and retry logic are
never executed.

This patch increases `max_retry` to `3` in both functions, aligning them
with the retry logic in `ixgbe_read_i2c_combined_generic_int`. This
ensures that the retry mechanism functions as intended, improving
robustness in case of I2C write failures.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index 07eaa3c3f4d36..530e4319a2e89 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -167,7 +167,7 @@ int ixgbe_write_i2c_combined_generic_int(struct ixgbe_hw *hw, u8 addr,
 					 u16 reg, u16 val, bool lock)
 {
 	u32 swfw_mask = hw->phy.phy_semaphore_mask;
-	int max_retry = 1;
+	int max_retry = 3;
 	int retry = 0;
 	u8 reg_high;
 	u8 csum;
@@ -2284,7 +2284,7 @@ static int ixgbe_write_i2c_byte_generic_int(struct ixgbe_hw *hw, u8 byte_offset,
 					    u8 dev_addr, u8 data, bool lock)
 {
 	u32 swfw_mask = hw->phy.phy_semaphore_mask;
-	u32 max_retry = 1;
+	u32 max_retry = 3;
 	u32 retry = 0;
 	int status;
 
-- 
2.39.5



