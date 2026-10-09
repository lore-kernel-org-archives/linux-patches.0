Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B182439F71;
	Fri,  9 Oct 2026 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555449; cv=none; b=nFNzsqxL6aUmuWL3aop5YXEw5WKEIJe17YGmEQ0uzb1n+e8+LtXn0z0Sn9HvawyEkwCEyuLBO9Yk15PyXB7iLV2Xe/QpLMFlR3EMyyjwf/NpUNnNp/22eONGTXPwgjCqgqoZhghpp9Lb/rnyEkY9pJh8qtN2iKNlGbt0/v8j3No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555449; c=relaxed/simple;
	bh=wAfJ1fkprrYV8UkmbmFx7n/6/a/Do8LunyKtu1NbQr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccRQaS2JTGEw5MjzyI9CLQU8ML7Lw78pSE+U11+J7MfBNHk3Bqh+sCUUaHSQv7bmM8Ql6Pay6wWJs+C5Y4NagznCZfY6RfMUmAeEhSXvVB1wBA3NLmCpn/9AKXtzO40x4td/1cjFTpgt5ZYzomKvYCMJ2Y0W9Zlu51Xe2p1zs7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDga2xGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDga2xGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281ED1F00893;
	Fri,  9 Oct 2026 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555447;
	bh=+7iHbMO7Ce2umq+d37KxKeIZQKc14Va5L9kjx+xwHwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDga2xGHx8YeC9guEr26V7QS7yO+3Miul4WPh7ZWJWv5k9GEo2OYMlO78HwRexjKr
	 GoKo2akBosKxXOL02F3YAu5II9rTWI6dX/7h16EC6H9b6strUP1U/UBixtfKW59vU/
	 RI18yLnR2nV4gtxZCoE/Vxrlzg98/b3zMIGq7O8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/403] mtd: core: call _get_device() with the master MTD
Date: Fri,  9 Oct 2026 16:07:01 +0200
Message-ID: <20261009140953.502280874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 12b31d1acd20b3185bb5f0748db0cf6874c8e9d1 ]

__get_mtd_device() calls the master's _get_device() callback with mtd,
which may be a partition. __put_mtd_device() passes the master.

This breaks gluebi partitions because gluebi_get_device() uses
container_of() and therefore requires the master MTD. Pass the master
to _get_device(), matching _put_device().

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 42cabd3c1efad..51c8ed4893480 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1315,7 +1315,7 @@ int __get_mtd_device(struct mtd_info *mtd)
 	int err;
 
 	if (master->_get_device) {
-		err = master->_get_device(mtd);
+		err = master->_get_device(master);
 		if (err)
 			return err;
 	}
-- 
2.53.0



