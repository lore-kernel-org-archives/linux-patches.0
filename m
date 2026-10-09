Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6624E432E;
	Fri,  9 Oct 2026 14:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556549; cv=none; b=iSNtvQ1KBCHeYm/LzoUBloiYsBQCFNXaMTVjfVKv8Hk0q3p9HgzxOmXdv5/wlkcrHIVQm3Auyhw3l7xXHPS7CcfXROv10Bv2O+OiQGzKvq/CqFaVwF/idnbD0PPfYk7U8ktbyWirG/ohnqs0VRUH2lzX7FDuOf+v3wL3TCiAKlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556549; c=relaxed/simple;
	bh=q72VABqJd41iSX+Wy1od9UKz6mERbMVnO5EXQq8siKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAtFroC0krdaGAtkU7c21Nb+pOg5i/YS6iQCJY6/VHeGMt+QHwQWuwUzfehwpj8ko2EWpn5s2JJ6dUq5BYFxDpQPjDwujhjcZbmOEebtZChEW7l6jXSn2BWRN2UkP6xk3mNGoXsfZTolxWD4VEL4ZYT5PlxwjD+5nl1cR/b4Ki8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jq+OXLwz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jq+OXLwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1221F1F0089A;
	Fri,  9 Oct 2026 14:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556547;
	bh=A+YqASJDtf0UFFcqj9EG8PqAXQYXXbY/YOW8s0RQeII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jq+OXLwzHknucLAlbWyujVoy9RR6S8sxvzBZgQwaB02pSo+acrvU0XuYH4WpnIStQ
	 krrOpajC8I/G0xmj3dIwBigS4HcTiw/nzkdyGEk1jRnfrMafcvWP63p3iaeQuYMcLN
	 fbJjymhHDg6jWE0b2SrG0crJlMbKWN6xmM/pRq+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Michael Walle <mwalle@kernel.org>
Subject: [PATCH 6.18 253/403] mtd: spi-nor: core: Fix mutex leak in spi_nor_rww_start_exclusive()
Date: Fri,  9 Oct 2026 16:10:14 +0200
Message-ID: <20261009140958.090020037@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 44b8a0bf5f96e8393312fc34b956766882341f16 upstream.

Use the same guard(mutex) pattern as the other RWW helpers so nor->lock
is released on both the busy and successful return paths.

Fixes: 03e7bb864d9a ("mtd: spi-nor: use scope-based mutex cleanup helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
[mw: rephrased commit message]
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1245,7 +1245,7 @@ static bool spi_nor_rww_start_exclusive(
 {
 	struct spi_nor_rww *rww = &nor->rww;
 
-	mutex_lock(&nor->lock);
+	guard(mutex)(&nor->lock);
 
 	if (rww->ongoing_io || rww->ongoing_rd || rww->ongoing_pe)
 		return false;


