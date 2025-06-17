Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A875D20B807;
	Tue, 17 Jun 2025 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177093; cv=none; b=a16Of7OIKkWPp4FT/lK2+FgqeaMzJMTs4QlksMtlTKk7j231kwTnetSLI1xj4ElQsmKmM+PGtvGroe1LKG3Cb2kYtySqZBOyRkj83l974ntVtajgX5O60zRN6DylsorpQaWWjQwDbhOYt5P5EPJpubtJI2oqrbkqUNviURFBAM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177093; c=relaxed/simple;
	bh=NhmoHB5BSLGJ9BFqRULlbHP7TqncaPX3lBkM8yWlldg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDd91pd/E/sXfJXJJVbhYL2KFKI5P+1RB3y8fPahQONA7fnMTNOOq0fQAcn2Dfa2gy4m2BBiO2TE4KseOkNNsTPKFV4QbrZfCDIcA7iYLUp76Qu9DMQpd3sy6oipDAOKrAAp0wNfuvRPZnsfzQy4xL75BrLeoAN83eLU3Jeawyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6lPR6RR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6lPR6RR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14583C4CEE7;
	Tue, 17 Jun 2025 16:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177093;
	bh=NhmoHB5BSLGJ9BFqRULlbHP7TqncaPX3lBkM8yWlldg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6lPR6RRxLRe5GC8g8rHjjIC6w5kVXkRCt1SkHeESbuNwdGQKle5rZtmuz+dACOeg
	 /902HgP1UI3Ih7s+C/OU//QOntGx1m1zwPA34GbRg7WIPcHz1gU9kxM/kxGotbohJm
	 3mivCggS+u7MccDg1KBv9VxpW4oYUcZNkeZvkae0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Arkhipov <m.arhipov@rosa.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/512] mtd: nand: ecc-mxic: Fix use of uninitialized variable ret
Date: Tue, 17 Jun 2025 17:24:03 +0200
Message-ID: <20250617152430.821063419@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Arkhipov <m.arhipov@rosa.ru>

[ Upstream commit d95846350aac72303036a70c4cdc69ae314aa26d ]

If ctx->steps is zero, the loop processing ECC steps is skipped,
and the variable ret remains uninitialized. It is later checked
and returned, which leads to undefined behavior and may cause
unpredictable results in user space or kernel crashes.

This scenario can be triggered in edge cases such as misconfigured
geometry, ECC engine misuse, or if ctx->steps is not validated
after initialization.

Initialize ret to zero before the loop to ensure correct and safe
behavior regardless of the ctx->steps value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 48e6633a9fa2 ("mtd: nand: mxic-ecc: Add Macronix external ECC engine support")
Signed-off-by: Mikhail Arkhipov <m.arhipov@rosa.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/ecc-mxic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/ecc-mxic.c b/drivers/mtd/nand/ecc-mxic.c
index 47e10945b8d27..63cb206269dd9 100644
--- a/drivers/mtd/nand/ecc-mxic.c
+++ b/drivers/mtd/nand/ecc-mxic.c
@@ -614,7 +614,7 @@ static int mxic_ecc_finish_io_req_external(struct nand_device *nand,
 {
 	struct mxic_ecc_engine *mxic = nand_to_mxic(nand);
 	struct mxic_ecc_ctx *ctx = nand_to_ecc_ctx(nand);
-	int nents, step, ret;
+	int nents, step, ret = 0;
 
 	if (req->mode == MTD_OPS_RAW)
 		return 0;
-- 
2.39.5



	q->limit = ctl->limit;
 	if (child) {
-		qdisc_tree_flush_backlog(q->qdisc);
+		qdisc_purge_queue(q->qdisc);
 		old_child = q->qdisc;
 		q->qdisc = child;
 	}
-- 
2.39.5



