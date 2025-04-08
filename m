Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87469269D03;
	Tue,  8 Apr 2025 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113636; cv=none; b=eWHPx7Cv5jFrAR5LRTMyz6hKh3TcsrM2teANdYERgUFXmuDc+4eHfQ9jETHqGiXnBvPYOmGf7t7jvPKuUzqtukb+9NSYkBbx+yPQLELWzn0SUh/COGNh4b4Evsw9IAMhABPMpyljD+Cp0ziOzsDx5wrYcNR0F7xJm/rAdL9OSrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113636; c=relaxed/simple;
	bh=bXT8SlWuv8RsFe9njsVVP9Hv80PlMAjDupsrFNVSnTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxcTav+0B5TpzvNXmiLxAuZMFtfHc8DFUGthQwEBSl2rqQsGdEqsEs0nAHhmlqScKFfZGs7NIykyGlqWiHr5CUCIEveVn9CwmratJto0VAW8mcNa+mW8zWtEjRPwIqycobKdF77bb2xq5UUeaeG+0IHZ3g/SfA8PxTRjc4ty3MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owqtTNrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owqtTNrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CF3C4CEE5;
	Tue,  8 Apr 2025 12:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113636;
	bh=bXT8SlWuv8RsFe9njsVVP9Hv80PlMAjDupsrFNVSnTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owqtTNrq+qxG5l3HdyrWdPK4POT9KNvICdylpEwGOIRmW4Rrf67rN0aldrWUztBtu
	 YtXVnAOMM6fRZ7LnOs8sNMIaD0LCndbw/LyBUdCedOWCSYEwEue6UQ7uwafbYRpJYW
	 /nrw555+NV3nWgUo3YsyLH5OMyUP/2Y1yexIrqXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/268] ntb: intel: Fix using link status DBs
Date: Tue,  8 Apr 2025 12:50:07 +0200
Message-ID: <20250408104833.841546521@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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



