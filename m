Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B871F30FF1D;
	Fri,  9 Jan 2026 11:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959564; cv=none; b=olZNVve7J/Q/9IAsSkE/tqAN+2qa0rGf0FqOV5sDZSvlkjIhsA9j2VWEdB+xLHxI6sbFNwi+XAGwAeMmDM3lOrnFX8ZeKGWy/oPjtoA+jTjonuohWt5ycnqRcait9fDXSde89OmKFB7m81BHFjQ8Z1qku9+zABNgnXVZkHHh5Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959564; c=relaxed/simple;
	bh=kJOoz2eyxRc7cvpLgA/r+uK50xFMUvo5u+VMevnwBwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWntQKcGNVz6zEltezwyrxvfu6NfdOMRxvZZX2XDxlo0zs0Wpr3serXB/pd0rywhEDgEr01OR8m9cdHthmDkcunQKxFhZ4mH14q+gU4R17FfDxKl8Sqxb4cDAIrtcDjfHIVvawoQaD7TFwOM+u0K5PQnlKiRRKncVrOHDRn5jSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3rcNVpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3rcNVpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422E3C4CEF1;
	Fri,  9 Jan 2026 11:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959564;
	bh=kJOoz2eyxRc7cvpLgA/r+uK50xFMUvo5u+VMevnwBwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3rcNVpFF7QIuvxUpzxDiah10YD98czgivgQ4wAoPpWP7DsItKbkuMeefoFJYzLkP
	 k/JtEIeSGG2vJLzBCu01BjZJHtNSZLvY3S6fW8fEaIR78JWXicuC3WBFuylNqOvmCp
	 IVhSpxvn9eUizqgLZkmwngPRSTfq+K8JNNvAPzGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/737] mtd: nand: relax ECC parameter validation check
Date: Fri,  9 Jan 2026 12:33:55 +0100
Message-ID: <20260109112137.611229762@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>

[ Upstream commit 050553c683f21eebd7d1020df9b2ec852e2a9e4e ]

Due to the custom handling and layouts of certain nand controllers this
validity check will always fail for certain layouts. The check
inherently depends on even chunk sizing and this is not always the
case.

Modify the check to only print a warning, instead of failing to
init the attached NAND. This allows various 8 bit and 12 ECC strength
layouts to be used.

Fixes: 68c18dae6888 ("mtd: rawnand: marvell: add missing layouts")
Signed-off-by: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 7c3e3d70be8b0..fe0b298f8425e 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -6450,11 +6450,14 @@ static int nand_scan_tail(struct nand_chip *chip)
 		ecc->steps = mtd->writesize / ecc->size;
 	if (!base->ecc.ctx.nsteps)
 		base->ecc.ctx.nsteps = ecc->steps;
-	if (ecc->steps * ecc->size != mtd->writesize) {
-		WARN(1, "Invalid ECC parameters\n");
-		ret = -EINVAL;
-		goto err_nand_manuf_cleanup;
-	}
+
+	/*
+	 * Validity check: Warn if ECC parameters are not compatible with page size.
+	 * Due to the custom handling of ECC blocks in certain controllers the check
+	 * may result in an expected failure.
+	 */
+	if (ecc->steps * ecc->size != mtd->writesize)
+		pr_warn("ECC parameters may be invalid in reference to underlying NAND chip\n");
 
 	if (!ecc->total) {
 		ecc->total = ecc->steps * ecc->bytes;
-- 
2.51.0



