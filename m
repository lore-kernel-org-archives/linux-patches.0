Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417A29346F;
	Wed,  9 Sep 2026 14:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964880; cv=none; b=Iw2g9PI3XMQIMgXiKnGYq80m52txi86oaaKuutc0QLBF6JIYFlShik+7o8odbZ2MkBgDtsLcG0jHISZ3uQZNMD44VmZTaUiMbNZk9lLNqdCN5zVWvvHsYBTfZGNOoSuUFt50lU3Krl90ROA2oth4rCBryI2iF4yJ8VpSkBBD+I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964880; c=relaxed/simple;
	bh=GPuYz0gE7HzCSesfG3aBRxrkQ9VvZLD5L5rKkSiHDeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyKGg6nMQsC7x6Yii8H2hG//1H9+YRh1f0KZcOWQmJ6EDfIUjIiVp9IvamXGsZ+14WzqbrkYzkAysWBHsaGQYx2D8PhNAgvF8J+p3ovKKU9xhWOotX8uZ5ca0aVmeAaP3rjBBeDRwA+LNmiSOF2mNFkScYppl1V2fOncnX9rtxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBg+IPTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBg+IPTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C751F00A3A;
	Wed,  9 Sep 2026 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964878;
	bh=cRyx/38p1KfaIrpCbo1mS8JB1pHVcB/Bss4M4x9Hu+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBg+IPTDQvBlrhr0q01y+T62qNoSUFgDX6ngBf19H83YJPRK++ypArtA/AqA+qCwS
	 9HHZqgdt3wxMeAfBidk5ju9NT/5YY/3Xq4ukybKMYTujiEwjIkzkmR/Cc72/8Q7sep
	 wa9fGa00p4kgydCZyuY3Rw6Xl4KsIrrQ/Lgn0rKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 558/583] zram: fix the issue that the write - back limits might overflow
Date: Wed,  9 Sep 2026 15:44:03 +0200
Message-ID: <20260909134257.020402566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Yuwen Chen <ywen.chen@foxmail.com>

[ Upstream commit 04d31610a7221cca624646241b1f6b3edd6c99fd ]

When the page size exceeds 4KB, if bd_wb_limit is set to a value that is
not aligned with the page size, it will cause a numerical wrap-around
issue for bd_wb_limit.  For example, when the page size is set to 16KB and
bd_wb_limit is set to 3, after one write-back operation, the value of
bd_wb_limit will become -1.  More seriously, since bd_wb_limit is an
unsigned number, its value may become as large as 2^64 - 1.

The core reason for this problem is that the unit of bd_wb_limit is 4KB.
For example, when a write-back occurs on a system with a page size of
16KB, 4 needs to be subtracted from bd_wb_limit.  This operation takes
place in the zram_account_writeback_submit function.

This patch fixes the issue by limiting bd_wb_limit to be an integer
multiple of PAGE_SIZE / 4096.

Link: https://lkml.kernel.org/r/tencent_5936CFE72BAB2BA76887BB69DCC1B5E67C05@qq.com
Fixes: 1d69a3f8ae77 ("zram: idle writeback fixes and cleanup")
Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: dde75313eed0 ("zram: set default primary compressor in zram_destroy_comps()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -544,6 +544,16 @@ static ssize_t writeback_limit_store(str
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
+	/*
+	 * When the page size is greater than 4KB, if bd_wb_limit is set to
+	 * a value that is not page - size aligned, it will cause value
+	 * wrapping. For example, when the page size is set to 16KB and
+	 * bd_wb_limit is set to 3, a single write - back operation will
+	 * cause bd_wb_limit to become -1. Even more terrifying is that
+	 * bd_wb_limit is an unsigned number.
+	 */
+	val = rounddown(val, PAGE_SIZE / 4096);
+
 	down_write(&zram->init_lock);
 	zram->bd_wb_limit = val;
 	up_write(&zram->init_lock);


