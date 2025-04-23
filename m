Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338D33A1B6;
	Wed, 23 Apr 2025 15:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421304; cv=none; b=RmbvQfrKekJ9Grzq0OvkoerA81mn1Cfn5b8Y2KtXsc5Muk0AR69VBy3Qyf+ZNSD7mZvBHTE6Vclq8rUaPHZWSuqBtMMYrY1XfovXc0Exq+BKrodOkuU44jjLVDG+IvO1ExM01S8qgpaSlU/eJneRmhTn0e7f/GGczaIYuTI7fqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421304; c=relaxed/simple;
	bh=F6tfxhEiBC7R8h5doMYo7Z3UQ+/QE2ZJra1ojHZwwa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORIvhRm7G6habayjrA9UcMRHr38bOrte6YKy0kI2cxub7m7EPsXiC+jS/BICl1hCJ/rqoUJ5RUrCKjLuCmh2nRG7H1Erqjd0zItiIuFQYm/UFeFaz31UZvsqolhyUcWosEyOP2RUJ94oiTMhpA1FaSBoBEq1NCgdveW6Xkpamak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fcdy3kke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fcdy3kke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B934FC4CEE2;
	Wed, 23 Apr 2025 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421304;
	bh=F6tfxhEiBC7R8h5doMYo7Z3UQ+/QE2ZJra1ojHZwwa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fcdy3kkez0UYWyGhl5XY58Q3jNqsT5KZiO72PXBW4oe2d/QUYRUgCkCLiG/d+bEf4
	 MzT3SrOD4Pyhyr0l4LUkx8NmcjNB3wv+jNzMh5NHgZqVlTojQdQ09+dsJJGr2YjIt8
	 w1inwwZbnUvlnMwU/ba4zVZHppfcF4bJ9Eu9riXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 125/291] mtd: inftlcore: Add error check for inftl_read_oob()
Date: Wed, 23 Apr 2025 16:41:54 +0200
Message-ID: <20250423142629.509230094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


