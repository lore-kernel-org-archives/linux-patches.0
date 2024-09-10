Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE9F13AD09;
	Tue, 10 Sep 2024 09:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961831; cv=none; b=opWxQraAzPsubxjUX7TBypqRJf6wRvSkDxtUMoJYyqpC0gU9dart4N1M4EFIF9X9sKhnbJ3mpgjSnv1gnD6XHdPNEbr/HNwBtOMTfp/mcc6W/sZ8rb2rj74j5LnY304ipJdQ4iI+SNR/pN6HtV9eyIVPwuuIhnyrq1+VybYYddE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961831; c=relaxed/simple;
	bh=raxOPTX28mnqcZslbFQvSvRyi3Y/cWED+AFcSIoFDMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkCLGY/yo9H/41ZlQhYsHtXKcGCngydbw6+bhlGRjG5lWfMKOEKZnY6rV+mhGXaz0a55dAuZCWfAVOSt731Qh+UCBhfCH1Z1pk1hSe6vY2XXAIzOnhvx/+hdntxh7wSwisikTL2buwQqsnLgisWEvBgjaDLE0YyDipLyAmiauE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhX1f385; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhX1f385"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2500AC4CEC3;
	Tue, 10 Sep 2024 09:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961831;
	bh=raxOPTX28mnqcZslbFQvSvRyi3Y/cWED+AFcSIoFDMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhX1f385x9LyhXQD+PI6VkuE/E9K5nGvKpiyrrg4S7mQ9HPVTq8Kdl8p/hxBZCAQ9
	 01rIRNsTNMK1QHQJ+R4oWHrbkI9/mnJANPzIpfMOmRG05z6frlpFF8tN9AvCyJ72F8
	 NqGhMqPdshk356k7IKtgGT1Q7IHWrsG6RHpEIimk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Bharata B Rao <bharata@amd.com>,
	Alistair Popple <apopple@nvidia.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 204/375] cxl/region: Fix a race condition in memory hotplug notifier
Date: Tue, 10 Sep 2024 11:30:01 +0200
Message-ID: <20240910092629.360469600@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Ying <ying.huang@intel.com>

[ Upstream commit a3483ee7e6a7f2d12b5950246f4e0ef94f4a5df0 ]

In the memory hotplug notifier function of the CXL region,
cxl_region_perf_attrs_callback(), the node ID is obtained by checking
the host address range of the region. However, the address range
information is not available when the region is registered in
devm_cxl_add_region(). Additionally, this information may be removed
or added under the protection of cxl_region_rwsem during runtime. If
the memory notifier is called for nodes other than that backed by the
region, a race condition may occur, potentially leading to a NULL
dereference or an invalid address range.

The race condition is addressed by checking the availability of the
address range information under the protection of cxl_region_rwsem. To
enhance code readability and use guard(), the relevant code has been
moved into a newly added function: cxl_region_nid().

Fixes: 067353a46d8c ("cxl/region: Add memory hotplug notifier for cxl region")
Signed-off-by: Huang, Ying <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://patch.msgid.link/20240618084639.1419629-2-ying.huang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 538ebd5a64fd..cd9ccdc6bc81 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2386,14 +2386,25 @@ static bool cxl_region_update_coordinates(struct cxl_region *cxlr, int nid)
 	return true;
 }
 
+static int cxl_region_nid(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_decoder *cxld;
+
+	guard(rwsem_read)(&cxl_region_rwsem);
+	cxled = p->targets[0];
+	if (!cxled)
+		return NUMA_NO_NODE;
+	cxld = &cxled->cxld;
+	return phys_to_target_node(cxld->hpa_range.start);
+}
+
 static int cxl_region_perf_attrs_callback(struct notifier_block *nb,
 					  unsigned long action, void *arg)
 {
 	struct cxl_region *cxlr = container_of(nb, struct cxl_region,
 					       memory_notifier);
-	struct cxl_region_params *p = &cxlr->params;
-	struct cxl_endpoint_decoder *cxled = p->targets[0];
-	struct cxl_decoder *cxld = &cxled->cxld;
 	struct memory_notify *mnb = arg;
 	int nid = mnb->status_change_nid;
 	int region_nid;
@@ -2401,7 +2412,7 @@ static int cxl_region_perf_attrs_callback(struct notifier_block *nb,
 	if (nid == NUMA_NO_NODE || action != MEM_ONLINE)
 		return NOTIFY_DONE;
 
-	region_nid = phys_to_target_node(cxld->hpa_range.start);
+	region_nid = cxl_region_nid(cxlr);
 	if (nid != region_nid)
 		return NOTIFY_DONE;
 
-- 
2.43.0



