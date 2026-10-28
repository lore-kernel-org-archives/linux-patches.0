Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208295;
	b=O/mUhBU5LOzdNf7qX/vSRvEb7YMRIcwO+OjcXBg4HClhL3wt9GmndIU4QBQE/N6tBupo
	 hOL5612uWEM+zj2u9FPdRfuRePq0Lt2xXCESMvsM05xhbIh+yZ6EL+4jfXjIPF5HiOu0W
	 SJmfTdySGZ/h5/apWcGwKkX2iP28mDVOR5lJd0XLNfdDVnVnH0CRzUwlGGEsl7jxr51hD
	 GxU/F/3CzF93o6dbdsVnXVBiGfOzXm5ZsYphKndpI533hrjxpAJB1eXZ5VEB5O5YqLXE5
	 VWnlcQwL0/FfaRF6rKYJlGm6O3H/mq6dbyD4F+4mVJnjlgKhxYXPli1xCVEGgyRgJFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hUem9dreCLUBOZE3Lx38RNxjy3GQgC9X9wnwLC5YrvA=;
	b=CNm3TkfUw0uEBb9IlpTL+uf5Qihb2TBI9U3W83Vf60D5R3x5ld7xi7/yVajlXWIFYlLo
	 tyJDt8AYrOBvNlzP+MTAp9dsJSsJpIpfPGWWxK1K1yMtuduNiprS/OJF/UbSNNXFefl6t
	 ydA/dKSZDMNTWVSgEa7WSNXrW5wDbmJ/E2ZBAwm+/N4OE2EzCswVVhZk7gMZiLwFF8xA1
	 5K7+xt+5e7puRYjUdyFhiIGYvQ75nqofdWErqZLGiy55EfEjGivpDPcvrh2a3QKYjdqcP
	 tP/owbof+6pcdEheGA78WCS41iEM4psibsFOT8i4SHUa6oKd+Zx6OFfst0Gl42Ez5Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zGn9XS7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D2C606A329;
	Wed, 28 Oct 2026 17:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zGn9XS7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6DC1F01825;
	Wed, 28 Oct 2026 17:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208294;
	bh=hUem9dreCLUBOZE3Lx38RNxjy3GQgC9X9wnwLC5YrvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zGn9XS7nMtZEVjRfB3q6pSkX5TVGbqXGb1Wfb39dn4j8Xvdg6fjadCXH4f97DEq9
	 zNprKsHQXJKGz6XXXmm0N1+5+JNoBof8bPiyrCCv0yvz7Pjf5gXyqHfWo0cOnF87Kz
	 rYbcyI9w3DlRWomeZAljchuuSXj2ryBNCK2lSTHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/516] power: supply: bq24257: fix use-after-free on remove
Date: Wed, 28 Oct 2026 17:53:41 +0100
Message-ID: <20261028170005.159274135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 9d34c9d660c3d0931d2cc749c46c47cf31f96e48 ]

The STAT-pin interrupt is devm-managed, so it stays armed until the devm
cleanup that runs after remove() returns. remove() cancels
bq->iilimit_setup_work while the threaded handler can still fire; that
handler reschedules the work and dereferences bq, so the work runs
against freed memory once devm frees bq.

Make the delayed work device-managed with devm_delayed_work_autocancel(),
registered before the interrupt request. The devm cleanup then releases
the interrupt first, so the handler can no longer reschedule the work,
and cancels the work before bq is freed. The explicit
cancel_delayed_work_sync() in remove() is no longer needed and is dropped.

Found by static analysis.

Fixes: 2219a935963e ("power_supply: Add TI BQ24257 charger driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260731143554.334179-1-fanwu01@zju.edu.cn
Link: https://patch.msgid.link/20260801051958.354528-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24257_charger.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/power/supply/bq24257_charger.c b/drivers/power/supply/bq24257_charger.c
index 96cb3290bcaa1..5c331bba3b35b 100644
--- a/drivers/power/supply/bq24257_charger.c
+++ b/drivers/power/supply/bq24257_charger.c
@@ -18,6 +18,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/devm-helpers.h>
 
 #include <linux/acpi.h>
 #include <linux/of.h>
@@ -1020,10 +1021,6 @@ static int bq24257_probe(struct i2c_client *client,
 	if (bq->chip == BQ24250)
 		bq->iilimit_autoset_enable = false;
 
-	if (bq->iilimit_autoset_enable)
-		INIT_DELAYED_WORK(&bq->iilimit_setup_work,
-				  bq24257_iilimit_setup_work);
-
 	/*
 	 * The BQ24250 doesn't have a dedicated Power Good (PG) pin so let's
 	 * not probe for it and instead use a SW-based approach to determine
@@ -1064,6 +1061,14 @@ static int bq24257_probe(struct i2c_client *client,
 		return ret;
 	}
 
+	if (bq->iilimit_autoset_enable) {
+		ret = devm_delayed_work_autocancel(dev,
+						   &bq->iilimit_setup_work,
+						   bq24257_iilimit_setup_work);
+		if (ret)
+			return ret;
+	}
+
 	ret = devm_request_threaded_irq(dev, client->irq, NULL,
 					bq24257_irq_handler_thread,
 					IRQF_TRIGGER_FALLING |
@@ -1081,9 +1086,6 @@ static int bq24257_remove(struct i2c_client *client)
 {
 	struct bq24257_device *bq = i2c_get_clientdata(client);
 
-	if (bq->iilimit_autoset_enable)
-		cancel_delayed_work_sync(&bq->iilimit_setup_work);
-
 	bq24257_field_write(bq, F_RESET, 1); /* reset to defaults */
 
 	return 0;
-- 
2.53.0



