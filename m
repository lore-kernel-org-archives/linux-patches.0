Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF331D0434;
	Wed,  2 Oct 2024 13:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875468; cv=none; b=hVAAoFCem0X7g4AtgeUYjusLrZhxoyn+8WXBv/9JVPOSeSwKjNkOSq1KIg3jnfW7DzKSyCJjuVEGGqGzC9wwXkVRaBdRH/ZGaHP3UQDj7xxNgQ72XdpyrU9FEaKBOAA6nB7I+73gzxW3KDMF60vx8MJvwXdkk/bkYEt8bZgc+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875468; c=relaxed/simple;
	bh=Dv8K2/rC2JDN0N85iUXd6wcs6IunTrc8gSh8kedn858=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfhYssOayPHBWMRnrgcKT82WrccPkXpMKU9JXPpdOe4rVMQauIgYRHUP9y5txpWJ8OrF9vH49bA0myCA3H1VmGno7fE/XFORBlP8+enw3deT+vIf8ssmiSirtzROWoBQ6sqehqN1W17ROAeQQar0EnpDB2oqxctdk1AIu4g4DoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3fI3VtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3fI3VtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0482FC4CECD;
	Wed,  2 Oct 2024 13:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875468;
	bh=Dv8K2/rC2JDN0N85iUXd6wcs6IunTrc8gSh8kedn858=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3fI3VtKvUuK0UmE0U8kNuBXQGIhlTI8yS5tk0Xk8cPBacmNzalDrr9r8DxEucSEo
	 IQeVj7oVNj+yNa3NmNYyMt4B3C7zDcq5q9Lksu2ImvlPPYbwrSF6BhJRhiw6s0aC9A
	 bwUK1kWvt6JQPUfPxVGU8M+6qfopmiPkKVg14vvY=
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
Subject: [PATCH 6.11 111/695] xsk: fix batch alloc API on non-coherent systems
Date: Wed,  2 Oct 2024 14:51:49 +0200
Message-ID: <20241002125826.903891059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



