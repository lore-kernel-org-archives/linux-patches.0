Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9609A13AE0
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4CEC433D2;
	Mon,  8 May 2023 11:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543622;
	bh=TcG9egfCML5p5qHU9oBwGFlNahDoqoIMbUNpE41ESlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGdCFO4Mg+C0LyNNQFAy9iVFnr4XdDBDc7+34uHFrc12ui+T0pnWxXcYhCu5s51DW
	 aUcxAth3VtgqOrjKDW2dkueOgAVsUl8+PKL4x1Yxt1B7CwLyN3NbIacc+uWubVcIXq
	 FuZ17MmTo7Y3mIbDCJFk85Xkrd2XC6GyH+zWi9z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 6.3 118/694] mtd: spi-nor: core: Update flashs current address mode when changing address mode
Date: Mon,  8 May 2023 11:39:13 +0200
Message-Id: <20230508094436.309120810@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit 37513c56139b79dd43c1774513c28f8ab2b05224 upstream.

The bug was obswerved while reading code. There are not many users of
addr_mode_nbytes. Anyway, we should update the flash's current address
mode when changing the address mode, fix it. We don't care for now about
the set_4byte_addr_mode(nor, false) from spi_nor_restore(), as it is
used at driver remove and shutdown.

Fixes: d7931a215063 ("mtd: spi-nor: core: Track flash's internal address mode")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230331074606.3559258-9-tudor.ambarus@linaro.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2732,6 +2732,7 @@ static int spi_nor_quad_enable(struct sp
 
 static int spi_nor_init(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = nor->params;
 	int err;
 
 	err = spi_nor_octal_dtr_enable(nor, true);
@@ -2773,9 +2774,10 @@ static int spi_nor_init(struct spi_nor *
 		 */
 		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
 			  "enabling reset hack; may not recover from unexpected reboots\n");
-		err = nor->params->set_4byte_addr_mode(nor, true);
+		err = params->set_4byte_addr_mode(nor, true);
 		if (err && err != -ENOTSUPP)
 			return err;
+		params->addr_mode_nbytes = 4;
 	}
 
 	return 0;


