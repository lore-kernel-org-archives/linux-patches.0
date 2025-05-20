Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45320DDA9;
	Tue, 20 May 2025 13:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749528; cv=none; b=L899z0Pr1pH5Ac2iuZSdVtrflZ2rWn83Ns+BuZhkvrnyknp+es55vG6xP3ayDjISSKS74XF+Q2Y+BfEqykEQfm1jrimXrorTVWHgy9HpYKue1sD66Nxfz9tengJOTWk1qnhfzV/IVAa4lW95HXoMI8aojTYFKNcg6FhZgxUgRPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749528; c=relaxed/simple;
	bh=48FRoC84zPDywtZEMRhiLI+EDwj/8AdYJTeAknoeaiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aU39NnVOfiniU4NKEbSAqyEDQesyQ40509J91unOahkqolz2WbZeP44cM43FQy/5fOivsHyMnPKIwEHs2JgIWjNeKv2Y93Sqmz0Cq17kzrfsDl0+C2g+d4QLUtx3nwDVaMd5hWwk7PZAKpHhdGklAjptHzCkLZqNE/NV0mazkos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YESess0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YESess0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E028C4CEE9;
	Tue, 20 May 2025 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749528;
	bh=48FRoC84zPDywtZEMRhiLI+EDwj/8AdYJTeAknoeaiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YESess0GGQGpA6qnsZNpnwnY6mLd7sSJ6UkstTgJ3dd4YECoossbARattQ5JzwXFh
	 cCR1a5LrLXXV5IhKGjoko6S3ykZZlQW0Ffwv+eChZVwbqjz3VhOdm13s21xXmk2+Xr
	 WATM5D970fIYmfoFXRpdjk9z62zTDNpLs0uysUFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 74/97] dmaengine: idxd: fix memory leak in error handling path of idxd_pci_probe
Date: Tue, 20 May 2025 15:50:39 +0200
Message-ID: <20250520125803.548533227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 90022b3a6981ec234902be5dbf0f983a12c759fc upstream.

Memory allocated for idxd is not freed if an error occurs during
idxd_pci_probe(). To fix it, free the allocated memory in the reverse
order of allocation before exiting the function in case of an error.

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Link: https://lore.kernel.org/r/20250404120217.48772-8-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -520,6 +520,17 @@ static void idxd_read_caps(struct idxd_d
 	multi_u64_to_bmap(idxd->opcap_bmap, &idxd->hw.opcap.bits[0], 4);
 }
 
+static void idxd_free(struct idxd_device *idxd)
+{
+	if (!idxd)
+		return;
+
+	put_device(idxd_confdev(idxd));
+	bitmap_free(idxd->opcap_bmap);
+	ida_free(&idxd_ida, idxd->id);
+	kfree(idxd);
+}
+
 static struct idxd_device *idxd_alloc(struct pci_dev *pdev, struct idxd_driver_data *data)
 {
 	struct device *dev = &pdev->dev;
@@ -739,7 +750,7 @@ static int idxd_pci_probe(struct pci_dev
  err:
 	pci_iounmap(pdev, idxd->reg_base);
  err_iomap:
-	put_device(idxd_confdev(idxd));
+	idxd_free(idxd);
  err_idxd_alloc:
 	pci_disable_device(pdev);
 	return rc;


