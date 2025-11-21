Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210D3346FB8;
	Fri, 21 Nov 2025 13:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731918; cv=none; b=ct0zQQabvnanRAH/DWFfonXiUO4PkEAxj1DqP5OX0DSQq4/oaUwO5tezpwyiC16l/X9J8hLULzdm5osr8crjqBpoKJXgaOS7qe5RlLK7Jf5xE1M5umoJwB5W4n7fm/XAYSHlyBo0JYuyZEMDmIxemKgApjk8v2OHdcuPGzR85rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731918; c=relaxed/simple;
	bh=nSw7NF+1kNFVFl+W9E8Mkjhac1/6nN62HgGm41J2dSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS0qJR+9aWT2r0qYhKOGsXnAHkRjXwN6jXwpmBJuQupXS6oKoPtYRXQXGC6Om1+NPYCJ9stTci3t+A6Yw/oeYHnPwTLAng8gA4WHaVcnWwbBoMIINXFNsrWsjR3NrEOnlzeosiIJJSkgJQ9cfXfFPpLrlyWoSMsAhdSfGfzaVUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBsLOYFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBsLOYFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05E4C4CEF1;
	Fri, 21 Nov 2025 13:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731918;
	bh=nSw7NF+1kNFVFl+W9E8Mkjhac1/6nN62HgGm41J2dSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBsLOYFh9Ir7wjYeuZrXDUcWcRklzSlUU6b6MYpUM1jrCV/ZUvV1IUVuCRzBkyGoX
	 LQhl0JyTyvpkWfntWeHTk5cV6HtBvGlnAgaOCU+ew+nkLh5qrN84l37qNiV6HH2h5q
	 Gr1ilx+yE28o5/ErJengyUJYdtoGIDrw0hKZLRLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/185] mtd: onenand: Pass correct pointer to IRQ handler
Date: Fri, 21 Nov 2025 14:12:00 +0100
Message-ID: <20251121130147.223816292@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 97315e7c901a1de60e8ca9b11e0e96d0f9253e18 ]

This was supposed to pass "onenand" instead of "&onenand" with the
ampersand.  Passing a random stack address which will be gone when the
function ends makes no sense.  However the good thing is that the pointer
is never used, so this doesn't cause a problem at run time.

Fixes: e23abf4b7743 ("mtd: OneNAND: S5PC110: Implement DMA interrupt method")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/onenand/onenand_samsung.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/onenand/onenand_samsung.c b/drivers/mtd/nand/onenand/onenand_samsung.c
index fd6890a03d557..0e21d443078e4 100644
--- a/drivers/mtd/nand/onenand/onenand_samsung.c
+++ b/drivers/mtd/nand/onenand/onenand_samsung.c
@@ -906,7 +906,7 @@ static int s3c_onenand_probe(struct platform_device *pdev)
 			err = devm_request_irq(&pdev->dev, r->start,
 					       s5pc110_onenand_irq,
 					       IRQF_SHARED, "onenand",
-					       &onenand);
+					       onenand);
 			if (err) {
 				dev_err(&pdev->dev, "failed to get irq\n");
 				return err;
-- 
2.51.0



