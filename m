Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD0815E8B;
	Mon, 30 Dec 2024 15:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574103; cv=none; b=L9L0SyYcnry5te7xmgQLI/Ug7aZs0L15auTt5/O3wqkn2c25vV5pBzhVXj4XIOGuk9o3dASm2VhuNKQ2Xrvg3YRK7+Sn4mFIDXsSLyWHFuQU2G/KYoTTEtKlM4Hqeg2SEskDel5FSxpXryhWj4sQg7a084G8dou8bNUkNYOSguM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574103; c=relaxed/simple;
	bh=vXoOTzBZnRmZ6qUJCTLY/ncsE3luWFRHotT0sgbRpMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdvGpdGWkJOvrjKN26zClIJX1hUxKXr+xBFVoYqKxvghCSLo9RATv16BrUN61lzTHEGLgUNz2mjNeOJxaR2LI2shIHEaM6Go9+plm7ZmcFMv/ixr7zZahFA8EOlkvXms1jpMQJxRujHTEX1HKBAJAQycRaioqe9f5YOcYdaYHc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBQMLVBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBQMLVBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC91CC4CED0;
	Mon, 30 Dec 2024 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574103;
	bh=vXoOTzBZnRmZ6qUJCTLY/ncsE3luWFRHotT0sgbRpMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBQMLVBEhqbc8dFmH9yxd5QZtPmlsHN4+j5ipGEJ8riySbsjy6GOzDj7Xd4zRYDUB
	 /8DwhPbdhFe2DftXti4MSME0qdVSuMcqheCfEKD96Tkw+BgncDSLsYFZpcrysXQ9Tq
	 C5L6PujQ9rDkcdd90CReYPkKHHr5DhJDKs3w6vsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 037/114] mtd: rawnand: fix double free in atmel_pmecc_create_user()
Date: Mon, 30 Dec 2024 16:42:34 +0100
Message-ID: <20241230154219.491762732@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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
 


