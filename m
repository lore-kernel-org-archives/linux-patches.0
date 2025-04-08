Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E675C26988C;
	Tue,  8 Apr 2025 12:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117000; cv=none; b=qChfGY1pKvggpHnYIUu/ZHVxsd9zqBAKcRf7BnSE/wfhQul+3UfKabnnFQuc1rI9uXmXl8Soutsw9AXTOSa3zDmYoShhue/TTSqHfyIj7AcjHqgTi3BSZPm0wO9+V+qpopp7eY28RTHvDwtNFH+9wT5wPOKz6+qchzr5GpOVYn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117000; c=relaxed/simple;
	bh=BCkeWY8hXwX4y/XKnbLE6EyDq/LXc+swQ7uMvinZhLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkSaRoC16QflQxBEKUYEzjWAZe4DoU4w1o13T7l+W4elQTBbm5pLaHmbb5vjv9Vi2aIn7Kt2AXdTioo61OezaHgyUR+rbvMyOenan9QS2HvmX4VP71J9YDZOFlfiC7zH3f2CU4eGs1GNpg+M7Rl3ZKWhyGmnMVQeg/3MgZlUnsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSmih8so; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSmih8so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DAEC4CEE5;
	Tue,  8 Apr 2025 12:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116999;
	bh=BCkeWY8hXwX4y/XKnbLE6EyDq/LXc+swQ7uMvinZhLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSmih8soNEGMOekJ4ax3/7krvfR9snwuW3k/3wl0OyGcDfOP5rkJisMIC3GEeFKPD
	 Fvoc6gkB92YirUtpUqxIxTlTjnQ/Ik3xFbQL5YwLogOB0KCQ0/JgV7+Jn6Eyy9juTA
	 xnwITV76KcBI5Ut098gwm2a+nzOa2Tkx0Nrpm9DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/423] ntb: intel: Fix using link status DBs
Date: Tue,  8 Apr 2025 12:50:33 +0200
Message-ID: <20250408104852.949834595@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 8144e9c8f30fb23bb736a5d24d5c9d46965563c4 ]

Make sure we are not using DB's which were remapped for link status.

Fixes: f6e51c354b60 ("ntb: intel: split out the gen3 code")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_gen3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ntb/hw/intel/ntb_hw_gen3.c b/drivers/ntb/hw/intel/ntb_hw_gen3.c
index ffcfc3e02c353..a5aa96a31f4a6 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen3.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen3.c
@@ -215,6 +215,9 @@ static int gen3_init_ntb(struct intel_ntb_dev *ndev)
 	}
 
 	ndev->db_valid_mask = BIT_ULL(ndev->db_count) - 1;
+	/* Make sure we are not using DB's used for link status */
+	if (ndev->hwerr_flags & NTB_HWERR_MSIX_VECTOR32_BAD)
+		ndev->db_valid_mask &= ~ndev->db_link_mask;
 
 	ndev->reg->db_iowrite(ndev->db_valid_mask,
 			      ndev->self_mmio +
-- 
2.39.5



