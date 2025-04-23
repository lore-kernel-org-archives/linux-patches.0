Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BB128E5F5;
	Wed, 23 Apr 2025 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421118; cv=none; b=u4j3t//NkXAnCDc7InYARcbzhI2LtUb4om5dqHNOQpu0d5lznoHWEFkr5p0ysVT1RhrvWslE6SGmKzkO3FPXMG8SBDDjd1U+2K+/BJYYKjmnsbK39GRLG0NXyEuFRM/Hlyg+A3bohOOXWOQUNhyBBjbiIZ1lDCJF+ELhv4RHJZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421118; c=relaxed/simple;
	bh=q7Hiy/oMKmIGA9jBcxoLcW40QVJRElc4J2wvwhopIm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mO+Rxt+LlS5YFHNYMGEq6Uv8HZS18Rra8EO0XcGCyVdlcq7ig+9MXFG3TamWMDuVLDjtvNi2KBxOwRQ4MXLi2WXx2Ge8XdIkI5y+kQfSHcX8VvtNINGLlv2faqaTwnbpFeJ+fD4blg3Y81+8b7KtCJpfGn4e0JxFW1jdghM6Oxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXiYWKmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXiYWKmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B09C4CEE8;
	Wed, 23 Apr 2025 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421118;
	bh=q7Hiy/oMKmIGA9jBcxoLcW40QVJRElc4J2wvwhopIm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXiYWKmnETSmFKmtiMGJXg/g6Bn9tJ3m4BV2R5l4s55oqMpPfpZT+yN0kMW4Zp/Fo
	 AyIEDU8yoiG1r88l5xycano31XGZ0VrhGwKe/s6uYbuQaY/S8P1sdNINU/VraYYQAL
	 DW6xUmptaCH/hSIZgn2aXsnsCUc61Ogs4b9ffVVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 148/393] mtd: Add check for devm_kcalloc()
Date: Wed, 23 Apr 2025 16:40:44 +0200
Message-ID: <20250423142649.496114794@linuxfoundation.org>
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

commit 2aee30bb10d7bad0a60255059c9ce1b84cf0130e upstream.

Add a check for devm_kcalloc() to ensure successful allocation.

Fixes: 78c08247b9d3 ("mtd: Support kmsg dumper based on pstore/blk")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpstore.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/mtdpstore.c
+++ b/drivers/mtd/mtdpstore.c
@@ -423,6 +423,9 @@ static void mtdpstore_notify_add(struct
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, mtd->erasesize));
 	cxt->badmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
 
+	if (!cxt->rmmap || !cxt->usedmap || !cxt->badmap)
+		return;
+
 	/* just support dmesg right now */
 	cxt->dev.flags = PSTORE_FLAGS_DMESG;
 	cxt->dev.zone.read = mtdpstore_read;


