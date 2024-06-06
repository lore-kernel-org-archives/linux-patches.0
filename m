Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DB61C617F;
	Thu,  6 Jun 2024 14:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683693; cv=none; b=Ea7Vfh8E4+MGqGl+1M6ZoQbxEqkcoWfoXzBznswGDciM2bJIKV+eFZqHTn1skHiYD3pCvThM4ZwRpli/e3Ow6fsKNYBNRziKOLg7lXxt3lBKmSO2vec+R1T0YQqePeSpZ4L6APZnD3an4EOPZQnL0CrM2YOAXXb7tnmKjIT3S7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683693; c=relaxed/simple;
	bh=VRcGj2IPDdCJDbbAweftXFcQ0aDFIEfPs+KTC+tpf5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awcDmeV2Xq7nMhQypjTep3TUK6FthUmW7k8C1Yw4LuRlY3GBpGoBefpA9e5/rutIwfBSJ/jad0qQ7wuK8MCmRVfHZIzDLTgrj6AxSt6fjZWWj/m2TFVqFcw4u3AgahszIhZCriZAzu8NS3JHmVKMEWDMZ34rJ9mQdZX2xy1MlD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgJCtMNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgJCtMNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3595C32782;
	Thu,  6 Jun 2024 14:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683693;
	bh=VRcGj2IPDdCJDbbAweftXFcQ0aDFIEfPs+KTC+tpf5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgJCtMNit1zJERQhrTB8O1mLtuC9BbkhV8kIfKSK3RlmFueJ200nFS7WU1UBFdMMU
	 kulZ9uT76HmdaWuqx6O5R9oMvs/hPjpkRDhfpQB6Ze0FSndxdk2Ya0rMld9efeB2qf
	 x+4CMFfTVw40DxHQjk03OV0wA64sA8sfwcBtdztQ=
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
Subject: [PATCH 6.6 604/744] cxl/trace: Correct DPA field masks for general_media & dram events
Date: Thu,  6 Jun 2024 16:04:36 +0200
Message-ID: <20240606131751.858551050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index f01d0709c9c32..bdf24867d5174 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -252,8 +252,8 @@ TRACE_EVENT(cxl_generic_event,
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



