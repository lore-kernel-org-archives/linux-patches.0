Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6668A284685;
	Wed, 23 Apr 2025 15:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421442; cv=none; b=SkooAVUCdRS4ebC0jJuBDlVuaraYEwUwsnk90F/hOyRGXXzopFcAiMpyJAuNNCCcaVE2vWwzQf0TpY3bymqdfJH9kAa5gsMhd0XFlIVufmMSHDj1aWoLbWjyXrA87TiO31+cdNWSPFXDdXRo0F2k2Ky4VeZi41rg1PCL3pgRfG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421442; c=relaxed/simple;
	bh=0/S/I3+BYjhFjom26XzvyfoFRAJvbk61xP/erQWO454=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/K+UI6+raE1qyF1+HKVFU30kEj4QukfUmm6m6/NV97eukz+hi1qMenC1ghrcuDektRpcHGNZub9m7a4659aOGpgohr2eQqSvHqd4gOxQf6g06YIa/IH3Af5Lf2fFaOdGP5SW3ilD8+7wMHxKs4PKyzFHfSjNY4mwc6cwaNcuIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxHkpNqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxHkpNqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC13C4CEE2;
	Wed, 23 Apr 2025 15:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421442;
	bh=0/S/I3+BYjhFjom26XzvyfoFRAJvbk61xP/erQWO454=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxHkpNqwxYF5fZBBi+qQuhrUtyCj+3oCZ2Nup9sPYI6g83/pkGA3dCsbCYaokA+pF
	 0hA94nBPiwFvAqlbAO7ZhWsnel4NINO8Z8uug4ESTv9vf6JY2pEZpmOQFfjhfMc97R
	 cPtpK+ihuaAqqe8V5nIn1FDIAU61+dSvV3QIOUXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 179/393] mtd: rawnand: Add status chack in r852_ready()
Date: Wed, 23 Apr 2025 16:41:15 +0200
Message-ID: <20250423142650.769634382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


