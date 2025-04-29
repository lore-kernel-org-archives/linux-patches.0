Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DE7216E30;
	Tue, 29 Apr 2025 16:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945288; cv=none; b=UnOCt7UkIuVusdTzgHpBzGCN4/9QPL45KCxQGuVc7ENjA0eBOpyEDiIDVinXyYSiiaObNRM5anZTVZYIDOxFN4hBAV+z//GFbpldJo4M0gTRfAOyXJ+Ehz5XMtQyYayDF/pY9eYN0riX808axoHzqwjDnoHrEdYjD7kn+Lz0LAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945288; c=relaxed/simple;
	bh=ShnDHtMu9urA8zNhVJKZDmBGLEvJZS9/4Dni8pMaQ58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHV8DVzd9ZM8Hw5JLBnA4iznfvTk191vSPWHtO3j11weA0Pvln4jT7Gdve0jFZ6I6+6S/f+ltircjSRhkfPzkX/NM+XgA1tBTWMg3bnjtAOe+DwO+iUCibieAKjozl6tOcl/j8yVYwas3634r5M5qZ4usTW0r6bG7ZqiMoBi6ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6xd1qWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6xd1qWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF41C4CEE3;
	Tue, 29 Apr 2025 16:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945287;
	bh=ShnDHtMu9urA8zNhVJKZDmBGLEvJZS9/4Dni8pMaQ58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6xd1qWSrVoa6SfPWuDxxyAOlQGMoosg0cWBS6jrH8pe3Sc9iI5WH9zgWWuF2FQzw
	 +lzYzyI3WedvyRsnQKflcG6dRlBRkEpCrnZ1w8utd9ptZUOBKk18QxNuCSkEek9Ks+
	 lEOc/EVq1aez/n8SOlG/v14zahTkeycTgMSm6PRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 063/179] mtd: inftlcore: Add error check for inftl_read_oob()
Date: Tue, 29 Apr 2025 18:40:04 +0200
Message-ID: <20250429161051.954472013@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


