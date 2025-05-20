Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CC024A076;
	Tue, 20 May 2025 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750362; cv=none; b=hB0Ptz9IIBhhp9Og13i40aaVBb9Va4lrgTZi2o+1B4Np9vw7SczhB7Djp0RV3X7FkVUGHvEYsN/obt8oPPRRYyDCtv1rVIZKiTdUQB7N3ujITvEKiO8jTw/V+PqqYn64l4WH4m4hlUbIQzrlTMBZj9pJAT9Wt0IALvjL/l2DrQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750362; c=relaxed/simple;
	bh=h0L7a40NHbYiWWMnb/tPaDstvTeIx6uxDtz3O94GoXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8U2n/nEqiqmT/fTzZhLZb0R1xNXTsy7qWiSiIcVmKeDoE95lVic33LwR7xIbhN5Sp3139u0WiUXRZEfhpTwuYlouBCHktpsQLDAb5Kz+ALmFrMv3o8j63xtKSiU8rB+L0YxCyGCHGIzcw8jWpacSQDndofObgvCZ4kCx1wCphk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNIX/7j/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNIX/7j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11939C4CEE9;
	Tue, 20 May 2025 14:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750362;
	bh=h0L7a40NHbYiWWMnb/tPaDstvTeIx6uxDtz3O94GoXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNIX/7j/cwtTrsuWDwLnaWdT766QwWzLlmrBiKlik7zhw5X43gtizxu9tJc0kc8H6
	 NwNZBzz1f0lpLzcr7RBLKUYH2UHlTHtZINvr/1bQwQdBMKo2qCC8GXse3+Tiz3VoLo
	 ji3Wp+eZLy/nwLGRDdQSFqrFj9tN/1ujHv4ccC9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 127/143] dmaengine: idxd: fix memory leak in error handling path of idxd_pci_probe
Date: Tue, 20 May 2025 15:51:22 +0200
Message-ID: <20250520125815.017500610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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
@@ -585,6 +585,17 @@ static void idxd_read_caps(struct idxd_d
 		idxd->hw.iaa_cap.bits = ioread64(idxd->reg_base + IDXD_IAACAP_OFFSET);
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
@@ -857,7 +868,7 @@ static int idxd_pci_probe(struct pci_dev
  err:
 	pci_iounmap(pdev, idxd->reg_base);
  err_iomap:
-	put_device(idxd_confdev(idxd));
+	idxd_free(idxd);
  err_idxd_alloc:
 	pci_disable_device(pdev);
 	return rc;


