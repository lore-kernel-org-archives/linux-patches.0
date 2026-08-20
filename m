Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD425B0BE;
	Thu, 20 Aug 2026 17:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248097; cv=none; b=U6cAnI1I8lPfqgFIFh9LgTLBtP00SOFkpW+92JnTEKJ6Adt0hJEjtKQcn+DVzfMZKjZkr8rvJkK17Z4J0rR6/im17KanIr0SKe+xd7TBsnnW4m1OwvzyoE64yw4QYTEkwK6KtSf0LC+ag0cO4T5dO3MJcE2syUT2KL25/rerh1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248097; c=relaxed/simple;
	bh=lYJOxzWkHrRbQZDec8zhXJ2l6rCz3Q5/bBY8N8HUDlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5STBEZMFyAt+58dGYt60zEXpBk4zC3D6n/0ciOWP6mduKWYR5kKwk+vIv1tnfWuk5O21mWgpoE/aUuE+ulix48yU84+9bSA6kXIonrTp8+XJ3js8FpcExiWADdyEDCXYihNRPGuTVWnXmCyDsS7ytFifk46JCvIBt2qtB2qpsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcUyPkmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcUyPkmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157231F000E9;
	Thu, 20 Aug 2026 17:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248095;
	bh=vnm0m0a3vqNDXckbldWwDwToMFSQXmvPgKN7k3+xoNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcUyPkmXW4BbMtiaymxtnxHS1H/ZweWPspZu9xDRzVBFy8tFef731B40lfezq6mSl
	 PLifVVFOG6BK2C7wQIe8mag7iIpvVhewVsuGRtzVgLueow3po8MXl+nuQbQdIuq0i8
	 IPzsuriV40XAJgaCfZymDm9VRF0BtkpPi2JbcF6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/303] udmabuf: Do not create malformed scatterlists
Date: Thu, 20 Aug 2026 16:53:16 +0200
Message-ID: <20260820145254.967783000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 5bf888673e0dda5a53220fa0c4956271a46c353c ]

Using a sg_set_folio() loop for every 4K results in a malformed scatterlist
because sg_set_folio() has an issue with offsets > PAGE_SIZE and because
scatterlist expects the creator to build a list which consolidates any
physical contiguity.

sg_alloc_table_from_pages() creates a valid scatterlist directly from a
struct page array, so go back to that.

Remove the offsets allocation and just store an array of tail pages as it
did before the below commit. Everything wants that anyhow.

Fixes: 0c8b91ef5100 ("udmabuf: add back support for mapping hugetlb pages")
Reported-by: Julian Orth <ju.orth@gmail.com>
Closes: https://lore.kernel.org/all/20260308-scatterlist-v1-1-39c4566b0bba@gmail.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patch.msgid.link/0-v1-42779f29381a+4b9-udmabuf_sg_jgg@nvidia.com
Stable-dep-of: 504e2b4ab97a ("dma-buf/udmabuf: skip redundant cpu sync to fix cacheline EEXIST warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -72,14 +72,16 @@ static struct sg_table *get_sg_table(str
 					0, ubuf->pagecount << PAGE_SHIFT,
 					GFP_KERNEL);
 	if (ret < 0)
-		goto err;
+		goto err_alloc;
+
 	ret = dma_map_sgtable(dev, sg, direction, 0);
 	if (ret < 0)
-		goto err;
+		goto err_map;
 	return sg;
 
-err:
+err_map:
 	sg_free_table(sg);
+err_alloc:
 	kfree(sg);
 	return ERR_PTR(ret);
 }


