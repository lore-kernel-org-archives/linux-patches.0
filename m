Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4A4353A75;
	Sat, 12 Sep 2026 11:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212727; cv=none; b=VuJeCwwuKu5GYCFPE4ckys/S1qtK/DCdw09FQdJNSILCafkOHWltvgMa3QJ7Gk7Lq1SejihS4xwP64Zc8QYMuIiXzrhNYu4PfdnkwE8qzxWB5Ze8KvCgWk4zplZev7dJ8uuOuPMqfqV+Lj0RY4pJkmLiGt2tA29q3+xYFSxrj8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212727; c=relaxed/simple;
	bh=7vQX96095SbAW8Aoso1QfYieOi8JDL2X3V7I41/pfTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXovIJVBFHmz6kekL7Rq30U++E06K8iX03ivNpzWMNzY7khH56xmfSil465Ntl7CCEHXTnOvbwir+J/WVC/3BxOYa6r2A7dtJf7SgVfM6k7F9PX8D5KhXSCcLSdZ5hOjsY+SWQIC3lHkpVe+8GTgxKbRykQ8r/c1PTGKKgoT65Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfMvRW19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfMvRW19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32801F00898;
	Sat, 12 Sep 2026 11:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212726;
	bh=oV6rvbb8Vtyd3SbjvpBDQHn6EjnvlsN/mDAjiDFoICA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfMvRW19S5ftoICdo1iw0BV16hH2WV/5ksWlnNtdYc/aYtMzLCh4fGC/timvWPfgB
	 TEPxk7W1+rhqoHFKX/ve9zY9NsqKYFve6r5YH6lAYP/5atnuXjkbzv6s9wMTRWQu6v
	 V6XUwaT0X+ihT6Ue2+KljY0gSkqbYeT+1xoAYo24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1495/1518] blk-mq-dma: always initialize dma state
Date: Sat, 12 Sep 2026 09:01:04 +0200
Message-ID: <20260912065657.381517094@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a0750fae73c55112ea11a4867bee40f11e679405 ]

Ensure the dma state is initialized when we're not using the contiguous
iova, otherwise the caller may be using a stale state from a previous
request that could use the coalesed iova allocation.

Fixes: 2f6b2565d43cdb5 ("block: accumulate memory segment gaps per bio")
Reported-by: Sebastian Ott <sebott@redhat.com>
Tested-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 94d3461b5bc8e..b7c26599f6b05 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -193,6 +193,7 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
 	if (blk_can_dma_map_iova(req, dma_dev) &&
 	    dma_iova_try_alloc(dma_dev, state, vec.paddr, total_len))
 		return blk_rq_dma_map_iova(req, dma_dev, state, iter, &vec);
+	memset(state, 0, sizeof(*state));
 	return blk_dma_map_direct(req, dma_dev, iter, &vec);
 }
 
-- 
2.53.0



