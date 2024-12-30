Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535AC15E8B;
	Mon, 30 Dec 2024 15:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574226; cv=none; b=cAq1y1KRcVTerOPDkx/ylFB3DwYT3KihOsRrbBFckmfpUU2rh2JFLuBcT1mjkOLeKwZyIjcTbfkkv/KieQACQpreV3E0wWxAJvEi6iuGVAHfrEeXEK37Kteb0hYQT5QPbaTq1+jqDveM4fNUY/uSGQWHwP3PT2lW3NxWV22Tabw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574226; c=relaxed/simple;
	bh=Tq2ofGbco3PwTlwrYKeyRoqXuIESnvHrkbyycHJIsXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIW+bLesjuU854LgXeB1QhqSt+5xuKInZGPw+gjUajfptdmxgBxZ1gL8YL8VnRp+yveJ860L9AfZK3dyXGD+pBBhAtNF/BVAJ2CYJp689c7FalDBEhCulQByB1JH7Fz+KIFr5cN1uYBeLLoFvOmDgke95rn+E6xbwtSBU3JLfVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wud2wmwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wud2wmwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0427C4CED0;
	Mon, 30 Dec 2024 15:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574226;
	bh=Tq2ofGbco3PwTlwrYKeyRoqXuIESnvHrkbyycHJIsXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wud2wmwWMus5bXjtnRDFfvjwn9a2HaapE6/dF3f6YMvD2dYFXevfbDGO8igb8seI/
	 /NW3aVjnQE4icU0zZoCwYlFCZ5ra9daG5RDe6tQ/KMBSxsyu6HqEWXP7Ex+olDedNG
	 AfyqaE/r411RMOCxwfEfRgInVOg0GDiWPBQxdWAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purushothama Siddaiah <psiddaiah@mvista.com>,
	Corey Minyard <cminyard@mvista.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/114] spi: omap2-mcspi: Fix the IS_ERR() bug for devm_clk_get_optional_enabled()
Date: Mon, 30 Dec 2024 16:43:10 +0100
Message-ID: <20241230154220.906132343@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Purushothama Siddaiah <psiddaiah@mvista.com>

[ Upstream commit 4c6ac5446d060f0bf435ccc8bc3aa7b7b5f718ad ]

The devm_clk_get_optional_enabled() function returns error
pointers(PTR_ERR()). So use IS_ERR() to check it.

Verified on K3-J7200 EVM board, without clock node mentioned
in the device tree.

Signed-off-by: Purushothama Siddaiah <psiddaiah@mvista.com>
Reviewed-by: Corey Minyard <cminyard@mvista.com>
Link: https://patch.msgid.link/20241205070426.1861048-1-psiddaiah@mvista.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 2c043817c66a..4a2f84c4d22e 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1561,10 +1561,10 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	}
 
 	mcspi->ref_clk = devm_clk_get_optional_enabled(&pdev->dev, NULL);
-	if (mcspi->ref_clk)
-		mcspi->ref_clk_hz = clk_get_rate(mcspi->ref_clk);
-	else
+	if (IS_ERR(mcspi->ref_clk))
 		mcspi->ref_clk_hz = OMAP2_MCSPI_MAX_FREQ;
+	else
+		mcspi->ref_clk_hz = clk_get_rate(mcspi->ref_clk);
 	ctlr->max_speed_hz = mcspi->ref_clk_hz;
 	ctlr->min_speed_hz = mcspi->ref_clk_hz >> 15;
 
-- 
2.39.5



