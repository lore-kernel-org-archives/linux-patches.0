Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED91C188701;
	Fri, 15 Nov 2024 06:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653035; cv=none; b=l1z/C4MODhzl/acebKLoPRhDTyB38G/7HyRd0UFa8nD/C4jAyzRa8Q4r/TTySMQz1p0Ph7ZoJEcIshacCrnoJYGCKcGjKihrUhuHmDA4HYFeD3GSngrzfhZd+4mAk+p4En5haa/+gBsN6s/hO6kAM4rC+qp6sfcs2ZdKzDLq9Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653035; c=relaxed/simple;
	bh=M+OJUOjfV6r2rZ3LoGq/frCOiOrC2oIbn5mM/ydCZvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjVPARJBKf4ZAdkkqu77AZNyMHRDxLxf2urYmWDKpJOJNVGPHKHWlcetqSk1KEV1W8ACRxZLdMrtXhyBxWQKBEniai3fgs7Ij/IVW9Ad0MRT2Pu97kCDdgQBXxoEVKLpHrVLLIEf+6jq4oJ/9pdEo0yaXgKQKwkW4wIKd2e0B9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wz25iu50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wz25iu50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC1FC4CECF;
	Fri, 15 Nov 2024 06:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653034;
	bh=M+OJUOjfV6r2rZ3LoGq/frCOiOrC2oIbn5mM/ydCZvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wz25iu508J3qIRLEjpjqVSj5tXVHuJth9iLKAyBqyHVdzK1w/QQRv6SsArV0j/iBB
	 SCDDXrpHH+tJ8VxABW8E8GSpSsuNsnCh5PSMxlu5e+/OK5CTNLfV2EQ3xXrCkW7ehm
	 e1KJZuxmY/8WHYbm3RbFA+oiC2cZUKIg5HZ1V3Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.4 34/66] mtd: rawnand: protect access to rawnand devices while in suspend
Date: Fri, 15 Nov 2024 07:37:43 +0100
Message-ID: <20241115063724.075230501@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

commit 8cba323437a49a45756d661f500b324fc2d486fe upstream.

Prevent rawnand access while in a suspended state.

Commit 013e6292aaf5 ("mtd: rawnand: Simplify the locking") allows the
rawnand layer to return errors rather than waiting in a blocking wait.

Tested on a iMX6ULL.

Fixes: 013e6292aaf5 ("mtd: rawnand: Simplify the locking")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220208085213.1838273-1-sean@geanix.com
[florian: Adjust rawnand.h members documentation and position]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |   44 +++++++++++++++++----------------------
 include/linux/mtd/rawnand.h      |    2 +
 2 files changed, 22 insertions(+), 24 deletions(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -359,16 +359,19 @@ static int nand_isbad_bbm(struct nand_ch
  *
  * Return: -EBUSY if the chip has been suspended, 0 otherwise
  */
-static int nand_get_device(struct nand_chip *chip)
+static void nand_get_device(struct nand_chip *chip)
 {
-	mutex_lock(&chip->lock);
-	if (chip->suspended) {
+	/* Wait until the device is resumed. */
+	while (1) {
+		mutex_lock(&chip->lock);
+		if (!chip->suspended) {
+			mutex_lock(&chip->controller->lock);
+			return;
+		}
 		mutex_unlock(&chip->lock);
-		return -EBUSY;
-	}
-	mutex_lock(&chip->controller->lock);
 
-	return 0;
+		wait_event(chip->resume_wq, !chip->suspended);
+	}
 }
 
 /**
@@ -593,9 +596,7 @@ static int nand_block_markbad_lowlevel(s
 		nand_erase_nand(chip, &einfo, 0);
 
 		/* Write bad block marker to OOB */
-		ret = nand_get_device(chip);
-		if (ret)
-			return ret;
+		nand_get_device(chip);
 
 		ret = nand_markbad_bbm(chip, ofs);
 		nand_release_device(chip);
@@ -3576,9 +3577,7 @@ static int nand_read_oob(struct mtd_info
 	    ops->mode != MTD_OPS_RAW)
 		return -ENOTSUPP;
 
-	ret = nand_get_device(chip);
-	if (ret)
-		return ret;
+	nand_get_device(chip);
 
 	if (!ops->datbuf)
 		ret = nand_do_read_oob(chip, from, ops);
@@ -4122,13 +4121,11 @@ static int nand_write_oob(struct mtd_inf
 			  struct mtd_oob_ops *ops)
 {
 	struct nand_chip *chip = mtd_to_nand(mtd);
-	int ret;
+	int ret = 0;
 
 	ops->retlen = 0;
 
-	ret = nand_get_device(chip);
-	if (ret)
-		return ret;
+	nand_get_device(chip);
 
 	switch (ops->mode) {
 	case MTD_OPS_PLACE_OOB:
@@ -4184,9 +4181,7 @@ int nand_erase_nand(struct nand_chip *ch
 		return -EINVAL;
 
 	/* Grab the lock and see if the device is available */
-	ret = nand_get_device(chip);
-	if (ret)
-		return ret;
+	nand_get_device(chip);
 
 	/* Shift to get first page */
 	page = (int)(instr->addr >> chip->page_shift);
@@ -4273,7 +4268,7 @@ static void nand_sync(struct mtd_info *m
 	pr_debug("%s: called\n", __func__);
 
 	/* Grab the lock and see if the device is available */
-	WARN_ON(nand_get_device(chip));
+	nand_get_device(chip);
 	/* Release it and go back */
 	nand_release_device(chip);
 }
@@ -4290,9 +4285,7 @@ static int nand_block_isbad(struct mtd_i
 	int ret;
 
 	/* Select the NAND device */
-	ret = nand_get_device(chip);
-	if (ret)
-		return ret;
+	nand_get_device(chip);
 
 	nand_select_target(chip, chipnr);
 
@@ -4354,6 +4347,8 @@ static void nand_resume(struct mtd_info
 		pr_err("%s called for a chip which is not in suspended state\n",
 			__func__);
 	mutex_unlock(&chip->lock);
+
+	wake_up_all(&chip->resume_wq);
 }
 
 /**
@@ -5014,6 +5009,7 @@ static int nand_scan_ident(struct nand_c
 	chip->cur_cs = -1;
 
 	mutex_init(&chip->lock);
+	init_waitqueue_head(&chip->resume_wq);
 
 	/* Enforce the right timings for reset/detection */
 	onfi_fill_data_interface(chip, NAND_SDR_IFACE, 0);
--- a/include/linux/mtd/rawnand.h
+++ b/include/linux/mtd/rawnand.h
@@ -1064,6 +1064,7 @@ struct nand_legacy {
  * @lock:		lock protecting the suspended field. Also used to
  *			serialize accesses to the NAND device.
  * @suspended:		set to 1 when the device is suspended, 0 when it's not.
+ * @resume_wq:		wait queue to sleep if rawnand is in suspended state.
  * @bbt:		[INTERN] bad block table pointer
  * @bbt_td:		[REPLACEABLE] bad block table descriptor for flash
  *			lookup.
@@ -1117,6 +1118,7 @@ struct nand_chip {
 
 	struct mutex lock;
 	unsigned int suspended : 1;
+	wait_queue_head_t resume_wq;
 
 	uint8_t *oob_poi;
 	struct nand_controller *controller;


