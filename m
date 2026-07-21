Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C9F403AE9;
	Tue, 21 Jul 2026 22:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674283; cv=none; b=VALPZs6OPYE01ZZGBUHy7N0LJasjt+13XtiecBxfUrJA/P97YMpEOW8T6WdoUBFWGqMiHzdUGu3onVpZqxxxw2yrFt+IIdzWLGBfH0kxJpRahrjc+VELqnHWVzWqfjsSGQ/t+bEv+XFC9XsxZITg0/rneeco52/E1ddEhCIOawc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674283; c=relaxed/simple;
	bh=d3KkoqPPWw7yXfaw/2l+eY7NAuC0ezKKUlYA4ezGl7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HToTpaARjuMQRVBQB+rz6Cs86uryNcyIg5AsY9yPBO5sUXojEDH/o2O6m7vV+C63eV7QZSaq+5gKWCOtvcb+iGkWe6kiDy9j9jHt/tAWy9/qKagC9LiYgip4Bf7PLk2M6ciySS2RIX74VEg26m2wSn9n6pX2az///DkWS7vrJ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTI6UARK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTI6UARK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABA81F000E9;
	Tue, 21 Jul 2026 22:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674281;
	bh=GRoivzDtRpnLVqHvzldnpofjtu0hksjRNfSvB8FBmCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTI6UARKslEXtaeXP96vkAgm9CL6UPGmZ0eA/kMoSw9I+FhcCFYssePKjK9ApY9DR
	 NDI+BPLtJjEX9bsFWCPGi+8k41hYGr2/CLz/t9QqYxJ2dEPFZcfvHNPlWYmf+5KGaW
	 wTGEi3X+4L7/PMofSIbq1J3IZejrtxyMOOeVIR1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 481/699] mtd: slram: remove failed entries from the device list
Date: Tue, 21 Jul 2026 17:24:00 +0200
Message-ID: <20260721152406.551534225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

commit 36f1648644d769c496a8e47e53603e863e358d73 upstream.

register_device() links a new slram_mtdlist entry before allocating all
of the state needed by the entry. If a later allocation, memremap(), or
mtd_device_register() fails, the partially initialized entry remains on
the global list. A later cleanup can then dereference or free invalid
state from that failed entry.

Unwind the partially initialized entry and clear the list tail on each
failure path after the entry has been linked.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/slram.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -129,6 +129,7 @@ static int slram_write(struct mtd_info *
 static int register_device(char *name, unsigned long start, unsigned long length)
 {
 	slram_mtd_list_t **curmtd;
+	int ret = -ENOMEM;
 
 	curmtd = &slram_mtdlist;
 	while (*curmtd) {
@@ -155,14 +156,15 @@ static int register_device(char *name, u
 
 	if (!(*curmtd)->mtdinfo) {
 		E("slram: Cannot allocate new MTD device.\n");
-		return(-ENOMEM);
+		goto err_free_list;
 	}
 
 	if (!(((slram_priv_t *)(*curmtd)->mtdinfo->priv)->start =
 		memremap(start, length,
 			 MEMREMAP_WB | MEMREMAP_WT | MEMREMAP_WC))) {
 		E("slram: memremap failed\n");
-		return -EIO;
+		ret = -EIO;
+		goto err_free_priv;
 	}
 	((slram_priv_t *)(*curmtd)->mtdinfo->priv)->end =
 		((slram_priv_t *)(*curmtd)->mtdinfo->priv)->start + length;
@@ -183,10 +185,8 @@ static int register_device(char *name, u
 
 	if (mtd_device_register((*curmtd)->mtdinfo, NULL, 0))	{
 		E("slram: Failed to register new device\n");
-		memunmap(((slram_priv_t *)(*curmtd)->mtdinfo->priv)->start);
-		kfree((*curmtd)->mtdinfo->priv);
-		kfree((*curmtd)->mtdinfo);
-		return(-EAGAIN);
+		ret = -EAGAIN;
+		goto err_unmap;
 	}
 	T("slram: Registered device %s from %luKiB to %luKiB\n", name,
 			(start / 1024), ((start + length) / 1024));
@@ -194,6 +194,16 @@ static int register_device(char *name, u
 			((slram_priv_t *)(*curmtd)->mtdinfo->priv)->start,
 			((slram_priv_t *)(*curmtd)->mtdinfo->priv)->end);
 	return(0);
+
+err_unmap:
+	memunmap(((slram_priv_t *)(*curmtd)->mtdinfo->priv)->start);
+err_free_priv:
+	kfree((*curmtd)->mtdinfo->priv);
+err_free_list:
+	kfree((*curmtd)->mtdinfo);
+	kfree(*curmtd);
+	*curmtd = NULL;
+	return ret;
 }
 
 static void unregister_devices(void)


