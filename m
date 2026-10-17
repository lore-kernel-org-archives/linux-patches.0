Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9B73A7D9E;
	Sat, 17 Oct 2026 17:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256659; cv=none; b=OhVWw3VXrLUoELFImnvbgJNTWjXRfOQpSTxdXOjc9W266FcOIujRVaHkRngia8a1IC+fiuPh+gNpO6Xy7bH4steiUARtQq2d7GQ9/WFUdpuYVJjFbdfcO1fklxpv1zNHN+QOnq0Lsje5aEIU0fj0d/7Okvc/MU9Sn6GQtVslh9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256659; c=relaxed/simple;
	bh=X0A+EiQb9PWi3RgCSrjp176mKUCFjo84zJEIysuo3+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NfNnQfpcUIy1tOVRJYlkWXQxTFAlbed5UAVh324MqwPoLjNtgD9oQodo2oTa3aIrlNwxnIadzawr4VSucPgg5eIBbEOERbzHoGE81Z3X+xYLZwEC+QPDyEDEAZrUIV2WmhPSwMvt35cIbugtFSbiE/GCCb2I8gr9EZpQoXWbVD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxkZ1bUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxkZ1bUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969401F000C4;
	Sat, 17 Oct 2026 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256658;
	bh=Kg3Z4DJnmPttSHmGESxFGMz3si/Pbc50ZMrKyXMfQZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxkZ1bUqucPIFYbJhCU5Bl78zF9JDzlgdTHsRGHmpPJt1xFNMxdz4D+gvg5DdSjXt
	 HvjVfYxZ9x+JO+7cfnR+N7aoGrtdd6/NAq0e7iUxVuvRCBNYrca0Q5xmd1M61+OLn+
	 AZ31kqe8/K0/JmQBDCtC39/hG4HdM1mLKTb5jOK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 0310/1674] mtd: spinand: fix zero oobavail when no ECC engine is used
Date: Sat, 17 Oct 2026 17:43:02 +0200
Message-ID: <20261017160439.075909379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

commit 636fe10d8f3559210ff63108a208d39ea2e9c3bd upstream.

Commit 00c15b78b4b4 ("mtd: spinand: Allow the case where there is no
ECC engine") made the OOB free bytes count conditional on having an
ECC engine so that probing would not fail when none is requested.
However mtd->oobavail is still assigned from ret just after that
block, and ret is 0 there, so the device ends up advertising no
available OOB bytes at all.

mtd_oobavail() returns mtd->oobavail for MTD_OPS_AUTO_OOB, so a zero
value makes every automatic OOB access fail with -EINVAL. JFFS2 fares
worse: it keeps its cleanmarker in the OOB area on NAND and refuses to
mount outright, reporting "inconsistent device description".

No ECC engine also means no ooblayout was ever installed, which would
make the count return -ENOTSUPP, so install the same fallback layout
the on-die path already uses before counting unconditionally.

Fixes: 00c15b78b4b4 ("mtd: spinand: Allow the case where there is no ECC engine")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1280,12 +1280,17 @@ static int spinand_init(struct spinand_d
 	mtd->_max_bad_blocks = nanddev_mtd_max_bad_blocks;
 	mtd->_resume = spinand_mtd_resume;
 
-	if (nand->ecc.engine) {
-		ret = mtd_ooblayout_count_freebytes(mtd);
-		if (ret < 0)
-			goto err_cleanup_ecc_engine;
+	if (!nand->ecc.engine) {
+		if (spinand->eccinfo.ooblayout)
+			mtd_set_ooblayout(mtd, spinand->eccinfo.ooblayout);
+		else
+			mtd_set_ooblayout(mtd, &spinand_noecc_ooblayout);
 	}
 
+	ret = mtd_ooblayout_count_freebytes(mtd);
+	if (ret < 0)
+		goto err_cleanup_ecc_engine;
+
 	mtd->oobavail = ret;
 
 	/* Propagate ECC information to mtd_info */


