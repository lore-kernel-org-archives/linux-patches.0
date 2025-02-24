Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D03B2192E8;
	Mon, 24 Feb 2025 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408198; cv=none; b=qkyXPBCacdl4n/ClhCn489dk5r5PWKzVsbPI3jkQwTs3AL53F4SVyDo4EAWYrtIlcjp5dJcsgXVHzBqb5cXb0/C6yRNPosd2lvv9ozptYWIFo225lwchMyFoVVjAbYY7O6vpTJ1ibyb6m2er6MYwdsOKim1CYTRLa0CezuRXcz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408198; c=relaxed/simple;
	bh=eB99jKI0dm31Y/cgu77K6Sw1ZjdbInRS0ygIjDa8mQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klNZxvDM2UtBgsYa8T7TqEkWdC6WOcGcJLrJSFa6iAUE4AvM0+naOQYOBONbzZKkYY8CgHRK93QUsmvc8z35Fh49QS65+kiJ8JR2h4Dy28R1zam2zyhTz3oeuhySTvD659Y31Xii608BSx8kutWCkTCYHxNzSHnpK3y+Dn82RmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ANQyEyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ANQyEyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721B4C4CED6;
	Mon, 24 Feb 2025 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408197;
	bh=eB99jKI0dm31Y/cgu77K6Sw1ZjdbInRS0ygIjDa8mQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ANQyEywEoOKHCFhZxhNOVKjYUpyXwvH2KtQ6Ax4LaK3aFjRmhivPLW9fj+2RyFVT
	 Ws08LmDVWPg+6PM0w/z7vnmS0ExbnlhMnd0D/yh2ddCSmVItNc9vOGp+Vj3JJNZgb1
	 GjPR2SuWuNDnZKV3DVCvapjjryouwOZ623ooPmlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 127/140] mtd: rawnand: cadence: fix incorrect device in dma_unmap_single
Date: Mon, 24 Feb 2025 15:35:26 +0100
Message-ID: <20250224142607.997047285@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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
@@ -1866,12 +1866,12 @@ static int cadence_nand_slave_dma_transf
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


