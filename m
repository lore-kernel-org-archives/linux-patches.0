Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E608F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2DFC433C7;
	Sun, 16 Jul 2023 20:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538755;
	bh=jRSihTJI2EMdEgMB0WWBFvNNICXqTi0ER/XzAzwH8v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BykCqFZIcxIo7m43yWUltrZkRcXKvkDvXFJ6yQ77ygGoZg0kqHg0A7yBx1g1RTfrO
	 e4OXZZO1Vv1xJuSfNUDOEvdWjbKXd7HFSmBqp7s+94GPjAq4JXGXGzz/6/4go/q1vY
	 6LaVuU/vyqFLJxrgWqccwPgVVvj5NIMDjwP8AmYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 535/800] cxl/region: Flag partially torn down regions as unusable
Date: Sun, 16 Jul 2023 21:46:28 +0200
Message-ID: <20230716195001.521202249@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 2ab47045ac96a605e3037d479a7d5854570ee5bf ]

cxl_region_decode_reset() walks all the decoders associated with a given
region and disables them. Due to decoder ordering rules it is possible
that a switch in the topology notices that a given decoder can not be
shutdown before another region with a higher HPA is shutdown first. That
can leave the region in a partially committed state.

Capture that state in a new CXL_REGION_F_NEEDS_RESET flag and require
that a successful cxl_region_decode_reset() attempt must be completed
before cxl_region_probe() accepts the region.

This is a corollary for the bug that Jonathan identified in "CXL/region
:  commit reset of out of order region appears to succeed." [1].

Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Link: http://lore.kernel.org/r/20230316171441.0000205b@Huawei.com [1]
Fixes: 176baefb2eb5 ("cxl/hdm: Commit decoder state to hardware")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/168696507423.3590522.16254212607926684429.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 12 ++++++++++++
 drivers/cxl/cxl.h         |  8 ++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 594ce3c2565df..fa29bd2ec3227 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -182,14 +182,19 @@ static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
 				rc = cxld->reset(cxld);
 			if (rc)
 				return rc;
+			set_bit(CXL_REGION_F_NEEDS_RESET, &cxlr->flags);
 		}
 
 endpoint_reset:
 		rc = cxled->cxld.reset(&cxled->cxld);
 		if (rc)
 			return rc;
+		set_bit(CXL_REGION_F_NEEDS_RESET, &cxlr->flags);
 	}
 
+	/* all decoders associated with this region have been torn down */
+	clear_bit(CXL_REGION_F_NEEDS_RESET, &cxlr->flags);
+
 	return 0;
 }
 
@@ -2864,6 +2869,13 @@ static int cxl_region_probe(struct device *dev)
 		goto out;
 	}
 
+	if (test_bit(CXL_REGION_F_NEEDS_RESET, &cxlr->flags)) {
+		dev_err(&cxlr->dev,
+			"failed to activate, re-commit region and retry\n");
+		rc = -ENXIO;
+		goto out;
+	}
+
 	/*
 	 * From this point on any path that changes the region's state away from
 	 * CXL_CONFIG_COMMIT is also responsible for releasing the driver.
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 70ab8fcd0377c..dcebe48bb5bb5 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -469,6 +469,14 @@ struct cxl_region_params {
  */
 #define CXL_REGION_F_AUTO 0
 
+/*
+ * Require that a committed region successfully complete a teardown once
+ * any of its associated decoders have been torn down. This maintains
+ * the commit state for the region since there are committed decoders,
+ * but blocks cxl_region_probe().
+ */
+#define CXL_REGION_F_NEEDS_RESET 1
+
 /**
  * struct cxl_region - CXL region
  * @dev: This region's device
-- 
2.39.2



