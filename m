Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1823D75D3;
	Wed, 20 May 2026 17:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298629; cv=none; b=MwXv201lnw+sIbFvib/nN9rJyS3SQiQYxNEeQ02Ab0IpN3Y5kcAvMHA4EwaOHHKwCknVa9mw3KPHPmmUOFbZu8cwXyoCojMlMgXEDrHL7N896HZbR7sUH9KVMW3xnnbtqjW5GQR212SsWSb+WvGSxnwWIe6pmdeGAG2PXFIKBWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298629; c=relaxed/simple;
	bh=33S4N3h88koXky5VA2ENvqmEdgR2KRAKCHdqZyRsOOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLswT5kzlJ7JcbAG56id9yJdpL7fVv+iiMbvAqZ4r/KHoo92eNTGcGGThbBq7b5Imd73iS8NSlCwrnYxsGsVn844ATL4y2W/2q3snNErCHjJY1p45Ys2h2ZBkkzyb+i1qrFrGG2VCD2Rkqf/zicexRQDbkcXVFgIXvtSi7C2Yls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09kCUewj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09kCUewj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B031F00893;
	Wed, 20 May 2026 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298625;
	bh=IpJNf7k7IXrIWQvzfZbMr0a8+tdm1GaFHTsmOtN2Rw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09kCUewjuvRb8H1jH/9cAcysGN0tgXyIWkMF1afFZu2mIb8ZY//CPJSIdYoa+D8LD
	 bWvdNYOh/9mBQU91IA+SSlb1gY2cTTVfXmfqBLC3AtI3ZidakIwpp6FoHfvLpoJT92
	 Tq2H+4T1J+6Xki7Bv5QP0msa2eToFbujx+aSmQa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 480/957] mtd: spinand: Add support for setting a bus interface
Date: Wed, 20 May 2026 18:16:03 +0200
Message-ID: <20260520162144.935490136@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 20387f2fe509eba46ecf758da052786d7b1203fb ]

Create a bus interface enumeration, currently only containing the
one we support: SSDR, for single SDR, so any operation whose command is
sent over a single data line in SDR mode, ie. any operation matching
1S-XX-XX.

The main spinand_device structure gets a new parameter to store this
enumeration, for now unused. Of course it is set to SSDR during the SSDR
templates initialization to further clarify the state we are in at the
moment.

This member is subject to be used to know in which bus configuration we
and be updated by the core when we switch to faster mode(s).

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 25a915fad503 ("mtd: spinand: winbond: Clarify when to enable the HS bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c |  1 +
 include/linux/mtd/spinand.h | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index b88f30ed746fc..9f6682c0af102 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1329,6 +1329,7 @@ static void spinand_init_ssdr_templates(struct spinand_device *spinand)
 	tmpl->page_read = (struct spi_mem_op)SPINAND_PAGE_READ_1S_1S_0_OP(0);
 	tmpl->prog_exec = (struct spi_mem_op)SPINAND_PROG_EXEC_1S_1S_0_OP(0);
 	spinand->op_templates = &spinand->ssdr_op_templates;
+	spinand->bus_iface = SSDR;
 }
 
 static const struct spi_mem_op *
diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index 3825fe9e759a6..c991c6c3bdedf 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -486,6 +486,14 @@ struct spinand_user_otp {
 	const struct spinand_user_otp_ops *ops;
 };
 
+/**
+ * enum spinand_bus_interface - SPI NAND bus interface types
+ * @SSDR: Bus configuration supporting all 1S-XX-XX operations, including dual and quad
+ */
+enum spinand_bus_interface {
+	SSDR,
+};
+
 /**
  * struct spinand_info - Structure used to describe SPI NAND chips
  * @model: model name
@@ -643,6 +651,7 @@ struct spinand_mem_ops {
  * @flags: NAND flags
  * @ssdr_op_templates: Templates for all single SDR SPI mem operations
  * @op_templates: Templates for all SPI mem operations
+ * @bus_iface: Current bus interface
  * @select_target: select a specific target/die. Usually called before sending
  *		   a command addressing a page or an eraseblock embedded in
  *		   this die. Only required if your chip exposes several dies
@@ -678,6 +687,7 @@ struct spinand_device {
 
 	struct spinand_mem_ops ssdr_op_templates;
 	struct spinand_mem_ops *op_templates;
+	enum spinand_bus_interface bus_iface;
 
 	struct spinand_dirmap *dirmaps;
 
-- 
2.53.0



