Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F6E2C028F;
	Thu, 15 Jan 2026 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496437; cv=none; b=XyfAJ5Lv6m85w3UaWivsgbPNaSJPSuCu1oCvJoKjGDe6FVAiAqcPAhHvNymGiwGiUeJepmbfnSh7OAh8qTP2DVBctQToYm5Gr2ArgdYzlFomblw/6QCodRXoKH9L5MFXvkYkPKB0PL7FgjKa+y/khgpymgeWIoi7cL3UYPGKg5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496437; c=relaxed/simple;
	bh=XUblAbUVdLgGLw2KRxDlSYnCWMtQnS26OXdiTeqscwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFA3ZBltYFBtUa1SGneTb+tL6fwYVdFsrGq+toYDviw/EQlGN3nxp3vEhqlrwc6QX63QpfuyhOHGVkQqn3jWg1oTRvJlLlaqGjpM9U4+RMdrwV6zZWJt0fqBT6q7d98Dv8wUtl7hNnEYrj4Uf2obTWnsanWb9QGWnlXjRfLQ6uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AyTQbjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AyTQbjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D069BC116D0;
	Thu, 15 Jan 2026 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496437;
	bh=XUblAbUVdLgGLw2KRxDlSYnCWMtQnS26OXdiTeqscwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AyTQbjV4VJvoHFdpvmD5WGG1qmArpKh4vWAelD2uYO6wd1j+b5ZuslqAt9Lo4wx3
	 J21Of7Qp4R/kAS6dlrhr8WQGPw09LVgaOkSO34OMPvyI7AKQGx1CIotmlzaGNrWLID
	 3Izk17+Zwh7QBEzkELG0UIMI2ZFIZwMPwXbP/Gqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.12 013/119] counter: 104-quad-8: Fix incorrect return value in IRQ handler
Date: Thu, 15 Jan 2026 17:47:08 +0100
Message-ID: <20260115164152.441592903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

commit 9517d76dd160208b7a432301ce7bec8fc1ddc305 upstream.

quad8_irq_handler() should return irqreturn_t enum values, but it
directly returns negative errno codes from regmap operations on error.

Return IRQ_NONE if the interrupt status cannot be read. If clearing the
interrupt fails, return IRQ_HANDLED to prevent the kernel from disabling
the IRQ line due to a spurious interrupt storm. Also, log these regmap
failures with dev_WARN_ONCE.

Fixes: 98ffe0252911 ("counter: 104-quad-8: Migrate to the regmap API")
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20251215020114.1913-1-vulab@iscas.ac.cn
Cc: stable@vger.kernel.org
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/104-quad-8.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -1192,6 +1192,7 @@ static irqreturn_t quad8_irq_handler(int
 {
 	struct counter_device *counter = private;
 	struct quad8 *const priv = counter_priv(counter);
+	struct device *dev = counter->parent;
 	unsigned int status;
 	unsigned long irq_status;
 	unsigned long channel;
@@ -1200,8 +1201,11 @@ static irqreturn_t quad8_irq_handler(int
 	int ret;
 
 	ret = regmap_read(priv->map, QUAD8_INTERRUPT_STATUS, &status);
-	if (ret)
-		return ret;
+	if (ret) {
+		dev_WARN_ONCE(dev, true,
+			"Attempt to read Interrupt Status Register failed: %d\n", ret);
+		return IRQ_NONE;
+	}
 	if (!status)
 		return IRQ_NONE;
 
@@ -1223,8 +1227,9 @@ static irqreturn_t quad8_irq_handler(int
 				break;
 		default:
 			/* should never reach this path */
-			WARN_ONCE(true, "invalid interrupt trigger function %u configured for channel %lu\n",
-				  flg_pins, channel);
+			dev_WARN_ONCE(dev, true,
+				"invalid interrupt trigger function %u configured for channel %lu\n",
+				flg_pins, channel);
 			continue;
 		}
 
@@ -1232,8 +1237,11 @@ static irqreturn_t quad8_irq_handler(int
 	}
 
 	ret = regmap_write(priv->map, QUAD8_CHANNEL_OPERATION, CLEAR_PENDING_INTERRUPTS);
-	if (ret)
-		return ret;
+	if (ret) {
+		dev_WARN_ONCE(dev, true,
+			"Attempt to clear pending interrupts by writing to Channel Operation Register failed: %d\n", ret);
+		return IRQ_HANDLED;
+	}
 
 	return IRQ_HANDLED;
 }


