Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085758615A;
	Tue, 17 Dec 2024 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456155; cv=none; b=Q6AF0v0vkSKpzafsVc9YYsq9Pap5iPYAbOHaFQXRBdPWxuw6ze1xqQ48iP6YctNSFwRMV2BB0Bs/gHW7sAqkXsNmBaBsQLYHjf55t02UcwbY0Ig3k4oG6d2bOZdSjjs5kg36eqzOwhCKPzfS1CLKJm40S5GDRxIZyOCFeaDqPkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456155; c=relaxed/simple;
	bh=SoIzgga6POdT4kqmPjWGRxLDbra8w+MNVw+EDF0XGzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6WaeAb0mypptx/elOxBLHk8VJ1N2Q67SJrGyiaRkDLgo0pSRBUuS4tSV9G7w+z25GoDO5H1Autz+6UCpaQQD1ERn5CxtPGlN20nKU8oLLkntKNRLFU1eWflwZn9lAW4TokoLQ0sLHg+tOTyR4ZlxRMeokyCfzGbLCDYxacpepE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1xMf43A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1xMf43A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8227FC4CED3;
	Tue, 17 Dec 2024 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456154;
	bh=SoIzgga6POdT4kqmPjWGRxLDbra8w+MNVw+EDF0XGzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1xMf43ATcM6mkDTIhw2TMXJr6Cu7xvsilJHRtjOvPvgfqJ1BIImD9moFa3OXtFkg
	 UUxgTVMcGRovR38gP90lCryFc0sUlOlVtz2giitUMxFus6KoWXhZhFzljUMHud6xTA
	 m4mn5NE1WBrnYZIzMvvTBwJkj71NuoN5ZUCi+11o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/109] netfilter: IDLETIMER: Fix for possible ABBA deadlock
Date: Tue, 17 Dec 2024 18:08:03 +0100
Message-ID: <20241217170536.682639359@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



