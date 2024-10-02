Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10B31D0F41;
	Wed,  2 Oct 2024 14:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877626; cv=none; b=qLLcn1389ZBOpdb+DtJpigczIsKsJ9V83btE/d6ibCACGdUDZPkv9Im7e5PPqN63VdTACJZX+53Njs/xKLzEMkr1LV4QET6O2gt/7QMsrW2xk0F4GSbXcAYNy1P7jjXS7eglKoFoqRNME5reIRhMC1H9q2sES7D7hF/+Chuf7KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877626; c=relaxed/simple;
	bh=4JL2rOLu6x6kBlN1a+XuwuM4b38vayZyj9plswc0bvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6TEvSVLE59H1mY/UnkM2QO2tp/ZlCB/ALpIhuIM0Unafuxne/pxcqTORyk4zLKtzJmasKZQ/vxYw0xkheuzvxuxlHu9EQYQIxCpCAZNUrIs/p+rXkeT2rdKr9dxBpejAvVJX6odMdf7hVOjwSJN4H1Z7utpGvTnh1M+WQuNH58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm1gXXDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm1gXXDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1595DC4CEC5;
	Wed,  2 Oct 2024 14:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877625;
	bh=4JL2rOLu6x6kBlN1a+XuwuM4b38vayZyj9plswc0bvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm1gXXDvxNJI1qNPqmFTFP8Z7Pm2qGz5Fo5VjRR/U6WsnqnTw35Js4///FD7HLQOk
	 G5qhVufz34YjSCTVga3jnB2uywuEAnJIf/k7ovv+OsG/rsKhaZOfWdqE+haBlu8XN/
	 2r0uQgNh1HhFKEWg6HEpbM6h19Va/+6Z4U9uQZic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dries De Winter <ddewinter@synamedia.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 097/634] xsk: fix batch alloc API on non-coherent systems
Date: Wed,  2 Oct 2024 14:53:17 +0200
Message-ID: <20241002125814.938605417@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 4144a1059b47e821c82c3c82eb23a4c7312dce3a ]

In cases when synchronizing DMA operations is necessary,
xsk_buff_alloc_batch() returns a single buffer instead of the requested
count. This puts the pressure on drivers that use batch API as they have
to check for this corner case on their side and take care of allocations
by themselves, which feels counter productive. Let us improve the core
by looping over xp_alloc() @max times when slow path needs to be taken.

Another issue with current interface, as spotted and fixed by Dries, was
that when driver called xsk_buff_alloc_batch() with @max == 0, for slow
path case it still allocated and returned a single buffer, which should
not happen. By introducing the logic from first paragraph we kill two
birds with one stone and address this problem as well.

Fixes: 47e4075df300 ("xsk: Batched buffer allocation for the pool")
Reported-and-tested-by: Dries De Winter <ddewinter@synamedia.com>
Co-developed-by: Dries De Winter <ddewinter@synamedia.com>
Signed-off-by: Dries De Winter <ddewinter@synamedia.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20240911191019.296480-1-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_buff_pool.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index c0e0204b96304..b0f24ebd05f0b 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -623,20 +623,31 @@ static u32 xp_alloc_reused(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u3
 	return nb_entries;
 }
 
-u32 xp_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max)
+static u32 xp_alloc_slow(struct xsk_buff_pool *pool, struct xdp_buff **xdp,
+			 u32 max)
 {
-	u32 nb_entries1 = 0, nb_entries2;
+	int i;
 
-	if (unlikely(pool->dev && dma_dev_need_sync(pool->dev))) {
+	for (i = 0; i < max; i++) {
 		struct xdp_buff *buff;
 
-		/* Slow path */
 		buff = xp_alloc(pool);
-		if (buff)
-			*xdp = buff;
-		return !!buff;
+		if (unlikely(!buff))
+			return i;
+		*xdp = buff;
+		xdp++;
 	}
 
+	return max;
+}
+
+u32 xp_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max)
+{
+	u32 nb_entries1 = 0, nb_entries2;
+
+	if (unlikely(pool->dev && dma_dev_need_sync(pool->dev)))
+		return xp_alloc_slow(pool, xdp, max);
+
 	if (unlikely(pool->free_list_cnt)) {
 		nb_entries1 = xp_alloc_reused(pool, xdp, max);
 		if (nb_entries1 == max)
-- 
2.43.0



