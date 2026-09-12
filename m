Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07254248C6;
	Sat, 12 Sep 2026 15:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228138; cv=none; b=CkUd8hiO/XVOv+vGd2cVSNomoL7wqrWq/pgKw88xdTic7tQn4stHnzQgilc7f6YSxKvY2UspV/bVEkkyrmkjYTkWQ1nmIBmmoNus9l6oG9vNmYa19XAqxVP/ZJIJDqLKe3uZQAKjKG9OzaFmmBrvJkc7QxpjAFUvEx8NZCeGO5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228138; c=relaxed/simple;
	bh=6d5/kQu8KD0UBjPBEoBcvp7/e/Fg7KuuvQBCt4usnDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttW1JhUQmq2fVcdJNnEWTJFc5vpmpxjUZbJInE+wXG3k47BwLTKX6Wy9suLIqJnb/7vJJJpZWPoG2TWw3jK5fd2CxLtLV3bM1RoNrMSNImXYw69zb2sNHIc4BJGoIKvjNYpfPdusbpxXYSB2zw4JmwRMJZzCDwtEioHHmGa2kz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnym7px3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnym7px3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E171F000FF;
	Sat, 12 Sep 2026 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228137;
	bh=sRGHu4b2xTIHTB21E2e/pWYQ7rmTbfTbhKRhEg/UPts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnym7px3T9UdnaWrlRYoGvMaNacIhkeFkgeOaWc3a87YW5VAftVnWxFwbv/y+T/Zz
	 6sjgMomTdxzABHwBVf3PMfm1J5V3eNF73kUyONEJNZh19Dj9hf697uIlWACPmZfbaM
	 1ez1L2FLx1okZ3PmbYbU6nyYJQ4dpGFGt6x832Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 0322/1191] mtd: afs: validate v2 image info bounds
Date: Sat, 12 Sep 2026 08:50:50 +0200
Message-ID: <20260912065555.461743299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit e9290031f736e99ad17c25c00311c92c266843b7 upstream.

The AFS v2 parser uses footer[8] to locate the image information block
inside the current erase block, then uses the image information
region_count to walk entries from a fixed local array. The footer offset
and region count come from flash contents and are not checked against the
erase block or the local image-info array before use.

Reject v2 entries whose image information offset would underflow the
erase block calculation, and reject region counts that cannot fit in the
local image-info array before walking region entries.

Fixes: b7cf5e2830bb ("mtd: afs: add v2 partition parsing")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Acked-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/parsers/afs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mtd/parsers/afs.c
+++ b/drivers/mtd/parsers/afs.c
@@ -235,6 +235,9 @@ static int afs_parse_v2_partition(struct
 	pr_debug("Parsing v2 partition @%08x-%08x\n",
 		 off, off + mtd->erasesize);
 
+	if (mtd->erasesize < sizeof(footer))
+		return -EINVAL;
+
 	/* First read the footer */
 	ptr = off + mtd->erasesize - sizeof(footer);
 	ret = mtd_read(mtd, ptr, sizeof(footer), &sz, (u_char *)footer);
@@ -245,6 +248,8 @@ static int afs_parse_v2_partition(struct
 	}
 	name = (char *) &footer[0];
 	version = footer[9];
+	if (footer[8] > mtd->erasesize - sizeof(footer))
+		return -EINVAL;
 	ptr = off + mtd->erasesize - sizeof(footer) - footer[8];
 
 	pr_debug("found image \"%s\", version %08x, info @%08x\n",
@@ -278,6 +283,8 @@ static int afs_parse_v2_partition(struct
 	entrypoint = imginfo[pad];
 	attributes = imginfo[pad+1];
 	region_count = imginfo[pad+2];
+	if (region_count > (ARRAY_SIZE(imginfo) - pad - 3) / 4)
+		return -EINVAL;
 	block_start = imginfo[20];
 	block_end = imginfo[21];
 


