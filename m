Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF4B13DB98;
	Tue, 27 Feb 2024 13:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042295; cv=none; b=I0JbWBR6c1GANqyzfGLCz+FuPmxKXSDVh8aCez9iml/OUVQD6IyOjIf6KFvrathhAECCF0ON91VsDKPfmw02z7hZdyAWs32CvdDqICOVFSAjF+6H4bTgPkGuA+sHOxaZX7AxLWAQtJuiO8Uscm05ODCrYnCXt5n/tzB6pPXm8aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042295; c=relaxed/simple;
	bh=EnNTSI6uA7VNThEzIQlR0N4K0vkPar2gXQdwZaQyTXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEkeM5Bxuqf6C4Z8wm9LdGcYLdyFnvaWbGj+sFUDx9HC9jBWYYlMnDEW5UrWpFFYTWY2/0uh30FBy2EOGx/z2WM6SegUGB4MB73l0g/bQ6SPrQNoOf4zmgDnPTzXOu/ezRWg42Wo+YN/6PT6zX3+gAmTX8otJuE8tP6uoDB92DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TA0anSrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TA0anSrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BC9C433F1;
	Tue, 27 Feb 2024 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042295;
	bh=EnNTSI6uA7VNThEzIQlR0N4K0vkPar2gXQdwZaQyTXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TA0anSrsVdY317ENgzki3C3MuQtTsA6Gvue4vviUT1rxHOj0boxmTtJoihmpu/GUb
	 VW2TxfLSMB3hut1Taen9zDJueCs6gv11SAv+sl/EQJ0Sir3mR6BnvD957IHpEb+Nke
	 Y304C4ebAaFfhY4sy7kgcIl/ro7mSN2PfRul7aD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/299] RDMA/irdma: Set the CQ read threshold for GEN 1
Date: Tue, 27 Feb 2024 14:25:29 +0100
Message-ID: <20240227131632.790371694@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d9750901c5990..60618b2046b97 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2186,9 +2186,8 @@ static int irdma_create_cq(struct ib_cq *ibcq,
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



