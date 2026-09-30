Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903553D092F;
	Wed, 30 Sep 2026 18:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794334; cv=none; b=ijJmc1XBb+rjo3xhwIjesHFVYUoA+UrsUixzpTCySQIA7ABCgDtUlkwzFpmASnCAa9fTzdZnSJg3J3pUcOrFg8QDvm2hlLWLqfYlDoh4i5ocZJXVzpRj87ZReoqgJ79jH+eJ3tu3Rsvx+n5SQG3OOpeXWl8JByliZR0PeRKWneQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794334; c=relaxed/simple;
	bh=MzGzlM3MUVjZo0VsTk8AWr6bUfJO2cG95GF9NP0QDkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6PrZeu9UiH5WPIjw7+ku8RP/eMcp07+yoJFME+1dexicYcaEEr2MwWvg5G3lDMWJXDbJ+N5XICtzR3xi1SZxZwhJfMsnq1AN6pw6+q4cnIwhy+D73o99Qnoz9OJ9urq51W32pawBrE+pw66LS77eb6i5LG8pDfGLo91+8GNa9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clyBr9ac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clyBr9ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6A41F000FF;
	Wed, 30 Sep 2026 18:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794333;
	bh=9BK8DR7d7/5vIRNBa5Sm26AVfKRYVJKnZBX2ZMqeyQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clyBr9acZDnMaQ09VCuj315T82YjSVCAsrTLaZIiUCXPwab9raqksImbQjei70OV/
	 N3l+9pW/x4AYiNXqvMu+d4xQGCVq864Psb1anbRUwW6KrW5NmLDw80BMCIyGdsWROR
	 Utx2lVVElH/u+wYubZQklmKwTQOTlxRFlvs4Sy2I=
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
Subject: [PATCH 6.6 0174/1193] clk: keystone: dont cache clock rate
Date: Wed, 30 Sep 2026 17:14:18 +0200
Message-ID: <20260930152438.060392190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 35fe197dd303c..9dcfcacdd64d5 100644
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



