Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6587B1EBFF2;
	Tue, 15 Oct 2024 12:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994396; cv=none; b=E1tgSMakgxZOoFEnvY/jV31zgMMOygZT32prXbT9gIAirZuNBUK68pb4UPP0BEYcBM2SXJZsQOLpSLq7+TcY6bPFJA4+UKatN2NGKnE4b4b/bM7xdQLV+Gsf4BhE0P69k4tXDHK90/kSKRTmcDkHy8udAtosV/Y2aMZO+5ATHKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994396; c=relaxed/simple;
	bh=x959NdzhK7Ip50wcrzC3S1AAmzYvy4+VU71iXkAPYVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNsRA5+p7lyee4a62GKeW7lfGGG89RL4wiJnX5WN8Q3hlbIt91z6zEqZkrbDxt44D4B3DxdnSw33oP88gbslG4zMbaXGnlcKSxrJ6NaVI5ca9KM6eZUtbW38pCxK0+3e8x9I8rhI8o6ory5rkTIuY+g9y3qVN8gDWz1WLq5txcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMGme+tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMGme+tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB335C4CEC6;
	Tue, 15 Oct 2024 12:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994396;
	bh=x959NdzhK7Ip50wcrzC3S1AAmzYvy4+VU71iXkAPYVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMGme+tjHLsYgb8HjjCXJxXgH/jn5izCXJzklH1JowT5+jBv7bYRppU9i/gr3I4K4
	 Bt+p5ygkTjF3HDnW3oPnnxTviGIc7gBfi7kPE68T08fuMBm0t/Ge3wfZ/UlXjNsFu+
	 WFUv4yH61Kmgbwd86ddGMn0irc54tdNo0d5c5ahw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0591ccf54ee05344e4eb@syzkaller.appspotmail.com,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 681/691] i2c: smbus: Check for parent device before dereference
Date: Tue, 15 Oct 2024 13:30:29 +0200
Message-ID: <20241015112507.350639168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 8302532f47bb6c3aa1ed2043d30187ca307f176a upstream.

An I²C adapter might be instantiated without parent. In such case
there is no property can be retrieved. Skip SMBus alert setup when
this happens.

Fixes: a263a84088f6 ("i2c: smbus: Use device_*() functions instead of of_*()")
Reported-by: syzbot+0591ccf54ee05344e4eb@syzkaller.appspotmail.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-smbus.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/i2c/i2c-core-smbus.c
+++ b/drivers/i2c/i2c-core-smbus.c
@@ -705,10 +705,14 @@ EXPORT_SYMBOL_GPL(i2c_new_smbus_alert_de
 #if IS_ENABLED(CONFIG_I2C_SMBUS)
 int i2c_setup_smbus_alert(struct i2c_adapter *adapter)
 {
+	struct device *parent = adapter->dev.parent;
 	int irq;
 
-	irq = device_property_match_string(adapter->dev.parent, "interrupt-names",
-					   "smbus_alert");
+	/* Adapter instantiated without parent, skip the SMBus alert setup */
+	if (!parent)
+		return 0;
+
+	irq = device_property_match_string(parent, "interrupt-names", "smbus_alert");
 	if (irq == -EINVAL || irq == -ENODATA)
 		return 0;
 	else if (irq < 0)


