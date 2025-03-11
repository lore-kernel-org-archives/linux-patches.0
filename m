Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0D2255E37;
	Tue, 11 Mar 2025 15:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705790; cv=none; b=dNWgnJxgiqdA60IfLPBcVi1MZITsiDjOhipMs+qUMY5l4TSEnCIvT0w17/jI8IkE9/4HfK/yhWhHBa1hBsCf49XjT3dR6ID9+Uy7aNUg2u1Qm+Z3Rjh9ojSBnYL+LMhHPZALSl0bSgEUa9le/uqIsHv3G6GFm95wEDD90gh98RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705790; c=relaxed/simple;
	bh=cZ7qjRxmkSkOulxg1PSgM5I9rpsM4FwUf5WtHv0gNRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHtFFZ/F6ajsjjtwPgoDUjhGtIG2XNcZhn5rZklhGYioyyNqMckivg0oRRFHMzGX9VSnIwGvZSbuq08Aist0lFXH9Aik3TvxSt8/rd51lQJZ/275s9fXjCDyzE6E6QYa/Y/PfjYkkvL3WT7Fcw8NUuzOvRon5moHCbZjbPQxxgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWE1A7lX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWE1A7lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1692CC4CEE9;
	Tue, 11 Mar 2025 15:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705790;
	bh=cZ7qjRxmkSkOulxg1PSgM5I9rpsM4FwUf5WtHv0gNRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWE1A7lXuDCoD+VttTkYBb18ngnmPkEnAWs465t0VmRyAKI7uQOuJO0Y6beyhYj25
	 sslVFyNVqni7pY60aks3YtYDL0ynWvbxF7FO4pAgUwWIlKXgH9FBR18pIpm20fSFsA
	 p3IofcsXd1JvfIyt2N+YlP+VAGAXES4r9yD8Ku5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 156/328] mtd: onenand: Fix uninitialized retlen in do_otp_read()
Date: Tue, 11 Mar 2025 15:58:46 +0100
Message-ID: <20250311145721.107366449@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2921,6 +2921,7 @@ static int do_otp_read(struct mtd_info *
 	ret = ONENAND_IS_4KB_PAGE(this) ?
 		onenand_mlc_read_ops_nolock(mtd, from, &ops) :
 		onenand_read_ops_nolock(mtd, from, &ops);
+	*retlen = ops.retlen;
 
 	/* Exit OTP access mode */
 	this->command(mtd, ONENAND_CMD_RESET, 0, 0);


