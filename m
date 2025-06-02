Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7105D22ACD1;
	Mon,  2 Jun 2025 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876846; cv=none; b=jSqkXGC5bkQ/2VWhMC2xvr4dkxUGSQqV58mPl9VflQnt1W/kb1DE5nhcUCQj3/U4X4L8Tc/gebdYFe0Q//UIWYqLV9/eWbhP1ljBxyWKqxw/dEUyHDcdejS7Eq+h2PsN2T/MDtELs0gOtimgHxb1urHHywLqSmV1uQ0i70q0jFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876846; c=relaxed/simple;
	bh=nctkTtGjYPGao6+8Nhm5rI1fwNUmYqfNJvZacSC6DNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2rHRs/DRlAjJUEoACfglKaXipsRfFpiXDJFUVhRd2yX5zV34kYRNWVJEXE0Ntu5DfqAfhouujU5E1i2+F59qwOUUzroz3sUk+rW7KQSvgsfQXIKHdEuqmpySO7cV+syhsNzVrwVmkjjTPXLIzYA3peZM7JHwufidDyhFGGCym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ai9TNcdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ai9TNcdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE76CC4CEEB;
	Mon,  2 Jun 2025 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876846;
	bh=nctkTtGjYPGao6+8Nhm5rI1fwNUmYqfNJvZacSC6DNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ai9TNcdk6x97Lmcd6tKnDVaG62Y1LFkAJOH82Mfg5b/JfIdWSSOkhLvKng4L7pxL3
	 vIQTyqwrmdbeHvVYerW9cCVV+1r6DECiKIbksjwHLarQP/0MyeiPRNrdKfeijbs3gA
	 aV5+P+NkMwiyo0EHRtWkvCBTcC7TeGBDouMiY5kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/325] iommu/amd/pgtbl_v2: Improve error handling
Date: Mon,  2 Jun 2025 15:46:08 +0200
Message-ID: <20250602134323.517734206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 36a1cfd497435ba5e37572fe9463bb62a7b1b984 ]

Return -ENOMEM if v2_alloc_pte() fails to allocate memory.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250227162320.5805-4-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 232d17bd941fd..c86cbbc21e882 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -264,7 +264,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 		map_size = get_alloc_page_size(pgsize);
 		pte = v2_alloc_pte(pdom->iop.pgd, iova, map_size, &updated);
 		if (!pte) {
-			ret = -EINVAL;
+			ret = -ENOMEM;
 			goto out;
 		}
 
-- 
2.39.5



