Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6360E1D2F52;
	Wed,  2 Oct 2024 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878514; cv=none; b=jsM4qnhHTvYvjDtsZdH2WTeefqJpSOdX1ZhoIazZGYCUSAGKPxGQUQGOgbqsStbevhaGYTiKG2DU//rq60liImTR5sxGjE8wY2w7209Spido1u6Gve5jKGbNdQFRqPLla1rkQRdPDNVi63udiWVaXZJ3DMeIrFdQlLKcXAyt9g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878514; c=relaxed/simple;
	bh=9fEVCmazk9bNTdqBOsb04d1ascEDx+VnstkWGLiMeKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3D2L8pkw3eXujXQpg+B+SBIbpd/rUHp3unVGJ+W9sfvkVcSjQDsEOvddJmy4ITpLSDDCVLYr5CPrMWG8TuN8luV5QCZ7xz+qHLVQiBItdpNZL3kyIz4iCE7H1yvyBv5Ibbnbo0tl/te/rSulpSjh6R7JBIotGlWAZZToeKcZq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOlppITj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOlppITj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D7FC4CECF;
	Wed,  2 Oct 2024 14:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878513;
	bh=9fEVCmazk9bNTdqBOsb04d1ascEDx+VnstkWGLiMeKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOlppITjYORsN/4K5yO8QeA5RyYUPaTLu/lfja0sF7ui3MRwBteQTlhrHVnMIG/z6
	 XegJviApXkKFx//gTeEHwoYvaPS0StzKOTD1VDa/fACaHyODaKwG4VHfpmCJlFeE0/
	 uPf1jbBkmDyZWiJm4FOax/777h7s3HtQPs7TO1Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 408/634] spi: airoha: fix airoha_snand_{write,read}_data data_len estimation
Date: Wed,  2 Oct 2024 14:58:28 +0200
Message-ID: <20241002125827.212456576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 0e58637eb968c636725dcd6c7055249b4e5326fb ]

Fix data length written and read in airoha_snand_write_data and
airoha_snand_read_data routines respectively if it is bigger than
SPI_MAX_TRANSFER_SIZE.

Fixes: a403997c1201 ("spi: airoha: add SPI-NAND Flash controller driver")
Tested-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20240913-airoha-spi-fixes-v1-2-de2e74ed4664@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-airoha-snfi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-airoha-snfi.c b/drivers/spi/spi-airoha-snfi.c
index be3e4ac42153e..c71be702cf6f6 100644
--- a/drivers/spi/spi-airoha-snfi.c
+++ b/drivers/spi/spi-airoha-snfi.c
@@ -405,7 +405,7 @@ static int airoha_snand_write_data(struct airoha_snand_ctrl *as_ctrl, u8 cmd,
 	for (i = 0; i < len; i += data_len) {
 		int err;
 
-		data_len = min(len, SPI_MAX_TRANSFER_SIZE);
+		data_len = min(len - i, SPI_MAX_TRANSFER_SIZE);
 		err = airoha_snand_set_fifo_op(as_ctrl, cmd, data_len);
 		if (err)
 			return err;
@@ -427,7 +427,7 @@ static int airoha_snand_read_data(struct airoha_snand_ctrl *as_ctrl, u8 *data,
 	for (i = 0; i < len; i += data_len) {
 		int err;
 
-		data_len = min(len, SPI_MAX_TRANSFER_SIZE);
+		data_len = min(len - i, SPI_MAX_TRANSFER_SIZE);
 		err = airoha_snand_set_fifo_op(as_ctrl, 0xc, data_len);
 		if (err)
 			return err;
-- 
2.43.0



