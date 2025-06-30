Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472E8224225;
	Mon, 30 Jun 2025 21:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317218; cv=none; b=td4XRpgkbuYavuqFp2CJ/KVJlVnvB817ClPBC2LzYvsaigNsMrJ8AblHUFUTSp3QdbyF/C8qz6A5S6gF7nb2Ox2nxPAzFvZinGyvy+cntCLoAkUuByvO8CvBhX8ibgpZhY4UXuVrIMfmtqeMx3PK3DMFmbmxRvUHRMyluZs01ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317218; c=relaxed/simple;
	bh=HNPMZ0KP5gxEj7QgLhSZnvjlAWeV9Dv4SmtTm2mDUwk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UHIY8AWAwZFMSdEqOSEN2D7Zy/TWcQZbATciGtiKNxTk1HKzSmIz1i77Rk+Lsb3+wUIzs67wgO+hrHRJMov8j8KBy+Vo9Iz2P5GdDBUUEert6F6p6tcAiv3/KNiShTvJbeBSjgt4sNXW7BqFelXGRKZ+94xoEzKQ/OKcibeYUp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V81duVcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V81duVcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9FFC4CEE3;
	Mon, 30 Jun 2025 21:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317216;
	bh=HNPMZ0KP5gxEj7QgLhSZnvjlAWeV9Dv4SmtTm2mDUwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V81duVccESRe2h+EAEKIDW7nA5PD+xSynxlFOztQj/I4NzOkPn59I2JIbE5Tt58+Y
	 e0Qj8DkVlI+NdDmx2+8sp1GUGP5OPOiKh4+dRZIpaZ9NUmA+P60Qg3aGyS/69B1kl9
	 jRVfKN9u+Yju2MeZB4mMQKVHBSunBkc43DhQ66u/IT0zLVhP2kLtC3D67/pvuYXndR
	 xPg8l5IMenlyvAd/WSO3HT/f2q2Y9Xt/oZjjsIA4e+jBe5LIsTX4pda7sXtOWL+uNQ
	 K2FWwqcLCs4mpcwQhnHxm7+BaQLciaGFVrTo21lsSJa5+1fXkxlksk/K1AG8L1sN33
	 L2eDqcql84jFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Long Li <longli@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	leon@kernel.org,
	kotaranov@microsoft.com,
	shirazsaleem@microsoft.com,
	shradhagupta@linux.microsoft.com,
	mlevitsk@redhat.com,
	peterz@infradead.org,
	haiyangz@microsoft.com,
	ernis@linux.microsoft.com
Subject: [PATCH AUTOSEL 6.12 14/21] net: mana: Record doorbell physical address in PF mode
Date: Mon, 30 Jun 2025 16:45:29 -0400
Message-Id: <20250630204536.1358327-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204536.1358327-1-sashal@kernel.org>
References: <20250630204536.1358327-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.35
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

[ Upstream commit e0fca6f2cebff539e9317a15a37dcf432e3b851a ]

MANA supports RDMA in PF mode. The driver should record the doorbell
physical address when in PF mode.

The doorbell physical address is used by the RDMA driver to map
doorbell pages of the device to user-mode applications through RDMA
verbs interface. In the past, they have been mapped to user-mode while
the device is in VF mode. With the support for PF mode implemented,
also expose those pages in PF mode.

Support for PF mode is implemented in
290e5d3c49f6 ("net: mana: Add support for Multi Vports on Bare metal")

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1750210606-12167-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Critical Functionality Fix

The commit fixes a missing functionality that prevents RDMA from working
properly in PF (Physical Function) mode. Looking at the code changes:

1. **The Problem**: In `mana_gd_init_pf_regs()`, the driver was not
   recording `gc->phys_db_page_base`, while the VF initialization
   function `mana_gd_init_vf_regs()` does record it (lines 50-51 in the
   existing code).

2. **The Impact**: The RDMA driver critically depends on
   `phys_db_page_base` in its `mana_ib_mmap()` function
   (drivers/infiniband/hw/mana/main.c:535-537):
  ```c
  pfn = (gc->phys_db_page_base +
  gc->db_page_size * mana_ucontext->doorbell) >>
  PAGE_SHIFT;
  ```
  This physical address is used to map doorbell pages to user-space
  applications through `rdma_user_mmap_io()`, which is essential for
  RDMA functionality.

3. **User Impact**: Without this fix, RDMA operations would fail in PF
   mode (bare metal deployments), making the RDMA feature completely
   unusable for those users.

## Meets Stable Criteria

- **Small and contained**: The fix adds only 3 lines of code
- **Fixes a real bug**: RDMA functionality is broken in PF mode without
  this
- **No architectural changes**: Simply records an address that's already
  being recorded in VF mode
- **Low regression risk**: The change is isolated to PF initialization
  path
- **Similar to previous stable fixes**: Commits #3 and #4 in the
  historical examples were both doorbell-related RDMA fixes that were
  backported

The commit essentially brings parity between VF and PF modes for
doorbell physical address recording, which is necessary for proper RDMA
operation. This is a clear functional bug that affects users running
MANA in PF mode with RDMA requirements.

 drivers/net/ethernet/microsoft/mana/gdma_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 9bac4083d8a09..876de6db63c4f 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -28,6 +28,9 @@ static void mana_gd_init_pf_regs(struct pci_dev *pdev)
 	gc->db_page_base = gc->bar0_va +
 				mana_gd_r64(gc, GDMA_PF_REG_DB_PAGE_OFF);
 
+	gc->phys_db_page_base = gc->bar0_pa +
+				mana_gd_r64(gc, GDMA_PF_REG_DB_PAGE_OFF);
+
 	sriov_base_off = mana_gd_r64(gc, GDMA_SRIOV_REG_CFG_BASE_OFF);
 
 	sriov_base_va = gc->bar0_va + sriov_base_off;
-- 
2.39.5

