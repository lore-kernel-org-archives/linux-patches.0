Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C081DDCE;
	Tue, 16 Jul 2024 16:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146139; cv=none; b=jIkwk7D9wfKwIjvJkto7atcfql3+P9B9uOo30xFQ3kqIWXCj+gXK6v8i83VM42kQAIgiUgb8Cf4pyeeqa0/KPuq7lFp3So4AA+iS7QNgZnhFFG0qNfB7UojvJqdfCBrjA/JczBUfbhjxqmxbF8WuDeIijmFtvpZMFYELOZ/IyMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146139; c=relaxed/simple;
	bh=6ZvNOWex02uyybM4uMDktheTv5z4nkyLEUFEHK2FeuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtYI+9Z2Sczo3hVyR7turvQlksGVW4r4oUMHxfWIiuaOzgYHA2I0OwbP5I7siOT3UtgTnPZHJtfVgKIAj3uq7T3WeWC1qqr8lJknBI8O5fFZzIv64tV4srZVx09uRexRbE+AyWA8ERZyr150yL4ottLFDAUPGzIt+vWjiJWFV4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4sZm+vJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4sZm+vJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DB5C116B1;
	Tue, 16 Jul 2024 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146139;
	bh=6ZvNOWex02uyybM4uMDktheTv5z4nkyLEUFEHK2FeuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4sZm+vJAkfHgEf4WlaKMWLNU4Tf71fl7Yh/Ge/6Smt/96wZasX49dvS8YHNOieph
	 myzxrU1sj/oNACB9tCdZ7xXYQJPQ9vkTqkXSfJPMajFoF2dmxQRL3D84al0xaZ60gr
	 t18fUrCJS/pF6a7UYz8uMufSLcrqEX1htp3/Hals=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kundan Kumar <kundan.kumar@samsung.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/144] nvme: adjust multiples of NVME_CTRL_PAGE_SIZE in offset
Date: Tue, 16 Jul 2024 17:32:19 +0200
Message-ID: <20240716152755.237586530@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7bb74112fef37..5a3ba7e390546 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -836,7 +836,8 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		struct bio_vec bv = req_bvec(req);
 
 		if (!is_pci_p2pdma_page(bv.bv_page)) {
-			if (bv.bv_offset + bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
+			if ((bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1)) +
+			     bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
 				return nvme_setup_prp_simple(dev, req,
 							     &cmnd->rw, &bv);
 
-- 
2.43.0



