Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C44B1F75B1;
	Tue,  3 Dec 2024 15:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238811; cv=none; b=UEc1depx1jI8A8wvwxLGLYegQHHdEUoM71hJYYiiGMHOJYq52i/dnHP7Fd0iO6tZGqQHcjwLefvuZXu/XQQmIJVbp51kH5tdIVl7CnlSY4oktx/J2TxEzMh+rnl0NVB+ImQu68RF7vUycL9txD08SsZE0frEj6YVOiP/VEdXGuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238811; c=relaxed/simple;
	bh=qiAv7pDJdGlkP+xljQSOSQo0xOcJsk++TIm4nYqNjeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KI4T77JAX4RV3Lvy2XTu0WiY5B58IDjYdz2jyDTYHHGxpzLiFJt/dqqMgl3kR1K4zCO2Wg7ao8z+uq/F8erhEOaX80w27IMpT6O8HdhdVrcrf7XNxB4wr9YcLcxhvKYZ/uTlSj21O6il9isF383L8WG0u68Jf1DcC0AEAR8meeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFYIKgv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFYIKgv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97960C4CECF;
	Tue,  3 Dec 2024 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238811;
	bh=qiAv7pDJdGlkP+xljQSOSQo0xOcJsk++TIm4nYqNjeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFYIKgv3GChGXgenjd7C4rnqA6BDmQeHfzV2GzNo4iBqAvy+Zj33u0gwpNKlxmrzo
	 ccrXiT2fKVYRAg3D4btoUpaeDmXntlPcX5kNpVRfyQ4FRsWXOYqE3mAGl5pgfOXYKn
	 K0Fb61txE8lFBm1jFatmwTptF6na6jVFyodsi3hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 403/817] mtd: spi-nor: spansion: Use nor->addr_nbytes in octal DTR mode in RD_ANY_REG_OP
Date: Tue,  3 Dec 2024 15:39:35 +0100
Message-ID: <20241203144011.603782056@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 6cc237c24e072..020994374ea13 100644
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



