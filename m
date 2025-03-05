Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49593256C64;
	Wed,  5 Mar 2025 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198772; cv=none; b=Po2XtluA1EdxJ/XYJMJEl1UxAgFvKGBotjUKSeyqC3bAlJ6TfdfJ30M3CeXrlNutC6VD83uv101TEd/ZoPaGaPbpTUMiRFfXPJNu6o70t7z2JpMgq6XC5o9lZVa8As16uK4RogPE1KLIENYtSIsLAJ1LfK+QelSlNBleTKrJOxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198772; c=relaxed/simple;
	bh=Az6PIg+1Nm5nMICPTEnuA/wwMXoIDqUcmGKtItsBa18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoDqQMNJuUlI8+/zgLmqeFhYvJuSoiSKWaxKo29xaBIj17fI5WhLCes/SkC0hnmNXmPi2H6iyxp2Ukf0KLWwBZXmnOPInpCvjegOH8GcpnEyqpaSR3aZi/H9/38rHgdGkfQH69yJLwBmWf/hQIvVLuvGUyqV00l1vAl3deB3eao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQAKtz9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQAKtz9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CBAC4CED1;
	Wed,  5 Mar 2025 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198772;
	bh=Az6PIg+1Nm5nMICPTEnuA/wwMXoIDqUcmGKtItsBa18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQAKtz9gy4R/4j20FaSCs4XgTYV/uBJdnQsuKliULb8flo0LX+Ix/dZCO5S6eZ5Si
	 ib/4H5QD+V8eU0DvtN6W/Q5O6CSQnDibvQqwRKgd5ujIyg2jZRu6DKRCr49S9z4T7j
	 h8vQLBSCmEYJlcJwx0x6BOfGDhdA7e5a2iz1cvjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.13 125/157] iommu/vt-d: Remove device comparison in context_setup_pass_through_cb
Date: Wed,  5 Mar 2025 18:49:21 +0100
Message-ID: <20250305174510.329639575@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerry Snitselaar <jsnitsel@redhat.com>

commit 64f792981e35e191eb619f6f2fefab76cc7d6112 upstream.

Remove the device comparison check in context_setup_pass_through_cb.
pci_for_each_dma_alias already makes a decision on whether the
callback function should be called for a device. With the check
in place it will fail to create context entries for aliases as
it walks up to the root bus.

Fixes: 2031c469f816 ("iommu/vt-d: Add support for static identity domain")
Closes: https://lore.kernel.org/linux-iommu/82499eb6-00b7-4f83-879a-e97b4144f576@linux.intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20250224180316.140123-1-jsnitsel@redhat.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4380,9 +4380,6 @@ static int context_setup_pass_through_cb
 {
 	struct device *dev = data;
 
-	if (dev != &pdev->dev)
-		return 0;
-
 	return context_setup_pass_through(dev, PCI_BUS_NUM(alias), alias & 0xff);
 }
 


