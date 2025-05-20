Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC1624EABF;
	Tue, 20 May 2025 14:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750830; cv=none; b=qpwlPlKTS1dywb4/sccdLFfeVZuCSk6iSYPS7Egsx9rjBknICmlgRpVr3dncLq2uA0CeV2mZ2WzvLhBJsc/XpS/WC0j4A+DeAdkHDLlcIwDE+HfmB2cjnQ51lsLhR5VTFz4Ednc+Fk03cs2JRWUD4ZTc8AWRKNJbUxUKHNcKa7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750830; c=relaxed/simple;
	bh=3KztxCCXw9WrMBDgFrPrMmgoExbIgI6qPFd5ckO1EJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3MgfKZbKF8gydAlEbjVotcV1cOSyDLxUVBn/2JnA1VpHXipW/wGE38hSKZdQ+Yrot2saEaSaZHcbFARnP72DPKx3t7rswVrUTChYWvWHdiLkpjWzKdCWqZ8Qc126kWoMKa0E0FS0N1LBf77TWZjtkguke98ALWQB23bUrbt97E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAerCktN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAerCktN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F25C4CEE9;
	Tue, 20 May 2025 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750829;
	bh=3KztxCCXw9WrMBDgFrPrMmgoExbIgI6qPFd5ckO1EJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAerCktNU1yRV8RfnaBbW35MWZtYautrmYzC644sFM8zpd/u6OaDL5LXekzDlmN41
	 JS0lgF2diFf+SsaZgwvmzoz668L+v+Fmt3Q+UCHN6NgV8EEIv/CVDNWl2lzXuEXCKx
	 /9oP4/RRS/sPcy343HkI3glK5MVST1pmw2H5aU1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.14 134/145] dmaengine: idxd: fix memory leak in error handling path of idxd_pci_probe
Date: Tue, 20 May 2025 15:51:44 +0200
Message-ID: <20250520125815.787662090@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -587,6 +587,17 @@ static void idxd_read_caps(struct idxd_d
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
@@ -1256,7 +1267,7 @@ int idxd_pci_probe_alloc(struct idxd_dev
  err:
 	pci_iounmap(pdev, idxd->reg_base);
  err_iomap:
-	put_device(idxd_confdev(idxd));
+	idxd_free(idxd);
  err_idxd_alloc:
 	pci_disable_device(pdev);
 	return rc;


