Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43973514752;
	Wed, 30 Sep 2026 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782598; cv=none; b=bsRB1ERtgtdOQPCNBWZ0PttS7s+jEfGKvkmhfPQeHWMUlt4kzkIGfTX/hWoPWMblvMrhMuZHuC5CMxVGzfeFj3R8S4CXJ2IyxWocSnqG/zDOzJFtO0CedLDy7gb7Gi6GG7e9w18HJhcqjKkO8jg/12OYriw5aJyF5Dyq9uza5Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782598; c=relaxed/simple;
	bh=Bku4T8zmSqsEC0F01BKWxj/7QsNTWdSOsZTNMmh9baU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQHs1aR0eSH+TWLl0rtVPGmvuS5w3djco5kP5Tn9jrczFSXhOhNJjC3akFlTGEhJEkQ8/37UX5CeN3jRiBCgRmccPJ4kJUmTVCuh8IuvqihTR2W16dLPTlQByUD6QOf6jcYBAj22rry99rXQzFroNwNe0jvT5cRkbW7xItbG7ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubUtl7W8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubUtl7W8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810131F00899;
	Wed, 30 Sep 2026 15:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782587;
	bh=pt7GNthEl4ko9Nsp71pKsSy21CNlGg9Ibl/d+91vbvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubUtl7W8IlHtvJpI9kNYE99UIiGNNTJ2tPnt46MsEvH6nvjuTtvPnm1QVuUNzql6x
	 piZkgqCB75CQmLIjqWon+L0fQD3Ogwmtr+o+hA49jru7ZM5GRmxPb/DfCOPfvcalRn
	 O9zYcoB/pkWDvLigXR0VtpBAsFCdNvYt3MPPTSX8=
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
Subject: [PATCH 5.10 098/595] clk: keystone: dont cache clock rate
Date: Wed, 30 Sep 2026 17:19:51 +0200
Message-ID: <20260930152349.845630542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8af2a9faa805a..422482f60bbb8 100644
--- a/drivers/clk/keystone/sci-clk.c
+++ b/drivers/clk/keystone/sci-clk.c
@@ -342,6 +342,14 @@ static int _sci_clk_build(struct sci_clk_provider *provider,
 
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



