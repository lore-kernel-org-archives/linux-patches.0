Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ACA1C6B4;
	Tue, 29 Apr 2025 17:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946820; cv=none; b=MvUdQRcCMcMAY4W7ZPWro5vHW4xUu/3rH9Pqp5MsQ0O6K+aglGNF+P5fga/UNdJYVaoIhUmGcnSyhRhsqTj0Nit8KoV6n9Il0oY/EFQmIBHfPl3Skef69bHKhFLuzCFU6RUqthB0osjZEInPjiF4RCttR0H4axfQ6ghWlDtzUao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946820; c=relaxed/simple;
	bh=RLHjf1OnwxE1P/Z+ZdefD1WmtJLI0mBSDTp8SBM/fJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1ib1+bmEH4wAZXggGMAVMXXRUCharV6GvQ0a8BbuFwah1rCpaBIm3H3XkWpCsWd7QjGPf6EssS5w6Z6qU2iaZnP7gUlif6WBysmW7QJh/gI4VSwiniNub6bSQR2XWU0QKncFSFKSX0rl6qs1pr6Lgpxn1peKzQxeLkW1Qcsaz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7FtsOSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7FtsOSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D23C4CEE3;
	Tue, 29 Apr 2025 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946819;
	bh=RLHjf1OnwxE1P/Z+ZdefD1WmtJLI0mBSDTp8SBM/fJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7FtsOSSaqVvq2XNa8O0wmMPoRL5jc9cAQ0p0o4RSuc2H+89kuq9vSgJ1U+TkpxpV
	 NPvqB4T6YPjNdRSEdom7mgSCt7oVaRjYclFy51Ws5HVwBxsVeN49UHgtb9P2cKhlYu
	 SSJbG7l7dUNTRbqDxzCyZDT2qXirHwHNj0Pae36I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 080/286] mtd: inftlcore: Add error check for inftl_read_oob()
Date: Tue, 29 Apr 2025 18:39:44 +0200
Message-ID: <20250429161111.141980111@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


