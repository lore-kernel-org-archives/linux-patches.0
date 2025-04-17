Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084CB22E3E6;
	Thu, 17 Apr 2025 18:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913499; cv=none; b=UB+RXZCFKMyB3xJ8QDdmQWHNsIW6gop4u3pAxa56w4zf7Y0tNNjBN2IiRSElnZpXNfx//cyx3BVZGwQSSCrl0ObSDnDCr3Xk7E3KOQV/IZdJab/B8tkoF7JOsp29cbKTOgjfAGcztYVo2Yf7H9idNGpp+1VFuW8L9iLInM371NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913499; c=relaxed/simple;
	bh=DXNBSWz+V+qz0hlDSapVuXl6XKxlRUbItdzgnw5gZ18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPRun+0hO8f3WAoluqyvFpib21TMeT0pd7WQt+goHRsTydgXCOPrZwK9/Iu3/WlykEl+tT/I8qTxl533iNBRpkKf+nqCOWGNNLjltFwiQd4Ae4u4n9xC1KSHAu2P3qfNB4OgD+aq6brJfMuUUCt7guWxKCU6qgEOTpwzid+/cWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W64rZguK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W64rZguK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90094C4CEE4;
	Thu, 17 Apr 2025 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913498;
	bh=DXNBSWz+V+qz0hlDSapVuXl6XKxlRUbItdzgnw5gZ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W64rZguKYBRaFzxBe8xbCMIka4QX3Mmp+uMND3sYv9NunnwJ8YAqjM3knypphxa6/
	 +bp8A37t6oQwY79LiKHlfbBSrUsyhCeN1SpzCFCVi8iCpFTNOyBywjqzVXpB4zHwGV
	 fgyU36C2g1oq9SCzHkkaKfFBBBh9/5joT4j1Cs8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.14 331/449] mtd: inftlcore: Add error check for inftl_read_oob()
Date: Thu, 17 Apr 2025 19:50:19 +0200
Message-ID: <20250417175131.471877031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 


