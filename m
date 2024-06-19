Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB16AD58;
	Wed, 19 Jun 2024 13:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802993; cv=none; b=kQd2u869/j+olBej2h2PDIVSY8ye7rt4oEvIlJzMkwood+Jv21qWQ5BzTSf4t3uniMud6mXAw/hsaXxBcg/QnNqWqvW/IXQ2cmyOEUta0Jwx0nlKVAVI7bbM3xx8fFEkoMUBHiza9fV9Mhx/Bsex9bLtCIgTIzvQSWhwnvAL9PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802993; c=relaxed/simple;
	bh=VnIVDj2ul2Y+Z/KvJ8WXoE6EuzRtNaEtfmLbBQtwWlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyO745oBPblRf8sBiM3B/P3h/aioferw/X2aKucciqy15Btu1Dsw+xqvSnBhuzegb7jHpffGZq2KqP94l31NpcnJdW3H5XWgnClL5Dr1Ivj1YLz8Day2TzVmBakqkqlVl6CeMpQ8zGc/xtg4z94LwAhu+A/FvqjhPE4gsqh050A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqOyU9JF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqOyU9JF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A48BC2BBFC;
	Wed, 19 Jun 2024 13:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802992;
	bh=VnIVDj2ul2Y+Z/KvJ8WXoE6EuzRtNaEtfmLbBQtwWlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqOyU9JFbSgIHTTZdntDu4EvOJ7lzXRxROm6H9uclIpCk2ik/Yinm4qrXaUQjPAFS
	 7bkisBe7MvaNt99pPGOMEutk9RPwDHJrcZeqnPEutkNxRaPRN0rIZXM4hUUHZaGj0m
	 RYnslm60leh9NcB9GldR2CA77m/JpOagru2FKqPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 109/281] cxl/region: Fix memregion leaks in devm_cxl_add_region()
Date: Wed, 19 Jun 2024 14:54:28 +0200
Message-ID: <20240619125614.043030949@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 49ba7b515c4c0719b866d16f068e62d16a8a3dd1 ]

Move the mode verification to __create_region() before allocating the
memregion to avoid the memregion leaks.

Fixes: 6e099264185d ("cxl/region: Add volatile region creation support")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/20240507053421.456439-1-lizhijian@fujitsu.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 812b2948b6c65..18b95149640b6 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2352,15 +2352,6 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 	struct device *dev;
 	int rc;
 
-	switch (mode) {
-	case CXL_DECODER_RAM:
-	case CXL_DECODER_PMEM:
-		break;
-	default:
-		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %d\n", mode);
-		return ERR_PTR(-EINVAL);
-	}
-
 	cxlr = cxl_region_alloc(cxlrd, id);
 	if (IS_ERR(cxlr))
 		return cxlr;
@@ -2415,6 +2406,15 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 {
 	int rc;
 
+	switch (mode) {
+	case CXL_DECODER_RAM:
+	case CXL_DECODER_PMEM:
+		break;
+	default:
+		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %d\n", mode);
+		return ERR_PTR(-EINVAL);
+	}
+
 	rc = memregion_alloc(GFP_KERNEL);
 	if (rc < 0)
 		return ERR_PTR(rc);
-- 
2.43.0



