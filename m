Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F249C3E3174;
	Tue, 31 Mar 2026 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974336; cv=none; b=O203/SdfNSAIBpapGQY2aUzMbFukofi8sAkxdvBnahf3uyZ4sEJPnkI5FEatwpY2OGVGV8Xa/VAsMwd2iixRBeLCv8/TAvAagUg6hJ3B4bz8OmkGoVYbK5Lq3iJ2u0RfzwkZNmPZTfXE0LnjufwzwP62rj5oCmS7D95C2G+v2o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974336; c=relaxed/simple;
	bh=rD2li+y8znJqUwQvaciEPf6oges0oS9hueLzt37EfIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKKDAcNfiMAKXSaO+Kz1tGWmez76OzyZhNaXePT9AnrRES+5+UtOPHeYjqy7Xm0wdp6n4/Pi4doTBrn2Lpu22AVyd5r0LhDD7sXf36tUbDbKAFcxz0s6JK3ZScXLdlDuvITerMWh7kQRyjRqSgUUrQZXSsffK0MrR1+J+bYXFic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k72eTs9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k72eTs9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A28C19423;
	Tue, 31 Mar 2026 16:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974335;
	bh=rD2li+y8znJqUwQvaciEPf6oges0oS9hueLzt37EfIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k72eTs9VtMwF44yGR479MQ0rsY2XlspP73ZMxtP7vt4Mj34r6G7dsZglvzshc6xkB
	 8+bMtpFo3VdUqnWGFZZySie8OUcr43ksCyhp/3TE6Dk3VhbJu60UUiZmBj5v2jwH0h
	 yyjmiXFVAQ+AhaG63jsWXwhz1UddIM9wlrylJshI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/175] cxl/hdm: Avoid incorrect DVSEC fallback when HDM decoders are enabled
Date: Tue, 31 Mar 2026 18:19:47 +0200
Message-ID: <20260331161729.909978788@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

[ Upstream commit 75cea0776de502f2a1be5ca02d37c586dc81887e ]

Check the global CXL_HDM_DECODER_ENABLE bit instead of looping over
per-decoder COMMITTED bits to determine whether to fall back to DVSEC
range emulation. When the HDM decoder capability is globally enabled,
ignore DVSEC range registers regardless of individual decoder commit
state.

should_emulate_decoders() currently loops over per-decoder COMMITTED
bits, which leads to an incorrect DVSEC fallback when those bits are
zero. One way to trigger this is to destroy a region and bounce the
memdev:

  cxl disable-region region0
  cxl destroy-region region0
  cxl disable-memdev mem0
  cxl enable-memdev mem0

Region teardown zeroes the HDM decoder registers including the committed
bits. The subsequent memdev re-probe finds uncommitted decoders and falls
back to DVSEC emulation, even though HDM remains globally enabled.

Observed failures:

  should_emulate_decoders: cxl_port endpoint6: decoder6.0: committed: 0 base: 0x0_00000000 size: 0x0_00000000
  devm_cxl_setup_hdm: cxl_port endpoint6: Fallback map 1 range register
  ..
  devm_cxl_add_region: cxl_acpi ACPI0017:00: decoder0.0: created region0
  __construct_region: cxl_pci 0000:e1:00.0: mem1:decoder6.0:
  __construct_region region0 res: [mem 0x850000000-0x284fffffff flags 0x200] iw: 1 ig: 4096
  cxl region0: pci0000:e0:port1 cxl_port_setup_targets expected iw: 1 ig: 4096 ..
  cxl region0: pci0000:e0:port1 cxl_port_setup_targets got iw: 1 ig: 256 state: disabled ..
  cxl_port endpoint6: failed to attach decoder6.0 to region0: -6
  ..
  devm_cxl_add_region: cxl_acpi ACPI0017:00: decoder0.0: created region4
  alloc_hpa: cxl region4: HPA allocation error (-34) ..

Fixes: 52cc48ad2a76 ("cxl/hdm: Limit emulation to the number of range registers")
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260316201950.224567-1-Smita.KoralahalliChannabasappa@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/hdm.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index f9738c863df0e..dc4dff7a2d38d 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -119,7 +119,6 @@ static bool should_emulate_decoders(struct cxl_endpoint_dvsec_info *info)
 	struct cxl_hdm *cxlhdm;
 	void __iomem *hdm;
 	u32 ctrl;
-	int i;
 
 	if (!info)
 		return false;
@@ -138,22 +137,16 @@ static bool should_emulate_decoders(struct cxl_endpoint_dvsec_info *info)
 		return false;
 
 	/*
-	 * If any decoders are committed already, there should not be any
-	 * emulated DVSEC decoders.
+	 * If HDM decoders are globally enabled, do not fall back to DVSEC
+	 * range emulation. Zeroed decoder registers after region teardown
+	 * do not imply absence of HDM capability.
+	 *
+	 * Falling back to DVSEC here would treat the decoder as AUTO and
+	 * may incorrectly latch default interleave settings.
 	 */
-	for (i = 0; i < cxlhdm->decoder_count; i++) {
-		ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(i));
-		dev_dbg(&info->port->dev,
-			"decoder%d.%d: committed: %ld base: %#x_%.8x size: %#x_%.8x\n",
-			info->port->id, i,
-			FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMITTED, ctrl),
-			readl(hdm + CXL_HDM_DECODER0_BASE_HIGH_OFFSET(i)),
-			readl(hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(i)),
-			readl(hdm + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(i)),
-			readl(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(i)));
-		if (FIELD_GET(CXL_HDM_DECODER0_CTRL_COMMITTED, ctrl))
-			return false;
-	}
+	ctrl = readl(hdm + CXL_HDM_DECODER_CTRL_OFFSET);
+	if (ctrl & CXL_HDM_DECODER_ENABLE)
+		return false;
 
 	return true;
 }
-- 
2.51.0



