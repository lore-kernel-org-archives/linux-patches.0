Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E99D42C514;
	Sat, 12 Sep 2026 12:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215734; cv=none; b=VdNrUEVujukO8cIxLtitxNZanA9QXGEkO5+zd4bevoK5WEZGXy/xh3quYUJnnOdq/of8fdYxxGG+Rnd4TT02irz2TevW3sRmntGx9VULV8d8lyjIauUgyAae2f+uZng01s6zetlDZHgbdNEUZ3v/myryvkPQt0q8Ew7JwXZ8NuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215734; c=relaxed/simple;
	bh=THRsE0Rake2RxHKjmMGNq2AazQMd5xbIUAyxs96v0k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH09Ocj4JUDeiTDUgiNWZEXCgWJLtx9JCDJiKbc+YXxoZSFJtbR/zjJtzpgEK/5rNWdqzQ2d1agQHCI9Ykn3SW9pNVImX43Tv6xSjLlzCKFI1HoscVMLUhwsl+wwoqdFh+g2K9QLa+usstH9jeFhzR7gM2vunsLZgz07WPu5VQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McIIk+qI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McIIk+qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129EE1F000FF;
	Sat, 12 Sep 2026 12:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215732;
	bh=/b0n/dEZalUN+cxJ2ECkAfIdSvsNSjVjR+n1STwUJkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McIIk+qIkPgm3Iu8p+eUwdKxu4OMCzf1lJFoQHNLa7x+tfKI4U7Ty5W1R5B7Y/7lV
	 k40WnRsOUMgP4bHBppIvQzIVmnxhsYkxb9uwbFgscqG5aBU4GySVIbbRXsKFWFn8Co
	 9QBleYrLZJZeqiKF6I6guYK3gEEEvVIzQ3JgnbO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0591/1376] mtd: mtdswap: Avoid freeing registered blktrans device twice
Date: Sat, 12 Sep 2026 08:50:17 +0200
Message-ID: <20260912065620.706068234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 779aa4c66a96bf43d2d62982ea1a9096a9128d87 ]

In mtdswap_add_mtd(), debugfs setup failure after successful blktrans
registration can free mbd_dev twice.

add_mtd_blktrans_dev() initializes the blktrans device reference and
publishes the disk. Once that succeeds, del_mtd_blktrans_dev() tears the
disk down and drops the blktrans reference; when that reference reaches
zero, blktrans_dev_release() frees the mtd_blktrans_dev.

The debugfs failure path called del_mtd_blktrans_dev(mbd_dev), then fell
through the common cleanup label and called kfree(mbd_dev) again. Clear
the local pointer after deregistration so the common cleanup can still
release the mtdswap state without freeing the blktrans object twice.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: e8e3edb95ce6 ("mtd: create per-device and module-scope debugfs entries")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdswap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/mtdswap.c b/drivers/mtd/mtdswap.c
index 4d695875ea1b2..b7d5fe7eef4b6 100644
--- a/drivers/mtd/mtdswap.c
+++ b/drivers/mtd/mtdswap.c
@@ -1452,6 +1452,7 @@ static void mtdswap_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 
 debugfs_failed:
 	del_mtd_blktrans_dev(mbd_dev);
+	mbd_dev = NULL;
 
 cleanup:
 	mtdswap_cleanup(d);
-- 
2.53.0



