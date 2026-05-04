Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1193DEAC8;
	Mon,  4 May 2026 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904777; cv=none; b=j4TymwyfUQBkLwF+/B/L+VmeGLml5G+V7jnn894CnaPil4JWkAuxFUlpvxFaiRV6Mazt2xLO3G5PIHD3ldN4Ogs36MFbN6WM0L98wesHvXv+s5jVUX/ct/BdUPDBxpWI3s139NPmXSCu57oGGRSWU3vPbxh8YnyKZclW35K3NQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904777; c=relaxed/simple;
	bh=ztQdI9n/sgHVmH5CH1EE0X5ziDncD50T5+ISJlDzdmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjocymIALK4fy3ymyXq8/CEIsVZ7P8mVs5Zh12ZPebIllybidVRl09sXIXF8/NyLjxSLOzh1NIOIhVQJTyGBz8JGWu4XbQlHiZ1bOybQfb8E69IPziuh4uyVwtFjGyqFw9NVhM8HDwifgadaa3uaM1jPRFlgqNsCKmrAH0bxJ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3IXjCO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3IXjCO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31136C2BCB8;
	Mon,  4 May 2026 14:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904777;
	bh=ztQdI9n/sgHVmH5CH1EE0X5ziDncD50T5+ISJlDzdmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3IXjCO0SB5ZwVTZLqJYnQJxMXmcmEhNuwagAA5HSAQDj2nPCKCkCFB5x+gbhvX0x
	 BhPnzg1uJMQ41scZ70kRPxM3Jj8lBf9cyYOO8FYHQPuiGstut8gYyeEn47hpWB/ln9
	 fAUlExnt3782ztRyLrU6d+Y9+zGFxbioDb7OPULw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjaikumar V S <sanjaikumar.vs@dicortech.com>,
	Hendrik Donner <hd@os-cillation.de>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: [PATCH 6.12 138/215] mtd: spi-nor: sst: Fix write enable before AAI sequence
Date: Mon,  4 May 2026 15:52:37 +0200
Message-ID: <20260504135135.195011261@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjaikumar V S <sanjaikumar.vs@dicortech.com>

commit a0f64241d3566a49c0a9b33ba7ae458ae22003a9 upstream.

When writing to SST flash starting at an odd address, a single byte is
first programmed using the byte program (BP) command. After this
operation completes, the flash hardware automatically clears the Write
Enable Latch (WEL) bit.

If an AAI (Auto Address Increment) word program sequence follows, it
requires WEL to be set. Without re-enabling writes, the AAI sequence
fails.

Add spi_nor_write_enable() after the odd-address byte program when more
data needs to be written. Use a local boolean for clarity.

Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
Cc: stable@vger.kernel.org
Signed-off-by: Sanjaikumar V S <sanjaikumar.vs@dicortech.com>
Tested-by: Hendrik Donner <hd@os-cillation.de>
Reviewed-by: Hendrik Donner <hd@os-cillation.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sst.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/mtd/spi-nor/sst.c
+++ b/drivers/mtd/spi-nor/sst.c
@@ -203,6 +203,8 @@ static int sst_nor_write(struct mtd_info
 
 	/* Start write from odd address. */
 	if (to % 2) {
+		bool needs_write_enable = (len > 1);
+
 		/* write one byte. */
 		ret = sst_nor_write_data(nor, to, 1, buf);
 		if (ret < 0)
@@ -210,6 +212,17 @@ static int sst_nor_write(struct mtd_info
 
 		to++;
 		actual++;
+
+		/*
+		 * Byte program clears the write enable latch. If more
+		 * data needs to be written using the AAI sequence,
+		 * re-enable writes.
+		 */
+		if (needs_write_enable) {
+			ret = spi_nor_write_enable(nor);
+			if (ret)
+				goto out;
+		}
 	}
 
 	/* Write out most of the data here. */


