Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD21D3876CC;
	Sat, 17 Oct 2026 16:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256292; cv=none; b=W0e3Sz7IFTiwiKS/S5Go6Wi9hbZG22fm6O8mkyS3wjtfodCsdcxGecLSXebxEoB8A0RqkwOEkffo/QAT97gF75VizHaZI0PprQSHaROksR0VruKxq/h5G7phSDiWy1dloMri5tNwJl6i6tLabQgyxtqIA2vX0RuxQcrywM7yc/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256292; c=relaxed/simple;
	bh=lpoW5cLuR6ZiII+1CLtjDxoOaJQX0xfq1ybeGGsd+ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL23awQJyJrNsk5Jzh6NkwZ8seQUwEuFnrHINAYCtpinwTFcMUG+ic0fkJTJGLPm/Yl8yflzg2ugz27XI5Yx3OeD+gOH3GPRAj0ufVCXQe5Q1Ds5xFmNTO8Ac/9SVa0ZAp/NQjBewVB26Or2Qqzk0KREU9LRFg7ClHmvbrNKwgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWr4KWPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWr4KWPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B2B1F000C4;
	Sat, 17 Oct 2026 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256291;
	bh=2tHPx4wifsQjWwGmHQBWKN5Nr3+unraHJ+EapNzWwWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWr4KWPrtVrTWIyDlmQg98ZMxAl0O3AFsbMeryfqOnCbu6fIrvx5/XL/KIHQkDhI6
	 FeqSprw2SzBvr16//NrJMNrc3bC/Kh0HiJkfJwmgQCzSt7PGx53+M3aCkjPsKhW9lz
	 EGR247o2MBbZXPquZH0qO309MzXHE9uodqKQEuu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0188/1674] mtd: core: call _get_device() with the master MTD
Date: Sat, 17 Oct 2026 17:41:00 +0200
Message-ID: <20261017160435.979628004@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 12b31d1acd20b3185bb5f0748db0cf6874c8e9d1 ]

__get_mtd_device() calls the master's _get_device() callback with mtd,
which may be a partition. __put_mtd_device() passes the master.

This breaks gluebi partitions because gluebi_get_device() uses
container_of() and therefore requires the master MTD. Pass the master
to _get_device(), matching _put_device().

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 506ebd4ba1b45..114127e08739d 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1255,7 +1255,7 @@ int __get_mtd_device(struct mtd_info *mtd)
 	int err;
 
 	if (master->_get_device) {
-		err = master->_get_device(mtd);
+		err = master->_get_device(master);
 		if (err)
 			return err;
 	}
-- 
2.53.0



