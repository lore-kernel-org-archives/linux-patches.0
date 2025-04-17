Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33CA24EF6F;
	Thu, 17 Apr 2025 18:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916189; cv=none; b=HlnySeVw4uljIyAuYM7MI61oBmEpA7owCXcU+cqdv4zE/chnEohft/DIliGtDhve2MeR4JYdQMRt2jaSiotlsZbHPjYTL5Qe93v0pg8BAzjaTEJLp/PmQVSo/mrRBEDvCTeAIdgau8AFria+6RnDbXBqCmMGBwIxKp39fnQyJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916189; c=relaxed/simple;
	bh=4SGWzo0FvzhQvcPU9U5NMkOp4mwiZHKWH5/Ynz2CgHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpc1hR+AJPgGTxxuaI9NQj0CQSXXZG/YKuuiMZQ8Zo4IdJF20o25inmAqEmI/10JE6B55697kC6AAg5KCtyIt+qcAo716nP1ijJPPYJsgZu4OdxTminrUvaIVB8h7VEfhe9mtjSc4kkYcVKoMvbvk+TnkvS9t6p2JBMJivlbbC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGUXyjF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGUXyjF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602EEC4CEE4;
	Thu, 17 Apr 2025 18:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916188;
	bh=4SGWzo0FvzhQvcPU9U5NMkOp4mwiZHKWH5/Ynz2CgHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGUXyjF1u212eceadkEj63bvko6KPnb5/SKnY8jt0tWzeuaS90g18N0zyqq1pgmiA
	 RLzLrXVdmROZ35/+mm9ZwPeN33VUJgsBfGIZ1ShyNo0RvEqZ9gxTrLVEVZCJPq3uSu
	 E1kceIg4sUfVVszpYq84pp+rd5FvKo6wQtIA9ixQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 372/393] s390/pci: Fix zpci_bus_is_isolated_vf() for non-VFs
Date: Thu, 17 Apr 2025 19:53:01 +0200
Message-ID: <20250417175122.560629735@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 8691abd3afaadd816a298503ec1a759df1305d2e upstream.

For non-VFs, zpci_bus_is_isolated_vf() should return false because they
aren't VFs. While zpci_iov_find_parent_pf() specifically checks if
a function is a VF, it then simply returns that there is no parent. The
simplistic check for a parent then leads to these functions being
confused with isolated VFs and isolating them on their own domain even
if sibling PFs should share the domain.

Fix this by explicitly checking if a function is not a VF. Note also
that at this point the case where RIDs are ignored is already handled
and in this case all PCI functions get isolated by being detected in
zpci_bus_is_multifunction_root().

Cc: stable@vger.kernel.org
Fixes: 2844ddbd540f ("s390/pci: Fix handling of isolated VFs")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_bus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -335,6 +335,9 @@ static bool zpci_bus_is_isolated_vf(stru
 {
 	struct pci_dev *pdev;
 
+	if (!zdev->vfn)
+		return false;
+
 	pdev = zpci_iov_find_parent_pf(zbus, zdev);
 	if (!pdev)
 		return true;


