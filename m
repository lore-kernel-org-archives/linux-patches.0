Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DF634D4C0;
	Tue, 16 Dec 2025 11:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885351; cv=none; b=pKLtua9b14SKxadqnwp1EPczR7iMJbNDRraq+uQxSuXZx+zC7muM3raTTXu6Sh3Wnay552SPCzKfRKNNS1TUjYII+x+1i3lGQFrMWu9vpjWdHFVS2g6e5pvGybWRY9zIYE++scsHRMAcH2tw5aygJDibWMTcvKbNUW1wM9oNH5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885351; c=relaxed/simple;
	bh=L5jFCdNAlNjIOOQKhEkhBy9n4Pz/5QvPND4OjcuQbW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqeGN0r2/KYwywa3GFhUNumk7hrnvvLWWLgyw9/AEGEkwZPWBcsJxB7Go8lEJ3uGz2DbM4d6XSJscp+wB6M/F6CV4ZkWxcsHb/hsSVq2dZR2nVe+yocaj/iQO7jsslkcmv5kkjBFTLZbI66OWDznuBf9b9qbUqOky0QyjhQXFAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tuif7W91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tuif7W91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD7EC4CEF1;
	Tue, 16 Dec 2025 11:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885351;
	bh=L5jFCdNAlNjIOOQKhEkhBy9n4Pz/5QvPND4OjcuQbW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tuif7W9189vv5LvajeSZcjWK+fRU9FsOee9eODgzNSEw47wOHnfImh/0fuNdmdJvy
	 p8thbt2AneQlTXyAaM5Un5htm05boGu/HWSfBlGl/qb0fSnllvTHeSLJCBOSyEDV3g
	 Mc1YwMixAEyLSH5KuHzCzzUmpqRs26i+7KVAnXfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 114/507] mtd: nand: relax ECC parameter validation check
Date: Tue, 16 Dec 2025 12:09:15 +0100
Message-ID: <20251216111349.664232115@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>

[ Upstream commit 050553c683f21eebd7d1020df9b2ec852e2a9e4e ]

Due to the custom handling and layouts of certain nand controllers this
validity check will always fail for certain layouts. The check
inherently depends on even chunk sizing and this is not always the
case.

Modify the check to only print a warning, instead of failing to
init the attached NAND. This allows various 8 bit and 12 ECC strength
layouts to be used.

Fixes: 68c18dae6888 ("mtd: rawnand: marvell: add missing layouts")
Signed-off-by: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 13e4060bd1b6a..a25145dbc16e1 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -6469,11 +6469,14 @@ static int nand_scan_tail(struct nand_chip *chip)
 		ecc->steps = mtd->writesize / ecc->size;
 	if (!base->ecc.ctx.nsteps)
 		base->ecc.ctx.nsteps = ecc->steps;
-	if (ecc->steps * ecc->size != mtd->writesize) {
-		WARN(1, "Invalid ECC parameters\n");
-		ret = -EINVAL;
-		goto err_nand_manuf_cleanup;
-	}
+
+	/*
+	 * Validity check: Warn if ECC parameters are not compatible with page size.
+	 * Due to the custom handling of ECC blocks in certain controllers the check
+	 * may result in an expected failure.
+	 */
+	if (ecc->steps * ecc->size != mtd->writesize)
+		pr_warn("ECC parameters may be invalid in reference to underlying NAND chip\n");
 
 	if (!ecc->total) {
 		ecc->total = ecc->steps * ecc->bytes;
-- 
2.51.0



