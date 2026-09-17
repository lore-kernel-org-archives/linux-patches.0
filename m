Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116334E021B;
	Thu, 17 Sep 2026 16:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661328; cv=none; b=c0GXLJv3drgW0VTV8hAHPWJQWHDypg8tC0RnMFPJmvV3Ac15rHAkokF7OqnMQcIFDunFHl73RXOx73l7sLKptcgpXwhH0d2uG1eWgu4+H4GUQzx3FGBKyviEZn7J4YfsuJ4HONb2HwVgI9/0LvfDObdI+jMeHtiJUlGzY3esODE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661328; c=relaxed/simple;
	bh=0/LFw4NbhfqpBHAXVieXP5D/GwWQpiDXTYtapJ8CiUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpK8R3+/6dI7YmNxIvrPdD8GE1jvImIW0/apq3tWpn8/jBg10n5tmiKqpOCajS7KdXNTQmyweXoF46N4BN8X0Vl7cbXWTnWI80Jv2ZTdF5L73xS7LxZWrrhfJl15O4nwz1QuN1yqqYNrIr6uCqQI8N/ryh0CMiwSDJ+CtRDqsVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xq3kuRkw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xq3kuRkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EE51F000FF;
	Thu, 17 Sep 2026 16:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661326;
	bh=v5x81EzsxuyhvBT3IxQDAL5QMJ2hswsUuFBMIvcx9LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xq3kuRkwfcKUZoRLLJE38JF+cl+VF5ruWh1tq2akYhgVh+8Wde0nqEoPvCzqv7s/K
	 XIFmH1ODZh9APfiaMywKTUjwEEW0KpjUZh3bMTfQU773jcXllMYPhEtQSkZ2d1UUd0
	 H8M9nWyAsP7BUcHbSTUbQ9OWPS4XJTcPJBHTUAfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rene Sapiens <rene.sapiens@linux.intel.com>,
	Pooja Katiyar <pooja.katiyar@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0157/1250] thunderbolt: Dont access path config space on Lane 1 adapters in tb_switch_reset_host()
Date: Thu, 17 Sep 2026 15:59:12 +0100
Message-ID: <20260917151556.334915934@linuxfoundation.org>
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

From: Pooja Katiyar <pooja.katiyar@intel.com>

[ Upstream commit 95c4379e37a0abea72dfd389cfe2c54452523690 ]

USB4 Lane 1 adapters do not have accessible path config space. Skip the
path config space cleanup in tb_switch_reset_host() for these ports. The
check is for USB4 switches only. Thunderbolt 1-3 Lane 1 adapters stay as
is because we do need to program their path config space.

Co-developed-by: Rene Sapiens <rene.sapiens@linux.intel.com>
Signed-off-by: Rene Sapiens <rene.sapiens@linux.intel.com>
Signed-off-by: Pooja Katiyar <pooja.katiyar@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/switch.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 0e07904aa73b4..a99d2db220802 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1601,6 +1601,12 @@ static int tb_switch_reset_host(struct tb_switch *sw)
 				ret = tb_port_reset(port);
 				if (ret)
 					return ret;
+				/*
+				 * USB4 Lane 1 adapters do not have accessible
+				 * path config space.
+				 */
+				if (tb_switch_is_usb4(sw) && !port->usb4)
+					continue;
 			} else if (tb_port_is_usb3_down(port) ||
 				   tb_port_is_usb3_up(port)) {
 				tb_usb3_port_enable(port, false);
-- 
2.53.0



