Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB7928D851;
	Wed, 23 Apr 2025 15:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421429; cv=none; b=UKRsELpDA7lKNJyLuDZeg7kbCvS2iBVS2aK1xDzsIuj4JcVa55qykVBp5kA09mjqkTOhN7DqjGXv6JBZiAN8s53/rHFl4QeW6J8SyKz8RY3tGkKBrB3++w89m2G47bfuMRfKrswzIWwQlt2w+F5VxJlD9RoPls2I298gplfJ/BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421429; c=relaxed/simple;
	bh=9tnOemIL/+kKY914uM0OGYWJxquWYmFYtTnK8s5/erc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCbs3H1kLAaOOmJbuw0J9kLxttN4PUsGl22lRjpLdpeP9rWz5wKYkj3oqH0+6PkMQQD2gPp/sx3L1d0kMAFzP/IapgCHl3KFZEpbwZstv80g89RzlZvS5+CgPwbBmWBbc71+g8FLBbQJ1ireGhBNvlkru+tG4SsxJIbrSv0Re8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaNQe1bK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaNQe1bK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC638C4CEE2;
	Wed, 23 Apr 2025 15:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421429;
	bh=9tnOemIL/+kKY914uM0OGYWJxquWYmFYtTnK8s5/erc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaNQe1bKT4rGrBvH/Rgk3obm146BQt+w3vBlTw7b9mRw4IrN3NxXjZhXzTBV4Gl0B
	 7ooTDfc4qJ/6mIU9t6btkOcZO6zDoY3G6BBhpuGP/NfvkJl1tBNwgW25+TWLsYKYFx
	 9q6PVVLqJWvPdBfgwD4l85nNCVJJKcr9berkuTd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 178/393] mtd: inftlcore: Add error check for inftl_read_oob()
Date: Wed, 23 Apr 2025 16:41:14 +0200
Message-ID: <20250423142650.726813562@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


