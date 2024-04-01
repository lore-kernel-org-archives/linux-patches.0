Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19719481BF;
	Mon,  1 Apr 2024 16:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989850; cv=none; b=WvcxFD8+ZefygkIGbelet8PQ2X3ABYPVPnyAqDRhOFp1waZjJ5dxsnGB12V6/FU2DUCZ85Af8awt1+C56/ACV8Jctb6CfUTMQyu/D8wvirwpQDPuzG+s1oj+1NY+hhkXpObopqQJ/A/L1LQ2uWPk8/jWRbkBqdagzP8eN8QM8cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989850; c=relaxed/simple;
	bh=V+JeAGk7sWJtMWZVUoJIEvOV97yGx5Vvj2rdaeOATdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgzxjZawvyU6sWgagQkFfUhlki61mI2Sxh22PLfB05I/K9d3UV+Ap/O8OLglh5+hkhPEclCkWnDCWVHjdlYUZF7LGt907F2oJfVoGXiCf9kjw4ECbUDjPAsjeu9NclPxZLdET/ZIIGHuUzF2m0z2Ol1x6lUOOj9SDz8hjDNCn9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=so3jBO5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="so3jBO5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79720C433F1;
	Mon,  1 Apr 2024 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989850;
	bh=V+JeAGk7sWJtMWZVUoJIEvOV97yGx5Vvj2rdaeOATdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=so3jBO5YcctkGcyer7+FUjgrhbkV57Q1WDcDx4/uGr+jod86za8PLtNZj3wtKHuD6
	 9b4TNjTrD9G4CWfzRW9BZkbQpIs9NVPhyobRrEytRBH9HCPcLOHagHr1FfmlOinJRI
	 jlH6qgah62DgS0mNUz8Z/BY+VdPtq4LV9r/+sbm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/396] cxl/trace: Properly initialize cxl_poison region name
Date: Mon,  1 Apr 2024 17:43:40 +0200
Message-ID: <20240401152553.039652038@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

[ Upstream commit 6c871260965255a1c142fb77ccee58b172d1690b ]

The TP_STRUCT__entry that gets assigned the region name, or an
empty string if no region is present, is erroneously initialized
to the cxl_region pointer. It needs to be properly initialized
otherwise it's length is wrong and garbage chars can appear in
the kernel trace output: /sys/kernel/tracing/trace

The bad initialization was due in part to a naming conflict with
the parameter: struct cxl_region *region. The field 'region' is
already exposed externally as the region name, so changing that
to something logical, like 'region_name' is not an option. Instead
rename the internal only struct cxl_region to the commonly used
'cxlr'.

Impact is that tooling depending on that trace data can miss
picking up a valid event when searching by region name. The
TP_printk() output, if enabled, does emit the correct region
names in the dmesg log.

This was found during testing of the cxl-list option to report
media-errors for a region.

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: stable@vger.kernel.org
Fixes: ddf49d57b841 ("cxl/trace: Add TRACE support for CXL media-error records")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/trace.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index a0b5819bc70b3..f01d0709c9c32 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -642,18 +642,18 @@ u64 cxl_trace_hpa(struct cxl_region *cxlr, struct cxl_memdev *memdev, u64 dpa);
 
 TRACE_EVENT(cxl_poison,
 
-	TP_PROTO(struct cxl_memdev *cxlmd, struct cxl_region *region,
+	TP_PROTO(struct cxl_memdev *cxlmd, struct cxl_region *cxlr,
 		 const struct cxl_poison_record *record, u8 flags,
 		 __le64 overflow_ts, enum cxl_poison_trace_type trace_type),
 
-	TP_ARGS(cxlmd, region, record, flags, overflow_ts, trace_type),
+	TP_ARGS(cxlmd, cxlr, record, flags, overflow_ts, trace_type),
 
 	TP_STRUCT__entry(
 		__string(memdev, dev_name(&cxlmd->dev))
 		__string(host, dev_name(cxlmd->dev.parent))
 		__field(u64, serial)
 		__field(u8, trace_type)
-		__string(region, region)
+		__string(region, cxlr ? dev_name(&cxlr->dev) : "")
 		__field(u64, overflow_ts)
 		__field(u64, hpa)
 		__field(u64, dpa)
@@ -673,10 +673,10 @@ TRACE_EVENT(cxl_poison,
 		__entry->source = cxl_poison_record_source(record);
 		__entry->trace_type = trace_type;
 		__entry->flags = flags;
-		if (region) {
-			__assign_str(region, dev_name(&region->dev));
-			memcpy(__entry->uuid, &region->params.uuid, 16);
-			__entry->hpa = cxl_trace_hpa(region, cxlmd,
+		if (cxlr) {
+			__assign_str(region, dev_name(&cxlr->dev));
+			memcpy(__entry->uuid, &cxlr->params.uuid, 16);
+			__entry->hpa = cxl_trace_hpa(cxlr, cxlmd,
 						     __entry->dpa);
 		} else {
 			__assign_str(region, "");
-- 
2.43.0



