Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32F2171AE
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E29C433EF;
	Mon,  8 May 2023 11:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546390;
	bh=aOZNtNljHZfhkNCjCFeZZMXEwFcdEvt9PXwW6uoMFZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRGC1MZzGsLiOMFW3zwZ/O81EWbhGo0ZOtPiBeZMIDD8qLuT03QPl3U+K6XGyL3ec
	 ulZupAkEZ6loEAbysUrch4BNh+Ehd5OqajJkdRP1otISWBy/IZuAu46H6KJZ+Nb8vC
	 elk0fLuf7CEHfWSrcdV5Bdd/08xwgv14zrzu/A2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 351/371] mtd: core: fix nvmem error reporting
Date: Mon,  8 May 2023 11:49:12 +0200
Message-Id: <20230508094826.066734481@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <michael@walle.cc>

commit 8bd1d24e6ca3c599dd455b0e1b22f77bab8290eb upstream.

The master MTD will only have an associated device if
CONFIG_MTD_PARTITIONED_MASTER is set, thus we cannot use dev_err() on
mtd->dev. Instead use the parent device which is the physical flash
memory.

Fixes: 4b361cfa8624 ("mtd: core: add OTP nvmem provider support")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230308082021.870459-2-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdcore.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -879,6 +879,7 @@ static int mtd_nvmem_fact_otp_reg_read(v
 
 static int mtd_otp_nvmem_add(struct mtd_info *mtd)
 {
+	struct device *dev = mtd->dev.parent;
 	struct nvmem_device *nvmem;
 	ssize_t size;
 	int err;
@@ -892,7 +893,7 @@ static int mtd_otp_nvmem_add(struct mtd_
 			nvmem = mtd_otp_nvmem_register(mtd, "user-otp", size,
 						       mtd_nvmem_user_otp_reg_read);
 			if (IS_ERR(nvmem)) {
-				dev_err(&mtd->dev, "Failed to register OTP NVMEM device\n");
+				dev_err(dev, "Failed to register OTP NVMEM device\n");
 				return PTR_ERR(nvmem);
 			}
 			mtd->otp_user_nvmem = nvmem;
@@ -910,7 +911,7 @@ static int mtd_otp_nvmem_add(struct mtd_
 			nvmem = mtd_otp_nvmem_register(mtd, "factory-otp", size,
 						       mtd_nvmem_fact_otp_reg_read);
 			if (IS_ERR(nvmem)) {
-				dev_err(&mtd->dev, "Failed to register OTP NVMEM device\n");
+				dev_err(dev, "Failed to register OTP NVMEM device\n");
 				err = PTR_ERR(nvmem);
 				goto err;
 			}


