Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F7F13AA55;
	Tue, 27 Feb 2024 13:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041330; cv=none; b=YSJdsfGxoSEE6X351BeENrOjvu3qReQ0ZsVIdVxeNrtQ+3M99oACI1PZTNnbOs9mp53I3L4cZrYBGRvbaZ/mqPCeZh8xcfQ4fu3EhQR6Uyi3egLjkYxBr/ejByQtuUGDEzqUt5cIIWNSadyOBMxGOOtQ0niR4lWkIapbJi9ziL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041330; c=relaxed/simple;
	bh=9UwR1hrATnc+XP4vkwJmEXWu8r+1ay0r8zivhAOYfPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kysmbA1RdJ76PBt3DqN4rh2G9HgCWWaM8SL5PAYj5nV8PvWKVZcF9SsPir2Lx6cCL2uuM3z5BV6+eyBB9ksn6FrpD1pHSwoVQnJrkXVTvC4Y0XvKAuP84zXFU8sY4av7fN/7AQcwizPSBaH1NMRIPUhn6fXj85EGd4j/bQcq5F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm17icxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm17icxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAE3C433F1;
	Tue, 27 Feb 2024 13:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041330;
	bh=9UwR1hrATnc+XP4vkwJmEXWu8r+1ay0r8zivhAOYfPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm17icxEkUfmMQsD0epEOsA42gghAbjND8D6XYXpDWl+teYcYmCTgP16eN4DJO5QF
	 GD2CtAtNkO4Pi4RYdsAR8kwsPheWAahsqQr5pvRij5u26GEzk7h9eSzbTw3b39Ed0G
	 DJ5b7LKnkPy8ulZ6im0hmfLve2H9MmYKMCbJz4lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 301/334] cache: ax45mp_cache: Align end size to cache boundary in ax45mp_dma_cache_wback()
Date: Tue, 27 Feb 2024 14:22:39 +0100
Message-ID: <20240227131640.751326122@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 9bd405c48b0ac4de087c0c4440fd79597201b8a7 ]

Align the end size to cache boundary size in ax45mp_dma_cache_wback()
callback likewise done in ax45mp_dma_cache_inv() callback.

Additionally return early in case of start == end.

Fixes: d34599bcd2e4 ("cache: Add L2 cache management for Andes AX45MP RISC-V core")
Reported-by: Pavel Machek <pavel@denx.de>
Link: https://lore.kernel.org/cip-dev/ZYsdKDiw7G+kxQ3m@duo.ucw.cz/
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cache/ax45mp_cache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cache/ax45mp_cache.c b/drivers/cache/ax45mp_cache.c
index 57186c58dc849..1d7dd3d2c101c 100644
--- a/drivers/cache/ax45mp_cache.c
+++ b/drivers/cache/ax45mp_cache.c
@@ -129,8 +129,12 @@ static void ax45mp_dma_cache_wback(phys_addr_t paddr, size_t size)
 	unsigned long line_size;
 	unsigned long flags;
 
+	if (unlikely(start == end))
+		return;
+
 	line_size = ax45mp_priv.ax45mp_cache_line_size;
 	start = start & (~(line_size - 1));
+	end = ((end + line_size - 1) & (~(line_size - 1)));
 	local_irq_save(flags);
 	ax45mp_cpu_dcache_wb_range(start, end);
 	local_irq_restore(flags);
-- 
2.43.0



