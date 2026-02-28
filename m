Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE40A345736
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301855; cv=none; b=Tu+6N4fHowSuYgLo+VrMQjfgYaqWC/F3XZwSyLYzpPFohp/uiUFUKkIrwF3ejFjzPSHd1g7FlU4sjtNu0QVRkqJyvdH+VQMFKJqUSKRKzApi6AIA5cH0OmHLmAa8PWoQYOtrJPaERQI0j/zDuGnzPGHDTCcDHZ1FDkJTdawdEWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301855; c=relaxed/simple;
	bh=NawSwEB9pi6GQMYM0KLa9D8fXL5nUVaq6rIExydWSXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=id5zEsdr++lHdyMrBuSDtibWnYN2sHyQjy5uNYAm1nBQ3mULpTeE7YClR55X4WE1Hon175ZMh4vYfa2oPFavLx6iqjgcnQOT3atNuwmKO9I4MDIx+RA7GfOL2jytb4vvhvHCsifIYAwrZ3ZAIvitd+4rd/6m32sk1b3VbCuxNS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CByNJMBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CByNJMBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBE8C19424;
	Sat, 28 Feb 2026 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301855;
	bh=NawSwEB9pi6GQMYM0KLa9D8fXL5nUVaq6rIExydWSXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CByNJMBt4iUJQLhNekQY/FLzIfF6cnG0WkEdT06tRtXygL2ebApPsl4+Jz29EcXVi
	 5RLFw3/ROGLGwqSZtXrPwmHIdwGEWHHljsYCnFont3P4rVpO2q74eCagQR4Ps5x0J9
	 NCB1ZoWxfgZBeCXvqfGTn9XYMsZ0MU4pFq/KYmThyp3rpjBVoclXn5/33SRqLvrbHB
	 oNmtWAp7Q1HcmdqLxfUm0jhH2pzoJn/AwvTC68e/elPZscllXT/14uLO3RVByZRbvc
	 56oXPkBHdtT+KrSPaj9483W1m5Hwbd/+M6xeuPCwfUsb4edDRZJMm+keAz/7O+C+CB
	 qbW9LdCtU/arQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/385] mtd: parsers: Fix memory leak in mtd_parser_tplink_safeloader_parse()
Date: Sat, 28 Feb 2026 12:58:18 -0500
Message-ID: <20260228180011.1568201-276-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 980ce2b02dd06a4fdf5fee38b2e14becf9cf7b8b ]

The function mtd_parser_tplink_safeloader_parse() allocates buf via
mtd_parser_tplink_safeloader_read_table(). If the allocation for
parts[idx].name fails inside the loop, the code jumps to the err_free
label without freeing buf, leading to a memory leak.

Fix this by freeing the temporary buffer buf in the err_free label.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 00a3588084be ("mtd: parsers: add TP-Link SafeLoader partitions table parser")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/tplink_safeloader.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/parsers/tplink_safeloader.c b/drivers/mtd/parsers/tplink_safeloader.c
index e358a029dc70c..4fcaf92d22e4f 100644
--- a/drivers/mtd/parsers/tplink_safeloader.c
+++ b/drivers/mtd/parsers/tplink_safeloader.c
@@ -116,6 +116,7 @@ static int mtd_parser_tplink_safeloader_parse(struct mtd_info *mtd,
 	return idx;
 
 err_free:
+	kfree(buf);
 	for (idx -= 1; idx >= 0; idx--)
 		kfree(parts[idx].name);
 err_free_parts:
-- 
2.51.0

