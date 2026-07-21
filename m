Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16C2471246;
	Tue, 21 Jul 2026 19:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661045; cv=none; b=kdjb1WKl0yGjIa3eir2t1XK4kATHtX2bED4qHLDeo/kNLne9p2sCI3w7k1EYpBgSnJR7RSIGJ7x80fxs6GGkEnDAxbTAUjly9Ien/FJz138Fas16j78eSlKD3tcRyzoq8ulzT+EfkXYzzhpTItO9ok5nRM9Bgm4kPc4DhpITiio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661045; c=relaxed/simple;
	bh=D/SM3p9z7iJyJ99eR8ONtHMtxgDBLJzSxhTWTOGIPKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmhGh2mHn7Q+UOUlxNPXQ/tv1+Je0+r1y7+bCu0+JN9NcHP1joL1WFGjZ2ZSwQYTnz9Xo4mUNEE4uOj/E71T3084A5AWxlS4tbUFXg6+p7E+yghrihhgOam18qQOwa6ySjASR+xkBqr0FHWnkbA6uwk20Wyv7+1C18JZEpna95I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2QRxcfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2QRxcfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9E01F000E9;
	Tue, 21 Jul 2026 19:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661044;
	bh=3CRPh/Ll/+NNQBYu1/hnZapA/LNIH1t0bWSixNf75W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2QRxcfFLo+E8wsU23POVVab7/mJTTC6p8+waPx3gT7sIXzTreTXLc86P3BXXvinH
	 pe71k9n1hq345u4kKIPN6zTfUE92Z8sRA0HpfXkG/L3Q08BU2aIPlMjB/7uqAdDISU
	 bGvwWhze+S4faq3wWbBKu+hTcN/vFUptsD/JFKto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1211/2077] rtc: isl1208: Balance enable_irq_wake() with disable_irq_wake() on cleanup
Date: Tue, 21 Jul 2026 17:14:44 +0200
Message-ID: <20260721152621.378336718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Madieu <john.madieu.xa@bp.renesas.com>

[ Upstream commit 1afe4f19d6ad404621150f0e91feeccf12fb1037 ]

isl1208_setup_irq() calls enable_irq_wake() after a successful
IRQ request, but the driver has no remove path that balances it.
The driver is devm-only, so on unbind devm releases the IRQ -
but enable_irq_wake() is not undone by IRQ release, so the wake
count for that IRQ stays incremented.

Each rebind therefore leaks one wake reference; the leak doubles
for the chip variant that has a separate evdet IRQ, since
isl1208_setup_irq() is then called twice during probe.

Register a devm action that calls disable_irq_wake() per IRQ.
While at it, check enable_irq_wake()'s return value:
on failure, propagate the error rather than silently registering
a disable action for an IRQ whose wake state was never enabled.

Fixes: 9ece7cd833a3 ("rtc: isl1208: Add "evdet" interrupt source for isl1219")
Signed-off-by: John Madieu <john.madieu.xa@bp.renesas.com>
Link: https://patch.msgid.link/20260425154959.2796261-3-john.madieu.xa@bp.renesas.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-isl1208.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index f71a6bb77b2a14..a0df53991fbdbb 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -822,6 +822,11 @@ static const struct nvmem_config isl1208_nvmem_config = {
 	.reg_write = isl1208_nvmem_write,
 };
 
+static void isl1208_disable_irq_wake_action(void *data)
+{
+	disable_irq_wake((unsigned long)data);
+}
+
 static int isl1208_setup_irq(struct i2c_client *client, int irq)
 {
 	int rc = devm_request_threaded_irq(&client->dev, irq, NULL,
@@ -831,7 +836,15 @@ static int isl1208_setup_irq(struct i2c_client *client, int irq)
 					client);
 	if (!rc) {
 		device_init_wakeup(&client->dev, true);
-		enable_irq_wake(irq);
+		rc = enable_irq_wake(irq);
+		if (rc)
+			return rc;
+
+		rc = devm_add_action_or_reset(&client->dev,
+					      isl1208_disable_irq_wake_action,
+					      (void *)(unsigned long)irq);
+		if (rc)
+			return rc;
 	} else {
 		dev_err(&client->dev,
 			"Unable to request irq %d, no alarm support\n",
-- 
2.53.0



