Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC7C26AC1;
	Mon,  8 Jan 2024 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBobcQDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEA9C433C8;
	Mon,  8 Jan 2024 15:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726847;
	bh=0JoGCUz1o/Sb72F305+fS2ObP48qu5XYjMQQMgm+RbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBobcQDgWBKk8r/v1s/9MbuPLajDjS0J2JN8HqNEZ1zkAbGe4meUHH4H+e7JpuY56
	 iApofTqJZvGYeqLBUagrSHZqWGrLGB4++mNWwUKFKcQ77AdB5uZog+71gIvI4vL30F
	 gIIjYUpSPUFKo6EQfYZPdHuxzXktrQYNkonigD1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/124] cxl/core: Always hold region_rwsem while reading poison lists
Date: Mon,  8 Jan 2024 16:08:44 +0100
Message-ID: <20240108150607.481837245@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 5558b92e8d39e18aa19619be2ee37274e9592528 ]

A read of a device poison list is triggered via a sysfs attribute
and the results are logged as kernel trace events of type cxl_poison.
The work is managed by either: a) the region driver when one of more
regions map the device, or by b) the memdev driver when no regions
map the device.

In the case of a) the region driver holds the region_rwsem while
reading the poison by committed endpoint decoder mappings and for
any unmapped resources. This makes sure that the cxl_poison trace
event trace reports valid region info. (Region name, HPA, and UUID).

In the case of b) the memdev driver holds the dpa_rwsem preventing
new DPA resources from being attached to a region. However, it leaves
a gap between region attach and decoder commit actions. If a DPA in
the gap is in the poison list, the cxl_poison trace event will omit
the region info.

Close the gap by holding the region_rwsem and the dpa_rwsem when
reading poison per memdev. Since both methods now hold both locks,
down_read both from the caller. Doing so also addresses the lockdep
assert that found this issue:
Commit 458ba8189cb4 ("cxl: Add cxl_decoders_committed() helper")

Fixes: f0832a586396 ("cxl/region: Provide region info to the cxl_poison trace event")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/08e8e7ec9a3413b91d51de39e385653494b1eed0.1701041440.git.alison.schofield@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/memdev.c | 9 ++++++++-
 drivers/cxl/core/region.c | 5 -----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index fc5c2b414793b..5ad1b13e780af 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -227,10 +227,16 @@ int cxl_trigger_poison_list(struct cxl_memdev *cxlmd)
 	if (!port || !is_cxl_endpoint(port))
 		return -EINVAL;
 
-	rc = down_read_interruptible(&cxl_dpa_rwsem);
+	rc = down_read_interruptible(&cxl_region_rwsem);
 	if (rc)
 		return rc;
 
+	rc = down_read_interruptible(&cxl_dpa_rwsem);
+	if (rc) {
+		up_read(&cxl_region_rwsem);
+		return rc;
+	}
+
 	if (cxl_num_decoders_committed(port) == 0) {
 		/* No regions mapped to this memdev */
 		rc = cxl_get_poison_by_memdev(cxlmd);
@@ -239,6 +245,7 @@ int cxl_trigger_poison_list(struct cxl_memdev *cxlmd)
 		rc =  cxl_get_poison_by_endpoint(port);
 	}
 	up_read(&cxl_dpa_rwsem);
+	up_read(&cxl_region_rwsem);
 
 	return rc;
 }
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 9d60020c5cb3b..e7206367ec669 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2467,10 +2467,6 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 	struct cxl_poison_context ctx;
 	int rc = 0;
 
-	rc = down_read_interruptible(&cxl_region_rwsem);
-	if (rc)
-		return rc;
-
 	ctx = (struct cxl_poison_context) {
 		.port = port
 	};
@@ -2480,7 +2476,6 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 		rc = cxl_get_poison_unmapped(to_cxl_memdev(port->uport_dev),
 					     &ctx);
 
-	up_read(&cxl_region_rwsem);
 	return rc;
 }
 
-- 
2.43.0



