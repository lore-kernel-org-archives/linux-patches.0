Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7162E43E083;
	Thu, 30 Jul 2026 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421186; cv=none; b=ViZaS2cG+1Knr8Dp7NZ5i2xId5tH6+4c3JmOmSqt4PffjeX6cjb9jYukfwoC4XN2DO9vJEN/6y/FP7BkiX6PIwboy0EDOzrZVlyY+9qt7aP1at9jviqJxKlG57AP/qmHv+fEK8KiUAbebhOux/yd9K7IbA+TMv+XX/VxaKSRmlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421186; c=relaxed/simple;
	bh=xAMHdrhLfvKiwVdMMMAz6gAp33ZpCM3L6IPHM9pto4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYzQ5W765vorq2A6Rbggq4+5e8TVtpzqZIDkR7ok+MIXRmN14CDldJdcruVMKbAKn79REkDdSksE+8FL4hlOs+yFM+Ca6Ytnh7m8JhUY3Uf5FZcyWHykacTig/b2/beE8ZSf9hD7ZPTw2efFs/YmBoF89QomFXQoNyVUUd1esds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSIXbe8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSIXbe8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE76B1F000E9;
	Thu, 30 Jul 2026 14:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421185;
	bh=aWaLUQzLyG+/xTgo/+ZVbdu3fTdMdNy0rIl7WmPvIB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSIXbe8sad65icfFvlvZpLEYlNSFR22zalOVMjTFdLTjT8zFVLRAwrynEob211gzo
	 gL8FU3pRiwD49aOQyiENXkwZI//jBduVCaDj94hb1gkkLlomK1FakTkNhdiJECxI9z
	 77C6U8K254oODmBwW6+BsJ1BUKxLsAqA97eTiwn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 020/744] mtd: virt_concat: fix use-after-free in mtd_virt_concat_destroy_joins()
Date: Thu, 30 Jul 2026 16:04:53 +0200
Message-ID: <20260730141444.714420028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 75c0c09541b49daa08fddbc2c18c2232f4eab7d8 ]

mtd_concat_destroy() frees item->concat so calling
mtd_virt_concat_put_mtd_devices(item->concat) leads to a use after free.

Fix this by moving mtd_virt_concat_put_mtd_devices() before
mtd_concat_destroy()

Fixes: 43db6366fc2d ("mtd: Add driver for concatenating devices")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtd_virt_concat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtd_virt_concat.c b/drivers/mtd/mtd_virt_concat.c
index 5db6e648927e29..5761816e7f4dca 100644
--- a/drivers/mtd/mtd_virt_concat.c
+++ b/drivers/mtd/mtd_virt_concat.c
@@ -75,8 +75,8 @@ void mtd_virt_concat_destroy_joins(void)
 		if (item->concat) {
 			mtd_device_unregister(mtd);
 			kfree(mtd->name);
-			mtd_concat_destroy(mtd);
 			mtd_virt_concat_put_mtd_devices(item->concat);
+			mtd_concat_destroy(mtd);
 		}
 	}
 }
-- 
2.53.0



