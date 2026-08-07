Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2723346D090;
	Fri,  7 Aug 2026 15:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115606; cv=none; b=lWCeUoL1yixvL4HkK2eVVWPKJgmAAZUyWKY32Sbu47tgcoJ7GrfUF/f9BSUuLJEQUbTtyxXqz7mqNPa+cN43Abz8EG8ONgXq0tEh059n63ntd3njksR6AV27G/BWW/YcYF0Mxg9ktl81trJ4tzi+RkWdu1qpxMTrYeWxRdxrs50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115606; c=relaxed/simple;
	bh=OHehQUegIjbMRtVMXcMkVbbIauEFN6F35Sx2F1Cpfqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqTE2/zSRnuFqSdvCDumnHvuMe+ipL4DKMY9iw/GUTM570UsylUE9ojy86FCC+9klX6xC4AUP8Z4NnSubi2cyHPlWfzBQ026altGccnuxoiE483sWmXFCIfZFiPFRupF99ZU8HahMadMZo8HGN49qHmN2ohCSQsPodjJwlRA2ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qo6e0Bd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qo6e0Bd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BD11F00A3D;
	Fri,  7 Aug 2026 15:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115605;
	bh=rWhdmTx2ukOD2dEvaOjh989Di72EbXsTnTAgjoJTpDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qo6e0Bd+iKdnLPKQJya0OohLwTjxptE1s3/B0idjEczxhd8FYkVplXPQmdyXfWIc5
	 w1b7jXCVbkKMfOyIvJ9NuzpxP4eKkPdqtNUKqdSbqfvU9knMt39rSqhF4yELv4QdlM
	 EPBSRK+oQzlxjWA00g2WcMEARXWftyVDY3snSu/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 290/396] i2c: jz4780: Cache host clock rate at probe to prevent CCF prepare_lock deadlock
Date: Fri,  7 Aug 2026 16:37:30 +0200
Message-ID: <20260807143430.526632858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -796,6 +797,8 @@ static int jz4780_i2c_probe(struct platf
 	if (IS_ERR(i2c->clk))
 		return PTR_ERR(i2c->clk);
 
+	i2c->clk_rate_khz = clk_get_rate(i2c->clk) / 1000;
+
 	ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency",
 				   &clk_freq);
 	if (ret) {


