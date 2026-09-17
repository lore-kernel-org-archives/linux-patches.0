Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09B35AEC4D;
	Thu, 17 Sep 2026 15:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659649; cv=none; b=gRBFtWIy9FaKaLeT59GxPwxZvGNJDsUd+rSfZuT2Z7He4LRcNBf7RWKOC416oO58CnLfGHENJCtwim0rJf46KTT3jCeKtere73BEQhzVeXlN8gOiYyw97XWbLLDZnf4ziXZu7CePAjTR/lAAyXgm6y11q5F9gDE7an8QB2kiAZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659649; c=relaxed/simple;
	bh=9PIzr6p2stk+j1sFQroJ2aIyDTDKbFqOOuUBeinjD7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVz1nzCIh9qLkvifwDqnKktkduOl+IyB2cPoYytniKj1SY5KMukFtnMnISSlwpUwChS36UpMHDTwlfq6aqJXv8sHmEXuVHfENIHoDdM81BzAqGSRrM7vobVUILBkv9aUbMhUfcxu+GWfhqoxnNd5t/Ox45ssdv4A/B/lDOc4tIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgNm/Hz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgNm/Hz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DBE1F00898;
	Thu, 17 Sep 2026 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659637;
	bh=o/zxLTqnOpnHEfiGDmYROEgPAaRPjouX/MmCCp8TrIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgNm/Hz01uddXHtZYBvQovK3jCwzBGeWwFXZzDwNtPIM8Xj0tNT17qo+89DKJoHmg
	 15W6zIZ0yfMs+CTh2qhBFCKxT3ztuRkWkZcFNK58DWL1LzNILoP9jP7py0V/Tga8tR
	 Dvpaq0CMdOgWvkYYgbByWzlK/TDKnG/e4P35VULU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 322/733] hwmon: (ltc4282) Make sure clk_init_data is fully initialized
Date: Thu, 17 Sep 2026 16:10:30 +0100
Message-ID: <20260917151359.521417775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b1675dc5b3c7f..54ba4b8542e94 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -1106,7 +1106,7 @@ static const struct clk_ops ltc4282_ops = {
 static int ltc428_clk_provider_setup(struct ltc4282_state *st,
 				     struct device *dev)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	if (!IS_ENABLED(CONFIG_COMMON_CLK))
-- 
2.53.0



