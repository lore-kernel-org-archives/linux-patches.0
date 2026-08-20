Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583DC25C6EE;
	Thu, 20 Aug 2026 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244621; cv=none; b=AtgqaL4EcBpdUkEQuc/AAaRvCRFOt4eiUuptBrxOIUzxk4X1OJOEYt0I3n+0PIZy7X5MOyIqW7+ODJ80vgrdR3HiOow5QPSgoyuw67qOv4frWdsN/4/4jLJbL90+E3QnTO7KLYnzkvBRKui9HSVLgXd7Vb8TixGyDjSgTcwYNsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244621; c=relaxed/simple;
	bh=EG9WVmg4KQrkkA0tbMQ0kMqsx3d/3P3ZUgfcY8i5LpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OeeCCR6yL37FSZGH/Wk+pZh3TUpGGcDqMr53LhFqv+kMNratdkrFdzNWAY9D2XuMG7y6+/CBFbmaPBVDednb23k2S04w8Gauxh0o/d8+Ru25y2+3X6uOdPr3Q3zysofRXOzgoMvge4QBb5cL7UOv5wGBEhXYKyRJkb2cK/BNU8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHqHnWVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHqHnWVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716BC1F000E9;
	Thu, 20 Aug 2026 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244620;
	bh=MEyzsST+uOK7t0H/92spm1YOhDpc1irsUxqSoSxg0Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHqHnWVCckvuOZbRAuyXrISsNzwEUep+G2D57bklcPhDvNHgk2PiTmkO1R53IBzgV
	 Wc4Ktd0WYpDXEiF2is5ZilAjlH7lyKGiNucv7JFhRd1CGOYoe1MtUvup+IhpVUAfJd
	 VaJIhrVLw0+tFIgsf0cQknKVVkkVxKtJ37Z5tn60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0591ccf54ee05344e4eb@syzkaller.appspotmail.com,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 233/235] i2c: smbus: Check for parent device before dereference
Date: Thu, 20 Aug 2026 16:57:49 +0200
Message-ID: <20260820145223.676951093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -703,10 +703,14 @@ EXPORT_SYMBOL_GPL(i2c_new_smbus_alert_de
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


