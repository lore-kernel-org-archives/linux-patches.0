Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B12E30C36B;
	Mon, 13 Oct 2025 15:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369062; cv=none; b=QoHS3syn2WOaFdgzBGrYpTpHi3AJhOa2LBuhUE14OEkHwfWgUB+OfRYCIJKvOYmp6pwAfjcimshUb9EUCXuqZI2ubXHVJYT/J0omLjCBR7PaiyOf33eQEMiGgddzt2iAMz2ccvZW3uenh6n//cKJuglRUe0+FJz4MIz5l2pZWeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369062; c=relaxed/simple;
	bh=vGT79vvu6gM8RTugh9J/OyB/sJZAnFbhgSKPZZiy3C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osEqF638Q0MuD1Tt7ejEMrGCOXwm6+R7WFh7JMXZ4L17iKQFV6itIjeFN7E0U9uk5PBQ4Vl0lJNLXN831vFmWk6Fs7GKXKkSl8CC+sA8BfMv+sG6gmBo26UfGMbGKg7it8jNXedC0XWMSuL4YRjYLw+HPLPZT4VNDNY7z/JDAvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afyf85fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afyf85fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CA5C4CEE7;
	Mon, 13 Oct 2025 15:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369061;
	bh=vGT79vvu6gM8RTugh9J/OyB/sJZAnFbhgSKPZZiy3C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afyf85fm3BvmNLToHGYBTgNSMErLKY3TYd/rYNGp6FZNod1HwLEkia2X02wGQh7Ip
	 0hEPSPvFEk/mFd3jbVnTUCG4y0OuHtTeth9y2P1pIoGWQ8SeZGmKPvRIo03KY+4Odw
	 QH/9gGsMQDDwb0Dlam0X9I3K2lk1cXf/skhMwZ8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 114/563] PM / devfreq: rockchip-dfi: double count on RK3588
Date: Mon, 13 Oct 2025 16:39:35 +0200
Message-ID: <20251013144415.425678662@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0470d7c175f4f..54effb6351965 100644
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
@@ -655,6 +656,9 @@ static int rockchip_ddr_perf_init(struct rockchip_dfi *dfi)
 		break;
 	}
 
+	if (!dfi->count_multiplier)
+		dfi->count_multiplier = 1;
+
 	ret = perf_pmu_register(pmu, "rockchip_ddr", -1);
 	if (ret)
 		return ret;
@@ -751,6 +755,7 @@ static int rk3588_dfi_init(struct rockchip_dfi *dfi)
 	dfi->max_channels = 4;
 
 	dfi->ddrmon_stride = 0x4000;
+	dfi->count_multiplier = 2;
 
 	return 0;
 };
-- 
2.51.0



