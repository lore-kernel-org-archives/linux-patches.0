Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871AD40244D;
	Tue, 21 Jul 2026 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654545; cv=none; b=R6LEuzJ/NC9FJRHCUDB16NcONiW1jIcQfLUVidsfINxyLVqgd/PsKLK58aZR0J4PqerItpvM5ub3TWOGtYSSyQ+d5LJ1X39kjhURwufLEigYqcJK42LwdQpD62WpP1d5Y1WoXMxzKPJY5fYSmUZclN9hJdX5Iz13XckA7P+onmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654545; c=relaxed/simple;
	bh=9Tb2+WLrmCN7b5S28rGsIwQA7MzhBn6mm9AeO2un3ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC3R9pz5cc9MDd4Rk1ndJtXAju6fX1wiXgsdk07kwp6aXziBpBMaqC5MFA2ud98XD22kb/4lmcAGy/Rke3+FEqYHnkkK5DRo2GL5Sih17h+Ki8MZDCe1FVCsm26VhVfHDyioKd+cKN7jN7bLXj/C69Xp2pTrGATlgSD7vTKHsYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/AX7vso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/AX7vso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EE01F000E9;
	Tue, 21 Jul 2026 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654544;
	bh=i6Vz2RIyFP9PhcC5uzlKg8OBTZVcC2Zt12NYfDnTBLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/AX7vsopVYm1/OUL6CB6xVM2H14Nvx0uBiJmiir1EbDwQdhJgVeAIKhaG+VTZwj4
	 +D8qmHOhXFmonW81zpf99yL7IQ3yy5EaenqGkOzYX4bXBc80m8Wzg98/SMNz5Var2x
	 BgGLunSZcUcDGJMkAN5MhSeMAHcRsSAEc4symqrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.1 1744/2077] mtd: maps: vmu-flash: fix fault in unaligned fixup
Date: Tue, 21 Jul 2026 17:23:37 +0200
Message-ID: <20260721152633.881031371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fuchs <fuchsfl@gmail.com>

commit 79d1661502c6e4b6f626185cef72cf2fa78116e1 upstream.

Use kzalloc_obj() / kzalloc_objs() to allocate the memcard structs,
instead of kmalloc_obj() / kmalloc_objs() to prevent access to
uninitialized data.

Fixes runtime error: Fault in unaligned fixup: 0000 [#1] at
mtd_get_fact_prot_info.

Fixes: 47a72688fae7 ("mtd: flash mapping support for Dreamcast VMU.")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/vmu-flash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -609,7 +609,7 @@ static int vmu_connect(struct maple_devi
 
 	basic_flash_data = be32_to_cpu(mdev->devinfo.function_data[c - 1]);
 
-	card = kmalloc_obj(struct memcard);
+	card = kzalloc_obj(struct memcard);
 	if (!card) {
 		error = -ENOMEM;
 		goto fail_nomem;
@@ -627,13 +627,13 @@ static int vmu_connect(struct maple_devi
 	* Not sure there are actually any multi-partition devices in the
 	* real world, but the hardware supports them, so, so will we
 	*/
-	card->parts = kmalloc_objs(struct vmupart, card->partitions);
+	card->parts = kzalloc_objs(struct vmupart, card->partitions);
 	if (!card->parts) {
 		error = -ENOMEM;
 		goto fail_partitions;
 	}
 
-	card->mtd = kmalloc_objs(struct mtd_info, card->partitions);
+	card->mtd = kzalloc_objs(struct mtd_info, card->partitions);
 	if (!card->mtd) {
 		error = -ENOMEM;
 		goto fail_mtd_info;


