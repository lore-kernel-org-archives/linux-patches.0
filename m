Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D771B250C06;
	Mon, 23 Jun 2025 13:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685714; cv=none; b=kQZtgb8Z91h1hh4mKLUUib/pUcx3vywD1gM2wj+c/Qp6Xf+QsHb91/xuAgvIAbvUBUaJEvy7E7/3nk7kGlDsspORco2cxBlzMzu5xFzvSb9TmeDDCDUDUTPZ9PpEAQj/Y8HTHomg1MxgJIKU6EEsOcq8xO1qa1c175dO472Sw/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685714; c=relaxed/simple;
	bh=INqqCv9y9C3AxJ3fAS5UL+oqu8smvU40cg/UqsylX6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/D0hEqXVzYZ75eruNDHdmib+9eLO2NIwhYT5F7JD6Z2zsEhynrWz85WCvFyaFYg2PQ+WE2llgZIiT1iW55KtVBgtF4zOKcx2u8tu2RKQaOXcX1lDXZ4QvKLKrETBzedwENJar15GhF0uF6IW7zvc8AZPSUms6iAIuDSAfmlkR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKBrJzIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKBrJzIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6F6C4CEF1;
	Mon, 23 Jun 2025 13:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685713;
	bh=INqqCv9y9C3AxJ3fAS5UL+oqu8smvU40cg/UqsylX6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKBrJzIENCu5phdXasgqGNy+Ck/H5PiewL09iPjFo7/tKKFCZiGvSiQGAMTVgrBqr
	 nZPgG33kAgpDygRq893msJK0J1K5D/zhPCGWO6hXoLyF1c3SolcBMxCOrc4ajQgat4
	 7F89mYBVTle0Xx4h+diwiKoQeRHT3mkvPo6zVGTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Xu <feng.f.xu@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/508] EDAC/skx_common: Fix general protection fault
Date: Mon, 23 Jun 2025 15:01:11 +0200
Message-ID: <20250623130645.892827235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 20d2d476b3ae18041be423671a8637ed5ffd6958 ]

After loading i10nm_edac (which automatically loads skx_edac_common), if
unload only i10nm_edac, then reload it and perform error injection testing,
a general protection fault may occur:

  mce: [Hardware Error]: Machine check events logged
  Oops: general protection fault ...
  ...
  Workqueue: events mce_gen_pool_process
  RIP: 0010:string+0x53/0xe0
  ...
  Call Trace:
  <TASK>
  ? die_addr+0x37/0x90
  ? exc_general_protection+0x1e7/0x3f0
  ? asm_exc_general_protection+0x26/0x30
  ? string+0x53/0xe0
  vsnprintf+0x23e/0x4c0
  snprintf+0x4d/0x70
  skx_adxl_decode+0x16a/0x330 [skx_edac_common]
  skx_mce_check_error.part.0+0xf8/0x220 [skx_edac_common]
  skx_mce_check_error+0x17/0x20 [skx_edac_common]
  ...

The issue arose was because the variable 'adxl_component_count' (inside
skx_edac_common), which counts the ADXL components, was not reset. During
the reloading of i10nm_edac, the count was incremented by the actual number
of ADXL components again, resulting in a count that was double the real
number of ADXL components. This led to an out-of-bounds reference to the
ADXL component array, causing the general protection fault above.

Fix this issue by resetting the 'adxl_component_count' in adxl_put(),
which is called during the unloading of {skx,i10nm}_edac.

Fixes: 123b15863550 ("EDAC, i10nm: make skx_common.o a separate module")
Reported-by: Feng Xu <feng.f.xu@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Feng Xu <feng.f.xu@intel.com>
Link: https://lore.kernel.org/r/20250417150724.1170168-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index e218909f9f9e8..c11870ac1b3c7 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -114,6 +114,7 @@ EXPORT_SYMBOL_GPL(skx_adxl_get);
 
 void skx_adxl_put(void)
 {
+	adxl_component_count = 0;
 	kfree(adxl_values);
 	kfree(adxl_msg);
 }
-- 
2.39.5



