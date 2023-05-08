Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA3B168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FDFC433EF;
	Mon,  8 May 2023 10:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543029;
	bh=XNuoop2LWH7ETPNfo47aB8TCCHbc//ILLK3BKSHYeBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Opye7dGGlOg7DyU7Es0Z2AQy6FZe9HWUByK3m0i4l8xKSCo0C/JHZ5h/iiG13mqO/
	 JxtLzcRtT18srDHepOf/5q5HHT9Lf6UGkNTJDxkIFZYXENF4jA7SpEFEcjUo4J9ZyF
	 sRhXepx6vYAG5R5moGgpFVKNpXJj2ZGzhVFY+jyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.2 626/663] mtd: core: fix nvmem error reporting
Date: Mon,  8 May 2023 11:47:32 +0200
Message-Id: <20230508094450.139135373@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
@@ -939,6 +939,7 @@ static int mtd_nvmem_fact_otp_reg_read(v
 
 static int mtd_otp_nvmem_add(struct mtd_info *mtd)
 {
+	struct device *dev = mtd->dev.parent;
 	struct nvmem_device *nvmem;
 	ssize_t size;
 	int err;
@@ -952,7 +953,7 @@ static int mtd_otp_nvmem_add(struct mtd_
 			nvmem = mtd_otp_nvmem_register(mtd, "user-otp", size,
 						       mtd_nvmem_user_otp_reg_read);
 			if (IS_ERR(nvmem)) {
-				dev_err(&mtd->dev, "Failed to register OTP NVMEM device\n");
+				dev_err(dev, "Failed to register OTP NVMEM device\n");
 				return PTR_ERR(nvmem);
 			}
 			mtd->otp_user_nvmem = nvmem;
@@ -970,7 +971,7 @@ static int mtd_otp_nvmem_add(struct mtd_
 			nvmem = mtd_otp_nvmem_register(mtd, "factory-otp", size,
 						       mtd_nvmem_fact_otp_reg_read);
 			if (IS_ERR(nvmem)) {
-				dev_err(&mtd->dev, "Failed to register OTP NVMEM device\n");
+				dev_err(dev, "Failed to register OTP NVMEM device\n");
 				err = PTR_ERR(nvmem);
 				goto err;
 			}


