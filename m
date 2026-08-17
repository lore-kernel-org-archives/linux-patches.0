Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DE1442FCB;
	Mon, 17 Aug 2026 14:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977484; cv=none; b=bMwIBapb2liiaFI3BW9+3qe57W7M/XyXFGPRIWGQVybjPAaeBasootwPkSG8UTmiToQCT3C14gDNyuyAJ40diTlWHWtioAWBLp4sRPsK5g8AvJHb0PTIHbMY+Ns2c0mkCpXGTQkKcW/F6D4Z53Hmr4cYE+wBllyXuLqCpGWc/7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977484; c=relaxed/simple;
	bh=Mm7MCAXRUmyByBJaTUEklYjZFsdAyI8f0dyVruo2fdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KudQ6WHnJfe8tjN9TM0O1Jd3hoQ+V6LAtbFv3+IEfpg/y0ADthIHq+i1CQ0TDDf4uK/+vk2fLdv7X8qc5xFExmq/P1Se+hBrCv+mlDOMCySDUH2g9gMGqHU+hTQXqs8uCJPG/ragc/CfKMIAZsznX44k1Yf1kav5tknI/LNbzWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfLE0tfI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfLE0tfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9791F000E9;
	Mon, 17 Aug 2026 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977483;
	bh=QMT4q8cAMktUtKbUxdCqILPOeV81fGid/i0r4BttjTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfLE0tfIMwYhrJXQBzssQgQvuc9oBCvMrwyl+JRgyrsgsBJgMSDbBb69mL7hsuA9p
	 +rDaQmPRz90TUeSFBhFhh0Njbe+tpWDiHKvF1DDr+neOUUy488/7ZuOtVn9wdBFmnV
	 7U0qLCgaG9r0ONb35Kx53uW0pgbNtchNYpnR/Oyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 344/456] i2c: jz4780: Cache host clock rate at probe to prevent CCF prepare_lock deadlock
Date: Mon, 17 Aug 2026 15:32:14 +0200
Message-ID: <20260817132553.030800524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H. Nikolaus Schaller <hns@goldelico.com>

commit d99607c888f26e8a4e9fe9772860cef4aff86bb4 upstream.

Fix a severe AB/BA deadlock between the Common Clock Framework (CCF)
and the I2C adapter lock, which triggers when an I2C-controlled clock
generator client (like the Si5351) is registered or modified under the CCF.

During an i2c client clock (generator) frequency change, the CCF acquires its global
'prepare_lock' mutex and the driver calls i2c_transfer() to update the client's
chip registers, stalling for the adapter's I2C bus lock.

Concurrently, an independent, parallel transfer on the same bus (e.g., a GPIO
expander handling LEDs) can hold the I2C adapter lock. Inside this parallel
transfer path, jz4780_i2c_set_speed() calls clk_get_rate() on the host
controller's input clock to calculate bus timings. This call attempts to acquire
the blocked CCF 'prepare_lock', creating a circular dependency that freezes
the system.

The jz4780 host controller clock itself is static and never changes at runtime.

However, calling clk_get_rate() inside the active transfer path introduces
an unnecessary dependency on the CCF internal locks.

Eliminate this synchronous clk_get_rate() call from the active transfer
path by caching the static host peripheral clock rate once - inside the private
jz4780_i2c structure during jz4780_i2c_probe(). Update jz4780_i2c_set_speed()
to use this cached value, safely decoupling active I2C transactions from the
CCF internal locks without any risk of stale timings.

Assisted-by web based Google AI (pinpointing the bug and writing the message).

Fixes: ba92222ed63a12 ("i2c: jz4780: Add i2c bus controller driver for Ingenic JZ4780")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # v4.1+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/2db6fd233aceb7238474e4833f4d25ca681c3ffb.1784492382.git.hns@goldelico.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-jz4780.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-jz4780.c
+++ b/drivers/i2c/busses/i2c-jz4780.c
@@ -141,6 +141,7 @@ struct jz4780_i2c {
 	void __iomem		*iomem;
 	int			 irq;
 	struct clk		*clk;
+	unsigned long		 clk_rate_khz;
 	struct i2c_adapter	 adap;
 	const struct ingenic_i2c_config *cdata;
 
@@ -246,7 +247,7 @@ static int jz4780_i2c_set_target(struct
 
 static int jz4780_i2c_set_speed(struct jz4780_i2c *i2c)
 {
-	int dev_clk_khz = clk_get_rate(i2c->clk) / 1000;
+	int dev_clk_khz = i2c->clk_rate_khz;
 	int cnt_high = 0;	/* HIGH period count of the SCL clock */
 	int cnt_low = 0;	/* LOW period count of the SCL clock */
 	int cnt_period = 0;	/* period count of the SCL clock */
@@ -800,6 +801,8 @@ static int jz4780_i2c_probe(struct platf
 	if (ret)
 		return ret;
 
+	i2c->clk_rate_khz = clk_get_rate(i2c->clk) / 1000;
+
 	ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency",
 				   &clk_freq);
 	if (ret) {


