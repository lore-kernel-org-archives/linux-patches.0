Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49956199385;
	Thu,  6 Jun 2024 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682996; cv=none; b=cuS+Yc5TDI1/zOO4XHyhWi9vAOORGDDPUftO29yccc/QHxqO8hRT4VNteFk53HJYe3W5hq1WZgbn1L54uJBSN19jW4wiCwfSbxRmycC6/vG7a4SQ7w/bkMhF4d7vtajdkKx3KeiUEWNOMQD0YYS9Zhp2sJVI6rgW0NigWmIUNGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682996; c=relaxed/simple;
	bh=kZJALDooGR/Ox7RlfDbguc8IXCpsAK5mY9LZGl0WpiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKI2jB8caF4+KX4n4ZQAxCbHbL2jDSwKs7gfd59dxbrUTzppVo+4tbYd9b2K+RznTAFEBxxouJ0oLE5WnZF9PCZKluFh1XYvhmbEWcvrz4JSFhzGnDF+BBHW8WWNvVW4bsSskqkCw+gSd4JeFoo17xxPP5IPfc/c1rSNVB5SEWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agx4vVFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agx4vVFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27189C2BD10;
	Thu,  6 Jun 2024 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682996;
	bh=kZJALDooGR/Ox7RlfDbguc8IXCpsAK5mY9LZGl0WpiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agx4vVFUYdONSqlB1oZJoiWC88CXl8Zi4Nok2damYVEV4xErccnfLnx1BLCmmvHja
	 KKVV4LROiTM3/r6c5g0YDrYXwZtgNbP4HAgp0h+EnF75KvAmY654+9V4Qj59Ux98Xc
	 mbkkh+eA6SzGQfScWtiaxRZiDYRe8jOr3DZ1HI+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 195/374] cxl/trace: Correct DPA field masks for general_media & dram events
Date: Thu,  6 Jun 2024 16:02:54 +0200
Message-ID: <20240606131658.380959588@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 2042d11cb57b7e0cbda7910e5ff80e9e8bf0ae17 ]

The length of Physical Address in General Media and DRAM event
records is 64-bit, so the field mask for extracting the DPA should
be 64-bit also, otherwise the trace event reports DPA's with the
upper 32 bits of a DPA address masked off. If users do DPA-to-HPA
translations this could lead to incorrect page retirement decisions.

Use GENMASK_ULL() for CXL_DPA_MASK to get all the DPA address bits.

Tidy up CXL_DPA_FLAGS_MASK by using GENMASK() to only mask the exact
flag bits.

These bits are defined as part of the event record physical address
descriptions of General Media and DRAM events in CXL Spec 3.1
Section 8.2.9.2 Events.

Fixes: d54a531a430b ("cxl/mem: Trace General Media Event Record")
Co-developed-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/2867fc43c57720a4a15a3179431829b8dbd2dc16.1714496730.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index e5f13260fc524..7c5cd069f10cc 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -253,8 +253,8 @@ TRACE_EVENT(cxl_generic_event,
  * DRAM Event Record
  * CXL rev 3.0 section 8.2.9.2.1.2; Table 8-44
  */
-#define CXL_DPA_FLAGS_MASK			0x3F
-#define CXL_DPA_MASK				(~CXL_DPA_FLAGS_MASK)
+#define CXL_DPA_FLAGS_MASK			GENMASK(1, 0)
+#define CXL_DPA_MASK				GENMASK_ULL(63, 6)
 
 #define CXL_DPA_VOLATILE			BIT(0)
 #define CXL_DPA_NOT_REPAIRABLE			BIT(1)
-- 
2.43.0



