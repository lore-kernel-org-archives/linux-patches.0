Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94711F9D4;
	Tue, 14 May 2024 11:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687818; cv=none; b=pWEXJZ6c+XOUkZGYuGrdaeZ72N+RVwjtu88SANm4IPBBaQYQhn+h6KM4bWw+3fd+g7C+yZK7SX9umv1MvrzOP3eBxbGJDN7c7G0zXF4q9S4FEYHHoI2HXJi4JCH64TUAjSF7jCPPjSSe4mRvhkPeBwotpOWfLN63PjH801eGPk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687818; c=relaxed/simple;
	bh=ntskfUeOP6y8aBguSve0jH0+crB4cReIFt1j8e/7JE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHSE14Nn9/aKyfPWTdtUtvJvLEKX+8mcHunblPnhP6cm+hImMVu2yisDx8ZkDtG51r3BttSjMWWGlkAqstpxavjKqjIVt+EQav3aWxc3MaDxcMjmJitPYpq1rrdZp8jsufOR9Kcb1Uqizm5lyH2sez4BfyTka9Ip7XjFM/kb3go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lbyqz1Rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lbyqz1Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E810C2BD10;
	Tue, 14 May 2024 11:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687818;
	bh=ntskfUeOP6y8aBguSve0jH0+crB4cReIFt1j8e/7JE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lbyqz1RnDM0GFRdd8H0ZZGE6tw0p9CCLTu4WOc1LfY8ZxjpoCnTuaPcM771sevT9S
	 ouAkTbQX3XU+JxOQ7G+AP62S51TnI3AVvj9/mKcC6unDvBxr3muGvQ4m5ZxfhakRAZ
	 iuBxzjZkk4qlsxbSaIEpYQEJ0qjgu/tkheXmy5Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/168] ata: sata_gemini: Check clk_enable() result
Date: Tue, 14 May 2024 12:19:32 +0200
Message-ID: <20240514101009.489038233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit e85006ae7430aef780cc4f0849692e266a102ec0 ]

The call to clk_enable() in gemini_sata_start_bridge() can fail.
Add a check to detect such failure.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_gemini.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/sata_gemini.c b/drivers/ata/sata_gemini.c
index 6fd54e968d10a..1564472fd5d50 100644
--- a/drivers/ata/sata_gemini.c
+++ b/drivers/ata/sata_gemini.c
@@ -201,7 +201,10 @@ int gemini_sata_start_bridge(struct sata_gemini *sg, unsigned int bridge)
 		pclk = sg->sata0_pclk;
 	else
 		pclk = sg->sata1_pclk;
-	clk_enable(pclk);
+	ret = clk_enable(pclk);
+	if (ret)
+		return ret;
+
 	msleep(10);
 
 	/* Do not keep clocking a bridge that is not online */
-- 
2.43.0



