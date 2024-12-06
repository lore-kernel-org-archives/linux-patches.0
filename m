Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5E913AA5F;
	Fri,  6 Dec 2024 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497393; cv=none; b=CofGfhAi0OvS1bNnrQQ+gY7ot1ahqzkwr8R2LKeC4foTXk70Sj46m5AyMCx7cTenPSrYc98wZCAskg2xG8Cdkaydc1ZgVbLl7oWMa2hGbF0SmEAWbikkhrPzAdr7bEjWI9XyXOzi3X/K0zB0bBMDD+/rSuyjBnFYrzxor+CU9U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497393; c=relaxed/simple;
	bh=Qn/m44XLMnAR2LRSLxgKCWhp+XfbgJvhaf2HpJ5Yz3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0XZCwnCRnS8UjAXvyztbKD2+Wgyhq90doUEx1HHbQ14mIa/7+PxgIdq18/mVAOMY1+axtPCs+mkdVKUqJfoUqURu0RE15fWmC3MQoUGeyak1OuCL1gbzUnvfFkMUabNXV/dKYa7yWGPjvfWFy/ZmbLeI1TIOSkX5L4aeA/7e4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKQKd3l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKQKd3l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8478AC4CED1;
	Fri,  6 Dec 2024 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497392;
	bh=Qn/m44XLMnAR2LRSLxgKCWhp+XfbgJvhaf2HpJ5Yz3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKQKd3l2kcdahFcV1ehKhSRUiyNUAfODVY/pN9tybJ+8cD7cag/C7wD96tu5IGVQr
	 EQoqzRHfLzJ4PFqRDklUhmGySQgxIukdniMVZPc+UjKF+VQQcJ+orC+sbYZODDM4cs
	 32CbhcjaFBOSb4w43xJ5GsNokPKdxHfSwtblAj08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/676] mtd: spi-nor: spansion: Use nor->addr_nbytes in octal DTR mode in RD_ANY_REG_OP
Date: Fri,  6 Dec 2024 15:31:36 +0100
Message-ID: <20241206143704.161716036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

[ Upstream commit b61c35e3404557779ec427c077f7a9f057bb053d ]

In octal DTR mode, RD_ANY_REG_OP needs to use 4-byte address regardless
of flash's internal address mode. Use nor->addr_nbytes which is set to 4
during setup.

Fixes: eff9604390d6 ("mtd: spi-nor: spansion: add octal DTR support in RD_ANY_REG_OP")
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Link: https://lore.kernel.org/r/20241016000837.17951-1-Takahiro.Kuwano@infineon.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/spansion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 709822fced867..828b442735ee8 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -105,6 +105,7 @@ static int cypress_nor_sr_ready_and_clear_reg(struct spi_nor *nor, u64 addr)
 	int ret;
 
 	if (nor->reg_proto == SNOR_PROTO_8_8_8_DTR) {
+		op.addr.nbytes = nor->addr_nbytes;
 		op.dummy.nbytes = params->rdsr_dummy;
 		op.data.nbytes = 2;
 	}
-- 
2.43.0



