Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1350B253B57;
	Thu, 17 Apr 2025 18:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914698; cv=none; b=atlXlRh9zYdIzo/MkU8ZXqrXY36XJXaIrs1jGL0T7pWcla4/YMF6K07TI/udqvL4q+12bwh1BgNQXpqVJ8/4L6AVJM1qk+61Ww10V2G1iEySb4JEp2cstW764iM2iXqMlK5eGtKUThikDl1Hg9w4oKBYiwmE67Rl3be8hzpmy0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914698; c=relaxed/simple;
	bh=3UfAuVej/DS2aw4tOBVbrRnLTW7/ba4FYs3SeGlif54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbKpfdxiPx9wj7i20N+CerRZDKhdPL84XLvoKlll0cOVrX/7kp3WFPVXyzpwkr3/YkmuXUzHVKmmJDo2ogej3B5PV9wFlMSyn727P7XnQtkfhGL3WBx2xG48wRBiiiOlp+QRImJmBeNLhvhv/L0x8irLoD6ns4hwO42V0uNdcV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOecQBOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOecQBOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A40C4CEE4;
	Thu, 17 Apr 2025 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914698;
	bh=3UfAuVej/DS2aw4tOBVbrRnLTW7/ba4FYs3SeGlif54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOecQBOX/Kk8UEY6NYpVbb9mHn5/1DNid6nwRfQYvY+GZZ6XtADHFuKwhbQze6ySl
	 8CC0J2vDAj7Y9PBRnXjma/o0RMAkdgBQYDFMLsavVADB7JaE+ZyCcGZbrdP23ecIcy
	 Dto1LP34SDQvPxyrwevhgvEX310b8oLcozGxsJrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.13 301/414] mtd: inftlcore: Add error check for inftl_read_oob()
Date: Thu, 17 Apr 2025 19:50:59 +0200
Message-ID: <20250417175123.535959713@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


