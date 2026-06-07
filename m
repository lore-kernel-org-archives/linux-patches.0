Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE5E30148C;
	Sun,  7 Jun 2026 10:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827472; cv=none; b=bRaSq9ExlKiwlskDlOgcBgYyVnzFkGVtc9FJw+bHJs8TdG/kmenxGSa7K4gmMzO1V9Z2ssRkngO4PQ4udN1iz2tD0yKKBJ9j94wW4hck+Su6yrLLPqXxHWrDI8xmsm4oMqi2itIoVJvhc7iH5TSaOZ39Lx2G/kzWYfb0tyKY8YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827472; c=relaxed/simple;
	bh=YYcWbp1rpT0aFuAMNlJZAgpbpQAUJLJovVlitJh6qAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojJWY7PhXBiupgTtL0lKNshAtlufWt5sks9HvIvREjlaPpXOcac1TE1b/v1973nwxkYPB4pQvbwaU8EOZQGgae2fGTcjlp2AwV61YpC4z2fP7UK6sh+ohCFfEXS9eaI2Wfvlb1zBPoPjyg4D7MO5lN03xUR3W7JMBXJJ8kO6Jcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJ73uNpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJ73uNpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0201F0089B;
	Sun,  7 Jun 2026 10:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827471;
	bh=L0iuhq9C578NeD1E+SMxxTFnWgRsTD5LgB2zMQqsRDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJ73uNpMYj7iUOqJf7UluM1EIgGv78nsIXYkJ//kQE0Gv0UCcBURT69E8JDX5EOXG
	 IkBlrIp61+X4IVr3DN7o2nj+A8PX4E0ZSyDd92WcO/gbMIESJcRP2ZBmn80zQ/lqFj
	 dagaF2YgjGgcyW5qxU5VZk+9yCDME34ohBOOF0mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 096/332] dpll: zl3073x: use __dpll_device_change_ntf() and remove change_work
Date: Sun,  7 Jun 2026 11:57:45 +0200
Message-ID: <20260607095731.675621521@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit d733f519f6443540f8359461a34e3b0042099bbe ]

The change_work was introduced to send device change notifications
from DPLL device callbacks without deadlocking on dpll_lock, since
the callbacks are already invoked under that lock. Now that
__dpll_device_change_ntf() is exported for callers that already
hold dpll_lock, use it directly and remove the change_work
infrastructure entirely.

This eliminates a race condition where change_work could be
re-scheduled after cancel_work_sync() during device teardown,
potentially causing the handler to dereference a freed or NULL
dpll_dev pointer.

Fixes: 9363b4837659 ("dpll: zl3073x: Allow to configure phase offset averaging factor")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20260526074525.1451008-3-ivecera@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/dpll.c | 26 +++++++++-----------------
 drivers/dpll/zl3073x/dpll.h |  2 --
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index c201c974a7f9a4..70c91948c7da8d 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -1193,15 +1193,6 @@ zl3073x_dpll_phase_offset_avg_factor_get(const struct dpll_device *dpll,
 	return 0;
 }
 
-static void
-zl3073x_dpll_change_work(struct work_struct *work)
-{
-	struct zl3073x_dpll *zldpll;
-
-	zldpll = container_of(work, struct zl3073x_dpll, change_work);
-	dpll_device_change_ntf(zldpll->dpll_dev);
-}
-
 static int
 zl3073x_dpll_phase_offset_avg_factor_set(const struct dpll_device *dpll,
 					 void *dpll_priv, u32 factor,
@@ -1227,8 +1218,10 @@ zl3073x_dpll_phase_offset_avg_factor_set(const struct dpll_device *dpll,
 	 * we have to send a notification for other DPLL devices.
 	 */
 	list_for_each_entry(item, &zldpll->dev->dplls, list) {
-		if (item != zldpll)
-			schedule_work(&item->change_work);
+		struct dpll_device *dpll_dev = READ_ONCE(item->dpll_dev);
+
+		if (item != zldpll && dpll_dev)
+			__dpll_device_change_ntf(dpll_dev);
 	}
 
 	return 0;
@@ -1724,13 +1717,13 @@ zl3073x_dpll_device_register(struct zl3073x_dpll *zldpll)
 static void
 zl3073x_dpll_device_unregister(struct zl3073x_dpll *zldpll)
 {
-	WARN(!zldpll->dpll_dev, "DPLL device is not registered\n");
+	struct dpll_device *dpll_dev = READ_ONCE(zldpll->dpll_dev);
 
-	cancel_work_sync(&zldpll->change_work);
+	WARN(!dpll_dev, "DPLL device is not registered\n");
 
-	dpll_device_unregister(zldpll->dpll_dev, &zldpll->ops, zldpll);
-	dpll_device_put(zldpll->dpll_dev, &zldpll->tracker);
-	zldpll->dpll_dev = NULL;
+	WRITE_ONCE(zldpll->dpll_dev, NULL);
+	dpll_device_unregister(dpll_dev, &zldpll->ops, zldpll);
+	dpll_device_put(dpll_dev, &zldpll->tracker);
 }
 
 /**
@@ -1976,7 +1969,6 @@ zl3073x_dpll_alloc(struct zl3073x_dev *zldev, u8 ch)
 	zldpll->dev = zldev;
 	zldpll->id = ch;
 	INIT_LIST_HEAD(&zldpll->pins);
-	INIT_WORK(&zldpll->change_work, zl3073x_dpll_change_work);
 
 	return zldpll;
 }
diff --git a/drivers/dpll/zl3073x/dpll.h b/drivers/dpll/zl3073x/dpll.h
index 278a24f357c9bd..241253212f7d57 100644
--- a/drivers/dpll/zl3073x/dpll.h
+++ b/drivers/dpll/zl3073x/dpll.h
@@ -22,7 +22,6 @@
  * @tracker: tracking object for the acquired reference
  * @lock_status: last saved DPLL lock status
  * @pins: list of pins
- * @change_work: device change notification work
  */
 struct zl3073x_dpll {
 	struct list_head		list;
@@ -37,7 +36,6 @@ struct zl3073x_dpll {
 	dpll_tracker			tracker;
 	enum dpll_lock_status		lock_status;
 	struct list_head		pins;
-	struct work_struct		change_work;
 };
 
 struct zl3073x_dpll *zl3073x_dpll_alloc(struct zl3073x_dev *zldev, u8 ch);
-- 
2.53.0



