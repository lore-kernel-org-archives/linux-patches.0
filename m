Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8322566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C1EC4339C;
	Tue, 18 Apr 2023 12:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820878;
	bh=efiiKarjmrO4+BjbyzVnd63nkffzhlECuL7abW/zxYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUgZzq8I8DqezBtn0DXDqi1Rgb8gL4b5Sbp3cO7HGnAe50qWlrjDT7Vptb6AAKKWX
	 QOzHlk2VPA1HANgEG4CA9GH/R2OQpJUY+1UCYZhl9bK4nuKrvPbW0OepkfTrfljzKS
	 h9UhV6P2tYYD2Cnao7pZTlNTBUUdoZ+vug9+d4ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bang Li <libang.linuxer@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 35/57] mtdblock: tolerate corrected bit-flips
Date: Tue, 18 Apr 2023 14:21:35 +0200
Message-Id: <20230418120259.962150002@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bang Li <libang.linuxer@gmail.com>

commit 0c3089601f064d80b3838eceb711fcac04bceaad upstream.

mtd_read() may return -EUCLEAN in case of corrected bit-flips.This
particular condition should not be treated like an error.

Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Fixes: e47f68587b82 ("mtd: check for max_bitflips in mtd_read_oob()")
Cc: <stable@vger.kernel.org> # v3.7
Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230328163012.4264-1-libang.linuxer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdblock.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -164,7 +164,7 @@ static int do_cached_write (struct mtdbl
 				mtdblk->cache_state = STATE_EMPTY;
 				ret = mtd_read(mtd, sect_start, sect_size,
 					       &retlen, mtdblk->cache_data);
-				if (ret)
+				if (ret && !mtd_is_bitflip(ret))
 					return ret;
 				if (retlen != sect_size)
 					return -EIO;
@@ -199,8 +199,12 @@ static int do_cached_read (struct mtdblk
 	pr_debug("mtdblock: read on \"%s\" at 0x%lx, size 0x%x\n",
 			mtd->name, pos, len);
 
-	if (!sect_size)
-		return mtd_read(mtd, pos, len, &retlen, buf);
+	if (!sect_size) {
+		ret = mtd_read(mtd, pos, len, &retlen, buf);
+		if (ret && !mtd_is_bitflip(ret))
+			return ret;
+		return 0;
+	}
 
 	while (len > 0) {
 		unsigned long sect_start = (pos/sect_size)*sect_size;
@@ -220,7 +224,7 @@ static int do_cached_read (struct mtdblk
 			memcpy (buf, mtdblk->cache_data + offset, size);
 		} else {
 			ret = mtd_read(mtd, pos, size, &retlen, buf);
-			if (ret)
+			if (ret && !mtd_is_bitflip(ret))
 				return ret;
 			if (retlen != size)
 				return -EIO;


