Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69141184524;
	Sat, 12 Sep 2026 13:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220838; cv=none; b=OjPXnjWTm/B9xfX6MKA6qtKcq61cJPjBA6mUZezVgZwKuztMKicMTdV6IAiGOfSM+cjGROG+bb2aHkOknOOULTyFDWxECJmKCHW8P2uTfTE3ITSeQVBq/ch1ugZt/z1BX6OCDtsVjMrOdWPKlzkwECQjoaV52gkl1eHWE5dOdjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220838; c=relaxed/simple;
	bh=Odr2c1W9acX0LxiUjDcgmSR44sRUM+YTAUEubHyt/lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwTiOoEK7FDS7lQqe0ZI/3bBtgpFhVVQ3RlZSrTuETeK0ZTEAFMyZ0mdn1BHq93RBfGniY3UzXdvuuyWjw4GazO6bQTjyohi5dxC3EEGgISIOJtlv/f2D2vocjS34pDz73klD8inTLcq7UTzx7K7Iljm4hMutQ9OPUqW+0RvtY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHD4JrCi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHD4JrCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D4B1F000FF;
	Sat, 12 Sep 2026 13:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220835;
	bh=+bGtqcqsT3SEAZpHZ03hlwxtBu5HXb/F4Rgo/viNSiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHD4JrCivVFkOrFs5C9M6jIqh0t06qaw1BdqcNEaXMXwzK7IXtoiEmBJecCB5lqEG
	 iryyx9XpwXCUincS5qkk7diXZkDnT2ESU+J2YZnvv/unMtWbgwYW0Hopg634y5LvOj
	 GkeZajh8oKEhf/42GYU617UzshYdKTpFpEO49qCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 0206/1424] power: supply: bq24257: fix use-after-free on remove
Date: Sat, 12 Sep 2026 08:43:58 +0200
Message-ID: <20260912065611.903282518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 9d34c9d660c3d0931d2cc749c46c47cf31f96e48 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq24257_charger.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/power/supply/bq24257_charger.c
+++ b/drivers/power/supply/bq24257_charger.c
@@ -18,6 +18,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/devm-helpers.h>
 
 #include <linux/acpi.h>
 #include <linux/of.h>
@@ -1018,10 +1019,6 @@ static int bq24257_probe(struct i2c_clie
 	if (bq->chip == BQ24250)
 		bq->iilimit_autoset_enable = false;
 
-	if (bq->iilimit_autoset_enable)
-		INIT_DELAYED_WORK(&bq->iilimit_setup_work,
-				  bq24257_iilimit_setup_work);
-
 	/*
 	 * The BQ24250 doesn't have a dedicated Power Good (PG) pin so let's
 	 * not probe for it and instead use a SW-based approach to determine
@@ -1062,6 +1059,14 @@ static int bq24257_probe(struct i2c_clie
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
@@ -1079,9 +1084,6 @@ static void bq24257_remove(struct i2c_cl
 {
 	struct bq24257_device *bq = i2c_get_clientdata(client);
 
-	if (bq->iilimit_autoset_enable)
-		cancel_delayed_work_sync(&bq->iilimit_setup_work);
-
 	bq24257_field_write(bq, F_RESET, 1); /* reset to defaults */
 }
 


