Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F02E257449;
	Thu, 17 Apr 2025 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915919; cv=none; b=cYcBMsqSeiYIxKHBZmSdqruSFzuEWBFDOp8Vd3cIIKz7FXY48RCR4VE9LykCDIYhO25XWjebSrTwaxzlCvg/4sPkkdDEjd0eAE25+xm+ROJI6L7fq48sAbx9SgWAKnMKGR0RdTWiEK3NAhD2y6NnN3BQHIlrcS8FNUbGXIHwOJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915919; c=relaxed/simple;
	bh=0d2ApT0JIAqwISTV5jJ+RgrZRbkAojXaTS2ImQitPMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uot2SbNA9nx3eWAstqEZXrTVHVMlN7vInfNqOHMMUQ8m+jHj871phIHuqJfay1DqQt/9HXS0QFZx7LvMNRsFkdhOsVd6IYCAYZK5LXIHg69hH5nJyG+VUBCy0HVRAMWwWLY5nH+wFsAKay14KT3s/2NLBe7DT9bRyhize2w+yrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofmS71Jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofmS71Jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA20AC4CEE4;
	Thu, 17 Apr 2025 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915919;
	bh=0d2ApT0JIAqwISTV5jJ+RgrZRbkAojXaTS2ImQitPMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofmS71JryIrsBTOLYxX64vq9aKcZH8H3SfePw65CdtwFaKGVMm8QO699ETGXicDpu
	 sQVWLmb0LV4p3JZqgSdqSteSCC4WN+hh45k/8zLaI2iwhBLlClZFBfWHEcV1NYge8h
	 zvAfRM9YjQRvC23c8saEmUKiLcuW538eLisgjGA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 282/393] mtd: inftlcore: Add error check for inftl_read_oob()
Date: Thu, 17 Apr 2025 19:51:31 +0200
Message-ID: <20250417175118.948640223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit d027951dc85cb2e15924c980dc22a6754d100c7c upstream.

In INFTL_findwriteunit(), the return value of inftl_read_oob()
need to be checked. A proper implementation can be
found in INFTL_deleteblock(). The status will be set as
SECTOR_IGNORE to break from the while-loop correctly
if the inftl_read_oob() fails.

Fixes: 8593fbc68b0d ("[MTD] Rework the out of band handling completely")
Cc: stable@vger.kernel.org # v2.6+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/inftlcore.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/mtd/inftlcore.c
+++ b/drivers/mtd/inftlcore.c
@@ -482,10 +482,11 @@ static inline u16 INFTL_findwriteunit(st
 		silly = MAX_LOOPS;
 
 		while (thisEUN <= inftl->lastEUN) {
-			inftl_read_oob(mtd, (thisEUN * inftl->EraseSize) +
-				       blockofs, 8, &retlen, (char *)&bci);
-
-			status = bci.Status | bci.Status1;
+			if (inftl_read_oob(mtd, (thisEUN * inftl->EraseSize) +
+				       blockofs, 8, &retlen, (char *)&bci) < 0)
+				status = SECTOR_IGNORE;
+			else
+				status = bci.Status | bci.Status1;
 			pr_debug("INFTL: status of block %d in EUN %d is %x\n",
 					block , writeEUN, status);
 


