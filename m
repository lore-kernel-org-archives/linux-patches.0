Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B37F79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02186C433F0;
	Thu, 12 Jan 2023 14:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533977;
	bh=LpoWBYcZu/peatgJRbYWvrab0sBh8G4kO2UPUUcAM68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjVri/NE03paHkd96GOfNKLVWyO+AN3dauMxQ3jud6chlE+JRZGMoP4g8Upe77Itb
	 WnNAShnoZ0MZ/PM/p470R0WdV37Bny/Lc8cGAl9pcFaUAQ5DH5lvOWrBnWrmaB9rdw
	 WenDWRomjsobCYRT51BK01b/yxIrz/AspqbI14Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@nokia.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.10 654/783] mtd: spi-nor: Check for zero erase size in spi_nor_find_best_erase_type()
Date: Thu, 12 Jan 2023 14:56:10 +0100
Message-Id: <20230112135554.650895786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

commit 2ebc336be08160debfe27f87660cf550d710f3e9 upstream.

Erase can be zeroed in spi_nor_parse_4bait() or
spi_nor_init_non_uniform_erase_map(). In practice it happened with
mt25qu256a, which supports 4K, 32K, 64K erases with 3b address commands,
but only 4K and 64K erase with 4b address commands.

Fixes: dc92843159a7 ("mtd: spi-nor: fix erase_type array to indicate current map conf")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211119081412.29732-1-alexander.sverdlin@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1220,6 +1220,8 @@ spi_nor_find_best_erase_type(const struc
 			continue;
 
 		erase = &map->erase_type[i];
+		if (!erase->size)
+			continue;
 
 		/* Alignment is not mandatory for overlaid regions */
 		if (region->offset & SNOR_OVERLAID_REGION &&


