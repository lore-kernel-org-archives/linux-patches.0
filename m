Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202B21DF749;
	Tue, 11 Mar 2025 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707029; cv=none; b=EwiEx3HHWXBFk+T5eQ16jXdxyD44H3vMxtFiEH5HcACojSXZpAX37siZyZa5aUgNfTOxIyXU303iJCuZpPBDFllK4A2XZHpFiNcib6P6vooNSJcFhX2jikmExpi20OPFbvtyTZHjbeGGps4SMLEYXJcb28bRb5e8eZdZyunxhkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707029; c=relaxed/simple;
	bh=Egjrp8vTtXDtXyT72sD73pK0NQo8qyVh8usbvvL5UTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNBmY6cpSv7pD6wuPaJ5i81JyVwjav/PfVlk0YlImOi3TTvEujCdlit0UBMrFxHN9U/dCg8RLqMnMUiuAcvW2kRyRDzJVfqqLwYeHkFU3mny0HyKK4dXyMxrBU5m+TOjHKvflxXwH50g49OVCc7leOF31Eyqe5WRiq2A3D0Jf80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pNbXYTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pNbXYTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E952C4CEE9;
	Tue, 11 Mar 2025 15:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707029;
	bh=Egjrp8vTtXDtXyT72sD73pK0NQo8qyVh8usbvvL5UTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pNbXYTSBYS9YJJ20R4L+ZYue79+0Y91Twk0xl5HaaL0hTUz/v68sQoyjyeDeg1lK
	 3ARl4znWxPQCO2FzNBb7NzFplArLRTb4sHmFfKdql1h0093vJE+5HPVEwtGZ7LAV32
	 1hNyBMLkcMm/b4JAyBk4inHS+EtpCBKBKnKDPMvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 218/462] mtd: onenand: Fix uninitialized retlen in do_otp_read()
Date: Tue, 11 Mar 2025 15:58:04 +0100
Message-ID: <20250311145806.977265398@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2916,6 +2916,7 @@ static int do_otp_read(struct mtd_info *
 	ret = ONENAND_IS_4KB_PAGE(this) ?
 		onenand_mlc_read_ops_nolock(mtd, from, &ops) :
 		onenand_read_ops_nolock(mtd, from, &ops);
+	*retlen = ops.retlen;
 
 	/* Exit OTP access mode */
 	this->command(mtd, ONENAND_CMD_RESET, 0, 0);


