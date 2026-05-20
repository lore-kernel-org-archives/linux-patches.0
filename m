Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1B0318EC7;
	Wed, 20 May 2026 16:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295901; cv=none; b=h7+CAjXSJ/Lvd1JKssPzBgl/yylnJ1PPckaSeutQ4efz66iXHxslNBE5pHU9dKX+FtUv4D+P01lDWvQ9xyWLzUApnF2cUH8cGFGZvvu5oZHBRJ0VXqF/HWYsngHC0LVV6G1cQHvWocDNcUfaHAa8TkJJmaAjDn7xZLtHfaJZihU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295901; c=relaxed/simple;
	bh=qOpCcmN2g7/lGtNXl0JtfWJXgUWwHv3psrhG0GnHzJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mzt3iBAvusyhDefVlF+jaHvoDtUtRwbE3pf6Af6hw4KD0t7anh5AgCz1yAg7Ad5Tff9RIfgcF6YhbM/ngRNVzFS5TdbwofxlErD9eQhcR4Mn0HLY1ZnokeRar/nlhrgYqG+0S46kbCMZZRTvEw+tSeJKnu3j3onF2Se4x5VN6BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHbGlH4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHbGlH4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534D71F000E9;
	Wed, 20 May 2026 16:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295899;
	bh=2csKRyEH9EPOGLJTXnkHzx4b1hQdNe2XTT2mCdRMsTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHbGlH4Ij2NGGGor8eWDUGhhcRgfUGGDfgWi7AfN3A5CoK36nL8n3NsyTiWIxnXh9
	 iJMMiCV4nChJuWRsOzzVpgOxuBuf8g0gPo4s4LXVKGFtnIrkr/FfY5TYo9DoLH4kPP
	 M1Ui+kvZyjHFeXCV0z5JDl3QIvy2tCWaQjtmFhMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0594/1146] mtd: spi-nor: core: correct the op.dummy.nbytes when check read operations
Date: Wed, 20 May 2026 18:14:04 +0200
Message-ID: <20260520162201.619415162@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 756564a536ecd8c9d33edd89f0647a91a0b03587 ]

When check read operation, need to setting the op.dummy.nbytes based
on current read operation rather than the nor->read_proto.

Fixes: 0e30f47232ab ("mtd: spi-nor: add support for DTR protocol")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 1eee519c01e5c..5dd0b3cb52503 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2393,7 +2393,7 @@ static int spi_nor_spimem_check_readop(struct spi_nor *nor,
 	/* convert the dummy cycles to the number of bytes */
 	op.dummy.nbytes = (read->num_mode_clocks + read->num_wait_states) *
 			  op.dummy.buswidth / 8;
-	if (spi_nor_protocol_is_dtr(nor->read_proto))
+	if (spi_nor_protocol_is_dtr(read->proto))
 		op.dummy.nbytes *= 2;
 
 	return spi_nor_spimem_check_read_pp_op(nor, &op);
-- 
2.53.0



