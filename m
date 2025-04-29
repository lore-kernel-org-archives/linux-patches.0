Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0014242D73;
	Tue, 29 Apr 2025 17:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948817; cv=none; b=oGM4oxRQvXZbhF86PJWjv29Xk42+VQoLR/lwnq8y17irWFo7zEr7oVGoo82lbDd7ovrakScqsYWPbnnTg6GNcvG70o6K4GrTbw1g54JL2EQseUngRI2Q8krhFUjoMXHpC0LYNihRYVgUwqFyVEBtj3ij49SNPpdPJWFSx7vWZ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948817; c=relaxed/simple;
	bh=5H7L7k4gUmo4FBjijGUxldKiCpjhNOVyJB0l6pX7OHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X62WoLz/BwfBdAGqmxu53Nf9JDnPw9hwIKa0cUO0q8X/pm/uOAsjX4xILa1BY+58D2iTEN8x0A20dz2EJAfW7bPfq1un3KsGOllzbInejcvzFRzPNG0qiHiCR3+YvmvSsSgt3WP+1OC1ozD6icPNYgcLWN1QmXNL0fCRSfRQxw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHO5xu6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHO5xu6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16EFC4CEE3;
	Tue, 29 Apr 2025 17:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948817;
	bh=5H7L7k4gUmo4FBjijGUxldKiCpjhNOVyJB0l6pX7OHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHO5xu6fmXaS/GvMNW7fgHa8EJ5Nt3cJO0acuHj9x2D7iq3m/IoAFSg6rjUc6gPz0
	 hFcOe724s2ohe6Hm9jzNGsQg/Z92P7T4ivEtw1yLuhBItLj7v5m6t6T2XLCA8VRleY
	 EPgqL1MEQv0RVSqThQTxl6pJONozaTM2kgmmYwCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 096/373] mtd: inftlcore: Add error check for inftl_read_oob()
Date: Tue, 29 Apr 2025 18:39:33 +0200
Message-ID: <20250429161127.102898688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


