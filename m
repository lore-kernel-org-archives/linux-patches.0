Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA5C518135;
	Thu, 17 Sep 2026 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664304; cv=none; b=oLfwti0via/ijwkBjGRDKQwHmyOEewRb23L5wsENpcsYw0kFEbDeC9t3y9WzHJAwr0Sk92ikCkS9lQMg+cXLqH4Mf0s3Lb9Umm8gjAIwN4G5QRuZC4xQvJc5VLlhJemaub3R0ZorQVfX56IyeG4afwaOLQmQfsAsGtBYiQXdMRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664304; c=relaxed/simple;
	bh=1PN1TJx++isbTyHDl7accFvyniTnRYPAMcowQaE9L+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ham9VX2h368ufp3BnTO0ZuBZcnx1fPcht6pw/zMXYNipcve7AE3ebl/8DzGnd2g7ocpuRgP4i20fDLVjZIbTOw/m/hddr4wghGLgk+UmYyczStcUD3G4epBtOwSpj8d8g+R09vDaZQhWU3CmqptULMwvGvpXhc3+riHu5LKY7RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiDWK+T6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiDWK+T6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9C71F000FF;
	Thu, 17 Sep 2026 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664303;
	bh=eC6ZjwNRtPlIhYteh9e+NaDvxy6/3Kh10RhWKp07zms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiDWK+T6Iq58ir0ltucH+6Gex9Nb7Fvvkv1XEtCXVDDdjMtiX0PYeLe0pVtM/Z/JU
	 4jAUEUhMglP5a6hNa7lNf1gDfaimPfafLUV4syqgqKdmEDiF4y0Ys0IAd3uFxMnaxV
	 As5WaDEp7H9mL1Rq8buvB/CUoukYpPzn1HeZ8rBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Randolph Sapp <rs@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Antonios Christidis <a-christidis@ti.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0326/1250] clk: keystone: dont cache clock rate
Date: Thu, 17 Sep 2026 16:02:01 +0100
Message-ID: <20260917151600.932343440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



