Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8373002A0;
	Thu, 28 May 2026 20:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000007; cv=none; b=LiHC+Broa9w33uu4KA+MaDc3TP5742ljHICP35kNGfhnsHSKR5pBchPQb3Ze1QXG4fWmxLmqQ986XNPsCZ/zmM9aetROvrDJk4/CM2PW+BkaRwfmyT+3TufwXtIsR915xwDqi7TvvRTYjekM9xFuChsH6N8USMRCsijS/OeebqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000007; c=relaxed/simple;
	bh=j21HaLX2YB9cWs7IHNT8RYd3IsT3NubpH1OiPZMvW1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TL3Ebdp5RpE1zvre25JRslxaR2oMIsmsKU28EwxSr5hWpYReZpR52FTxQKV/9pnnX8lckI+MaGNKUjqhUC8LDEJR9+mcYjZZB4Bi236W82zNfUfxF/jQYmVZ2v/4flr79KW7Z5ehfIBEhDNahqGQc3mTy4x3P5U6bGbgicAWKSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XewklCH3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XewklCH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A201F000E9;
	Thu, 28 May 2026 20:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000006;
	bh=bzjpnQ2FPUGuvKj6ZJPAugFp+lRaPl5ZNNzFmtpYfdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XewklCH3O+kw+TatP/XOFtZWvP1FdFV9mGRBgW18Q4gKcS1yDz9zBjIpeYwsiAW8H
	 rziE+BxC0yO+AMibdgOWMC2VQT6pGu4l8kurDziLklodusUSqkmnJHuaaaN3vRZO7g
	 naHaeGI9GFMwIrwdNWte8O0ddAI2MngQH9HRF1XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Shi <cshi008@fiu.edu>,
	Weidong Zhu <weizhu@fiu.edu>,
	Dave Tian <daveti@purdue.edu>,
	Sungwoo Kim <iam@sung-woo.kim>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/377] block: bio-integrity: Fix null-ptr-deref in bio_integrity_map_user()
Date: Thu, 28 May 2026 21:48:26 +0200
Message-ID: <20260528194646.126150080@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit 8582792cf23b3d94674d4d838f7cde9a28d0fcaf ]

pin_user_pages_fast() can partially succeed and return the number of
pages that were actually pinned. However, the bio_integrity_map_user()
does not handle this partial pinning. This leads to a general protection
fault since bvec_from_pages() dereferences an unpinned page address,
which is 0.

To fix this, add a check to verify that all requested memory is pinned.
If partial pinning occurs, unpin the memory and return -EFAULT.

Kernel Oops:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 1061 Comm: nvme-passthroug Not tainted 7.0.0-11783-g90957f9314e8-dirty #16 PREEMPT(lazy)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
RIP: 0010:bio_integrity_map_user.cold+0x1b0/0x9d6

Fixes: 492c5d455969 ("block: bio-integrity: directly map user buffers")
Acked-by: Chao Shi <cshi008@fiu.edu>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Acked-by: Dave Tian <daveti@purdue.edu>
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://github.com/linux-blktests/blktests/pull/244
Link: https://patch.msgid.link/20260512050929.541397-2-iam@sung-woo.kim
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index ab4a15437925e..46c59ed92bd1c 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -299,6 +299,24 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
+	/*
+	 * Handle partial pinning. This can happen when pin_user_pages_fast()
+	 * returns fewer pages than requested.
+	 */
+	if (user_backed_iter(iter) && unlikely(ret != bytes)) {
+		if (ret > 0) {
+			int npinned = DIV_ROUND_UP(offset + ret, PAGE_SIZE);
+			int i;
+
+			for (i = 0; i < npinned; i++)
+				unpin_user_page(pages[i]);
+		}
+		if (pages != stack_pages)
+			kvfree(pages);
+		ret = -EFAULT;
+		goto free_bvec;
+	}
+
 	nr_bvecs = bvec_from_pages(bvec, pages, nr_vecs, bytes, offset,
 				   &is_p2p);
 	if (pages != stack_pages)
-- 
2.53.0



