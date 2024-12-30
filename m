Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265B31AB505;
	Mon, 30 Dec 2024 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573795; cv=none; b=A30ME7jil4DBOg7F0+8DUVswpipuTetJCKoITsRacrgEHIuDa9HVtYHJ5UDZqOjR+UiLzHPttkzjVpOtpvjnm7iKZpQ+sA4DvWraXQQvS1J8DslqaKHK+5c6l3+l8Pj1Li1ZxR/JMRUssZeLiKc2zifw2mgPIDCMCl0XoK99ssA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573795; c=relaxed/simple;
	bh=rl93Pfjd3ilbYk4UMIswZLXp+IXNL0CQj7hVNK7AR+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOqUs4c5eyJ+NonehWJwHaOQfrghqWOnmq6/XsFOEEuqVpXOFIaWSI3KIPNd0DL8KNyCWQTBy0QjCt/VnOTByAvS5CsgEBgRWlM6PmWa/VNi+kVilijVpWHIR79lOW1GMVuorMqLUdr55HQZRXi+F9UR3TNZRW9w75fjSLzRgCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b98wZJut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b98wZJut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0FEC4CED0;
	Mon, 30 Dec 2024 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573795;
	bh=rl93Pfjd3ilbYk4UMIswZLXp+IXNL0CQj7hVNK7AR+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b98wZJutSEYQ3n69hYH2V2m7TCDLAMVuoNThoeWxAhbI9/8uILN63KKx9KN2FkRzE
	 C0PnqzK1zNkIH1inzWzrQHtmSghvNB7WHWmi6w6bMSA/5T5Ak3tv+dshNNHgywFdAv
	 SWZa7zu/afx7aAHVh/DDTSQJEDQLHxEDU8PNcBAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 28/86] mtd: rawnand: fix double free in atmel_pmecc_create_user()
Date: Mon, 30 Dec 2024 16:42:36 +0100
Message-ID: <20241230154212.789559287@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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
 


