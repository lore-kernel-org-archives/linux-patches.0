Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F8F2F37;
	Tue, 20 May 2025 14:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749915; cv=none; b=uEjaidYFLEHT/ZXubHtU0a1aZNkwQit9yBuS7nDusAfDkJeLfXmG38K1Yvv0EL3N6Ni1Ima5nbocw+/ZaLdYnprV9sJybXj+ZCh7V4WpfGXbJNOuh3fms4QRGVKoAq7igL2lm+Faicl6eHWhb0bzRo6cXvmqkWCvzPTWXS1/T6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749915; c=relaxed/simple;
	bh=4HMnH92tgsO+USQdwrLb6KX1a3wbBTcHetlt+6TgSJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qh1R76cbxMF0ySJggeWT451JJDSdaXUlKeVXx7AB6tydjr0kejQtGeYi08X/Sv7i6tUzvOtHXxnrufTrkGxJktbwu+GG8i+3/gMa35GIqotUFMXF58KtkhRwkNdDotUddbI1IhyxNUeAT3t1k7F0peIi+R9z0XDacAOoIwviAIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpsUjER5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpsUjER5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD22C4CEE9;
	Tue, 20 May 2025 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749914;
	bh=4HMnH92tgsO+USQdwrLb6KX1a3wbBTcHetlt+6TgSJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpsUjER5CaH/wnEjuDqSypCsjxGsyZGP0xM9IJOEGMrOMFhaYWjt5yva3EZAGQ+L3
	 ZdafoncCtihdOCKAaGRooP8zknG5EnH6UQXN7ADVo9O0CfbqxWDqbyU3AirGTdS2qO
	 Ve94u4NRGsfqEv3FUyIgBzyJEfnCcrXrJFRDqRPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 101/117] dmaengine: idxd: fix memory leak in error handling path of idxd_pci_probe
Date: Tue, 20 May 2025 15:51:06 +0200
Message-ID: <20250520125807.995067824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -577,6 +577,17 @@ static void idxd_read_caps(struct idxd_d
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
@@ -843,7 +854,7 @@ static int idxd_pci_probe(struct pci_dev
  err:
 	pci_iounmap(pdev, idxd->reg_base);
  err_iomap:
-	put_device(idxd_confdev(idxd));
+	idxd_free(idxd);
  err_idxd_alloc:
 	pci_disable_device(pdev);
 	return rc;


