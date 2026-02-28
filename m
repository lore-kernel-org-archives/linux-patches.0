Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC0F270545
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302188; cv=none; b=jVnLQHgj+SuMS9VtwAVwQrrHge4+ArVs37w4DeZ/PxMFhvyr0mTmAfObObQ6WFO8a3rtjLjas67bOwtAXetmZOM3zBfc14HBfMAbEb5t43v8mACnM88ZLFdgRCwhNhjq45TcCJqSXoQ8xCsbfL6U5jawfiedh2XponhoY5R3x4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302188; c=relaxed/simple;
	bh=JkUY1j/PvfF8gbV+XcnRvKCIoaFbCV80lQ2CzUMe+N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAk4pztyRvqoGqVN3f+wQa0dPGQDJ2BlS8kTHgwGfCY8LKhpJViExC9OFlXwDo7QxJha0SmdyDEo66+ZNj8rJCvF0I2kvaCn0QVA+bSUMQm+NF/qri7YZduNVxDcQSFoGaPaVMj3dIizMbzKRUmhLAFi74GFfWsq0AkLnURneWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DH/wCcQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DH/wCcQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13F4C19423;
	Sat, 28 Feb 2026 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302188;
	bh=JkUY1j/PvfF8gbV+XcnRvKCIoaFbCV80lQ2CzUMe+N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DH/wCcQGdun4gGqF8dgkzea3yrdcrUuKi9r7h7l7TpNMCAczaEF/ODOwE1pXbE7ig
	 R0tn4ykRJ0xcH0X+w41ojYOB5ASNnq2z8/wJhZbOcdHUYMn8YSuJB4nIhevhWbDw50
	 VGp/7MsKCXArdKZmcVMM+rrTEmt3oyNM3N3l+RB9YIXo3AQ4mcO2Dz+yHsWJCJbWz4
	 HO+tc5MyHF7utF3W+cDSRO5Caoa9JDU5f2PRB7JwH31EbBW5P3zryJb4GtX3oWXLwX
	 CxgoSTIL3yPabAja11b7SmQJHkP0vxbOEytoqLIB3+UGgMjhevrxB2k9tuVvUuqiPd
	 t0G1PW1h8kkJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/283] mtd: parsers: Fix memory leak in mtd_parser_tplink_safeloader_parse()
Date: Sat, 28 Feb 2026 13:05:31 -0500
Message-ID: <20260228180709.1583486-189-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 1c689dafca2ae..3580c79e3277e 100644
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

