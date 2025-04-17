Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2881D07BA;
	Thu, 17 Apr 2025 18:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914550; cv=none; b=MH6k1bCiJzX1YJRVAJj9u+wPAiqe6YjOwyS6fvFOYAyS9LKxlYL2oWiomPH7g/UefOtrcGA1ZnqIiGtjV69z99Q8ltv60s1E7GSvJOIHXSrAiBWWh4UBsg0kXWTYUG5iQo6DImp3/XspMPl1FiKLHc2f32gB5oiDDCMWE0enVrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914550; c=relaxed/simple;
	bh=kYuS51iF8wCyNEfBd306ZUPTi3kqwBFZAihWN9RQWnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsl/S57pQr4PMzJIbYysPcyS2SEYx/ONCPQ7PijC+gO9zViyZT7gzIlJMNBEyUahldx6/KZdJHjHrWrx/suNy618Nk4brfpHCzCZyXI6ljkMQ/78iqlHKnd62XvnDZ6ITZqB27VHCep6oELDzel6kOIliVfndDU3ciYJ7o80I/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bljnm9sI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bljnm9sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08338C4CEE4;
	Thu, 17 Apr 2025 18:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914550;
	bh=kYuS51iF8wCyNEfBd306ZUPTi3kqwBFZAihWN9RQWnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bljnm9sIyPsufaRf5bP40rRMCgNeAyu8VJ8DID2TWX/aRikDSxzXj3yOy4+wW+tpL
	 d8Y0J3WKeakICvuHyAAxQULqt4fOZtmA9txTGu+ZTX43prvt4PE/Ah6Mb8fIkfVOLZ
	 IdKwUAXat+TsfXamdK6yLgGbKdMYxNZ+vCrh1oVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.13 253/414] mtd: Replace kcalloc() with devm_kcalloc()
Date: Thu, 17 Apr 2025 19:50:11 +0200
Message-ID: <20250417175121.596739252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 1b61a59876f0eafc19b23007c522ee407f55dbec upstream.

Replace kcalloc() with devm_kcalloc() to prevent memory leaks in case of
errors.

Fixes: 78c08247b9d3 ("mtd: Support kmsg dumper based on pstore/blk")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpstore.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/mtd/mtdpstore.c
+++ b/drivers/mtd/mtdpstore.c
@@ -417,11 +417,11 @@ static void mtdpstore_notify_add(struct
 	}
 
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, info->kmsg_size));
-	cxt->rmmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
-	cxt->usedmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
+	cxt->rmmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
+	cxt->usedmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
 
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, mtd->erasesize));
-	cxt->badmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
+	cxt->badmap = devm_kcalloc(&mtd->dev, longcnt, sizeof(long), GFP_KERNEL);
 
 	if (!cxt->rmmap || !cxt->usedmap || !cxt->badmap)
 		return;
@@ -530,9 +530,6 @@ static void mtdpstore_notify_remove(stru
 	mtdpstore_flush_removed(cxt);
 
 	unregister_pstore_device(&cxt->dev);
-	kfree(cxt->badmap);
-	kfree(cxt->usedmap);
-	kfree(cxt->rmmap);
 	cxt->mtd = NULL;
 	cxt->index = -1;
 }


