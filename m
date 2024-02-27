Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C21F13B798;
	Tue, 27 Feb 2024 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043588; cv=none; b=Wh1xROvLiT27q4kWVE12AKzPn7Xiky5hRnjbOwFbN+eg/rojIkZsyDwGyTTgBd1k5B4oeqJ74p9rLB7opAraUwXNdR5U6Ghg6UWvDoBlDHazxcagqtg5TT9SMdXEqHA8cdot32FoUKLjf86zRHE3c18xH9wYm27eCIeUJep6B+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043588; c=relaxed/simple;
	bh=DXvuD2f3SFkiskVFRm6sPqUqn9tMOcclYltbs7oQGDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Obl8sgrqdu6wwIR47QvwBg15ZYk1pOILiGq/PiD6QmkcDvKq8p6va4cfOC5qqKk1yra4T5cGt567ArpIxqLhFX9bdKeSvP+5Mm3AJGBRbWJR+TSaa8EKOF1ey76KBy8i5VGpGBwwxmiFgWFZTW7xNSBImpqcKLA9jh+n53aY55A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfqUhMs7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfqUhMs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24787C433F1;
	Tue, 27 Feb 2024 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043588;
	bh=DXvuD2f3SFkiskVFRm6sPqUqn9tMOcclYltbs7oQGDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfqUhMs7B+FDiwAsO6UF+XiHVrrHKbolAwc8zdNWddYmdOiadceCFj50BVTKhWtxo
	 LlE9wlqdNmco/5L2KuUptXMK8fOlAo7bzqJHir+ez2J5evYJJgCRGKBUYyOcCTvZG2
	 RXn+45fU8gLrYULEuDJEHJBjQUf7r4xX3eVdSejU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/195] RDMA/irdma: Set the CQ read threshold for GEN 1
Date: Tue, 27 Feb 2024 14:26:35 +0100
Message-ID: <20240227131614.863789033@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 666047f3ece9f991774c1fe9b223139a9ef8908d ]

The CQ shadow read threshold is currently not set for GEN 2.  This could
cause an invalid CQ overflow condition, so remove the GEN check that
exclused GEN 1.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Link: https://lore.kernel.org/r/20240131233849.400285-4-sindhu.devale@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 0fbc39df1e7d4..42c671f209233 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2121,9 +2121,8 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 		info.cq_base_pa = iwcq->kmem.pa;
 	}
 
-	if (dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
-		info.shadow_read_threshold = min(info.cq_uk_init_info.cq_size / 2,
-						 (u32)IRDMA_MAX_CQ_READ_THRESH);
+	info.shadow_read_threshold = min(info.cq_uk_init_info.cq_size / 2,
+					 (u32)IRDMA_MAX_CQ_READ_THRESH);
 
 	if (irdma_sc_cq_init(cq, &info)) {
 		ibdev_dbg(&iwdev->ibdev, "VERBS: init cq fail\n");
-- 
2.43.0



