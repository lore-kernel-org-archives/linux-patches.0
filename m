Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F5D443A94;
	Mon, 31 Aug 2026 13:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183236; cv=none; b=bHMM8hTJZK2H3vrhAtpoTWavhkpj6zRYZtKdQB+wPWkRvWpzIaMsCI2g7cpxVpnUJbNfeFlaxSGm1j/xC9Q1Xoz2zkPcId2LT9w2s36yWO6FjNtzgBW05kMBFMFn0s6fJRanHsBA/PYe6uRLXMLwdPlH+POT7TBG0dS3ZcxDjPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183236; c=relaxed/simple;
	bh=AXwQcapE6nuipMF+6O6PGobUOjdDVwwO8SHOwvXE78A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NpR/6QXmktLcq1wIfP30NjHFYd+7w5FbafrRDDVmhyK6u4jz4ofMighPVOB17nP9EKQzGG3OpCiVlzATZ92VRQXrMPFCCDyXiO4yNisrDV9O+CYxxTS3rDjhbcCcHnkX3uS2G9IOtEewpjtqhzuWKmIGxP1NzozxV18GmDAfJuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgRck4lu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgRck4lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841E71F00A3D;
	Mon, 31 Aug 2026 13:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183235;
	bh=KbRkYwnQi8E0M8Q6TBJ0YGyVB5OutSqWDHxS8ant4AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgRck4luXYMSp+/6mh5I9lj1BpHNklP5EpFTF3f6GYBCH4ypL0cPqCkqQ1LLjIQTY
	 U3VuytCTZSkdv8khnfFn+IYcOhSaemVJRpx3iuG6eOn2HlH0n+hZsDNizqOyY5c3m6
	 ks/1yU1yvSsDQtv4wk4ovGH1m2Wh5/QkumOsJXPRBWIkeliqfey14+3gCa9URummvf
	 4bkwWaG1clQ/qu5udMQpLng5V3UfSuapNQ7eMFkyF0gkCuznjd1a2XCnPMKVh2nJhc
	 4/Xa+b2xCIaumokWL23JcSymnXwTB9BT6Ei4tzNu0OxWUSelV8hhZfclF5G9SXoD+D
	 c8uQXAXM9H1fQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Walle <mwalle@kernel.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Randolph Sapp <rs@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Antonios Christidis <a-christidis@ti.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kristo@kernel.org,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] clk: keystone: don't cache clock rate
Date: Mon, 31 Aug 2026 09:20:54 -0400
Message-ID: <20260831133314.4125787-26-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit a80b32a140c8612bbaed27009c383d43304db6d5 ]

The TISCI firmware will return 0 if the clock or consumer is not
enabled although there is a stored value in the firmware. IOW a call to
set rate will work but at get rate will always return 0 if the clock is
disabled.
The clk framework will try to cache the clock rate when it's requested
by a consumer. If the clock or consumer is not enabled at that point,
the cached value is 0, which is wrong. Thus, disable the cache
altogether.

Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Randolph Sapp <rs@ti.com>
Reviewed-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Antonios Christidis <a-christidis@ti.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://patch.msgid.link/20260507-clk-sci-v2-1-38f59b48777a@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background checks finished:

- **Commit presence:** `a80b32a140c86` is **not** in the local 6.18.44
  tree (as expected from the analysis).
- **Related GPU commits:** No separate `drm/imagination` clock-control
  fix turned up on mainline — the `sci-clk` NOCACHE change is the
  standalone fix from the J722S GPU bring-up work.

The earlier analysis stands: **YES** for backport to this tree.

 drivers/clk/keystone/sci-clk.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/keystone/sci-clk.c b/drivers/clk/keystone/sci-clk.c
index a4b42811de55d..066823458a75c 100644
--- a/drivers/clk/keystone/sci-clk.c
+++ b/drivers/clk/keystone/sci-clk.c
@@ -333,6 +333,14 @@ static int _sci_clk_build(struct sci_clk_provider *provider,
 
 	init.ops = &sci_clk_ops;
 	init.num_parents = sci_clk->num_parents;
+
+	/*
+	 * A clock rate query to the SCI firmware will return 0 if either the
+	 * clock itself is disabled or the attached device/consumer is disabled.
+	 * This makes it inherently unsuitable for the caching of the clk
+	 * framework.
+	 */
+	init.flags = CLK_GET_RATE_NOCACHE;
 	sci_clk->hw.init = &init;
 
 	ret = devm_clk_hw_register(provider->dev, &sci_clk->hw);
-- 
2.53.0

