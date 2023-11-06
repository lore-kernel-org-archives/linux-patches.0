Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EEE22EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvjG9kZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607A8C433C8;
	Mon,  6 Nov 2023 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277371;
	bh=8PUnEN1zEiDU4RKukng19K5iRa75Nn10TZ4ZNZxfZ4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvjG9kZtcGZYuT+zDDwXrFHTO5/tYSmF/DjB9L5xskT3h5zXbeYowJzhHHJ0To9Wk
	 dlyNsnk9QcWbwhcr/TEHtOxvv/EqxMty4FPf+jJasznb0CpYUr8xFcqcxiQTlBzFmB
	 G7NgUnYorW+pFl010K6MqRokODavZO5xa7PHviEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"William A. Kennington III" <william@wkennington.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/128] spi: npcm-fiu: Fix UMA reads when dummy.nbytes == 0
Date: Mon,  6 Nov 2023 14:04:10 +0100
Message-ID: <20231106130313.234358905@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

From: William A. Kennington III <william@wkennington.com>

[ Upstream commit 2ec8b010979036c2fe79a64adb6ecc0bd11e91d1 ]

We don't want to use the value of ilog2(0) as dummy.buswidth is 0 when
dummy.nbytes is 0. Since we have no dummy bytes, we don't need to
configure the dummy byte bits per clock register value anyway.

Signed-off-by: "William A. Kennington III" <william@wkennington.com>
Link: https://lore.kernel.org/r/20230922182812.2728066-1-william@wkennington.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-npcm-fiu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-npcm-fiu.c b/drivers/spi/spi-npcm-fiu.c
index b62471ab6d7f2..1edaf22e265bf 100644
--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -334,8 +334,9 @@ static int npcm_fiu_uma_read(struct spi_mem *mem,
 		uma_cfg |= ilog2(op->cmd.buswidth);
 		uma_cfg |= ilog2(op->addr.buswidth)
 			<< NPCM_FIU_UMA_CFG_ADBPCK_SHIFT;
-		uma_cfg |= ilog2(op->dummy.buswidth)
-			<< NPCM_FIU_UMA_CFG_DBPCK_SHIFT;
+		if (op->dummy.nbytes)
+			uma_cfg |= ilog2(op->dummy.buswidth)
+				<< NPCM_FIU_UMA_CFG_DBPCK_SHIFT;
 		uma_cfg |= ilog2(op->data.buswidth)
 			<< NPCM_FIU_UMA_CFG_RDBPCK_SHIFT;
 		uma_cfg |= op->dummy.nbytes << NPCM_FIU_UMA_CFG_DBSIZ_SHIFT;
-- 
2.42.0



