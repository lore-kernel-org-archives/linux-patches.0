Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632F0408026;
	Tue, 21 Jul 2026 18:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657235; cv=none; b=XEXEHScTAGilA5dLvNYh8G6uHbN0yvZ4VRFx9+scCZIwJ7VbJvsDIO67vIe0egjCtKTGyQvzeAYxdo+RJ2VP4mcGV7IfhTwsABOlLwhgxxVKYWCjJ3C71kJhHSGq8aQd0abyNFOlpHkT1OmxKYlPOBU/aV/lXEMGSi5KlzeZyfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657235; c=relaxed/simple;
	bh=IUJfDO1rHD8NHzVS+HamyamLGzcHn6SlczRE7w0ZXyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DiABSEYCbr9RAAxauZRPjjRlg7yUKqdiHcjru+Qg+dLF78FYwPuMOK93EC4XJV6m22zGt+B4YnzPg73N9nKYy9uiXJ8Ud+0kh5mT7REEqorRVMwiYnqvCqkExNbWhe63NRh0WgIyo/buoJkynBmMJWpGpShyMrTJ2VvrM36c6AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSTsw8RX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSTsw8RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6691F000E9;
	Tue, 21 Jul 2026 18:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657234;
	bh=CDo0IMt52a59/uhgP4yDv1yiyVmNT8xugMu32tQqxCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSTsw8RXTtXpqUZ2OXO0U44qfmXGVDGMcSCGk9ALBTOFv+lYk2rvAbAfa0eXtHLVD
	 yUGfcGv0xkF7jEoIJQr3gGJ7+PJXJb/pIaFUarnOayYpM29pNvgHQkzT5HNv9K4BsZ
	 DKvZaFQz7Fz1iQzUtQ1aU59cZczanITHcEBKbzPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0687/1611] platform/x86/intel/vsec: Restore BAR fallback for header walk
Date: Tue, 21 Jul 2026 17:13:23 +0200
Message-ID: <20260721152530.834697689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4e2e9f6a586b11..1e292eaeb209d6 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -465,10 +465,25 @@ static int intel_vsec_walk_header(struct device *dev,
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



