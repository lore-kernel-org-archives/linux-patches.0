Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147BA347BC6;
	Tue, 21 Jul 2026 22:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674291; cv=none; b=frNhdyPmRMRCb+mggeFL98h03url1wsyiEEC5+JHiMm4S85xzXxRIOKGQLkFDOCLaxv6dxCd1qdbxisqI2au6ibuqX2SmdcJ1gSxIsfQnIpyriaNYLh4KIwqNMxQ1jTfF49NBf3AiCFR0OzKYu6nnHdyC92MWHSLRNiLaA3xnBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674291; c=relaxed/simple;
	bh=zwU7VgUON4zqUV6LoJTSiZvxmlfUJCNpBt4nEBkb5ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C74zqDIUfz+DXFvD8YrsxV3lsiH642LisGk6dbc7HD1zLN2VCIaKDAUeT+/0BXwuHSw4AaDaB6Q3uEDMo+U04bZ5q2TmDQOu2ST+WFt+wdwRpsxfGcX8apjvoAj00lqjASIqr1V2cAsngvXdwCQYrxoodh2Xs8Qnq02xRUD+eLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsqq00jQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsqq00jQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298D71F000E9;
	Tue, 21 Jul 2026 22:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674289;
	bh=7/dpPW6cBYglwGh2TmqC4T3ixHuJSKWAU+KfUi39LQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsqq00jQ53vB67liA7woEXKrJTPUw9atHC8yTF+N+9hVTpRXUu6q072O9Fl/90EFv
	 qXqxjsRA+OUUt8Y+xNUJYWvKw6J4i1PBPX4KMih+7mSZxgeEfa0fihT6Rh3Y2b4hgn
	 VFp40QGZPAPwI/DlBi5fSVPqxqAWOh8wwwZ53B1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 484/699] mtd: rawnand: fix condition in nand_select_target()
Date: Tue, 21 Jul 2026 17:24:03 +0200
Message-ID: <20260721152406.620807793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@rulkc.org>

commit 8507c2cc9e4fa402401819f44d1e8a5ef4d11d8b upstream.

'cs' here must be in range [0:nanddev_ntargets[.

Cc: stable@vger.kernel.org
Fixes: 32813e288414 ("mtd: rawnand: Get rid of chip->numchips")
Signed-off-by: Arseniy Krasnov <avkrasnov@rulkc.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -174,7 +174,7 @@ void nand_select_target(struct nand_chip
 	 * cs should always lie between 0 and nanddev_ntargets(), when that's
 	 * not the case it's a bug and the caller should be fixed.
 	 */
-	if (WARN_ON(cs > nanddev_ntargets(&chip->base)))
+	if (WARN_ON(cs >= nanddev_ntargets(&chip->base)))
 		return;
 
 	chip->cur_cs = cs;


