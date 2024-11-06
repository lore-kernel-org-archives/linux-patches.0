Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A3C1DF98C;
	Wed,  6 Nov 2024 12:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896062; cv=none; b=FV77jo7VPxujq3cOSD7zG8sEyBeMmnk0FngDNW2SXWknAO3B+3gf5uJRNJG9+uvCNnNXyZD/LGMbpUgJPoM86UzBPBvR14ZLb5jzEjFnL4PbRb91KA6bjJfAVfIUoEulqyzbHd0rf4BVQVFD1e1VPrTGeb2q5Oa0PNMcSkjkLIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896062; c=relaxed/simple;
	bh=jYMTNPdOLn5aXr2eyjZuu8oFF/IyLttDXMYHpXDqepk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auIoiGBQtyVqkm11x10I8ZX8exeCqoL11vmsbvEzWXdD7RtsTvgigQIZGB9Ak5zM7MIty01FbBpjHb8b0f2M9LW+AoepLAahBnkysSm1yJsA1MVA7lkD0R+rrtSsr4UteCBSYx0er8UFpzB0ZBxH+WU/OAl4ygRWkwnHcMzDQh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYsCinod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYsCinod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE28C4CECD;
	Wed,  6 Nov 2024 12:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896062;
	bh=jYMTNPdOLn5aXr2eyjZuu8oFF/IyLttDXMYHpXDqepk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYsCinodqh8k8ihdgdQBWyYt8nlBQM8Wk7Ny6WSLQU+IgEU13yH5xSFy9h+WaeUG3
	 YceImW+55ygtdHoZj4hZaq2wPV/sbnPE2CO0Q26Mt8xMmB6GYVbaDnspvVKP/Q2liA
	 TfT5WWQ7vHFSjx0tNi4R3NoJhM5RbVwWqsPas57w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiju Jose <shiju.jose@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 076/245] cxl/events: Fix Trace DRAM Event Record
Date: Wed,  6 Nov 2024 13:02:09 +0100
Message-ID: <20241106120321.076394320@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiju Jose <shiju.jose@huawei.com>

[ Upstream commit 53ab8678e7180834be29cf56cd52825fc3427c02 ]

CXL spec rev 3.0 section 8.2.9.2.1.2 defines the DRAM Event Record.

Fix decode memory event type field of DRAM Event Record.
For e.g. if value is 0x1 it will be reported as an Invalid Address
(General Media Event Record - Memory Event Type) instead of Scrub Media
ECC Error (DRAM Event Record - Memory Event Type) and so on.

Fixes: 2d6c1e6d60ba ("cxl/mem: Trace DRAM Event Record")
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Link: https://patch.msgid.link/20241014143003.1170-1-shiju.jose@huawei.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/trace.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index 9167cfba7f592..cdffebcf20a4d 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -279,7 +279,7 @@ TRACE_EVENT(cxl_generic_event,
 #define CXL_GMER_MEM_EVT_TYPE_ECC_ERROR			0x00
 #define CXL_GMER_MEM_EVT_TYPE_INV_ADDR			0x01
 #define CXL_GMER_MEM_EVT_TYPE_DATA_PATH_ERROR		0x02
-#define show_mem_event_type(type)	__print_symbolic(type,			\
+#define show_gmer_mem_event_type(type)	__print_symbolic(type,			\
 	{ CXL_GMER_MEM_EVT_TYPE_ECC_ERROR,		"ECC Error" },		\
 	{ CXL_GMER_MEM_EVT_TYPE_INV_ADDR,		"Invalid Address" },	\
 	{ CXL_GMER_MEM_EVT_TYPE_DATA_PATH_ERROR,	"Data Path Error" }	\
@@ -373,7 +373,7 @@ TRACE_EVENT(cxl_general_media,
 		"hpa=%llx region=%s region_uuid=%pUb",
 		__entry->dpa, show_dpa_flags(__entry->dpa_flags),
 		show_event_desc_flags(__entry->descriptor),
-		show_mem_event_type(__entry->type),
+		show_gmer_mem_event_type(__entry->type),
 		show_trans_type(__entry->transaction_type),
 		__entry->channel, __entry->rank, __entry->device,
 		__print_hex(__entry->comp_id, CXL_EVENT_GEN_MED_COMP_ID_SIZE),
@@ -391,6 +391,17 @@ TRACE_EVENT(cxl_general_media,
  * DRAM Event Record defines many fields the same as the General Media Event
  * Record.  Reuse those definitions as appropriate.
  */
+#define CXL_DER_MEM_EVT_TYPE_ECC_ERROR			0x00
+#define CXL_DER_MEM_EVT_TYPE_SCRUB_MEDIA_ECC_ERROR	0x01
+#define CXL_DER_MEM_EVT_TYPE_INV_ADDR			0x02
+#define CXL_DER_MEM_EVT_TYPE_DATA_PATH_ERROR		0x03
+#define show_dram_mem_event_type(type)  __print_symbolic(type,				\
+	{ CXL_DER_MEM_EVT_TYPE_ECC_ERROR,		"ECC Error" },			\
+	{ CXL_DER_MEM_EVT_TYPE_SCRUB_MEDIA_ECC_ERROR,	"Scrub Media ECC Error" },	\
+	{ CXL_DER_MEM_EVT_TYPE_INV_ADDR,		"Invalid Address" },		\
+	{ CXL_DER_MEM_EVT_TYPE_DATA_PATH_ERROR,		"Data Path Error" }		\
+)
+
 #define CXL_DER_VALID_CHANNEL				BIT(0)
 #define CXL_DER_VALID_RANK				BIT(1)
 #define CXL_DER_VALID_NIBBLE				BIT(2)
@@ -477,7 +488,7 @@ TRACE_EVENT(cxl_dram,
 		"hpa=%llx region=%s region_uuid=%pUb",
 		__entry->dpa, show_dpa_flags(__entry->dpa_flags),
 		show_event_desc_flags(__entry->descriptor),
-		show_mem_event_type(__entry->type),
+		show_dram_mem_event_type(__entry->type),
 		show_trans_type(__entry->transaction_type),
 		__entry->channel, __entry->rank, __entry->nibble_mask,
 		__entry->bank_group, __entry->bank,
-- 
2.43.0



