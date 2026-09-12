Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BD228E0;
	Sat, 12 Sep 2026 16:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229764; cv=none; b=gzWaKE8APlTV3ur4jovAQabKlSYsoPwhE+5TrFPzC0UkQdarFMUazCy2zGR5blRJA0hrud09OwfAPLsL+Sn3LRfeRTFJ6uVORJKW8hkW3S6g7YBBXO7wLXZ2YJ2B8kqEqBNf63GYdhVgNFyePLDHx9kW+4XA7UOuPKWcEP2C6Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229764; c=relaxed/simple;
	bh=3mZxW7zBKdjhyxOrnmGjdO7nbSFgXOqxL3JFrkZcoC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5vPQF8m7T7JNgtd9fGqE1U42s//npxAfgVg/RejTj7ZLswP8rAUMWgnUUwIR/XwCjwhpyKOjoenO20Pi1TFRsS/hiB1hHi0F5DSBj8TBCeFGaWtnV/lAninXttgaMYtFTURDc1cycQbbdNXunNT1qWiyfNFRA9Qq61QjD0UVbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwjxsfD6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwjxsfD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186F31F000FF;
	Sat, 12 Sep 2026 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229763;
	bh=yCUY9JiwSalBDfuH0LOT+0qsjXb9yPw+rEO2N1c6Zho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwjxsfD6Ib/Q9jvr8sL0gSSgOfDUSDfjemTPXT30l+MB3FP3XbjdICXcYR51D7qk5
	 jbN9MLIASU9+REcwLgwXu8NJQz9idTQLwS3/HgZ7koPlW0erW/0dUx1VhwupBRAM8n
	 t+EhgcPPMITvp+WcrwgI0quP4wJf26esCyqQu7Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0657/1191] mtd: mtdswap: Avoid freeing registered blktrans device twice
Date: Sat, 12 Sep 2026 08:56:25 +0200
Message-ID: <20260912065603.012757255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



