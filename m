Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC21A94A;
	Tue,  8 Apr 2025 11:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112902; cv=none; b=il4e6u8C8q6lYfRY++mb9ypuzCVrUxjRXCsHME3U+1TOSYr7mzpk04CW7wu3khAOp0Fy4Z2+KuEKzSH6NqplqaRU7guNpC1YoJIWgnDyRn49t31LdDwIUtqGbgn+vY1n6lQd4bAD9p2nZLxs2DsTzjQTXOuaum/R61bQmX2OS3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112902; c=relaxed/simple;
	bh=HRzaQXydfC+kJhfXoFNcRtk3odnlKOOwiVFfQ0Jtxqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bU2aSzew2I2O0hIP7CjeqzNErL9KLNOdP1UuA3hnrW5kuCOLRB4FIFnX2u4pwvNBsNPxrVM6K2l+7hepqW30H79BNooGo7sLCsPmrTdhHmDrbmkm+2NSfZIQn3SNdmF4xctVG4G1+up+qD8qpuIn/YCMWdfryYaVqar89Q6p7RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpyWjTG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpyWjTG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28952C4CEE7;
	Tue,  8 Apr 2025 11:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112902;
	bh=HRzaQXydfC+kJhfXoFNcRtk3odnlKOOwiVFfQ0Jtxqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpyWjTG1HZXStM8VaFNIfGqWw/j83m2v0Y8QqoOeBE7znXxwVzr4cVLYCh8j9bDfn
	 f8/a55ZhflgSa6LKB6hLobv1TMXRAsN5qv+q/SO7d48NZg4MdeX6iwhaXT0rO8BScu
	 uaqX/r+ITZl6YriF/eqvGlB7GdhLqbm4Bpe+9F+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/279] ntb: intel: Fix using link status DBs
Date: Tue,  8 Apr 2025 12:50:22 +0200
Message-ID: <20250408104832.837457193@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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



