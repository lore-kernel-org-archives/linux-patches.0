Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C5A1DE4F6;
	Mon,  6 Jan 2025 15:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178349; cv=none; b=cWCmzAqoCtxVbZm3xOAwFAz8mNfkprXXD6dQI2wDx1J8aHCpZuZWx8MRTb/uugRnEh9YSbZcjAjAfSIfKd2FrAFh2fszx/bwEgnG13+LlJd0/nwCFViUsYZHC+ZaIUd3YOEQw0UFw7iHSP1qpIJxZjyQnpMW7a1pTueqfq1E6Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178349; c=relaxed/simple;
	bh=pm8oQDD98WYvvr2swv+WhkAyl9cFoj+50ZiDGE4WFxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epZsm75+ciYniO9f1DnkFM14QF6VQrvTpLz5tgHsNc8akoEn5bs9b7HWEC1HkgRfDr7FC+ePZZ5Mwz6dbnRuuf3ML4XFQrJOS3c8r0hl7Gcr3Rmw37sCTFZaxnjra1xR0BuokjJv2zMb3Y3pnHE0ujDEc9lOvWuU/dDG8BWkrww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLv8Gm6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLv8Gm6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF2CC4CED2;
	Mon,  6 Jan 2025 15:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178349;
	bh=pm8oQDD98WYvvr2swv+WhkAyl9cFoj+50ZiDGE4WFxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLv8Gm6ChDBxqxr4Ime+Nk0WoXYikeHsmqUfsZIg7GfcUSD/UhkhdqPwVqGirMw0W
	 rxK65eD2ua3m8AeyHUwMbo8LzWWMDJXoop9j7RoY4X7MrrricJr6GhWEpM0WnBtG0M
	 4NIFixAlRFBJ87cM12ZprsTDuJoXYH94q3PoIwUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 057/138] mtd: rawnand: fix double free in atmel_pmecc_create_user()
Date: Mon,  6 Jan 2025 16:16:21 +0100
Message-ID: <20250106151135.394824530@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit d8e4771f99c0400a1873235704b28bb803c83d17 upstream.

The "user" pointer was converted from being allocated with kzalloc() to
being allocated by devm_kzalloc().  Calling kfree(user) will lead to a
double free.

Fixes: 6d734f1bfc33 ("mtd: rawnand: atmel: Fix possible memory leak")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/atmel/pmecc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/atmel/pmecc.c
+++ b/drivers/mtd/nand/raw/atmel/pmecc.c
@@ -380,10 +380,8 @@ atmel_pmecc_create_user(struct atmel_pme
 	user->delta = user->dmu + req->ecc.strength + 1;
 
 	gf_tables = atmel_pmecc_get_gf_tables(req);
-	if (IS_ERR(gf_tables)) {
-		kfree(user);
+	if (IS_ERR(gf_tables))
 		return ERR_CAST(gf_tables);
-	}
 
 	user->gf_tables = gf_tables;
 


