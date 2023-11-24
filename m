Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7D02D626;
	Fri, 24 Nov 2023 18:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUoGg0qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE80C433C7;
	Fri, 24 Nov 2023 18:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851269;
	bh=A7LM0W+oWegUi1gbwQcr9UeIN/dSEsdf3g/Eh6Om1yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUoGg0quKRQotIaEe5zUp4ZPCPFeWuLCzkHP72G0QIQqfBpdz+ijMFoBzL7xje1FP
	 mZPvaPO4xhoAsdsRzR6PHRzn5o73kjxh9H0e5YKctFTjo1z0R/hdXR05jzX0qdCdq/
	 UqX8ZpUIYEDFu6RDCOXWAw8i1XYTvHbSqJFZgrw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Harris <jim.harris@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.5 355/491] cxl/region: Do not try to cleanup after cxl_region_setup_targets() fails
Date: Fri, 24 Nov 2023 17:49:51 +0000
Message-ID: <20231124172035.238743395@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Harris <jim.harris@samsung.com>

commit 0718588c7aaa7a1510b4de972370535b61dddd0d upstream.

Commit 5e42bcbc3fef ("cxl/region: decrement ->nr_targets on error in
cxl_region_attach()") tried to avoid 'eiw' initialization errors when
->nr_targets exceeded 16, by just decrementing ->nr_targets when
cxl_region_setup_targets() failed.

Commit 86987c766276 ("cxl/region: Cleanup target list on attach error")
extended that cleanup to also clear cxled->pos and p->targets[pos]. The
initialization error was incidentally fixed separately by:
Commit 8d4285425714 ("cxl/region: Fix port setup uninitialized variable
warnings") which was merged a few days after 5e42bcbc3fef.

But now the original cleanup when cxl_region_setup_targets() fails
prevents endpoint and switch decoder resources from being reused:

1) the cleanup does not set the decoder's region to NULL, which results
   in future dpa_size_store() calls returning -EBUSY
2) the decoder is not properly freed, which results in future commit
   errors associated with the upstream switch

Now that the initialization errors were fixed separately, the proper
cleanup for this case is to just return immediately. Then the resources
associated with this target get cleanup up as normal when the failed
region is deleted.

The ->nr_targets decrement in the error case also helped prevent
a p->targets[] array overflow, so add a new check to prevent against
that overflow.

Tested by trying to create an invalid region for a 2 switch * 2 endpoint
topology, and then following up with creating a valid region.

Fixes: 5e42bcbc3fef ("cxl/region: decrement ->nr_targets on error in cxl_region_attach()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jim Harris <jim.harris@samsung.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/169703589120.1202031.14696100866518083806.stgit@bgt-140510-bm03.eng.stellus.in
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1676,6 +1676,12 @@ static int cxl_region_attach(struct cxl_
 		return -ENXIO;
 	}
 
+	if (p->nr_targets >= p->interleave_ways) {
+		dev_dbg(&cxlr->dev, "region already has %d endpoints\n",
+			p->nr_targets);
+		return -EINVAL;
+	}
+
 	ep_port = cxled_to_port(cxled);
 	root_port = cxlrd_to_port(cxlrd);
 	dport = cxl_find_dport_by_dev(root_port, ep_port->host_bridge);
@@ -1768,7 +1774,7 @@ static int cxl_region_attach(struct cxl_
 	if (p->nr_targets == p->interleave_ways) {
 		rc = cxl_region_setup_targets(cxlr);
 		if (rc)
-			goto err_decrement;
+			return rc;
 		p->state = CXL_CONFIG_ACTIVE;
 	}
 
@@ -1800,12 +1806,6 @@ static int cxl_region_attach(struct cxl_
 	}
 
 	return 0;
-
-err_decrement:
-	p->nr_targets--;
-	cxled->pos = -1;
-	p->targets[pos] = NULL;
-	return rc;
 }
 
 static int cxl_region_detach(struct cxl_endpoint_decoder *cxled)


