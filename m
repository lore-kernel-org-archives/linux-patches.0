Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A662512E1;
	Wed,  5 Mar 2025 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197234; cv=none; b=ZZl7H3sLgduH7z4PpSiPLVISfXmLjfDtJyUOXg+d4vJCIOddXDwd9C7fb3vndTy8ASMkMJedPihbTQ9q16XPyWZ+sdfXTHAq2WHGdJgTVJ4/9IszFCQt5GP6bWukizf2wK+VbuwcVWWje1aYS4+mZpzB/HFZLJF9U2LmVkZiLjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197234; c=relaxed/simple;
	bh=j0L250aN2kRfAN7IS47jts3BaS7swHxO0P/sW3L7o3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlrcQ9E5KD17lDcC6+ZqVY81FmVEXoGjcFo5ppKIYdKXCWL3/L6s7cjyX97RGuwvxxJgXqu0PTDrHOffiRpRjgNoFuagd5mnwgGkg2VUlsPiFNJxFMf6hdOkAHXf1jm+9iiyaAdVDMiYkw7gNddnH9CwTaNazcihvzQocc3EgRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M82qerMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M82qerMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BB5C4CED1;
	Wed,  5 Mar 2025 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197233;
	bh=j0L250aN2kRfAN7IS47jts3BaS7swHxO0P/sW3L7o3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M82qerMDLkgfe5ixtGxef24M06OLjeILaohSZ0Nx/USA5nA7uRoddnN6B1j505+qu
	 7BMQ5L3Ty5UbkFCGY+aK07xlRGgTRpdY0o2Y3soP2hW15kGXlE9m6FnQbpR3vXdzSt
	 bBvnCmuXgnArI9QDx6O/Us3dMiktbm5AVA3nyanc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 085/176] mtd: rawnand: cadence: fix incorrect device in dma_unmap_single
Date: Wed,  5 Mar 2025 18:47:34 +0100
Message-ID: <20250305174508.876644409@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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
@@ -1858,12 +1858,12 @@ static int cadence_nand_slave_dma_transf
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


