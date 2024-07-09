Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A917C55E4C;
	Tue,  9 Jul 2024 11:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524809; cv=none; b=BOUMitpqQhc28nLKEREACfths4y6FyjqTg3e/Bv/b/UKmcDV+i+YZTvZ31TPaoQwMvYt539yP7llOU4ayOEOc/LLr35/x9ENHdAL3ycXjM3gLIaR8+DNc1mlxbHsDcBrcq5T4LzQMkwglDbNJv+jbl2a3qfjisBDq041oYJixV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524809; c=relaxed/simple;
	bh=QaKA4ZCn4UT2AWIoX07pZuegDQEXy3EtYzc8unO7tq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G59I6+yP4GABlUi8oEndRq38Jj1v+AXDDcXvXGBL4Di6ZFQs6Z7j4sOT6A6AZj0ZxIuM1yKrsHC3ddI+AX0xvwG0uS0lXA1UM2g0+noviuZxiXxK4AkEnkl+MNLLCPqAy6r6vSyW/6XdzAPA0wokbtTbQ0eMWylgolizFvatBdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLgcpVwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLgcpVwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B57C4AF0B;
	Tue,  9 Jul 2024 11:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524809;
	bh=QaKA4ZCn4UT2AWIoX07pZuegDQEXy3EtYzc8unO7tq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLgcpVwcyvqs7zAz7OVqdNHNTl05lRdYc+aPXw1VEmaK224wrzzdVc3Wu3VYVM4P6
	 obLb043C07JeOyuGKtfiNFIE2q2uwca3hHLkRZ040tWNxyUyHhFJq60ryW7CkCBk2q
	 Ofs0uBYkjBTRnOozFIeHJP0rhjqJD28YMt0vGDNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kundan Kumar <kundan.kumar@samsung.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/102] nvme: adjust multiples of NVME_CTRL_PAGE_SIZE in offset
Date: Tue,  9 Jul 2024 13:10:56 +0200
Message-ID: <20240709110654.986986426@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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
index 5ff09f2cacab7..32e89ea853a47 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -824,7 +824,8 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		struct bio_vec bv = req_bvec(req);
 
 		if (!is_pci_p2pdma_page(bv.bv_page)) {
-			if (bv.bv_offset + bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
+			if ((bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1)) +
+			     bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
 				return nvme_setup_prp_simple(dev, req,
 							     &cmnd->rw, &bv);
 
-- 
2.43.0



