Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FCE250C1F;
	Wed,  5 Mar 2025 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198263; cv=none; b=oibLb0iHqwWHk4sDgC/eTQqPuZFHniGBmsNglI4lvM03ZyBaT/CSMgJbr+lbGGJcLZYHdnaVQdcK4NfcvtKNCYR1yH08q6/lNTmaJbH9lYkdYZfglAHlGJmmlibw686oxEudJEvgesUDBcpxSwDtzp7WLO5c3unT8WL36oYc6dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198263; c=relaxed/simple;
	bh=T8KurzKBrBlhSf85kxM4Bt++S9N2H8QZMeigzbJB+/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgZ/9zKVrWGsOrv1wLAKS0Wec6sePNmpPI0My0X8dex5oPeOFB/9n3l0Nafyq5WcXw9LJ6LzgFUSL1s4braYekrI2lzmXxbvG+4qW5E2nUg8ICXNZePvRjAkjNLq1mK2aEfRPO022B01o+fI+9HeUjfHRRgNjSb8bY5wcRDNl4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ph7bD0D0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ph7bD0D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFC7C4CEE0;
	Wed,  5 Mar 2025 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198263;
	bh=T8KurzKBrBlhSf85kxM4Bt++S9N2H8QZMeigzbJB+/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ph7bD0D0qoIi/ctvWUiNwEbHBd69hAY6Ccx2EZKB8rdHt5iqZiNemAd1vmUcuL1i2
	 FvROICr1sCm8s6MQlQF+J86czgkzBJZmb2w8Gy6jHnGN9vMIA5Hrb9dGzLssD3JMZX
	 iIuGoVa3awV8Qd0LIUhs1VtXVBxeodXMT1NhIpB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.12 120/150] iommu/vt-d: Remove device comparison in context_setup_pass_through_cb
Date: Wed,  5 Mar 2025 18:49:09 +0100
Message-ID: <20250305174508.640113535@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4547,9 +4547,6 @@ static int context_setup_pass_through_cb
 {
 	struct device *dev = data;
 
-	if (dev != &pdev->dev)
-		return 0;
-
 	return context_setup_pass_through(dev, PCI_BUS_NUM(alias), alias & 0xff);
 }
 


