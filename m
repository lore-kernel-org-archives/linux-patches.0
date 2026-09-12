Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAF430568E;
	Sat, 12 Sep 2026 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231843; cv=none; b=OuYlNTLEuz/iwuZraK/ExN2pNVER3AfO8hl1/7o4bxjlE043w1II6bH1u+lQbesEEULdv7wWVGa/jHt5Mxda53u2sTcYsTrNL6anpdUm0pAS6Sv2gnBHubt0g6KemlwRYJ3GIVyH4BBTwgKVAzETo3Mx5oHzrU8Won0xNCev9r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231843; c=relaxed/simple;
	bh=nBhASNdBpSe+pjUKFiABKCPcs5JvvMcaFpieGwRwVYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQWoNI/8wHxw5wQF5sH7SE3MvaA/4LUG1YxOo4xYY/DKgly1KS1rD0eU5P5zG6OrRcT3Ypsi8lWTLcNXnMfB/ZOmR6LhiAMrOwahg6HaObeZ7+8w9vE7ZPsFWZ7Q3YG9BblX6KXGWnMAYxHNobhE98MNANdCpDBNR62yU5rI5x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtX24KdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtX24KdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5111F000FF;
	Sat, 12 Sep 2026 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231841;
	bh=01UBtv4NMtj6xKycwJuThJuIXoRxPMroSHoUL0XWdl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtX24KdCZzwYC3kddnfOfuxNzhB+FhfXVvUA3+qHCLLQ2M7yD/Q+sf/S3FZADfZ3E
	 71iJS65bZhVUGK04Qee9sNcoYpT/hXkV5cydttOQR4ivkVN0DXNuLMtezkwruLBPBK
	 NgQ1m8n2IEJXO6VXehtEuMrl6khImZ+LcgyyzCCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Simon Horman <horms@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1081/1191] forcedeth: stop the tx_timeout register dump past the requested window
Date: Sat, 12 Sep 2026 09:03:29 +0200
Message-ID: <20260912065612.447800362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Czernohous <marek@czernohous.de>

[ Upstream commit cfa9178ce2e5b4f2e2a9e8b577a6cff841665aa0 ]

nv_tx_timeout() dumps the register window in rows of eight dwords:

	for (i = 0; i <= np->register_size; i += 32) {
		netdev_info(dev, "%3x: %08x ... %08x\n", i,
			    readl(base + i + 0), ..., readl(base + i + 28));

The loop bound only checks the row's starting offset, so the final row
reads a full 32 bytes from a position that is below the end of the window
but too close to it. base is mapped with exactly that length:

	np->base = ioremap(addr, np->register_size);

so the tail of that row is read from beyond the length the driver asked
for. Per variant, the last iteration reads past register_size by:

	NV_PCI_REGSZ_VER1 (0x270): row 0x260 reads to 0x27f, 16 bytes over
	NV_PCI_REGSZ_VER2 (0x2d4): row 0x2c0 reads to 0x2df, 12 bytes over
	NV_PCI_REGSZ_VER3 (0x604): row 0x600 reads to 0x61f, 28 bytes over

This happens on every supported device, not just one of them. Note that
it is not a consequence of the sizes being odd: with i <= register_size
the offending row is reached whatever the size, and a size that were a
multiple of 32 would overrun by a full row rather than by a remainder.

To be precise about the severity: the reads stay inside the BAR. Memory
BAR sizes are powers of two, the driver only accepts a region with
pci_resource_len() >= register_size (forcedeth.c:5757-5762), and the
next power of two at or above each register_size already covers the
offending row: 0x400 for 0x270 and 0x2d4, 0x800 for 0x604. ioremap()
also rounds the mapped length up to page granularity, so the reads land
inside the mapping the CPU has as well. What they leave is the window
the driver asked for, not the BAR and not the mapping. That is still a
driver reading registers it did not ask for, and it is trivial to
avoid, but nobody should expect a fault from it.

Changing <= to < is not enough: register_size is a length and every size
above is larger than its last row start, so i still reaches the offending
row. Check that the whole row fits instead.

The trade-off is that a partial trailing row is no longer dumped: 16 bytes
for VER1, 20 for VER2, 4 for VER3. That seemed preferable to reading
outside the requested window, and to open-coding a second, narrower dump
for the remainder in what is a debug-only path. Extending the dump to
cover the tail can be done on top if anyone misses those registers.

Only reachable with the debug_tx_timeout module parameter, which defaults
to false. It has not been observed at runtime: forcing a genuine TX
timeout on the reference machine is not something I can do safely, so this
rests on the arithmetic above and on a build test, not on a reproduction.
UBSAN does not catch it either, since these are MMIO reads rather than an
array access. It was found by reading the function while fixing the
saved_config_space off-by-one in nv_suspend() and nv_resume().

The dump was introduced with a fixed 0x400 bound while ioremap() mapped
only NV_PCI_REGSZ (0x270), so it read about 0x190 bytes too far from the
start. Commit 86a0f04387bf ("[PATCH] forcedeth: fix initialization")
later replaced 0x400 with np->register_size, which shrank the overrun to
the remainder but did not remove it.

Fixes: c2dba06dae7d ("[PATCH] forcedeth: rewritten tx irq handling")
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/178682367886.3748309.6978554332066826294@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index b2f00eeb36a2e..41af3ac9fc020 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -2754,7 +2754,7 @@ static void nv_tx_timeout(struct net_device *dev, unsigned int txqueue)
 
 		netdev_info(dev, "Ring at %lx\n", (unsigned long)np->ring_addr);
 		netdev_info(dev, "Dumping tx registers\n");
-		for (i = 0; i <= np->register_size; i += 32) {
+		for (i = 0; i + 32 <= np->register_size; i += 32) {
 			netdev_info(dev,
 				    "%3x: %08x %08x %08x %08x "
 				    "%08x %08x %08x %08x\n",
-- 
2.53.0



