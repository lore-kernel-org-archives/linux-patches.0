Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489962FE07B;
	Sat,  6 Dec 2025 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765029782; cv=none; b=eag2HLPEhWhyvrfKk+MCBlx9EbbZ2iMbjPyy/rTX12FX1gp6LecywNrQcwx8g8Vx+7CDOy/ytlB++VNGL86XqOGWxo1su0pCqI9zYzld1I1Azck/yqy4lzApBEdz3QhkdpDMhVVqW7iCzao0qmrcqwaK3QKrZsdeCo4rItk3n5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765029782; c=relaxed/simple;
	bh=PvdZO5bm6TogTtlCpTFs+u3DM3Gw3FRyQpADdWSTjBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbjerDkUzdvr50sbV5/3PNJcnHrf+5RH48ISP4s50xeR0gWGBMxcLcKGPwK7i4zHM0Kx5npSY5C40AJ4aabTQjxkaK8e5tgaQyx+P1Lyuu7Y0ikE30e48vnxoOkqAEYOoOqY38jOIqVFGoTD0uAkLpBSFnCjGsEBCzovpTIhtIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+iavT5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+iavT5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9C1C4CEF5;
	Sat,  6 Dec 2025 14:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765029781;
	bh=PvdZO5bm6TogTtlCpTFs+u3DM3Gw3FRyQpADdWSTjBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+iavT5w51FWrGKVkAE384/TAi313CAIH1wjlZSB5XTSTtjqwWoDo1Lj+H5U0YGar
	 IfByuBu8VTqWCR1PI+BhWvIUfHnT79jbNo2bO6tAw1snTNBduDmiNrFeXnFROO/5+J
	 KV/XXZU6eUOopQuKNnL2P6e0TAuJ1Ya9LrCQFEUvfRn9cpB6irxfXhPjOjVVshkJp0
	 ucDW9sDdYcoyBRG58Eu6F3XGDDgxkrJ2OxyvGSpvz4FxjIUDzW1MILWXXpaxkMBycv
	 BAr2qHPpAhre5HBPgi8itXgcDQBhg1h9Us9QFIWFwMaJ63N2cjlXUPnFKFQE3YS5G5
	 Z9Cd22qM8A8mw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Stephen Zhang <starzhangzsd@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.1] gfs2: Fix use of bio_chain
Date: Sat,  6 Dec 2025 09:02:09 -0500
Message-ID: <20251206140252.645973-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251206140252.645973-1-sashal@kernel.org>
References: <20251206140252.645973-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941 ]

In gfs2_chain_bio(), the call to bio_chain() has its arguments swapped.
The result is leaked bios and incorrect synchronization (only the last
bio will actually be waited for).  This code is only used during mount
and filesystem thaw, so the bug normally won't be noticeable.

Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:



 fs/gfs2/lops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9c8c305a75c46..914d03f6c4e82 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -487,7 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(new, prev);
+	bio_chain(prev, new);
 	submit_bio(prev);
 	return new;
 }
-- 
2.51.0

