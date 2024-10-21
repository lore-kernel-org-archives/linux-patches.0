Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5BB1E9098;
	Mon, 21 Oct 2024 10:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507603; cv=none; b=G6opzv0M6VSSdvq3yiVfO2/UiGWXWTLs9KjJT4r01Ar3QsfikttQC+G5wYzBrUnTZlgSh4ikt0wybsYem1sQtJJLFtrUCOeX0MtijneUKdSh6oVv+0a8k6U0hBbFO97ze45nDpZYZKc8UpBBC6pj8Hlh5ugiWFZpfNRyqDiA7x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507603; c=relaxed/simple;
	bh=Fwq76tkRvqoif28uROWPY1s+2bJe7ksZRxyHYkkTWCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJ/TCbX8eJPfw9RREy8E24vJTRcXRocMqPKhCz9P8U0SdNBxxoQOkLmPpeysWcIALKYGcWLV3UsG3Fmuwk2J1JAlW8VAiCJp9wlWqUSEhUCDV+36fELFP2x5e+2H4iSf2huz0jOiVhHDP43GulZgaiGCgWCB4ezkEZYSf4K8SNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXDWqcyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXDWqcyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA42C4CEC3;
	Mon, 21 Oct 2024 10:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507603;
	bh=Fwq76tkRvqoif28uROWPY1s+2bJe7ksZRxyHYkkTWCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXDWqcywtClZbhZyxG6TspQEiON65JNH5vwvuvbWdwaqEiplEWwSQxz+okCtBFU8s
	 CvCaAVThd7abw4ACHHk5/JZRIfq1m1YK2xlXfcxApNtRsXKhcNW1Jr1TuV22PeiZ+d
	 pT2hbz+nn3ypVYtz/1Hx12YwvOizoRNMN45b8+sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Brandt <todd.e.brandt@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 39/82] iommu/vt-d: Fix incorrect pci_for_each_dma_alias() for non-PCI devices
Date: Mon, 21 Oct 2024 12:25:20 +0200
Message-ID: <20241021102248.786836165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 6e02a277f1db24fa039e23783c8921c7b0e5b1b3 upstream.

Previously, the domain_context_clear() function incorrectly called
pci_for_each_dma_alias() to set up context entries for non-PCI devices.
This could lead to kernel hangs or other unexpected behavior.

Add a check to only call pci_for_each_dma_alias() for PCI devices. For
non-PCI devices, domain_context_clear_one() is called directly.

Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219363
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219349
Fixes: 9a16ab9d6402 ("iommu/vt-d: Make context clearing consistent with context mapping")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20241014013744.102197-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4465,8 +4465,10 @@ static int domain_context_clear_one_cb(s
  */
 static void domain_context_clear(struct device_domain_info *info)
 {
-	if (!dev_is_pci(info->dev))
+	if (!dev_is_pci(info->dev)) {
 		domain_context_clear_one(info, info->bus, info->devfn);
+		return;
+	}
 
 	pci_for_each_dma_alias(to_pci_dev(info->dev),
 			       &domain_context_clear_one_cb, info);


