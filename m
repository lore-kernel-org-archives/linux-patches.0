Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9441531DB;
	Thu, 13 Feb 2025 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460943; cv=none; b=i2IeDhJC944Pk9WmewPrEBjQtxXwNbn8++Q3sgZxW9kr1SczTFZyptpybBLBxzGe+C3/y1KtTYYCOuUctiiIN2aeGI3j7nKvloCY/PgPAbiNXThPihF7HhsJF3RliOmzhXc4MLI5twbJVe+6lhsAuXZykLNmWmGTwFhaWEYALyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460943; c=relaxed/simple;
	bh=gxkNLhN5Vywso3kIlbPB/ydear+z2K+5Pj1apJpNgjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoCYDOCReugBHO4e4OUIGG3mNT8oM5wVE1ithYhBwu1EGxidU276h3cGp9bXDmZvfP/bjBayRtlkTrNqmpgdOSK5Z9DbgVoVXP8TCW2WkBXsDEU+Ip1j1gQzyjX3Kv15fYjNCjmQpmUVhc7n9+eRAGtO3kj8vHvtry7XJ3EUG6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drx760uN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drx760uN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7179C4CED1;
	Thu, 13 Feb 2025 15:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460943;
	bh=gxkNLhN5Vywso3kIlbPB/ydear+z2K+5Pj1apJpNgjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drx760uN9WezII3l2g7ViZIQwROlw7c5jro+KwP6gOhz7R7dL8qK5N2yP2XgO0rVb
	 r4/nZMGDMgjOtAYIzpDW8Bib4YzGA2JSFN/wgeAbyuqqKosLc3hSezsxHrYjs+33+c
	 q0dJw9MkOLPt9Y0k5TeXwiDe+ZngLC/i50JrkYtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 240/273] mtd: onenand: Fix uninitialized retlen in do_otp_read()
Date: Thu, 13 Feb 2025 15:30:12 +0100
Message-ID: <20250213142416.918297790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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


