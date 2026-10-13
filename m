Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278A14F55C6;
	Tue, 13 Oct 2026 12:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894084; cv=none; b=bd4LUubX7iXYR27RcG6tR77xveMJlYjK6RB/5KVvSJ5r71BKMcjqz3nRRNHDydwkvDfHiiW6TgO1Gu/f+s21md2ur/F+ilpsR5zpbM7TPvtRXsLOhEvofe9G9w3Cn2Brwj9tZn99FKKb/HSI9i6ko5GLJ3TQVr3YAFZOtboVHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894084; c=relaxed/simple;
	bh=bTFZdcgfULs1uCggu4gExPTL3tm8hP47RF/+eJP+7Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kycT6Z5LObtaSvFgM6hmUDFgO33etmFYRhGJt+uFxXG7L9mTt3zIy8sg/ejD2q2pd2ZNZlN7toA6+M8MfzMSisbmSc5uOqHp/OVJSzKFy0PgSjBKQVIju8fGjQoRIov6nN1guUa5QK+XSzyiRpmeBcPpSBaoGoC2cd1CAhgCA8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSiieMwz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSiieMwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE6C1F000FF;
	Tue, 13 Oct 2026 12:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894083;
	bh=6Z5gzHvs29JqiGnj+Nu+8jX+l9HRa6B/BajKdE6AFxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSiieMwzFNdh0oyyEewAifDyltrbaLNIYnP4mOirYXqWqhA7EPg8sCBHWjqRhuF3M
	 uf5hCG9vaflR+ofGURz7grD8a6/wm3k4eFY3fCTRdGTvLZxChOAKT01+cisK261Qmu
	 HV11FKh2ZlBS2R0WPR2m3VPHzHXIS0X1raSrA3H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 397/621] net: mana: Cap MSI-X vectors to the device MSI-X table size
Date: Tue, 13 Oct 2026 13:36:32 +0200
Message-ID: <20261013112930.264381649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit 2c7493f980140a5c40eb4f98f97c557193a2c330 ]

mana_gd_query_max_resources() sizes gc->num_msix_usable from resp.max_msix
and the CPU count, but never from the device MSI-X table. On a 1792 vCPU
M-series VM that yields 1793 while the table has 1024 entries, and
mana_gd_setup_remaining_irqs() then walks indices 1..1792, running off the
end of the region mapped by msix_map_region():

  BUG: unable to handle page fault for address: ff8e347f8b99800c
  RIP: 0010:msix_prepare_msi_desc+0x7a/0x90
  RAX: 0000000000004000 RBX: ff4330cb164ea780 RCX: ff8e347f8b998000
  Call Trace:
   <TASK>
   __msi_domain_alloc_irqs+0x13a/0x440
   msi_domain_alloc_irq_at+0x149/0x1b0
   mana_gd_setup+0x351/0x890
   mana_gd_probe+0x274/0x390
   </TASK>

RAX is index 1024 * PCI_MSIX_ENTRY_SIZE, one entry past the table.

msi_insert_desc() does range check the index, but only against the MSI
domain hwsize, which matches the table only for devices on an MSI parent
domain. With a global PCI/MSI domain hwsize is MSI_XA_DOMAIN_SIZE, so
nothing bounds the request.

Cap num_msix_usable with pci_msix_vec_count().

Fixes: 755391121038 ("net: mana: Allocate MSI-X vectors dynamically")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260821183736.733296-1-longli@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 81cbc47de0c62..29bbaebf3e571 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -107,6 +107,7 @@ static int mana_gd_query_max_resources(struct pci_dev *pdev)
 	struct gdma_context *gc = pci_get_drvdata(pdev);
 	struct gdma_query_max_resources_resp resp = {};
 	struct gdma_general_req req = {};
+	unsigned int msix_vec_count;
 	int err;
 
 	mana_gd_init_req_hdr(&req.hdr, GDMA_QUERY_MAX_RESOURCES,
@@ -131,6 +132,24 @@ static int mana_gd_query_max_resources(struct pci_dev *pdev)
 		gc->num_msix_usable = min(resp.max_msix, num_online_cpus() + 1);
 	}
 
+	/* MSI-X vectors are allocated by index into the device MSI-X table, so
+	 * never ask for more than the table holds. It can be smaller than both
+	 * resp.max_msix and the CPU count.
+	 */
+	err = pci_msix_vec_count(pdev);
+	if (err <= 0) {
+		dev_err(gc->dev, "Failed to query MSI-X table size: %d\n", err);
+		return err < 0 ? err : -ENOSPC;
+	}
+	msix_vec_count = err;
+
+	if (gc->num_msix_usable > msix_vec_count) {
+		dev_info(gc->dev,
+			 "Limiting MSI-X vectors from %u to table size %u\n",
+			 gc->num_msix_usable, msix_vec_count);
+		gc->num_msix_usable = msix_vec_count;
+	}
+
 	if (gc->num_msix_usable <= 1)
 		return -ENOSPC;
 
-- 
2.53.0



