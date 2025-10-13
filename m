Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22273115A9;
	Mon, 13 Oct 2025 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368130; cv=none; b=JB+/ug0q6PwZjQ6tpBKUCfZ5p1xOfccrQbhcLcDKSHSicfmYfKBC2q0YhSiRqQRjrjCUrJSSDR+3K9PVQBhRjjUkkDyRBgzq+tq1nqAVEX9KLZmUgJCqA2U25vXS7+u1wsrJvpbRu0pDOn67OJaounj3WrCtkGVsI6YrHTDGVF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368130; c=relaxed/simple;
	bh=mKk5N6+3NKiQiDQjyY/REGL+N/hch1f4VktunBszK0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0ze27yF7sfl37rJplInZy/CjWktY01ewaGwrU18wR3VXokv530cf8hW3hTTjw4FlRVKUYpoZn5nluQlR7Rf7sdR1xc6NWRUuc5bh3sfu3wcTsbPgb3wHWms172OpbFabSPnlih9HIeCbnwF+Rqbh8j0NOnfCel3tD7Yk1/3Cqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ux0BWdGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ux0BWdGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB243C4CEE7;
	Mon, 13 Oct 2025 15:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368130;
	bh=mKk5N6+3NKiQiDQjyY/REGL+N/hch1f4VktunBszK0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux0BWdGarnzqssRiRPV1HT8l/JHuxe+sRYobY602j82NTV9rlIpClxVhjPalAhdRa
	 V5jUbc/3tD/GBAOuxkuQ6PjzoSNdLIE+f6YBh442XrUJa0wHDhDEIna4AhhwPdFrZS
	 IrzxsfhEBrVvGnWszMPCXdsY22I8jXzRm3jfLQK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/262] PM / devfreq: rockchip-dfi: double count on RK3588
Date: Mon, 13 Oct 2025 16:43:16 +0200
Message-ID: <20251013144328.075353339@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit f89c7fb83ae95578e355bed1a7aeea5f3ca5a067 ]

On RK3588 with LPDDR4X memory, the cycle count as returned by

  perf stat -a -e rockchip_ddr/cycles/ sleep 1

consistently reads half as much as what the actual DDR frequency is at.
For a LPDDR4X module running at 2112MHz, I get more like 1056059916
cycles per second, which is almost bang-on half what it should be. No,
I'm not mixing up megatransfers and megahertz.

Consulting the downstream driver, this appears to be because the RK3588
hardware specifically (and RK3528 as well, for future reference) needs a
multiplier of 2 to get to the correct frequency with everything but
LPDDR5.

The RK3588's actual memory bandwidth measurements in MB/s are correct
however, as confirmed with stress-ng --stream. This makes me think the
access counters are not affected in the same way. This tracks with the
vendor kernel not multiplying the access counts either.

Solve this by adding a new member to the dfi struct, which each SoC can
set to whatever they want, but defaults to 1 if left unset by the SoC
init functions. The event_get_count op can then use this multiplier if
the cycle count is requested.

The cycle multiplier is not used in rockchip_dfi_get_event because the
vendor driver doesn't use it there either, and we don't do other actual
bandwidth unit conversion stuff in there anyway.

Fixes: 481d97ba61e1 ("PM / devfreq: rockchip-dfi: add support for RK3588")
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://lore.kernel.org/lkml/20250530-rk3588-dfi-improvements-v1-1-6e077c243a95@collabora.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/event/rockchip-dfi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/event/rockchip-dfi.c b/drivers/devfreq/event/rockchip-dfi.c
index e2a1e4463b6f5..712df781436ce 100644
--- a/drivers/devfreq/event/rockchip-dfi.c
+++ b/drivers/devfreq/event/rockchip-dfi.c
@@ -116,6 +116,7 @@ struct rockchip_dfi {
 	int buswidth[DMC_MAX_CHANNELS];
 	int ddrmon_stride;
 	bool ddrmon_ctrl_single;
+	unsigned int count_multiplier;	/* number of data clocks per count */
 };
 
 static int rockchip_dfi_enable(struct rockchip_dfi *dfi)
@@ -435,7 +436,7 @@ static u64 rockchip_ddr_perf_event_get_count(struct perf_event *event)
 
 	switch (event->attr.config) {
 	case PERF_EVENT_CYCLES:
-		count = total.c[0].clock_cycles;
+		count = total.c[0].clock_cycles * dfi->count_multiplier;
 		break;
 	case PERF_EVENT_READ_BYTES:
 		for (i = 0; i < dfi->max_channels; i++)
@@ -656,6 +657,9 @@ static int rockchip_ddr_perf_init(struct rockchip_dfi *dfi)
 		break;
 	}
 
+	if (!dfi->count_multiplier)
+		dfi->count_multiplier = 1;
+
 	ret = perf_pmu_register(pmu, "rockchip_ddr", -1);
 	if (ret)
 		return ret;
@@ -752,6 +756,7 @@ static int rk3588_dfi_init(struct rockchip_dfi *dfi)
 	dfi->max_channels = 4;
 
 	dfi->ddrmon_stride = 0x4000;
+	dfi->count_multiplier = 2;
 
 	return 0;
 };
-- 
2.51.0



