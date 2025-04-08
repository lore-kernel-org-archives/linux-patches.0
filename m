Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045D11B87CF;
	Tue,  8 Apr 2025 12:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114108; cv=none; b=n9MEdu5/lQjaaeKSkFrgVjud61BUEwmHhM1Nn5h1MhmKK0IAm5e9zoS0i96tkFQGwGCeoxnikjbpVLyLysHRUbhipmhOFXITWiRWW/9XcgADBlW8sfgB4KhWiD1qfO6z+x3lTFhLjfcUpohmn0LYuIvVmCRg4xI754dQ9M7vh8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114108; c=relaxed/simple;
	bh=zCfSr06+VqkcX2jqdpMX5qwAQb8IzHWA6SiFSzmrHDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjkwHl4hn+RoNES2rKZVGC4xRyTztnGFxqgVd7luLPnNwnrhOJvQtAzn8V5RzgRrxCMaM30zOnkTevmPQ9ZWk+PFrSlF1FL+t9Rk+gXIqJ8pNJ/qua4VExt67b0KWpaYuH1FeQKKuxlI7MXQpan8G3WE46Zg1wAPm2DKjgcejvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K47tQ3tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K47tQ3tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A947C4CEE5;
	Tue,  8 Apr 2025 12:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114107;
	bh=zCfSr06+VqkcX2jqdpMX5qwAQb8IzHWA6SiFSzmrHDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K47tQ3twfiPZE9LkG+IMMOKF53l04Phc9Op/2yWUo2tkisYT+sjnFl4BLa+FqhVeM
	 sNFKRpIoxWYarJ5pxTkdt3EX6vpht54Egzvrpm6fk5NctBTbcdAkApTsyYoyJAVoW+
	 3m3pTKwI7JKSmZjE9uHDVhsj0c231kQS+foB4G6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/154] ntb: intel: Fix using link status DBs
Date: Tue,  8 Apr 2025 12:51:20 +0200
Message-ID: <20250408104819.768997691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c3397160db7f7..0076a73c51721 100644
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



