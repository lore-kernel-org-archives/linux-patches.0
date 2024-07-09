Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B8827713;
	Tue,  9 Jul 2024 11:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524447; cv=none; b=fXYzIELpRblBI84wQfW2MolY+6lSZ7XqV9MEtzOeoKyiaRUBwgj/IC3Md/fwfFypuWUIkdoJVEn1A0pHjstKDqoDLQOIr2fTwoc4ilfNeW8ePBJ/+LYDVLD7MmBDKI1xEytcpBlE2OwywaIchxSjGaSLdjevl3ZaXgMPl/uUNjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524447; c=relaxed/simple;
	bh=C0dcPnNoJN6CbQhZRD0wD5P2F3zYFhqQygOJX038OJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRQUo1dUDNSzTAgVhIUqb0qFiFkhv/0i53JeHLMnX9vFroQgRLwkESmUGr0a8I918KKi0J+iUywZPzl9OBHbHhHnXemE0tWdZj04fKlj1g/wFM1YV+C43dLLi71wthATQVT+9cBpgZIX2AhRdzu2S34SMPy9YO7mhZyiu8uwl9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrEKlzrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrEKlzrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE72AC32786;
	Tue,  9 Jul 2024 11:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524447;
	bh=C0dcPnNoJN6CbQhZRD0wD5P2F3zYFhqQygOJX038OJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrEKlzrAILDG8e3nWDYRQ/Ilw21Tzux2vkDgmzG5CKfX5hNEgwNm4GIgPouxDayEw
	 Kxiz1zWXKn9eLgiD5D0U6NKo5V/cZtEu4JzVpFsPOg7mPVEoyuKiXbx2CtfjHXFbwl
	 NH4QSOy/D14pplI+KFguykOtAuWVPNM3akdZwFr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kundan Kumar <kundan.kumar@samsung.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 183/197] nvme: adjust multiples of NVME_CTRL_PAGE_SIZE in offset
Date: Tue,  9 Jul 2024 13:10:37 +0200
Message-ID: <20240709110716.025144470@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 710043086dffa..102a9fb0c65ff 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -778,7 +778,8 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		struct bio_vec bv = req_bvec(req);
 
 		if (!is_pci_p2pdma_page(bv.bv_page)) {
-			if (bv.bv_offset + bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
+			if ((bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1)) +
+			     bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
 				return nvme_setup_prp_simple(dev, req,
 							     &cmnd->rw, &bv);
 
-- 
2.43.0



