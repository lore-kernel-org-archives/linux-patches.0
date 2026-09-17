Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8550E59C;
	Thu, 17 Sep 2026 17:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665833; cv=none; b=Yf8P8ymHhdYgN1cpGDzCqLUErLXLYDz/+rlNdPqCMWEntq1SFKBkDbBgNYdgpB/HfqP0tETu3wwH0qkrCm2gES1ey0s40anQxL2njN4cY41EydK4AgvpCluy2o/eEPkm1BlF3bxgIUf4+AXUY93RoKVoz7Tlfvfl4BIHMO6Bc44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665833; c=relaxed/simple;
	bh=D9Rqxvx9GTR1ZVegDwEypYAxuzBmcYwv6MpRPR9VS+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZryuTbMqEn8sv2dhk/FHr+W73yMQqR7PCbk9YfEjFy1aV/4KOFk1YKAH/NcCO9Z6Waja2E0OTWKo434mlCCVRLzdnhA8SYuQJsgUf/vRorSRqUnIan/cNBpoGUrxS1W0rb3appjJz757gAM1xS5ve+7h/fTzwffCHxiDh4ieME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofLXmHLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofLXmHLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777371F000FF;
	Thu, 17 Sep 2026 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665832;
	bh=Sd/fwfw8LvSS01budw7/XBgB7jL/AL7R8yN6ya4wiSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofLXmHLfWkFz2otm2ULUquzrRGctY8GocmrWLQU+nQLpNG4kF8ePUNvptEY5N5vM9
	 3GyAhOXAWjvhZBlWMZJ3w8O5aACcHvwFDzLM/kkmmXhR47z6bP+uWAtThm4VefD1Ye
	 Cs+QaZ+e4fnkXfe6BpvXI9rgwKbU0sETQJlsvqPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0835/1250] hwmon: (ltc4282) Make sure clk_init_data is fully initialized
Date: Thu, 17 Sep 2026 16:10:30 +0100
Message-ID: <20260917151614.580524321@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit e317326d1755ea054b98e7a4833b929157461c35 ]

The clk_init_data structure contains several mutually-exclusive members
for different methods to specify the possible parents of a clock,
prompting drivers to initialize only the members they need.  However,
not initializing all members may cause subtle issues, which are only
exposed when CONFIG_INIT_STACK_ALL_PATTERN or CONFIG_INIT_STACK_NONE is
enabled.

ltc428_clk_provider_setup() does not fill in any parent clocks, and
assumes that init.num_parents is NULL.  However, the latter in
uninitialized, and thus may cause a crash.

Make sure all members are fully initialized, to fix such bugs, and to
avoid future breakage when converting drivers to a different method for
specifying the parents.

Fixes: cbc29538dbf7d740 ("hwmon: Add driver for LTC4282")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/8ec3c5cbd2df675a938f090470f5da5f22008517.1787165329.git.geert+renesas@glider.be
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4282.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ltc4282.c b/drivers/hwmon/ltc4282.c
index 269f96738f5b3..a82374ba7fc58 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -1140,7 +1140,7 @@ static const struct clk_ops ltc4282_ops = {
 static int ltc428_clk_provider_setup(struct ltc4282_state *st,
 				     struct device *dev)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_COMMON_CLK))
-- 
2.53.0



