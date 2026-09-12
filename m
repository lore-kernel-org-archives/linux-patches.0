Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C4E2D739C;
	Sat, 12 Sep 2026 13:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218923; cv=none; b=j9ayXmdWZsKd/H0JBeQfh4cr+2DYga5WsamExuDpcO3bbDcUbLu4p6q8GTnXRNrqWu8WN/Ueeyzf++ZpCkv7YEMgoh2bO4IAN6OIpkiq0ioQ/YSye2d9Go+kjJ44ZJ0Eo2MvQZ5zC87/LicXMuXNl4UldI7959pte9FgWjdxX1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218923; c=relaxed/simple;
	bh=TE/KwobZPcMPk3WnohtNNpkwI/2s8uaBXWke0yOVaZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Za9ior5zIJkgPTpQVpSLWmKkGC2W0zabEPQcnDlhbw6T6blfTqIQcrm7lRbiv+ltL+iOa5FJvHt0rV942kCPtN1fkG8fPhy1fLcpcg0vhAH2nnNFSTNgX+g6qTFAdtViSvipLY3qxIsBpz9qi7gbv7p/99TJyF8HFvlyM0sziA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adp2he6/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adp2he6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4C31F000FF;
	Sat, 12 Sep 2026 13:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218922;
	bh=Zo/xIdPmzKQ9bZNfRtUcjtNGLPLm5wAHAISvoK5uou4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Adp2he6/G6D0T6sya6Mo876HDt8uR51NwO0Je2Htp9HGIJ+eVur0gImSfpQfUc/7H
	 hbq47ktfDzBegLGNiu7CTdPUa82/oF+QXx4iOGhB54uyB+X50XCBBnXDZSV5riyVLy
	 yONFVwcJ5LujpCR1h6SIo2gN0gk9Km+o01MQx9vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1243/1376] RDMA/ucma: Allow path records to exactly fit the output buffer
Date: Sat, 12 Sep 2026 09:01:09 +0200
Message-ID: <20260912065635.247901138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 8049741ac93acd3a590dac070e12571fddf0e294 ]

ucma_query_path() emits a path record only when the remaining output
buffer is strictly larger than struct ib_path_rec_data. A buffer sized
exactly for the response header and N complete records therefore gets
only N - 1 records, while resp->num_paths still advertises N. A caller
sizing its buffer for a single record gets a header claiming one path
and no path data at all.

ucma_query_ib_service() in the same file computes the record count with
a plain division and so accepts an exact fit; make ucma_query_path()
behave the same way.

Current librdmacm is unaffected because it always sizes the response for
six records while the kernel currently reports at most two paths. Other
users of the UAPI that provide an exactly sized buffer can observe the
truncated response.

Fixes: ac53b264b2f3 ("RDMA/ucma: Support querying when IB paths are not reversible")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20260806201358.147478-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/ucma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b270799924889..5abab926e3354 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -922,7 +922,7 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
 
 	resp->num_paths = ctx->cm_id->route.num_pri_alt_paths;
 	for (i = 0, out_len -= sizeof(*resp);
-	     i < resp->num_paths && out_len > sizeof(struct ib_path_rec_data);
+	     i < resp->num_paths && out_len >= sizeof(struct ib_path_rec_data);
 	     i++, out_len -= sizeof(struct ib_path_rec_data)) {
 		struct sa_path_rec *rec = &ctx->cm_id->route.path_rec[i];
 
-- 
2.53.0



