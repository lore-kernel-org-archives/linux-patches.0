Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC9742A7B4;
	Tue, 21 Jul 2026 19:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660465; cv=none; b=UXGihAfhUplASSNAT6llrvC6YEeB+071pl3JAo6yqGohN8QTIrvZyDt57aRTaGI3BzL8HyBLcDD3R4DBi88tYSjxhbtdq/6++S3Zpkbj3T7PhglG0cABPafT6GdheRCJ4eNaa5jeR/qH83iV3elOaLMH99MVibOBtaLfUFyrYDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660465; c=relaxed/simple;
	bh=bZ0sGN2jbi8UsTUdSiPCuiLVLJNVMQrCDd1pf+4HjIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Or3VdVVqv4DfL3exqlwTkxhZIIrhB618UVNVT9WKLr9WtX3dZrz4EzVhbOpcDV2wRHK1V3HxmTtItr+6nfTdUQsh3B/8u4yIH/4LV5VQMgnJ0rhCj2fI2LbOlGfV5kLjBaTN4wUsrfinecXacHvUjWUf4awXOvZbANkYckVgbW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9q7KReF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9q7KReF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933C01F00ACA;
	Tue, 21 Jul 2026 19:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660436;
	bh=hfPjS6j8avZRHBGWjzQm8ApS5YT5hw5R925KoUcbelQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9q7KReFqXjVlOLPPhsleKnFT7TcSfTSi4csenZzB4OG+5Z9cFRjHlrqOo6IHeR8+
	 C5wHSxjGjMSaNCZQkNpsvX034G/eudxAgdmCYgr7vOS6E11L8wuGLmBoVwsfV4a/z1
	 Jur2M69p2qUfiWlKg5+RiGVi5BLTVLN7R5eeEKeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0980/2077] platform/x86/intel/vsec: Restore BAR fallback for header walk
Date: Tue, 21 Jul 2026 17:10:53 +0200
Message-ID: <20260721152615.934673903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit 375bbbbd112af028ee0b45d833a6233c23d19bbf ]

The base_addr refactor changed intel_vsec_walk_header() to pass
info->base_addr as the discovery-table base address. For the PCI VSEC
driver this info comes from driver_data, but exported callers may provide
their own static headers and leave base_addr unset.

For xe, this made the discovery-table base address zero instead of the BAR
selected by header->tbir, preventing PMT endpoints from being created.

Restore the previous behavior for the header-walk path by falling back to
pci_resource_start(pdev, header->tbir) when base_addr is not specified.
Keep explicit base_addr override behavior unchanged.

This preserves the refactor structure while fixing the functional
regression in manual-header users.

Fixes: 904b333fc51c ("platform/x86/intel/vsec: Refactor base_addr handling")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20260529183150.129744-1-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 18e4a892bf0f0f..439c0c8ac896c7 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -488,10 +488,25 @@ static int intel_vsec_walk_header(struct device *dev,
 				  const struct intel_vsec_platform_info *info)
 {
 	struct intel_vsec_header **header = info->headers;
+	u64 base_addr;
 	int ret;
 
 	for ( ; *header; header++) {
-		ret = intel_vsec_register_device(dev, *header, info, info->base_addr);
+		if (info->base_addr) {
+			base_addr = info->base_addr;
+		} else {
+			struct pci_dev *pdev;
+
+			if (!dev_is_pci(dev)) {
+				dev_err(dev, "non-PCI device without a base address\n");
+				return -EINVAL;
+			}
+
+			pdev = to_pci_dev(dev);
+			base_addr = pci_resource_start(pdev, (*header)->tbir);
+		}
+
+		ret = intel_vsec_register_device(dev, *header, info, base_addr);
 		if (ret)
 			return ret;
 	}
-- 
2.53.0



