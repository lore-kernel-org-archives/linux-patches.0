Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F40819F40A;
	Thu, 17 Apr 2025 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913243; cv=none; b=am1n5NqbUfe3RI8YzFFbm9XzkinOa68XO3xNBsu5Ssibp7/cH4D9BR3yY2y2uhDTP7WGiMb7IVrsQWtLwkCUSAoDxQSWozfeDRrNHoUOUVE+CfPIuwLPZz7s9NnI+08X//tu4tXd5s4Wmp4Z79ysL0aDslKxIShxn3z3jBMDF0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913243; c=relaxed/simple;
	bh=hDIhx/FB2w5Yr7GYU3sT6An52DH/lXeAxwW2YBymt9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1H4jnTmIbzyfS/mlZ8szriK8fG6yjdIDA6CmbEzqZwspyEOtqjTIX+zDkD/A7LyvxXn1uslcnqCpL7/HcBmXInzEQn5VIvgB00RtFevG2aSf90OumlE3oqydIeKxGclqGr0CLFck3lQWylLXKG9qRdp9QPzPkiu1GFiLjqKh98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2pttEru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2pttEru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E3BC4CEE4;
	Thu, 17 Apr 2025 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913243;
	bh=hDIhx/FB2w5Yr7GYU3sT6An52DH/lXeAxwW2YBymt9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2pttEruQWDIYSA1CLkNEjsAjDWm1Z5CxkjTaaQduOMbhoS6AVlLJOgvHDUDhpi1E
	 jZKTPGQDpJOMQ/E2AKNLRWIS9ANcPekm6tyo6kZ6DNQ09Z31LaonUlUtJAWwd8n98M
	 DpvQDPogCKeet43q6K3OXf3/mORiTIC2SVgKIVU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.14 275/449] mtd: Replace kcalloc() with devm_kcalloc()
Date: Thu, 17 Apr 2025 19:49:23 +0200
Message-ID: <20250417175129.129531997@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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


