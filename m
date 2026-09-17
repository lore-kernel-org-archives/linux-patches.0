Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0187B3DE447;
	Thu, 17 Sep 2026 18:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670565; cv=none; b=l17AuODap7uTQrmNERMV1rS9mILxTK5iBSrNo6KjG9+nD8kucQASyV9OnBEi+Zw4a7tkFwt58wT+1Qs9YEejtzygRBGmUrjdN6zh3bb4h31Z9y/fcXB3J5velVRwFMQuQpjIv6v1SLTf0gp2IJIC+yHkVXqhNqKrqNw6kZmwf4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670565; c=relaxed/simple;
	bh=whZX9VwBcUDmtKmq+P2dFVHhezeHIs6ONQrc+5CLKug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFR1rXCQF/deAhdvX18K+hz7tap3mp1y70+i+16KdhMxTmah12xG/Iqbk++EmXNQxoMXW2coYeRlun5S8BsDoA7ofJN131/NNcWk3hT1x8hIjs19T0M/xrn0rnthGLwWISG3EeZ8o7sFB7Pj8F6LQuPdapAk0Fh6Dv9ua4KVfgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnQJOc0g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnQJOc0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5EA1F00898;
	Thu, 17 Sep 2026 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670563;
	bh=OOAaMu+G3zKgotAOT/Ri9bWOjPcQEiircnmh3UqRlLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnQJOc0gl/59Y/Nd8MIwgB4fRPq8O+oErNMU7+8zQcLbGCQvJFYI9PR7wdNs8gWCG
	 MgYo1529pYKG7Ly53N8caDc+Vkl7wxe3POVc99XpWb7j/k5eU75i52PQRJzJmZs/FW
	 79FOCHHdoL9cx9O8JIqrLIXG190KCt1hZvmQsAfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0702/1102] hwmon: (ltc4282) Make sure clk_init_data is fully initialized
Date: Thu, 17 Sep 2026 16:10:45 +0100
Message-ID: <20260917151557.931481928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 5f7ab813051c8..965a138f5f49a 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -1138,7 +1138,7 @@ static const struct clk_ops ltc4282_ops = {
 static int ltc428_clk_provider_setup(struct ltc4282_state *st,
 				     struct device *dev)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_COMMON_CLK))
-- 
2.53.0



