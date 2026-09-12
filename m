Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1466352003;
	Sat, 12 Sep 2026 10:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207903; cv=none; b=d5Qk7MpKcNdlEsyxULcfhXFErMd1zWWkmvmEumOk1eT/H+RmffF+D4HNkScQJpXfVwniq28jj6g97ONum7PdllC1sahA6uEaT+kisuLOnfW1RcxTa0foxMQ4ldifoXmP9qcuD4xggBv7/Uv0m82fFHByoYtnkToAfgVnOWWLYzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207903; c=relaxed/simple;
	bh=tAdaaO5D+Uz1y75gEzz/S8VkTzTOloD+atlQKn6kaX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoJ7C2YMw7rI3C8isSkMf75ex9wn32vdFNMcdf1Lk0GhC1dg72ccjLj0vTkm4fQGMI9YcqBdCcPmD39X8/KCDbFqjohwY48P7shfr+9iu22rSQk7wzrw3RapqKfhlpqL4ipg8OWvWU2FaDo/sF82vPMBkYwnGOW5vmts/T404jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDOz4Eoc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDOz4Eoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45221F000FF;
	Sat, 12 Sep 2026 10:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207901;
	bh=39VSgtsx9fksRiTO7NLFSBkgh0sgXdehUv8G0KBBWWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDOz4Eoc9e+Pri2hXmpWP88PKIJ20pBMdJ7CKvOlxITFAQDMWsAu18L/1+UNuQPog
	 IUimPqZMrdmQv1IfiPWAQ5xgj3iybnTby/Uv7MtHJYEjyiSdnp/35vuxazGR5K+CxF
	 551Q5whknQXfFqs2y6v7GgDEDFGgOFFehw1gSUlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0465/1518] mtd: mtdswap: Avoid freeing registered blktrans device twice
Date: Sat, 12 Sep 2026 08:43:54 +0200
Message-ID: <20260912065633.966638957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 42ff7deace80c..d38528210350c 100644
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



