Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C33227EA0;
	Mon, 10 Mar 2025 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629612; cv=none; b=vD//vSpHFoVEdVhfXcUrisnXnD1MHXNpsrJ0sXomdN9OGd3IWYUTkCQg2XdQT7OhhbxKpmN/cwZetsXGPPP631uUQs4r2ukGYH22SpZE0+7b0cKOB7ZQTGCrElseuQuWs49+TnpGkMsYsORdU10TUFQLkLs1xTLlNnvphcqN+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629612; c=relaxed/simple;
	bh=moILZu9gOfdf9MUs/aEdh6oP26Knu+hw+FMRnjMDkBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUNlESkcIyD6blb83qAOublxdmGWaZG8LibZ9sAfCDZpBf8UMoyTLeKWFN1dXyctN+Gu/SObVzUsY6MmM3SgkkKGVJUmJfI9z/R0BZLUtQQCpN/WRmXZr1n6XrfcD84FEZWDNUpp0i3icA74RA078rTiuerrL8+s3tOE1DrLBHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqgNnRr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqgNnRr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B24BC4CEE5;
	Mon, 10 Mar 2025 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629612;
	bh=moILZu9gOfdf9MUs/aEdh6oP26Knu+hw+FMRnjMDkBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqgNnRr0BkCaddK9LsKBgwmTV1uK9ZXSWAZqFhptLkgYl2SJGYhQJF98VTftEyOww
	 L3kM8OKc3m4xZwhLJddqaWKD4MuOV8pK2zpO+hZSN6/eLT1pofZz2gGCRKjvsu0Ota
	 7UVeVQKPS+MzhLidYh9Vc2FVl5esJi9mVtc0wFmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 323/620] mtd: onenand: Fix uninitialized retlen in do_otp_read()
Date: Mon, 10 Mar 2025 18:02:49 +0100
Message-ID: <20250310170558.356720703@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2911,6 +2911,7 @@ static int do_otp_read(struct mtd_info *
 	ret = ONENAND_IS_4KB_PAGE(this) ?
 		onenand_mlc_read_ops_nolock(mtd, from, &ops) :
 		onenand_read_ops_nolock(mtd, from, &ops);
+	*retlen = ops.retlen;
 
 	/* Exit OTP access mode */
 	this->command(mtd, ONENAND_CMD_RESET, 0, 0);


