Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E068281357;
	Wed, 23 Apr 2025 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421139; cv=none; b=eZNTz9y6z4yG6mzuHTtNEBuw7ddZ46jaCgbKzMaIEKnJ81NSZ3bwZNPBzTEDqfOmabJn0QdpwzOKV/yjGi+9odxLhrWgZi9ZPnSfgRGSdX+mgiLgLgKI68pMu35a2eJhJKYaHAGbR+hkSdUzBJ9rDm5xr08eJIG5Z3KAhqrpLoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421139; c=relaxed/simple;
	bh=+Lbi3ONyU943Llc/nr4G64NzaVeULR9q2yKvpcYqn6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJhDG3YBMnRWpGJssc4Nxcm1ivuBwPnW+wBTc2TdrHrTJU+2+x57c2P2Wh9TV9dAAhTrC3DdwrM4cZKKHJlTJbFLzHbn16Bcms2rIA9sj8Dgon3nH7SdZEigSs1z8B3q5Aob+7G0HgaDz7q/jGx9KLkbzV9T0RwlmjYxaEMH9ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UClKI9kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UClKI9kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2C8C4CEE2;
	Wed, 23 Apr 2025 15:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421139;
	bh=+Lbi3ONyU943Llc/nr4G64NzaVeULR9q2yKvpcYqn6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UClKI9kwHJ1HQ3MTi5by+E/nPm5W/AhzaatnHo2MCf3Yo46VyZYN5Ho4KrOFlQWh9
	 fQQ+Kee5GuK4UQHnwD7Tfoyy51Y3Tc6l2b0mwBENyNj2/fIVYTacJfsOqONtRoYWBm
	 utkEK7xtYZoiETsuw+cKkKYLKaf6DAcx1Dcx+usM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 150/393] mtd: Replace kcalloc() with devm_kcalloc()
Date: Wed, 23 Apr 2025 16:40:46 +0200
Message-ID: <20250423142649.575902723@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 1b61a59876f0eafc19b23007c522ee407f55dbec upstream.

Replace kcalloc() with devm_kcalloc() to prevent memory leaks in case of
errors.

Fixes: 78c08247b9d3 ("mtd: Support kmsg dumper based on pstore/blk")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpstore.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/mtd/mtdpstore.c
+++ b/drivers/mtd/mtdpstore.c
@@ -417,11 +417,11 @@ static void mtdpstore_notify_add(struct
 	}
 
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, info->kmsg_size));
-	cxt->rmmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
-	cxt->usedmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
+	cxt->rmmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
+	cxt->usedmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
 
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, mtd->erasesize));
-	cxt->badmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
+	cxt->badmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
 
 	if (!cxt->rmmap || !cxt->usedmap || !cxt->badmap)
 		return;
@@ -530,9 +530,6 @@ static void mtdpstore_notify_remove(stru
 	mtdpstore_flush_removed(cxt);
 
 	unregister_pstore_device(&cxt->dev);
-	kfree(cxt->badmap);
-	kfree(cxt->usedmap);
-	kfree(cxt->rmmap);
 	cxt->mtd = NULL;
 	cxt->index = -1;
 }


