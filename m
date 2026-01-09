Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E88733372B;
	Fri,  9 Jan 2026 12:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962680; cv=none; b=q0mM15sAZfaTPjFiaTzZGa8vPv0oYTwcLZ78u0cK1FQSZiBwIUM/N0KtJEi7eAv6yOEsHkr4oRLkvwMmuyhTF4lhP/eR+UOqvlVZSLt/L9DESj8VWE8VITetoG5bIF2YSwI+TkR5HvWQwV86xQyceQ8XXIt0UqVxGfAQMoi6d5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962680; c=relaxed/simple;
	bh=iXtxEKI6KaSIZ4WkuonKv0EGAjyXHQoyUCmWS2NWPok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMvVcPqu3+r3RAcP1CAA5ItEbpkh4iwlPrABF7Bq7A5i9iFuU6sDI0TUPA1g3npxVA9CciKksVwIszkSY9rs7DyzyHVnUxGAWIucjNUSKQw6JGEqzUvSkwtwYBLLKGWoiSVm1jDk7RllDkQ5c1R7pikPKeCVVSDkxK70qwJFlwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQa9L9F8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQa9L9F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A254AC4CEF1;
	Fri,  9 Jan 2026 12:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962680;
	bh=iXtxEKI6KaSIZ4WkuonKv0EGAjyXHQoyUCmWS2NWPok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQa9L9F8JLgmcc6TNhJtFezAKVi3vJ5R1vVn/G3GtblyRn9iwGSyc5PisABEKNcmv
	 BtF1bc4+/OWwMpNczTvz+VoH6gEehjAJ99cNOcGLkuGFaYe1ilQUVbatQfnT6j+OhB
	 nDi5GOpam6SIP68eMATprfkKSPNTEV8cS3cEfXuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.1 449/634] iommu/amd: Fix pci_segment memleak in alloc_pci_segment()
Date: Fri,  9 Jan 2026 12:42:07 +0100
Message-ID: <20260109112134.436237072@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinhui Guo <guojinhui.liam@bytedance.com>

commit 75ba146c2674ba49ed8a222c67f9abfb4a4f2a4f upstream.

Fix a memory leak of struct amd_iommu_pci_segment in alloc_pci_segment()
when system memory (or contiguous memory) is insufficient.

Fixes: 04230c119930 ("iommu/amd: Introduce per PCI segment device table")
Fixes: eda797a27795 ("iommu/amd: Introduce per PCI segment rlookup table")
Fixes: 99fc4ac3d297 ("iommu/amd: Introduce per PCI segment alias_table")
Cc: stable@vger.kernel.org
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1629,13 +1629,22 @@ static struct amd_iommu_pci_seg *__init
 	list_add_tail(&pci_seg->list, &amd_iommu_pci_seg_list);
 
 	if (alloc_dev_table(pci_seg))
-		return NULL;
+		goto err_free_pci_seg;
 	if (alloc_alias_table(pci_seg))
-		return NULL;
+		goto err_free_dev_table;
 	if (alloc_rlookup_table(pci_seg))
-		return NULL;
+		goto err_free_alias_table;
 
 	return pci_seg;
+
+err_free_alias_table:
+	free_alias_table(pci_seg);
+err_free_dev_table:
+	free_dev_table(pci_seg);
+err_free_pci_seg:
+	list_del(&pci_seg->list);
+	kfree(pci_seg);
+	return NULL;
 }
 
 static struct amd_iommu_pci_seg *__init get_pci_segment(u16 id,


