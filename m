Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2008650C2A4;
	Wed, 30 Sep 2026 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788522; cv=none; b=O6OBg5xjXBMh8xzbCGbpWVvilXTJYY2HdNiSuky/DJPuMFRJjnJOZ1mxmdE5l/VqSQPTITLHCbAx88rzi3/82yS0vfdTPBa51wgadmlHN3qz8IEGvQDvHhG6A8z5HsYxGA8UlCekklWjv+4eb51cRNkDQqdegBBEA8zXb1eVJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788522; c=relaxed/simple;
	bh=nKTLq6zIbMJjCQUGBsMfwNellZR5e1CRS4zdaO1joiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ry516//WOTt+ZB5m6xndlib8vzginokHC8X/sCJZZKAXAY9IlBaUnh+S45R8u0QvgKl3WjndS1+fHj0S2aGX0jQnsj/mvNX+gYz3yaBVMIfhaMjqtBxJoDNxStYYhcl98nqUktFT/J5dX76HjsogUivhHk+M+yuwaThGWXC/FA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0b+CEGyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0b+CEGyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E4C1F000FF;
	Wed, 30 Sep 2026 17:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788521;
	bh=xtLcuADA+pZ3jikspFuEacE6M/fRNCiRMRVsuzrbuCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0b+CEGyrE6EglanodKbHwO3BhKpYy3dNcv9zOUjrf21f+liVPh+K5rHbh3x10Lgg2
	 e60bRkuPeRFMiQAnTiGoJnDhbaKD+owD6xlYoWS31VWLAXgE7OwwDk+ob6xLbGmiLf
	 fwQG/1XGKYkN7J4DObb346nCWg4Ud+orHmsS+cVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	James Clark <jjc@jclark.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/877] net: macb: fix ordering around PTP timestamp read
Date: Wed, 30 Sep 2026 17:17:43 +0200
Message-ID: <20260930152418.000796695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f2b09100f710e..004c0b3b9181c 100644
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



