Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B691F7545;
	Tue, 17 Dec 2024 17:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456684; cv=none; b=ooZt9p9euVJ386zpO5YGctOk6eM/8kx/qQQE87Qf9rSQdO2Br/dGyDoZThreremEtSZoq1m8TUe7V1+jQSxNdKCH67DZY7Q5jYmmF0nXM0DZEh31jnTdmo5Radhxb+qVglcIxR2mOAZb8TX2vheLKo2QF9ueGWtjZLmrGGxn9Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456684; c=relaxed/simple;
	bh=m6BLWQXsb8YL9/P83ZXG4R3aAvT9OE46IuFX2UKrhnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCyElgQuyipgsiy0vJ/5pwQnl6fYqbopeoNNhgx3PcHtPaJwuSA5z7Ifte+ri7atIryVHXwwLmncChBXTbMZWKh0L3h+YvIc4swQ8HJ0tBJgxyvP6oqTBIz2UnpqYJTN7+2f2j3AxdbQRk8N+jrJuSlYJ0TqduE1T/HQiqUDL2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAoK3u5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAoK3u5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889ABC4CED3;
	Tue, 17 Dec 2024 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456683;
	bh=m6BLWQXsb8YL9/P83ZXG4R3aAvT9OE46IuFX2UKrhnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAoK3u5MjIP4XKFeEhf6FpB+uwViYjVBqrvRGMYnVu2s2feOXk4QmEqKVPUjjzz2m
	 uFUGjGogvtTYS4SApouyTjQTDv6wLmqLMRt/c4y+xovmKcWttwyyFXTEWkXQ27ezHR
	 st6lJYIylj1wSNtSz5zUrmU2VNKheyUDXgqkIx6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/172] netfilter: IDLETIMER: Fix for possible ABBA deadlock
Date: Tue, 17 Dec 2024 18:08:10 +0100
Message-ID: <20241217170551.896544562@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit f36b01994d68ffc253c8296e2228dfe6e6431c03 ]

Deletion of the last rule referencing a given idletimer may happen at
the same time as a read of its file in sysfs:

| ======================================================
| WARNING: possible circular locking dependency detected
| 6.12.0-rc7-01692-g5e9a28f41134-dirty #594 Not tainted
| ------------------------------------------------------
| iptables/3303 is trying to acquire lock:
| ffff8881057e04b8 (kn->active#48){++++}-{0:0}, at: __kernfs_remove+0x20
|
| but task is already holding lock:
| ffffffffa0249068 (list_mutex){+.+.}-{3:3}, at: idletimer_tg_destroy_v]
|
| which lock already depends on the new lock.

A simple reproducer is:

| #!/bin/bash
|
| while true; do
|         iptables -A INPUT -i foo -j IDLETIMER --timeout 10 --label "testme"
|         iptables -D INPUT -i foo -j IDLETIMER --timeout 10 --label "testme"
| done &
| while true; do
|         cat /sys/class/xt_idletimer/timers/testme >/dev/null
| done

Avoid this by freeing list_mutex right after deleting the element from
the list, then continuing with the teardown.

Fixes: 0902b469bd25 ("netfilter: xtables: idletimer target implementation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_IDLETIMER.c | 52 +++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index f8b25b6f5da7..9869ef3c2ab3 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -409,21 +409,23 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 
 	mutex_lock(&list_mutex);
 
-	if (--info->timer->refcnt == 0) {
-		pr_debug("deleting timer %s\n", info->label);
-
-		list_del(&info->timer->entry);
-		timer_shutdown_sync(&info->timer->timer);
-		cancel_work_sync(&info->timer->work);
-		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
-		kfree(info->timer->attr.attr.name);
-		kfree(info->timer);
-	} else {
+	if (--info->timer->refcnt > 0) {
 		pr_debug("decreased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
+		mutex_unlock(&list_mutex);
+		return;
 	}
 
+	pr_debug("deleting timer %s\n", info->label);
+
+	list_del(&info->timer->entry);
 	mutex_unlock(&list_mutex);
+
+	timer_shutdown_sync(&info->timer->timer);
+	cancel_work_sync(&info->timer->work);
+	sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
+	kfree(info->timer->attr.attr.name);
+	kfree(info->timer);
 }
 
 static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
@@ -434,25 +436,27 @@ static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
 
 	mutex_lock(&list_mutex);
 
-	if (--info->timer->refcnt == 0) {
-		pr_debug("deleting timer %s\n", info->label);
-
-		list_del(&info->timer->entry);
-		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
-			alarm_cancel(&info->timer->alarm);
-		} else {
-			timer_shutdown_sync(&info->timer->timer);
-		}
-		cancel_work_sync(&info->timer->work);
-		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
-		kfree(info->timer->attr.attr.name);
-		kfree(info->timer);
-	} else {
+	if (--info->timer->refcnt > 0) {
 		pr_debug("decreased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
+		mutex_unlock(&list_mutex);
+		return;
 	}
 
+	pr_debug("deleting timer %s\n", info->label);
+
+	list_del(&info->timer->entry);
 	mutex_unlock(&list_mutex);
+
+	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+		alarm_cancel(&info->timer->alarm);
+	} else {
+		timer_shutdown_sync(&info->timer->timer);
+	}
+	cancel_work_sync(&info->timer->work);
+	sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
+	kfree(info->timer->attr.attr.name);
+	kfree(info->timer);
 }
 
 
-- 
2.39.5



