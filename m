Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429CBBA34;
	Mon,  6 Jan 2025 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179158; cv=none; b=ZyPDGihD/UQrqvba6Ze0qSMMxAj6AuiDvcahZTgLIb2SimwlK7TbjEDN8+gSikxwRMSwwEne16KZ8kwTBIKLWDi5aIQRi6zdwVAnN6kP3xSq5NLQkzs4BXPkQoZNRiOkJKhX4+m7QgGIbjSkv5v9kFnaSmoUl+XOAo/nc0ZWCaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179158; c=relaxed/simple;
	bh=ttV53ShuZYi347xMFp1gVPU/a3wIBnlqrPQZkHMdiEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRa1yCFlSEBvIlkZGIWxBOwZ7075W/TgmkxMNdkWtVSmPJiivffGClx7ajCgdKsk8fWg+2IOZvjbsCxi+ABKbRfSRH1u4ffgqlQMUR7szgZ9si46Bvc9P2ngEAb8jCXf1b9DeljgzVks6oJkkDEm7MZA8hUfnStcH9y0OOuYc50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpa5O/js; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpa5O/js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9C7C4CED2;
	Mon,  6 Jan 2025 15:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179156;
	bh=ttV53ShuZYi347xMFp1gVPU/a3wIBnlqrPQZkHMdiEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpa5O/jscnE+iDC8LMhHt7Z318SiCQawKTGd+zUhTaivDMb0CaCKpR6vnYuoP0a3t
	 N11ovi6DwSDLCoRWq6a0IsF9fwW7F/+CWih75EKJ0P+RLPxYX92Q5eaUQzd8js7B//
	 9K7nCK+JheYU9mUSMKtRJNBAlZ6H9Kb/839J7qUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 43/93] mtd: rawnand: fix double free in atmel_pmecc_create_user()
Date: Mon,  6 Jan 2025 16:17:19 +0100
Message-ID: <20250106151130.327133696@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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
 


