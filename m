Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78141AB6C9;
	Tue,  3 Dec 2024 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241313; cv=none; b=Th6lbE9pik1LavPjMQ4iYzzv70VhIY9xc/R2cpxH0xRsUOABtIUdmk7wK4jak3DJbXLJ1AMEVyxMeBZ9ncDzCVO0xvZxIrHwki6IrEcaIb1V2C5ab5yzim1PZMPXZjrX1m4bijD7PuPJHZhisifgeNIr6uQHEU5Fx6acdK//ba4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241313; c=relaxed/simple;
	bh=NZih0Jo1W02L4TzidHQPIzoY4U6h5A0z99eCmlz5Cks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSLG0eWISmnvETdtklRzDYIhfBcJg/m3Fs7VPr/zI8V800XJvpvaid8zbbwQBqFD2sNtLp4Gct0wVJSdxDw88EQvmxtIZVbAoLetNBte/ZmJzH9IL5rSoUZWZwsvppgH3ire/pGZyzGqGYbOpdG4w24hiU/wd8KZ3RY3kWwXsN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liWZkmJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liWZkmJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246A7C4CECF;
	Tue,  3 Dec 2024 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241313;
	bh=NZih0Jo1W02L4TzidHQPIzoY4U6h5A0z99eCmlz5Cks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liWZkmJI5llewzrvs8PuiHST9QSZDHNwjIQlD+eXaHmXUmyalKbuAV59XOMoWKu08
	 HynaK26ORniEabtNFI4oM96rP9fwwd/BZ+UzhfoJDpIl8lVEpaydOtuIvjYfSnolYR
	 XdRS33CYvJYs8ZmOS1OT1m9oxWpa0oo4eFKW5rQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/826] mtd: spi-nor: spansion: Use nor->addr_nbytes in octal DTR mode in RD_ANY_REG_OP
Date: Tue,  3 Dec 2024 15:41:52 +0100
Message-ID: <20241203144758.782946716@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d6c92595f6bc9..5a88a6096ca8c 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -106,6 +106,7 @@ static int cypress_nor_sr_ready_and_clear_reg(struct spi_nor *nor, u64 addr)
 	int ret;
 
 	if (nor->reg_proto == SNOR_PROTO_8_8_8_DTR) {
+		op.addr.nbytes = nor->addr_nbytes;
 		op.dummy.nbytes = params->rdsr_dummy;
 		op.data.nbytes = 2;
 	}
-- 
2.43.0



