Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19DD3D4126;
	Thu, 15 Jan 2026 17:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499343; cv=none; b=XS5jya/k68LzRHsLh6khlqw04CenurgN7gLsNu9ZEGt2pnmUCFiSkhq7H/8lCuRAiCtvBmSurPXK+bOEZzv3ECNI0u/8j5n2Xa4XSXbQ6U6GDh2PYLVm7QOo/Hz0E1PhmQAaCi9nuDJS9pYKv6bARqoabMwxfwP7aUU6h+cOpWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499343; c=relaxed/simple;
	bh=Bf/qQ5TrY0h4u8y/Yd3nvpXFvL9qBnSxtJPHYqzbLB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agwdRMakFh94Ta/nnJsPBH/OUAJERUlzunkgUR9grYspxCA7sBGYaceaexiTaYwGiGbCJ9RDA/6YR67d0A+Vwb4qSGAQ7lpKuo1ddkbkrr96rIpLIEZ4iGIINIqThUfETEph2i7vIQYlOIebPHkS2vYOFeCQlcT+bTuNOIFLzYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRM/NFaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRM/NFaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644A5C2BC87;
	Thu, 15 Jan 2026 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499342;
	bh=Bf/qQ5TrY0h4u8y/Yd3nvpXFvL9qBnSxtJPHYqzbLB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRM/NFazpQN8LoLpKMntMPlEbbbC+Dr3/PmmL/lKZyu6aMZ9WZ8cJVe8xwb9hajWA
	 y3zOV//YJnKgOWcvuoVM95Bl7CaXQT62BrlXnoPSfg44nw85Mt7YMn596OLK/xLek5
	 qhIDY7q9a4YBrIvfTlEH64Q+LAja1BXn6gU2Jk7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/451] block/rnbd-clt: fix wrong max ID in ida_alloc_max
Date: Thu, 15 Jan 2026 17:46:33 +0100
Message-ID: <20260115164237.848271280@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 9d6033e350694a67885605674244d43c9559dc36 ]

We need to pass 'end - 1' to ida_alloc_max after switch from
ida_simple_get to ida_alloc_max.

Otherwise smatch warns.

drivers/block/rnbd/rnbd-clt.c:1460 init_dev() error: Calling ida_alloc_max() with a 'max' argument which is a power of 2. -1 missing?

Fixes: 24afc15dbe21 ("block/rnbd: Remove a useless mutex")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://lore.kernel.org/r/20221230010926.32243-1-guoqing.jiang@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c9b5645fd8ca ("block: rnbd-clt: Fix leaked ID in init_dev()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index ced9c4d7b926..ea4b7002f438 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1378,7 +1378,7 @@ static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
 		goto out_alloc;
 	}
 
-	ret = ida_alloc_max(&index_ida, 1 << (MINORBITS - RNBD_PART_BITS),
+	ret = ida_alloc_max(&index_ida, (1 << (MINORBITS - RNBD_PART_BITS)) - 1,
 			    GFP_KERNEL);
 	if (ret < 0) {
 		pr_err("Failed to initialize device '%s' from session %s, allocating idr failed, err: %d\n",
-- 
2.51.0



