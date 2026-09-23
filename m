Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA7138D6A2;
	Wed, 23 Sep 2026 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173490; cv=none; b=gwIllZFaPXeami/MMt5bECEaauoWtAFUGHfJ43YYkP9BOpFiNQHHuNbmmTJrs3TWvRWPGSPit24Lmr/QELYuOBwCik0fOqZd2X8wEanEC3bwYlRhWDZWwqPub+BcXcNXx9MiMfOV8izdIZQPBoMyKo/t6B2n6nzJwAD/IEHKoUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173490; c=relaxed/simple;
	bh=2f+126b6XCUcL0VBUOWhKGZFlqwMXHnugMKvZOEzQGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IACH2UVN8gfbI9KzbR1LIDWksohjUX+LTxhFxu1YeLXX4LfGekAD0C7wNK9m51QdgHzKn+UQoyheJmHQzTQ7QUZ795ZrsmWRNWifzwlieS5lE0jx1Cya5Yalp38FaTgUdk+0i+uI/n1j2vN4V4DXBdfmWGTbKa2jLy5/6CSkN5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ES8BDmi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ES8BDmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E6D1F000FF;
	Wed, 23 Sep 2026 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173489;
	bh=Dk3Ysuv/Z3Pwt6n0xnZbYAfUaKAZc+frPVxct2TPxEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ES8BDmia114x6zjoRggqgtBFs5iRZvOuwiK0wtn/1m1vMVLdEfCQB0GJbHqa+acv
	 4F64P2+KMxULbVGLbvwFG7ei4FOD3mbj/7igdfNrWtSyOQvi6o+2IDBlbNFf6hGPpE
	 buBc7t1FPe4V0x43hQ2O/0z3Z+Rjn6PfJSaddd2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	James Clark <jjc@jclark.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 219/438] net: macb: fix ordering around PTP timestamp read
Date: Wed, 23 Sep 2026 16:04:00 +0200
Message-ID: <20260923140650.442254340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6d91663899886..14ae57fa00cba 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -50,7 +50,12 @@ static int gem_tsu_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts,
 
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
@@ -62,7 +67,11 @@ static int gem_tsu_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts,
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



