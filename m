Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54EB134CDC;
	Tue, 14 May 2024 10:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684339; cv=none; b=RyDBjB71caVw8NugzL22ESccbbZiOjtzN92drmWSwLsep0kcAcjZU8pFov6NYrK/44XLVfMcYNsm/V7d034eAaywWFW0YoKKRr1BF6bXsYcEgf//MmWJVwgGNZn2yg3JBRs0dn+h+B90Ce+UMuVYFvdWtNzfPVD4CzvK6r0Eu1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684339; c=relaxed/simple;
	bh=uhEEL5EB6w4EfWhBtwVY6STj1V1DjdswwDuO+swWgnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oL7bc/picPtRTAZPfd5LjUIpqxShGA/+Aj75jN7pFbUKxnRwX2n6rCh6vio277RZUjVxawwN4mq/DSP6t+c0HV7+tik1kikqPWKD/CQ01ZAgpnrC9LQ5xWgCx75woVH7irfIdTgoJ95oTju6VGlKS8WvvczacDNowFp9LkN/e9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2ml0ErL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2ml0ErL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B713AC2BD10;
	Tue, 14 May 2024 10:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684339;
	bh=uhEEL5EB6w4EfWhBtwVY6STj1V1DjdswwDuO+swWgnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2ml0ErLhkDEVBpz0l9i+zU2pV3tjkr7ceVvLvP9ETuZiV+mcSfjrbWh8T0bcbCjd
	 lFeua0jEU+lGdlSrEprsA5bfWfHqFJyvvXdzUJ0byThRea81T8ij+hbe/8x78KCl45
	 d1ZhmTsJtQaAU5JH0QM6Iyha8IB3V7pePlqeiH7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/301] mtd: limit OTP NVMEM cell parse to non-NAND devices
Date: Tue, 14 May 2024 12:14:35 +0200
Message-ID: <20240514101032.393231007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit d2d73a6dd17365c43e109263841f7c26da55cfb0 ]

MTD OTP logic is very fragile on parsing NVMEM cell and can be
problematic with some specific kind of devices.

The problem was discovered by e87161321a40 ("mtd: rawnand: macronix:
OTP access for MX30LFxG18AC") where OTP support was added to a NAND
device. With the case of NAND devices, it does require a node where ECC
info are declared and all the fixed partitions, and this cause the OTP
codepath to parse this node as OTP NVMEM cells, making probe fail and
the NAND device registration fail.

MTD OTP parsing should have been limited to always using compatible to
prevent this error by using node with compatible "otp-user" or
"otp-factory".

NVMEM across the years had various iteration on how cells could be
declared in DT, in some old implementation, no_of_node should have been
enabled but now add_legacy_fixed_of_cells should be used to disable
NVMEM to parse child node as NVMEM cell.

To fix this and limit any regression with other MTD that makes use of
declaring OTP as direct child of the dev node, disable
add_legacy_fixed_of_cells if we detect the MTD type is Nand.

With the following logic, the OTP NVMEM entry is correctly created with
no cells and the MTD Nand is correctly probed and partitions are
correctly exposed.

Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
Cc: <stable@vger.kernel.org> # v6.7+
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240412105030.1598-1-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index fbf60d1364f0d..5c32208b17a1d 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -899,7 +899,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
 	config.name = compatible;
 	config.id = NVMEM_DEVID_AUTO;
 	config.owner = THIS_MODULE;
-	config.add_legacy_fixed_of_cells = true;
+	config.add_legacy_fixed_of_cells = !mtd_type_is_nand(mtd);
 	config.type = NVMEM_TYPE_OTP;
 	config.root_only = true;
 	config.ignore_wp = true;
-- 
2.43.0



