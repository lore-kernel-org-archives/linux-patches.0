Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF4C19AA40;
	Tue, 16 Jul 2024 15:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144625; cv=none; b=L+Gt1JjYM1TtAfedhgMP70ap3+7xWKtTBhLqR09EQ9p4SKceEPFN4ID4Iv8y+TZql5WzdCW8lD1Vv+ONpYnx+oDilpsClkJNu8cWvVnarD4OSKVHbO4zEN3N4nlhuahsm+33UUfdeSnHuAQWZ+lnNk7jSByZM3l+4idWv1RYFLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144625; c=relaxed/simple;
	bh=V2d0QwK8famWjJVwxS3f8KEDuGD7I066VkSsuvG4Le4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mh9tP7yRpAwYlSkWmfqdEpHpfQ2Hp85LlP1uG0/JVT33LLLDgXL4HKWw/HQjkU8zs2YQkskr+2JyGpSJdRYD08SSzdRvTrJfG8/LzqP3q+i1xZt18XhkaydydoKHzcaitfXXT/XDW2/iedjsJAjih41hCyIv/OP8vkI2kqWoKog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQ33eRue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQ33eRue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96875C116B1;
	Tue, 16 Jul 2024 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144625;
	bh=V2d0QwK8famWjJVwxS3f8KEDuGD7I066VkSsuvG4Le4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQ33eRuepzMnlEDqgjq3EPCPiH7MgWxZikwCV3efVaS2lvDa41VajCY7vqkCYh4Wf
	 k1wwOGa/jZc/40GVJ+pMSJC1GX/rAwd+Fk3FXchl3DPQPVEak2gVFlnBTMoXOVRbAE
	 SzYau0CZ2W2qmXfBqmjkxhsE5pt7Vz4o3RsOH+JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kundan Kumar <kundan.kumar@samsung.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/108] nvme: adjust multiples of NVME_CTRL_PAGE_SIZE in offset
Date: Tue, 16 Jul 2024 17:31:07 +0200
Message-ID: <20240716152747.986142597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kundan Kumar <kundan.kumar@samsung.com>

[ Upstream commit 1bd293fcf3af84674e82ed022c049491f3768840 ]

bio_vec start offset may be relatively large particularly when large
folio gets added to the bio. A bigger offset will result in avoiding the
single-segment mapping optimization and end up using expensive
mempool_alloc further.

Rather than using absolute value, adjust bv_offset by
NVME_CTRL_PAGE_SIZE while checking if segment can be fitted into one/two
PRP entries.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5242feda5471a..a7131f4752e28 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -844,7 +844,8 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		struct bio_vec bv = req_bvec(req);
 
 		if (!is_pci_p2pdma_page(bv.bv_page)) {
-			if (bv.bv_offset + bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
+			if ((bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1)) +
+			     bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
 				return nvme_setup_prp_simple(dev, req,
 							     &cmnd->rw, &bv);
 
-- 
2.43.0



