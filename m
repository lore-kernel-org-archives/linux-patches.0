Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C09B37754D;
	Wed, 20 May 2026 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297292; cv=none; b=OIepwMpC+Y6cIaU1DW00v6qTil5jit50wGbeSw7slu7C+kgphvtY2w/f7il6PFhQP1DbzgYsjv5SzJ1FQpqYTWMutdB8bAnw3j5hpqJwpYYZFXanx9PApmQDCG8ApRdPKobn5WqX5Q54moiwPqAq6OSjabNFj8CbcncnTOVknAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297292; c=relaxed/simple;
	bh=wPYWVd2FTmpVXpaGWdsu/m2dJkFFaQrPNIRrm+jpAV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEk28ajkYezjnE3hWI/nVHOe/GBybEovzEINqqVERw+BJzfWZZAuI9Rc+qOUVHqfXndrSFoslx8x0YcwgPPsH4a1rq92X/Ns8H5caEzS1L3GIkkdSzXXZyL+fofuxyWTVS5Rv2JV4jSIN/mX1JI+PUN5Hy7CNBsiLlFwollxiUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8emEBk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8emEBk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14531F000E9;
	Wed, 20 May 2026 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297291;
	bh=qZMJMBkYPaegDneS4Cypx/tLmAtr3vsrs/kQvG5aLas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8emEBk/Sn9241gE5vwKotR7W7pJTgFdrCqovgcHMDYyUJiSECCIZqxkfhQcFgHRS
	 iXra7k4/H+zDoieo95CnJtd+e6CqOnOjoLfaiFhbew+7QbKKzOsAHyfdwPZTC57fkt
	 p5I+b9qYygBaNGWehCqh5JCil+ThPPsrdCeyRavE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.0 1122/1146] iommu: Fix NULL group->domain dereference in pci_dev_reset_iommu_done()
Date: Wed, 20 May 2026 18:22:52 +0200
Message-ID: <20260520162213.633516289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit d769711fcddd005f1e654b3bde547140917fe696 upstream.

Local sashiko review pointed it out that group->domain could be NULL when
a default domain fails to allocate during the first probe, which can crash
at domain->ops->attach_dev dereference in __iommu_attach_device() invoked
by pci_dev_reset_iommu_done().

pci_dev_reset_iommu_prepare() is fine as an old_domain pointer can be NULL.

Skip the re-attach in pci_dev_reset_iommu_done() to fix the bug.

Fixes: c279e83953d9 ("iommu: Introduce pci_dev_reset_iommu_prepare/done()")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -4035,8 +4035,13 @@ void pci_dev_reset_iommu_done(struct pci
 	if (WARN_ON(!group->blocking_domain))
 		return;
 
-	/* Re-attach RID domain back to group->domain */
-	if (group->domain != group->blocking_domain) {
+	/*
+	 * Re-attach RID domain back to group->domain
+	 *
+	 * Leave the device parked in the blocking_domain if group->domain isn't
+	 * initialized yet
+	 */
+	if (group->domain && group->domain != group->blocking_domain) {
 		WARN_ON(__iommu_attach_device(group->domain, &pdev->dev,
 					      group->blocking_domain));
 	}


