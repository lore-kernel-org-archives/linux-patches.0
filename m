Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E0412C47A;
	Tue, 30 Apr 2024 11:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476298; cv=none; b=lRhe4wMYqKOg93QcIf2AKkx2H2WIY10GuD15FNXfPQJFVr1cyjLoZ9UpSxgE7qobRu3bCoQ6ajc3OP29bEIERe5XBRLOydcHGbM1ls5tKouq4BVdyQH16YvsLIm9rs9jv4QZnNykQki/kX73kfyY3zYunCwE9imLm4Oacj1sjn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476298; c=relaxed/simple;
	bh=dBEnNRLDx28w+DDLgNWPFCJ3R+nxSIbLnXeH8JyPBGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCvCiO0uV7yY8u3zeDWn2HpbaCn9emMaBUU46wrZCVfvSTWP8bLq+Iv1hDUaFfDR3OtD2huSl2Lwx95LdwfpUTwhCvxj4Wq/n60xLquZFbYbp4Lh63hHYKwA2byCkT1psdFLAscLv0eq0WyZeHgYvEEvTZhyq8no8FM6aVlJy+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHHVgqAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHHVgqAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04193C2BBFC;
	Tue, 30 Apr 2024 11:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476298;
	bh=dBEnNRLDx28w+DDLgNWPFCJ3R+nxSIbLnXeH8JyPBGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHHVgqAJHC6tgKUIPbQYQ63vFR6gu90IEMvCQcHtPzThHYytuRzoKzfdWt+U52wOY
	 GVsYGxiNWCp5Ze7QTHiQanZnBbT6VqRaO75IVp++iH+SPY4JYO8Y0Hnud5Utr1IJ2J
	 ZDNp5Pzr2+P2imu/RSajUIyRBcRS7AtvKGdx0bj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 097/107] mtd: diskonchip: work around ubsan link failure
Date: Tue, 30 Apr 2024 12:40:57 +0200
Message-ID: <20240430103047.521177987@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 21c9fb611c25d5cd038f6fe485232e7884bb0b3d upstream.

I ran into a randconfig build failure with UBSAN using gcc-13.2:

arm-linux-gnueabi-ld: error: unplaced orphan section `.bss..Lubsan_data31' from `drivers/mtd/nand/raw/diskonchip.o'

I'm not entirely sure what is going on here, but I suspect this has something
to do with the check for the end of the doc_locations[] array that contains
an (unsigned long)0xffffffff element, which is compared against the signed
(int)0xffffffff. If this is the case, we should get a runtime check for
undefined behavior, but we instead get an unexpected build-time error.

I would have expected this to work fine on 32-bit architectures despite the
signed integer overflow, though on 64-bit architectures this likely won't
ever work.

Changing the contition to instead check for the size of the array makes the
code safe everywhere and avoids the ubsan check that leads to the link
error. The loop code goes back to before 2.6.12.

Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240405143015.717429-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/diskonchip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/diskonchip.c
+++ b/drivers/mtd/nand/raw/diskonchip.c
@@ -53,7 +53,7 @@ static unsigned long doc_locations[] __i
 	0xe8000, 0xea000, 0xec000, 0xee000,
 #endif
 #endif
-	0xffffffff };
+};
 
 static struct mtd_info *doclist = NULL;
 
@@ -1666,7 +1666,7 @@ static int __init init_nanddoc(void)
 		if (ret < 0)
 			return ret;
 	} else {
-		for (i = 0; (doc_locations[i] != 0xffffffff); i++) {
+		for (i = 0; i < ARRAY_SIZE(doc_locations); i++) {
 			doc_probe(doc_locations[i]);
 		}
 	}


