Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66DC3358BE;
	Fri, 21 Nov 2025 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733527; cv=none; b=d804vNl+kySsE5IPxn9ux4wrbygNSL0TrjaWJ0fkNW4Rwee3q7uEnWbiQ++KuQ0N3COvWYxpg/cUBs2DN8kCu0MuTfvlOhLMmq/7vvAY2NwvAR50WlWxVSzkqpFto536YH4qZfjU2wHvV40rri5UTei45SP2oS/oYaLPpX7JOnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733527; c=relaxed/simple;
	bh=/yPJIkFM8N5Mjz5+AwG2I8WL+pXzt97053mHR4BDYqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzX7tE0XTOcY+ljaH+jCh+d8/RDcG7nCUX1thi2bZ+XDg299Kig1QWLvxz48FYSHcBlwz+TqT5OZmJWfT/SdMYvdRyeiQb6MdrxoWNt2bA7J5CvNLNamtOA+hQfLWyH3k51k0WQiNA5yU0MFdveI6oWpD/jJAg7oIeG/YvorGlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcqBNnVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcqBNnVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B28C4CEF1;
	Fri, 21 Nov 2025 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733526;
	bh=/yPJIkFM8N5Mjz5+AwG2I8WL+pXzt97053mHR4BDYqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcqBNnVLdZ23R2y9/yvBrqdb8m5UxKZQyP0BdH32bvkf0UNigmjnC8we8Rt6hz5d6
	 Bgn6BE1vkFWmSKK7w6UWLfttdzHpKBAnSHgUwBNWzm5IGm8hvvs6QACoQLQ2jHSp7p
	 5hreN935+I0gfdmJtMgnZFV6njDAmduw3TlsWp94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 455/529] mtd: onenand: Pass correct pointer to IRQ handler
Date: Fri, 21 Nov 2025 14:12:34 +0100
Message-ID: <20251121130247.197879758@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



