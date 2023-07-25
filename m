Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9E31EA7E
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21177C433C8;
	Tue, 25 Jul 2023 10:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282625;
	bh=99ArWk82MXHgryZ2pZbrD4DUKmoz2456CjFTnq0Mg7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZOr6cZRULP4D2JLykp0bKDflUAONqxlRzgZRGKCoLwVnAx8od4B6Q1Ss7tEPyMTX
	 5ysYHRs5K/WzWOyM8bGaPVcgXravNC2oytR65TjUD35dHER40lkZkpH+PDlw3H18cP
	 y1u/9fqZbeuIkNTKh7laI3PlYZJJJLKjVjw+w+vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 157/227] iommu/sva: Fix signedness bug in iommu_sva_alloc_pasid()
Date: Tue, 25 Jul 2023 12:45:24 +0200
Message-ID: <20230725104521.427550488@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit c20ecf7bb6153149b81a9277eda23398957656f2 ]

The ida_alloc_range() function returns negative error codes on error.
On success it returns values in the min to max range (inclusive).  It
never returns more then INT_MAX even if "max" is higher.  It never
returns values in the 0 to (min - 1) range.

The bug is that "min" is an unsigned int so negative error codes will
be promoted to high positive values errors treated as success.

Fixes: 1a14bf0fc7ed ("iommu/sva: Use GFP_KERNEL for pasid allocation")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/6b32095d-7491-4ebb-a850-12e96209eaaf@kili.mountain
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu-sva.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 3ebd4b6586b3e..05c0fb2acbc44 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -34,8 +34,9 @@ static int iommu_sva_alloc_pasid(struct mm_struct *mm, ioasid_t min, ioasid_t ma
 	}
 
 	ret = ida_alloc_range(&iommu_global_pasid_ida, min, max, GFP_KERNEL);
-	if (ret < min)
+	if (ret < 0)
 		goto out;
+
 	mm->pasid = ret;
 	ret = 0;
 out:
-- 
2.39.2



