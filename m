Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7E328B7D;
	Mon, 27 Oct 2025 18:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591078; cv=none; b=RnJat5k5Kg0Tq4nfz1RkVTQcdsVey1dWai93m69UrIiy7WixbAiqkXuXazDUOGogXU4kKhBcAKu+mqEjoCcaN4zDdGxxoumIPRZ0CKVggISEqywLXPYLo9TIzIu21V1SNJoiBDp365dPv5+dc/kPRGDHpiZ5iPIrXAK0og6N9VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591078; c=relaxed/simple;
	bh=sUrpIn9fvuezH/q3YRZTbNWd+GqqNQeEalSr/MgUOEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rm0gLfv3OPRXgD72gQ7agcynFkMNBaJzw+1zE9U4fYZ/KGBsXokRQTiOLok7eQWRwBvjFvAvupVLXrKEglwZBkdRkWhGfjjl3j13yQfTUTFzsH6QPGyKQ6RGm6sLLFYH9JMolNZQt7mfFgGRItf9DNJekteB3K34FUGBG2E4loQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0G8CVoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0G8CVoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421E6C4CEF1;
	Mon, 27 Oct 2025 18:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591078;
	bh=sUrpIn9fvuezH/q3YRZTbNWd+GqqNQeEalSr/MgUOEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0G8CVoEiKRfOF1brwHlUXHep+Zbh4MSthWS3QLS1KNWPT5mem8yXeaKs8IoCGXhn
	 d2wkHt9obqzYXNmqLXX3BAprBjN3t7n9vOzPmYiapo2KC1fsYlfUzEyMkR4Txa7m6Z
	 TXFcFO7aDlDnGi0+cTHDecFtRAjvb5D6aZ09/1eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/332] watchdog: mpc8xxx_wdt: Reload the watchdog timer when enabling the watchdog
Date: Mon, 27 Oct 2025 19:31:52 +0100
Message-ID: <20251027183526.179386666@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 7dfd80f70ef00d871df5af7c391133f7ba61ad9b ]

When the watchdog gets enabled with this driver, it leaves enough time
for the core watchdog subsystem to start pinging it. But when the
watchdog is already started by hardware or by the boot loader, little
time remains before it fires and it happens that the core watchdog
subsystem doesn't have time to start pinging it.

Until commit 19ce9490aa84 ("watchdog: mpc8xxx: use the core worker
function") pinging was managed by the driver itself and the watchdog
was immediately pinged by setting the timer expiry to 0.

So restore similar behaviour by pinging it when enabling it so that
if it was already enabled the watchdog timer counter is reloaded.

Fixes: 19ce9490aa84 ("watchdog: mpc8xxx: use the core worker function")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/mpc8xxx_wdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 3fc457bc16db3..18349ec0c1010 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -100,6 +100,8 @@ static int mpc8xxx_wdt_start(struct watchdog_device *w)
 	ddata->swtc = tmp >> 16;
 	set_bit(WDOG_HW_RUNNING, &ddata->wdd.status);
 
+	mpc8xxx_wdt_keepalive(ddata);
+
 	return 0;
 }
 
-- 
2.51.0



