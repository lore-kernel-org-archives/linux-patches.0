Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D461219A7A;
	Mon, 23 Jun 2025 21:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715426; cv=none; b=o9ItRpdAe+BKLloZMtfDxuU/xNTWN62GL/Km9yGvYV/GOL7pGNyuY5QRbxfb8NFdRWaPW5F6AikwZI8kEr3DhMk9YZ5T3/dH9U9e1NjfwZ0QRAv698cT2jKID1Xu4s6FBiAklq2yIj2vXvXVoKceiWTQperqJSwtsGHta/dBJ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715426; c=relaxed/simple;
	bh=j7b0CpFzGgPMk9RTLPUoS3EJHOWRlaqYjMKMvjhgO7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0EfLmNRlWPeCRe2M+ZlYMrVJoDmrD+SalFPDiQd7RBzzTxowRavcIrs70w7t2GETfsLErBljoOKx/EtfU+IqVZoX8pz06PBtnGrB3O4kby8+qZuPB5UEISfzP0chWG1RngbWbEq6vhscF2G3WzjXN/2iwJHs1ageOmEBrZPBac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKdQTctl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKdQTctl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF6DC4CEF2;
	Mon, 23 Jun 2025 21:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715426;
	bh=j7b0CpFzGgPMk9RTLPUoS3EJHOWRlaqYjMKMvjhgO7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKdQTctly3QvUwtU11yoA5hO6/k86+K77NynG6ZF4yae+7ljg6qq0jNoi8L1l2KDS
	 sCZL4A6kdTfWKYVdCIrIbf+ke5JuV5kjeXhvr3ZeU2adSaeJm/GkkWdYHg2L6eYCm+
	 d29GBY+Mpzv9eK5fmSvOAKjeVnb9mpN7RAvUyjxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/355] watchdog: da9052_wdt: respect TWDMIN
Date: Mon, 23 Jun 2025 15:07:55 +0200
Message-ID: <20250623130635.009276473@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 325f510fcd9cda5a44bcb662b74ba4e3dabaca10 ]

We have to wait at least the minimium time for the watchdog window
(TWDMIN) before writings to the wdt register after the
watchdog is activated.
Otherwise the chip will assert TWD_ERROR and power down to reset mode.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250326-da9052-fixes-v3-4-a38a560fef0e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/da9052_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index d708c091bf1b1..180526220d8c4 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -164,6 +164,7 @@ static int da9052_wdt_probe(struct platform_device *pdev)
 	da9052_wdt = &driver_data->wdt;
 
 	da9052_wdt->timeout = DA9052_DEF_TIMEOUT;
+	da9052_wdt->min_hw_heartbeat_ms = DA9052_TWDMIN;
 	da9052_wdt->info = &da9052_wdt_info;
 	da9052_wdt->ops = &da9052_wdt_ops;
 	da9052_wdt->parent = dev;
-- 
2.39.5



