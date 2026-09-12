Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5770247D92F;
	Sat, 12 Sep 2026 13:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219081; cv=none; b=FvXZo4x+hzLT4rldvjG+lTawQtBXgkDEH0h0eX0ia5gK7fJJ6cMAzJgvsqOVRNEyDLJdTTGJH9KqeOiYuniJG+I/E7mjJvVB6Fbnr1/8JC8lMu7IoihXIGM1tVJrDOaRw8BzkfqE1a0QTkteZZKSDhonNC0/eWDqy5yj2A6iGg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219081; c=relaxed/simple;
	bh=coZtsTGeCuhSf37e20jARKeo6ZdVovyAUTzFen6C0XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9B3wkQYRBrqevk1T8XbojkOHA9EPOKHCc00zgMbCqjAACF0JqMW9O1uTaYq4YrTg/5om5cKTwVJ/i8dwPPM+5D1u+WOBefZbxfpUCMwhzMyJsuOPBsTvFIB1a/rFfCKVCnOBx/zzSM2XSr9Q1Qw6Z77h4Kl8WTX0erEYkJ72cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJynYMfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJynYMfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F2E1F000FF;
	Sat, 12 Sep 2026 13:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219079;
	bh=Q8txaLHMORPp4RFufk9Hm3hzAQpXqVS93SfceSzf7Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJynYMfwreuFcXVXm2q7emyOoD0GU1lqjwcH4HSv+gToKos4mx2Xt9j9OKiVwM4Bt
	 b1WZ3zuUUcgnhWD2ExoPvbvsgFXdso+DUyfPWbLnaqJk7obQpM2UCe8C12m8sKW79n
	 mIftbgGUgGpTS+ULpZKPu0Zij1IqZwhvPLI1yOEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Czernohous <marek@czernohous.de>,
	Simon Horman <horms@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1250/1376] forcedeth: stop the tx_timeout register dump past the requested window
Date: Sat, 12 Sep 2026 09:01:16 +0200
Message-ID: <20260912065635.401622104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c9fb3be4fca94..f28ea729ebb4f 100644
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



