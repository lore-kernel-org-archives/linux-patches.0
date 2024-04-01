Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0BCC129;
	Mon,  1 Apr 2024 16:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988532; cv=none; b=gSuWqFUaLZadf17a6jR7isxQCQa4RHG5vN2gGh8n6grIQwYzq8RD9N9E6DjPCF38ARFFIQNz5LCrZYdg3/Ng2RR9pHm6Rx8FH9zoSyew6L1BvIhxkExIt1AWNsv6pHe4sY/SdYnsnNDnYBuUXLwWp/nx9xcgIAoERuV+tV+Nvek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988532; c=relaxed/simple;
	bh=yU8J3Y3T/sjfwtNI7Wv61S6ZBHvjvTNOUZ4B9zB2Kfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMJz64E7usCzrgo9KojGMyDrlPmOaXTiOIZpzN1Y5JiK7uW3Ie4uB+s9yUhQzH2ZuVib3yBuBFgG0r8ZSvYIPzDB4tzm+jVmocCtSCmsSwikSFdhC/rWMDFpA4vsp8Tkgi+2A/Djd4zdYfqmMQzxUHpJnO4f2BGn3tiTgk7yIH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eczy/J2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eczy/J2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58777C433F1;
	Mon,  1 Apr 2024 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988531;
	bh=yU8J3Y3T/sjfwtNI7Wv61S6ZBHvjvTNOUZ4B9zB2Kfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eczy/J2HOiGR08/mLP3ZDUBz0qhy1hmKfyNX9tsZklGeJWTJ9O3uoEkbs85q9b/4b
	 HfQ5wotzW4O5P0L2+SHhqnw7JvQSVmiDBZvjFzl8S/M+f8f9RRlFhMGyuviQkwUXqH
	 5EVtPrMzz2atOhMC49/KzjaFOwhY4kh1d7VB7RjY=
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
Subject: [PATCH 6.7 195/432] cxl/trace: Properly initialize cxl_poison region name
Date: Mon,  1 Apr 2024 17:43:02 +0200
Message-ID: <20240401152558.957086115@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



