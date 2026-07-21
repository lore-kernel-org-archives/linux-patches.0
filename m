Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828A53368A5;
	Tue, 21 Jul 2026 20:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667261; cv=none; b=j9GQA0ekgISc0PG4YBMTG2R/EIoxdAYFxRrMuDRtC+jXFjIYnWylMFeVQPJOMUtiaM4vqxpXToIskUPwKAuRvyQ1ZdkqgwemwbrcdbdFnVhUOIAHVTlt+PO4LX0at9xbCdANTEl6jM4Fch0/Z/kVTGIC+Puvvo/MJ7mrK2Quhis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667261; c=relaxed/simple;
	bh=yPxkViJ5HGIdwDPlI7e3/wri5Ik632rdzc1aKPhccqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YP5lT6iZ+WYIqfYi7tp0sVDHIFhy+Xa5q+2mt2QfX6hdeK7kcc18kiWax/w5XYato6dfkL/+rUu3KtlWnVRj8GibPLCU0LbA4vjJSNilS4hWB7jZXoqICQ0ZNoxxkARUOu90aYOkYXs1ecHST6PjAYx9uMGz3dz1Z1T3IZ1mP/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJZqbuHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJZqbuHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C921F000E9;
	Tue, 21 Jul 2026 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667260;
	bh=MFv+Di8rUqyqYY6es0iBZxAbWRXxCRltIKcSkJ1ZMDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJZqbuHVZecYysj1Tmi5b44BEXAfk0VqUadI1r26FkfR3h+xCBz3HL74/5tY6/9vY
	 N5xKCg7Dpz6WPctyvP0qzujGSshH10h0cDhOBuGQKjEs2fHAG1a1bLeywrkREysZHq
	 CEDFY2ZOkeQUDTJLs7Ry5IJwT8KKgOxuOR5pQfuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 0994/1266] mtd: slram: remove failed entries from the device list
Date: Tue, 21 Jul 2026 17:23:51 +0200
Message-ID: <20260721152504.075231282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


