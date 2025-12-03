Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD453126C1;
	Wed,  3 Dec 2025 16:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778186; cv=none; b=HcWEk53b5+yEYkP4Xc4cK50/7optlhJUbmbrwlw+j1jV5DwW/ccsLsGyNcilKouFY5kpJP1+z2KYTOYfiqC0zfatX0Ma1nMOE5MB8ctxPQ++sIO/fh8RFzdv+PFM5MWGMz/STjIaiFfva6BJliEhQ4EO7y8baq4ImTTexjUE7N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778186; c=relaxed/simple;
	bh=IyQQkJRxNgcuX4IXR3uM6COKwV3BrSpGdwtNLZnRLH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TU0WQjbb18NLmFdRzCS9HHjgve8xCSQOktlqxNuhU2WdFcCyW1uaDo+KtwLrFHyDpqo2cIprWOFfkZHmU5XLgr9sbJdl0kQcsVlJVHaufoZleP9nX+vKNQTB0gsT3csIG1aBNGqd/PgS7hEdKMEwrELTn/Fd09yDHdURIbLa9l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYpZXts4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYpZXts4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476C9C116B1;
	Wed,  3 Dec 2025 16:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778185;
	bh=IyQQkJRxNgcuX4IXR3uM6COKwV3BrSpGdwtNLZnRLH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYpZXts4Bj9n5BGRz0mhJY6HkUULuqg9ilx2OCivxj3RfsaPVEAqX4mE7BABK+fYT
	 ecvF/UTsZ9NMGKA5WSRx9FDvdWdXOQZ6vCbV5VT27GO84KwbXzwGcHuuLCxWKzEADE
	 XEyAAl8LtLILmyBJCzXND6mLV5uMFbEWwqMU5Pow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/392] mtd: onenand: Pass correct pointer to IRQ handler
Date: Wed,  3 Dec 2025 16:26:58 +0100
Message-ID: <20251203152424.026830710@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b64895573515e..48608632280c5 100644
--- a/drivers/mtd/nand/onenand/onenand_samsung.c
+++ b/drivers/mtd/nand/onenand/onenand_samsung.c
@@ -909,7 +909,7 @@ static int s3c_onenand_probe(struct platform_device *pdev)
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



