Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3771A2594B6;
	Mon, 30 Dec 2024 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573645; cv=none; b=gdQ/KmDTVGEon+zPT98U3LLS/AuKB4z/LFb7jA8O2uVnyjLj7n44Nklxq5WzJzs8pGWvVobQf02WJ9/0lL0fuoB9bX5nxW0hq4hpFYvEzwsJNoIFSJafv48VFrh+IPZwLtNlgO7U0orCwI55+FKOZYrj8PZuSJnXk5UDze5c1H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573645; c=relaxed/simple;
	bh=AA/QYhsQm6mhPUCQRAhvYnjdT6zTvc/DdM+LtZTpDrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcCbYxIoysvaiwDG6yGiUHA2yi22BNsjNFsYP/z3lxCu6R+PZKbli0Kt83Ccp3py+aWVk+EzP5SSe9ynmaqCxbyoogbwk/Yd2gdAgHoGN6jtFhtgtx0DZqmEFcQlVszEAvMehghjmDTYr8TW67JrpKiGNxKKXjYDdXMvzln0TKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuYPM6I/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuYPM6I/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EC5C4CED0;
	Mon, 30 Dec 2024 15:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573644;
	bh=AA/QYhsQm6mhPUCQRAhvYnjdT6zTvc/DdM+LtZTpDrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuYPM6I/L2UutuyKGLfQEuqqAgCocn+rpUYEimkXabNcwlhUVE6J/+HSyD/D8v4zD
	 lQmi9/kcLi/I2FnBzxSOpNKHxzckIRQ0myTlyzpwTMn7j1jJLxMXdRjVk1JWWFHdHE
	 7lr1ZlhuChT0W4lcYzFre4BPiFLv6DkfPWbI1cVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 23/60] mtd: rawnand: fix double free in atmel_pmecc_create_user()
Date: Mon, 30 Dec 2024 16:42:33 +0100
Message-ID: <20241230154208.164246821@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


