Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D935B1A5BBB;
	Thu, 17 Apr 2025 18:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916037; cv=none; b=ClOQf989cfOtM04a56gnWTX5IFtcCReR0745j3QOr+231vZNtC2uQJu674Tl8Fw/5/L5C7lHZwh1SsRs2d42K46BZBVeZUi+wFm2YeuiiiTTiWXw/XbjBU42+4Na4oxwoCzoD4uJ1Tbw+kwSri08LUvdGpQ6BDvl8tm8A7A+jOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916037; c=relaxed/simple;
	bh=vVMa5IZGHs64APtril/1lFhZUwgHDh3grheBdCcJhKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8qQR5YngpvPKsB1GwCU05v5hF6XbgadFfQMV/H5xnl7eztTUmkf/OvG5Z75AULmEQe+22UPBiYJLU/PMTCtwscPi9hkRgU06cnmiaWMlWKhvmj7Q6Ep6bJPhqQyAjn4ijZZYleBBBSc2T6KWjv8cLjOw804RThs3rey9vGcYu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chswuqfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chswuqfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A602C4CEE4;
	Thu, 17 Apr 2025 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916037;
	bh=vVMa5IZGHs64APtril/1lFhZUwgHDh3grheBdCcJhKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chswuqflQNOajF8awVEA/ksKi45DoqpjntrV8/G2r0p1B6Ay252lBSETrxbib/i7A
	 9rLiOGFnbkbSKAyzujkmjvZviYG82OksqcWmjJrCekUStiJ2PAc5zHMaYNqg/NtccM
	 AVwxHREmjDY4byG0+ej4UCyr6BWFwPd+wQl5Xfgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 283/393] mtd: rawnand: Add status chack in r852_ready()
Date: Thu, 17 Apr 2025 19:51:32 +0200
Message-ID: <20250417175118.991015703@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit b79fe1829975556854665258cf4d2476784a89db upstream.

In r852_ready(), the dev get from r852_get_dev() need to be checked.
An unstable device should not be ready. A proper implementation can
be found in r852_read_byte(). Add a status check and return 0 when it is
unstable.

Fixes: 50a487e7719c ("mtd: rawnand: Pass a nand_chip object to chip->dev_ready()")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/r852.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/nand/raw/r852.c
+++ b/drivers/mtd/nand/raw/r852.c
@@ -387,6 +387,9 @@ static int r852_wait(struct nand_chip *c
 static int r852_ready(struct nand_chip *chip)
 {
 	struct r852_device *dev = r852_get_dev(nand_to_mtd(chip));
+	if (dev->card_unstable)
+		return 0;
+
 	return !(r852_read_reg(dev, R852_CARD_STA) & R852_CARD_STA_BUSY);
 }
 


