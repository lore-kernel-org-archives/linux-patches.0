Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C61522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8083DC433C7;
	Sun,  9 Jul 2023 11:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902561;
	bh=jOQNyeaFYgJc6MtCm3hHjNpCjQehGqYhSONjli8/8VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwJC7Lfnj00A33bgPvYIUa5kjcRFxmxR9XRjM3QQfAsZyW2gakYXgxMjs5AolpKmD
	 Z2l8nD0MPrCeFLNW0cgXs4DnLzhaC9I6EvyN3keEp70Mt7UVE2h6TBDARr9tqCFdyd
	 clPn98+0pK+T7vS9uClCrgoqXelC0+gK25Odhpqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 420/431] cxl/region: Fix state transitions after reset failure
Date: Sun,  9 Jul 2023 13:16:08 +0200
Message-ID: <20230709111501.033237561@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit adfe19738b71a893da62cb2e30bd6bdb4299ea67 ]

Jonathan reports that failed attempts to reset a region (teardown its
HDM decoder configuration) mistakenly advance the state of the region
to "not committed". Revert to the previous state of the region on reset
failure so that the reset can be re-attempted.

Reported-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Closes: http://lore.kernel.org/r/20230316171441.0000205b@Huawei.com
Fixes: 176baefb2eb5 ("cxl/hdm: Commit decoder state to hardware")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/168696507968.3590522.14484000711718573626.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index c1422167ab02b..1997bc1bf64aa 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -296,9 +296,11 @@ static ssize_t commit_store(struct device *dev, struct device_attribute *attr,
 	if (rc)
 		return rc;
 
-	if (commit)
+	if (commit) {
 		rc = cxl_region_decode_commit(cxlr);
-	else {
+		if (rc == 0)
+			p->state = CXL_CONFIG_COMMIT;
+	} else {
 		p->state = CXL_CONFIG_RESET_PENDING;
 		up_write(&cxl_region_rwsem);
 		device_release_driver(&cxlr->dev);
@@ -308,18 +310,20 @@ static ssize_t commit_store(struct device *dev, struct device_attribute *attr,
 		 * The lock was dropped, so need to revalidate that the reset is
 		 * still pending.
 		 */
-		if (p->state == CXL_CONFIG_RESET_PENDING)
+		if (p->state == CXL_CONFIG_RESET_PENDING) {
 			rc = cxl_region_decode_reset(cxlr, p->interleave_ways);
+			/*
+			 * Revert to committed since there may still be active
+			 * decoders associated with this region, or move forward
+			 * to active to mark the reset successful
+			 */
+			if (rc)
+				p->state = CXL_CONFIG_COMMIT;
+			else
+				p->state = CXL_CONFIG_ACTIVE;
+		}
 	}
 
-	if (rc)
-		goto out;
-
-	if (commit)
-		p->state = CXL_CONFIG_COMMIT;
-	else if (p->state == CXL_CONFIG_RESET_PENDING)
-		p->state = CXL_CONFIG_ACTIVE;
-
 out:
 	up_write(&cxl_region_rwsem);
 
-- 
2.39.2



