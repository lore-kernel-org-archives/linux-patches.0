Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C724E56E3;
	Fri,  9 Oct 2026 14:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557237; cv=none; b=QnSSX4mpv1UkIGo7lG+wMfYdlpXW30SlCkxWBb68uZG2jg0SaLUJjDor41W2VQSiMdvACKZvhZIKMKubKOKm3Pte5mqL2RGKphYHPzS8B+XHwnjfpNNYrhhiPaVul2vzdEpNPUhCJ7eq2J12ZD5wTZzVSx65RGkh1XIH65QDqdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557237; c=relaxed/simple;
	bh=y3UtAnPeN0bM+suACP1etnxmTkMlSefn/kxol0PIAR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O3JOBFn4/QdZOxyFEr25l76qafaG5keF5qpsu4YVcHAy5PFLNhdm//2BPlj4s5liSkrziSM2NI3ROhYP3yIbi6CsWZ+VL/lgvxBTH+RbXHfF+9ogHli9mTeeFfJaruJjDIEe0a7gK1HhbMU69brJ9rxkBP1sHxb9lIGHzJAULx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRyPuu3B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRyPuu3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E721F000FF;
	Fri,  9 Oct 2026 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557234;
	bh=1+d5uSXInBUZHyBmu6UWxnjTeTagKyPzauTaPSzzyHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRyPuu3Bh+5aoaC6a1LkMx1dpswo+48KZxERUHxfZKKIBttgy2wJ/yMMZiEy6cK1I
	 Ua/CP0Y8KSHoTnFKKb0E5ty9mmn8qvaGArnQI2Mxv2SfELmSbGcgGJ6fHgdUcE0MPS
	 Y3T1S9gngLHQx6VhuRoA0SIru5ktG9iJQSt8apds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.2 309/428] mtd: spinand: fix zero oobavail when no ECC engine is used
Date: Fri,  9 Oct 2026 16:10:46 +0200
Message-ID: <20261009140952.908128424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1995,12 +1995,17 @@ static int spinand_init(struct spinand_d
 			goto err_cleanup_ecc_engine;
 	}
 
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


