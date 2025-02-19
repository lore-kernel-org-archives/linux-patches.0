Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC070188CCA;
	Wed, 19 Feb 2025 09:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957169; cv=none; b=IWYzXYTVQpPjA6VlTliFCgG6u4pCW2fOhzdRAAkOBEDKpBH/qdFOTc8OVzRvJYUlo0CJL/IhqY0tu1dYHq1PtYYtN3dCg1f74qjVoErBtmxQ0xJUeAr2ncNjt6grqzs3Tewmsdh2QPZb0xvsDHw69j1JbY10UdnBU8fZTo/SGtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957169; c=relaxed/simple;
	bh=SUPR+0puziScBKScoxuP2k9GYRD8/Drz4lilGJZs42k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3I8Lh9xgqQOBKg566MzINKyzncpSYd9F6sUCajNpmnM4eUDJLg7le62d704KbqgYadt5LFhYd4KOPhdJS0wqcaOCKacAADpd0IppAheKJ7KMzRg8gG7UJpoz45cvajkVhSyiijmU8ti/K9Lb56JsLoRNZR7qgL0/MOqZBw9Ylw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iP3r1RcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iP3r1RcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35524C4CED1;
	Wed, 19 Feb 2025 09:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957169;
	bh=SUPR+0puziScBKScoxuP2k9GYRD8/Drz4lilGJZs42k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iP3r1RcZTRskUyql9V0MrO9mKlbVep1zkEvaH0Auwv/43S/gbMQL8Yad9D/SX3Aiy
	 ZSH9bclsJ4Lr80yAONhgZcemp2S3/thUbf5azuVQvyOXjp24+Nv63f091LnP5rU/b+
	 iNp8Aj5hZlFMclvRCDVXsHr8On4uy7plsC9ObxnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 433/578] mtd: onenand: Fix uninitialized retlen in do_otp_read()
Date: Wed, 19 Feb 2025 09:27:17 +0100
Message-ID: <20250219082710.044810671@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Ivan Stepchenko <sid@itb.spb.ru>

commit 70a71f8151b9879b0950668ce3ad76263261fee0 upstream.

The function do_otp_read() does not set the output parameter *retlen,
which is expected to contain the number of bytes actually read.
As a result, in onenand_otp_walk(), the tmp_retlen variable remains
uninitialized after calling do_otp_walk() and used to change
the values of the buf, len and retlen variables.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 49dc08eeda70 ("[MTD] [OneNAND] fix numerous races")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Stepchenko <sid@itb.spb.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/onenand/onenand_base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/onenand/onenand_base.c
+++ b/drivers/mtd/nand/onenand/onenand_base.c
@@ -2923,6 +2923,7 @@ static int do_otp_read(struct mtd_info *
 	ret = ONENAND_IS_4KB_PAGE(this) ?
 		onenand_mlc_read_ops_nolock(mtd, from, &ops) :
 		onenand_read_ops_nolock(mtd, from, &ops);
+	*retlen = ops.retlen;
 
 	/* Exit OTP access mode */
 	this->command(mtd, ONENAND_CMD_RESET, 0, 0);


