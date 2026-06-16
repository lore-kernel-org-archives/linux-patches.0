Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD73472760;
	Tue, 16 Jun 2026 17:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632374; cv=none; b=of29BxJAfBYfJBXX8nyUgmcz0P0zFBEoCsG2jbO+cl/4WJ787Rc1HmCS2h4AsuJWr24Qh9EC3NFuxwCcg01YhWKfmVURP2wdwXadHHD85mO+rK9spAbVhel61a+lvwW5/avnOjPdeAkEqesXm/AhVzg2IH71/QfoVs2BfMEEeHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632374; c=relaxed/simple;
	bh=kMZcvg484cnXjBiQ/Q1GhHjdSYzfitujl7fr70r7t/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTBmtGfhUlUhlMgDlOAcGhQhgMx0w8bU/Ltq+ku8gzbG1dxpX5/hE1F89WVTRMCUlp7cUpOU3yR9E4KXQGNtgJxLfzFZmDSjNLvviep5Zf0twhk0oe8tHDAtyZWhciaSLlcMzTr96l3ZBWAV8+Ik5XPPF7AlGwie/BsxyqDH3uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWtCl3vE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWtCl3vE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7921F000E9;
	Tue, 16 Jun 2026 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632372;
	bh=hHcTtI0XPrmvaFMuj8vTDQzCxihKrkoHFiuIuLxh1+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWtCl3vEDc+uBjAu+LhVzQUrcRVS/TVkShnKUAMemYQxLVn6Duj3GW9hQ1tbtK804
	 tHyaKVfh3XvHXmdUgYuyltxlPu8vOsE+udnzG+ooeSzlN3N5tBx98t4i7rZ69Gj7Pz
	 UsfX+Uxst8V2seq7Q5YlbT7phCm2fGm/vJZz5m50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Takahiro Kuwano <takahiro.kuwano@infineon.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 398/522] mtd: spi-nor: debugfs: fix out-of-bounds read in spi_nor_params_show()
Date: Tue, 16 Jun 2026 20:29:05 +0530
Message-ID: <20260616145144.693842984@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit e47029b977e747cb3a9174308fd55762cce70147 ]

Sashiko noticed an out-of-bounds read [1].

In spi_nor_params_show(), the snor_f_names array is passed to
spi_nor_print_flags() using sizeof(snor_f_names).

Since snor_f_names is an array of pointers, sizeof() returns the total
number of bytes occupied by the pointers
	(element_count * sizeof(void *))
rather than the element count itself. On 64-bit systems, this makes the
passed length 8x larger than intended.

Inside spi_nor_print_flags(), the 'names_len' argument is used to
bounds-check the 'names' array access. An out-of-bounds read occurs
if a flag bit is set that exceeds the array's actual element count
but is within the inflated byte-size count.

Correct this by using ARRAY_SIZE() to pass the actual number of
string pointers in the array.

Cc: stable@vger.kernel.org
Fixes: 0257be79fc4a ("mtd: spi-nor: expose internal parameters via debugfs")
Closes: https://sashiko.dev/#/patchset/20260417-die-erase-fix-v2-1-73bb7004ebad%40infineon.com [1]
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Takahiro Kuwano <takahiro.kuwano@infineon.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ adjusted include-block context to keep 6.1.y's existing non-alphabetical header order while still adding `#include <linux/array_size.h>` at the top ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/debugfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/array_size.h>
 #include <linux/mtd/spi-nor.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi-mem.h>
@@ -91,7 +92,8 @@ static int spi_nor_params_show(struct se
 	seq_printf(s, "address nbytes\t%u\n", nor->addr_nbytes);
 
 	seq_puts(s, "flags\t\t");
-	spi_nor_print_flags(s, nor->flags, snor_f_names, sizeof(snor_f_names));
+	spi_nor_print_flags(s, nor->flags, snor_f_names,
+			    ARRAY_SIZE(snor_f_names));
 	seq_puts(s, "\n");
 
 	seq_puts(s, "\nopcodes\n");


