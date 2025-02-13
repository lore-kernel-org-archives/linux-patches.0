Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A2A1547F0;
	Thu, 13 Feb 2025 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460077; cv=none; b=scdKkt5EUtEJG3jMVtLjBnF7i5EHp8pDL8kZWO6deS5pDW8gwQOFAAtUj66dFakZK3ny4w9kwml7qORYffJXP73tb7/f0nzwuFYqxS5qG7Sae64bd4kbFF0ruZU94GBrPVQcUr6bWZn3RruZ7FvJz5oB7YnKhOiFzqzvmcuR4Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460077; c=relaxed/simple;
	bh=a0yL6/AyCFUVqLPeTAeQrFs1oVEC1QD1kqTH6LEhDoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOEMg0VH3SDVgSrC1ptrfzD9AgX2HyzTVE4KmOJ4XvBCfl+1Q/PaK/9DuFFGut2G2+IT9h2krxsO2yG6LdqBBp97HnVbgrhSFtcVq2xGoR09jVL3fZhAhbenN9ilyiLO4lPkcuZD8YWmYflb1FERmluMCwv+fpxaL4VMcuZ3mV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0aHSY+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0aHSY+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC5CC4CEE8;
	Thu, 13 Feb 2025 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460076;
	bh=a0yL6/AyCFUVqLPeTAeQrFs1oVEC1QD1kqTH6LEhDoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0aHSY+xcTdOPyaNTiwmrnOcWGLHInR9q7mzLCyp32RNsIqDyfpirImIj0A9CTdmU
	 PXBtOY4JRdCbCAnLLTDeowhbPk5/ajVtm9dXcOW+z48HEM3Kr1bC0ZdQ2Z5mUhYAXP
	 B9K5lDu+yLupR2zfNHr0rlD11g1s/f5mrwyiTFy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.13 410/443] mtd: onenand: Fix uninitialized retlen in do_otp_read()
Date: Thu, 13 Feb 2025 15:29:35 +0100
Message-ID: <20250213142456.428295690@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


