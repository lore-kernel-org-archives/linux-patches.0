Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A617552;
	Mon,  1 Apr 2024 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987106; cv=none; b=N/jQ5sRqoMp+HVDw65Hw6x4EVZ7K3o7XFxzjVftspy6TVMWGZKrj2GvKUEztDC33GKP9Odv19255ZAlgwy2tgTYOHtuvx9dJLS6ErXmwTsOmJhk/iU/mgXgy0B+j0XFiC57AUxNQu3AHBYkSwE1FzBpK14XRaZcqrKxAcY6hzLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987106; c=relaxed/simple;
	bh=NU4clqdMfxkOZLQhCTkO88BzpgbZ3KcTL4wmZl3iCGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQoo2MXCM/LGzlZ5a7i3jU6JLcJdy/0mX6ywDyYBRdjwxbpxfbMS5ncp4KK6jMDT4ZKx0xb7/EfDjAvKCTLRdYgP7EXkeFHnE9x48IP4IPHcih6qOLHb+rfjeqI/KNqXF3gI8FDmZogmW9nXtZz2MsL1aQO8F1uY6EJGzN1+sOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+N+C4fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+N+C4fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46CEC433F1;
	Mon,  1 Apr 2024 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987106;
	bh=NU4clqdMfxkOZLQhCTkO88BzpgbZ3KcTL4wmZl3iCGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+N+C4fwE7h22iQ4OLTTMXUJ++ddMAn4KaCpCM49DFh7SM/VvkI3teRPlsJ+cgluT
	 G+dakHyNi+Ur+CDy+6y3DMf80yZ1VYUHlzSZBIvkuxV+wcof/InqHOXbnU6MzPYTWu
	 8UrTSruJ5aZATP+//4bsWZPcBrjUUf60bdVRlaXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 185/399] mtd: rawnand: Constrain even more when continuous reads are enabled
Date: Mon,  1 Apr 2024 17:42:31 +0200
Message-ID: <20240401152554.698607785@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 78ffbefba8d7822b232585570b293de5bc397da6 ]

As a matter of fact, continuous reads require additional handling at the
operation level in order for them to work properly. The core helpers do
have this additional logic now, but any time a controller implements its
own page helper, this extra logic is "lost". This means we need another
level of per-controller driver checks to ensure they can leverage
continuous reads. This is for now unsupported, so in order to ensure
continuous reads are enabled only when fully using the core page
helpers, we need to add more initial checks.

Also, as performance is not relevant during raw accesses, we also
prevent these from enabling the feature.

This should solve the issue seen with controllers such as the STM32 FMC2
when in sequencer mode. In this case, the continuous read feature would
be enabled but not leveraged, and most importantly not disabled, leading
to further operations to fail.

Reported-by: Christophe Kerello <christophe.kerello@foss.st.com>
Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Christophe Kerello <christophe.kerello@foss.st.com>
Link: https://lore.kernel.org/linux-mtd/20240307115315.1942678-1-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 4d5a663e4e059..2479fa98f9912 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -3594,7 +3594,8 @@ static int nand_do_read_ops(struct nand_chip *chip, loff_t from,
 	oob = ops->oobbuf;
 	oob_required = oob ? 1 : 0;
 
-	rawnand_enable_cont_reads(chip, page, readlen, col);
+	if (likely(ops->mode != MTD_OPS_RAW))
+		rawnand_enable_cont_reads(chip, page, readlen, col);
 
 	while (1) {
 		struct mtd_ecc_stats ecc_stats = mtd->ecc_stats;
@@ -5212,6 +5213,15 @@ static void rawnand_late_check_supported_ops(struct nand_chip *chip)
 	if (!nand_has_exec_op(chip))
 		return;
 
+	/*
+	 * For now, continuous reads can only be used with the core page helpers.
+	 * This can be extended later.
+	 */
+	if (!(chip->ecc.read_page == nand_read_page_hwecc ||
+	      chip->ecc.read_page == nand_read_page_syndrome ||
+	      chip->ecc.read_page == nand_read_page_swecc))
+		return;
+
 	rawnand_check_cont_read_support(chip);
 }
 
-- 
2.43.0



