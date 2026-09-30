Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2184F7CCF;
	Wed, 30 Sep 2026 16:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786023; cv=none; b=nnNt8ccqQAkVhqkQ2jgJAdep4o4yMG9hShSNfKAR2O8qm7hZ8WOU1ykfLoAXnoN9b0usdR6QMxIrVrZ0OUZAm4j8tG5O0bT5Tp7HxybGw2Sk9LRDxRN64tSJWuNBpPPiA4sapva3nGUMD0xDadr3U+l3f8P3Q8P5xjXW1roku3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786023; c=relaxed/simple;
	bh=f/KPGg8a+cqFuMblBrzwl+uK03vml+nQU1A1TqmspPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WIoxm3vQB9CXlXyqooOiGk0/yxHrtXkg81V5GTlHeJuEkMzy0JLWjKjY33ihCkq8zQN/w/LJsqJ1yFSRCEN72SMUyKrMS2pf0IqCSPar8ydOYdULxGeCPr5VKnAyvzlhml8C6NDynZ6sCH8bQ8/pZzJ3BdqlDYzkbPxlW3JHO+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUHyiUMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUHyiUMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37D01F000FF;
	Wed, 30 Sep 2026 16:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786022;
	bh=C9QjeU6K52p9OKwe7Iry0wSE6Bq4VhhugvaMhij157w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUHyiUMzpZ1agXMCdHZ/oEVNP9n0x842F7CdHtWgvhgrXQ3XlqHQ7PG9v7jiB2U5m
	 WiOaVQqTg2WFWUaLehnQjc0M9wff57QIFkH+hE5u+DBht6xLOaDrivZc2oDXUz0s17
	 D5NKHuJ10o9nbfuqUuQCow4NztoR5BlTD+OV7VLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	James Clark <jjc@jclark.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 688/982] net: macb: fix ordering around PTP timestamp read
Date: Wed, 30 Sep 2026 17:23:44 +0200
Message-ID: <20260930152431.540242973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <jjc@jclark.com>

[ Upstream commit 9ca4ba24259183ce15665be86b2956cd896c4687 ]

PTP_SYS_OFFSET_EXTENDED returns system timestamps that do not correctly
bracket the PHC register read on MACB/GEM. On a Raspberry Pi 5, the
returned interval can be as short as 37 ns, while an ordered register
read takes approximately 1 us. This biases the midpoint used by phc2sys,
causing CLOCK_REALTIME to run approximately 0.5 us ahead when synchronized
to the PHC.

gem_tsu_get_time() reads the nanoseconds register using the driver's
relaxed MMIO accessor. On weakly ordered systems, the subsequent system
timestamp can be taken before the register read completes. The internal
smp_rmb() in the pre-timestamp path also does not guarantee ordering
against the subsequent MMIO read.

Add rmb() before and after the bracketed nanoseconds read in both the
normal and seconds rollover paths so the system timestamps bracket the
PHC read. Adding the post-read barrier increases the minimum interval on
the same Raspberry Pi 5 to approximately 1 us.

Fixes: e51bb5c2784c ("net: macb: ptp: Switch to gettimex64() interface")
Tested-by: Nicolai Buchwitz <nb@tipi-net.de> # Raspberry Pi CM5, min bracket 37 ns -> 981 ns
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Assisted-by: LLM
Signed-off-by: James Clark <jjc@jclark.com>
Link: https://patch.msgid.link/20260915045823.76100-1-jjc@jclark.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_ptp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index b1b02b8faa8bd..84ba09bfdd303 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -48,7 +48,12 @@ static int gem_tsu_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts,
 
 	spin_lock_irqsave(&bp->tsu_clk_lock, flags);
 	ptp_read_system_prets(sts);
+	/* explicit barriers are needed because gem_readl() is relaxed */
+	if (sts)
+		rmb();
 	first = gem_readl(bp, TN);
+	if (sts)
+		rmb();
 	ptp_read_system_postts(sts);
 	secl = gem_readl(bp, TSL);
 	sech = gem_readl(bp, TSH);
@@ -60,7 +65,11 @@ static int gem_tsu_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts,
 		 * (assume all done within 1s)
 		 */
 		ptp_read_system_prets(sts);
+		if (sts)
+			rmb();
 		ts->tv_nsec = gem_readl(bp, TN);
+		if (sts)
+			rmb();
 		ptp_read_system_postts(sts);
 		secl = gem_readl(bp, TSL);
 		sech = gem_readl(bp, TSH);
-- 
2.53.0



