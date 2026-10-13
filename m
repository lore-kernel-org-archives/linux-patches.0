Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBA11A0B0E;
	Tue, 13 Oct 2026 12:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895217; cv=none; b=KgViNn+FSkKGPV7zRkTtTFaBInOZTX8486LYxloI7OA8o7tfqqZ9lVFoSey4hywWPjHimTOyrOFwjMcxvt5AwagP5soOhnLpP0oUQED4pOxiZAj3Lc3zkkrPi+TKLnA1Ik5Do86o7ZZPPwVelu3WpPyqnjzfl4D23Hefsr00DQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895217; c=relaxed/simple;
	bh=fdz2yivJ6wOvefUzb62GeeAQKGktdJVXePouU/jf4Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZzCxyyOvSBVnTawBP1cwcFQsXk/OpxSZc/J9UZroRH+7pZKZgH6aqahpniTnZeDu9WbdNMznod89mwHNDcW7IrK5+u27WlIQUzf55gDHgKv4iFaL3iif6PMh8x1YR467UxDGY57tljmQbAoQ7K5D/L0ys+4asWLFGeFc5JrR5gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDvUK8DI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDvUK8DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6EA1F000FF;
	Tue, 13 Oct 2026 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895215;
	bh=24kSBWPuOQzdRJ6UaZW8CFMd00a+D7l7TQZLPtRKNow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDvUK8DIS04PRrx4F1tmX2eb69WAyxNmohurx6qq7p8LkwaHP8Qx1Hlsc/wouylQr
	 9biSEY75lWQIiEY3huyEkUpuK7b5314MxOM/45myYfGyQJO1v7VUGGlVk51N7H1Evn
	 957sKIlsHcF/ZLlpnajRjtsjypPzxZ2fw3mnLlTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 200/497] mtd: spinand: fix zero oobavail when no ECC engine is used
Date: Tue, 13 Oct 2026 13:36:07 +0200
Message-ID: <20261013112912.639467821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1511,12 +1511,17 @@ static int spinand_init(struct spinand_d
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


