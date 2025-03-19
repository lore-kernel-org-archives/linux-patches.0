Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453CF1DB15C;
	Wed, 19 Mar 2025 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394935; cv=none; b=oogdIrfw3nq9dLouRUN0zQao01xWzzMJvW9S740tSBSx2/BXMmb3Z7LTxWspxFgviBCQmE9Qh0LJ4lUElPNs05Gwjh+dyEcnF8JFDPFrR+i5zMW9B/VtHLtDWc+ulzPhcbuf7f3sI9vYwXXrA2FtMDnynGhsceJy1tNcAU9HyCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394935; c=relaxed/simple;
	bh=XNS5jSISiRUURaKPBWlQcF9K1lNWgXfVy4BldSO8Nfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKIg1LgblgLCPZlGjnLIGyIuzpscbmI13t+SwYKGp/hmDUZQzu9YHTVOhSJN1i4zOjB4Dh5xdn/fTa9Qum1AkS6T8XsQXT5xdHz1W6HJ8/oEqJGpgVolSnuJhXr+BcnrqGo+d2fiWkuAdRvFMwFEw9RlaPDevyrgHKuhoQQlTfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7KejjJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7KejjJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9914C4CEE4;
	Wed, 19 Mar 2025 14:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394933;
	bh=XNS5jSISiRUURaKPBWlQcF9K1lNWgXfVy4BldSO8Nfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7KejjJzGGI3ZV7zwY8ngkHIIJduuyE9l9oKjXC/r0dBYBUx8SFrbUOBTO695wk0W
	 q89RYAkO6w1M8KOSLzG9deeyvvF+SpirFMPfkZy/2mCgOSQE5jWk5ZC/OMUQtu15H5
	 pua9pNxra1sdmCoYicEnTtGpeK+LRMbS5UfVUasU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 148/241] block: fix kmem_cache of name bio-108 already exists
Date: Wed, 19 Mar 2025 07:30:18 -0700
Message-ID: <20250319143031.377190648@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b654f7a51ffb386131de42aa98ed831f8c126546 ]

Device mapper bioset often has big bio_slab size, which can be more than
1000, then 8byte can't hold the slab name any more, cause the kmem_cache
allocation warning of 'kmem_cache of name 'bio-108' already exists'.

Fix the warning by extending bio_slab->name to 12 bytes, but fix output
of /proc/slabinfo

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250228132656.2838008-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index d5bdc31d88d32..f54e8572affc1 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -77,7 +77,7 @@ struct bio_slab {
 	struct kmem_cache *slab;
 	unsigned int slab_ref;
 	unsigned int slab_size;
-	char name[8];
+	char name[12];
 };
 static DEFINE_MUTEX(bio_slab_lock);
 static DEFINE_XARRAY(bio_slabs);
-- 
2.39.5



