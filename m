Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5922F3B1EE2;
	Tue, 12 May 2026 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607890; cv=none; b=NqFuVHQYsYn4YubzOQ6y1FIxDR1QrQhzdAt1m4UjsIDQGtglI1rnRp9mA0PUR3H84MRQGiTFECczyZDXg2f1Ased9WHKiYoUV3cLFaWas58ahTZXwX+lh0BYOH2TkabVkK5RKr7DhRzr+3ceJU56Szo5/LhS7MwhNlFcyoxgcCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607890; c=relaxed/simple;
	bh=WbQVusx2gnbSBj/SFpxgmxlusmQaHgYroaBenyUd3BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRIi9wCo4EdFpoOI35KUizZQHIuqyUzyzFOCaSlEqoALsTSs7yJkc9cPk1VpQuURqw05rR+O92sr9/gh8dlDk5ofvoaC2TLSJ8zf+t5BnboLl7Jl2mEi6Yq25IaJsoTzAkBr6qZlv5gNJwS9bJSZzoVXhyE8SbCTqFqrK54IkGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmyjN+I8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmyjN+I8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6401C2BCF5;
	Tue, 12 May 2026 17:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607890;
	bh=WbQVusx2gnbSBj/SFpxgmxlusmQaHgYroaBenyUd3BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmyjN+I8MSq3cZLxFu5OspYrcYN9y7LgdXOgkgM6OKVorviGOG1rrvMFdK++bvXOd
	 i0BGSPD0SiWbNerzDEK9kgq1j+GZEwh6eqOKqhOiDDu3KRz/OaXIw6xlhHuh7XHkB2
	 et66Ta0najiw4bDvcAn9APD1lh7JgdaH+wcnlt6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Takahiro Kuwano <takahiro.kuwano@infineon.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 076/206] mtd: spi-nor: debugfs: fix out-of-bounds read in spi_nor_params_show()
Date: Tue, 12 May 2026 19:38:48 +0200
Message-ID: <20260512173934.460301810@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit e47029b977e747cb3a9174308fd55762cce70147 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/debugfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/array_size.h>
 #include <linux/debugfs.h>
 #include <linux/mtd/spi-nor.h>
 #include <linux/spi/spi.h>
@@ -92,7 +93,8 @@ static int spi_nor_params_show(struct se
 	seq_printf(s, "address nbytes\t%u\n", nor->addr_nbytes);
 
 	seq_puts(s, "flags\t\t");
-	spi_nor_print_flags(s, nor->flags, snor_f_names, sizeof(snor_f_names));
+	spi_nor_print_flags(s, nor->flags, snor_f_names,
+			    ARRAY_SIZE(snor_f_names));
 	seq_puts(s, "\n");
 
 	seq_puts(s, "\nopcodes\n");


