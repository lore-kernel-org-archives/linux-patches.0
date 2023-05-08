Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D32171AE
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273AFC433EF;
	Mon,  8 May 2023 11:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546387;
	bh=rCRwmt9PhaGGtUdXV+8Wmt2v3n79goQCheAMzZUA/s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj9vt2dhvJ89ebQ2ojD//bh8rfrF5tQtXXev3N61riEc+ptL7rZi78UjbzqzN98q8
	 ocmw797+t8vOKrsNkV96o6TbEAQoJwCBMEbQgN0wavX16WWKOmy8QFWwHrvmRzl9K3
	 be4hiqvrqKez/IW0GUzmxHuT2zqdbuIKkeREWKBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 350/371] mtd: core: provide unique name for nvmem device, take two
Date: Mon,  8 May 2023 11:49:11 +0200
Message-Id: <20230508094826.018564374@linuxfoundation.org>
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

commit 1cd9ceaa5282ff10ea20a7fbadde5a476a1cc99e upstream.

Commit c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
tries to give the nvmem device a unique name, but fails badly if the mtd
device doesn't have a "struct device" associated with it, i.e. if
CONFIG_MTD_PARTITIONED_MASTER is not set. This will result in the name
"(null)-user-otp", which is not unique. It seems the best we can do is
to use the compatible name together with a unique identifier added by
the nvmem subsystem by using NVMEM_DEVID_AUTO.

Fixes: c048b60d39e1 ("mtd: core: provide unique name for nvmem device")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230308082021.870459-1-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdcore.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -828,8 +828,8 @@ static struct nvmem_device *mtd_otp_nvme
 
 	/* OTP nvmem will be registered on the physical device */
 	config.dev = mtd->dev.parent;
-	config.name = kasprintf(GFP_KERNEL, "%s-%s", dev_name(&mtd->dev), compatible);
-	config.id = NVMEM_DEVID_NONE;
+	config.name = compatible;
+	config.id = NVMEM_DEVID_AUTO;
 	config.owner = THIS_MODULE;
 	config.type = NVMEM_TYPE_OTP;
 	config.root_only = true;
@@ -845,7 +845,6 @@ static struct nvmem_device *mtd_otp_nvme
 		nvmem = NULL;
 
 	of_node_put(np);
-	kfree(config.name);
 
 	return nvmem;
 }


