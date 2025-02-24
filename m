Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50FD18A6AD;
	Mon, 24 Feb 2025 15:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409268; cv=none; b=KtdFpssFl7VJ83AOH9JIMhHS7bZDj7PggewFCbLOvC53SPjKpwynWlhEo1Alw36HgvxS9I0zTdfOY7kyGumYIwMnky8V8JVNkDtVG/cZcqHjwGNcUSP2lGs5JB/c6c2DTsVeZSGwblSsQovZ6sjHweEzXdfOMuXc6vxBk/oPN/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409268; c=relaxed/simple;
	bh=BKGPQHAO9yskAZiyM5aLNrgWQqYOCufkAFPkzMXk2Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dexvQyup9MRR4foT6iAAbkoGCdHtoZzhv3h1SDx6PGu76KJzKyfbVNcM4/eKMxg7Ktqh2Ha35IMLwXvvrOGSi1tnrVdlAfPFkFf5pPjlbhu0eogatCEIJOQzlxCpjA+o7viRJpZBEMGBf/qrvAAHaJcBejsbDwK5kXPFAjTTXJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILt9VG/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILt9VG/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58878C4CED6;
	Mon, 24 Feb 2025 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409268;
	bh=BKGPQHAO9yskAZiyM5aLNrgWQqYOCufkAFPkzMXk2Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILt9VG/MH1LEkk2AOr0JpmlcKfyQJyivvX3DqznLRnTFA7mj1mD7GXdoW7GJEiZN7
	 ifF0azB6B/gUt3c3aghnH3wk3Zg0rlog5wBihBEAdPwuvKVDMHANj3XsQ6WXiMkkqA
	 KulvwHTbOpuE9OYOPYAnLDVYhXBsydhPCSSr0GfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.13 126/138] mtd: rawnand: cadence: fix incorrect device in dma_unmap_single
Date: Mon, 24 Feb 2025 15:35:56 +0100
Message-ID: <20250224142609.423892991@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

commit f37d135b42cb484bdecee93f56b9f483214ede78 upstream.

dma_map_single is using physical/bus device (DMA) but dma_unmap_single
is using framework device(NAND controller), which is incorrect.
Fixed dma_unmap_single to use correct physical/bus device.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -1863,12 +1863,12 @@ static int cadence_nand_slave_dma_transf
 	dma_async_issue_pending(cdns_ctrl->dmac);
 	wait_for_completion(&finished);
 
-	dma_unmap_single(cdns_ctrl->dev, buf_dma, len, dir);
+	dma_unmap_single(dma_dev->dev, buf_dma, len, dir);
 
 	return 0;
 
 err_unmap:
-	dma_unmap_single(cdns_ctrl->dev, buf_dma, len, dir);
+	dma_unmap_single(dma_dev->dev, buf_dma, len, dir);
 
 err:
 	dev_dbg(cdns_ctrl->dev, "Fall back to CPU I/O\n");


