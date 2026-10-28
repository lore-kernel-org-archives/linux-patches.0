Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214003;
	b=OFeGOcG0b68LyeEf4Ka+4ed/khHlQHNERGhqQFnYSVlWSZb7khZ7SYhA61LuwhPno+mq
	 OFYYOC/fbVDQU+E9Lq3p8NYnMJdl8sM5PU0X/9O10ozu/rCJfRlhN0H5O5zGwgA7HDS+C
	 ef4T025dO1J9YQuvWCnOkkqLTofdak5yXcCykQvdo8D6SFlbA9bCYNT7ETf5l23M4yA4j
	 qXO1VP+CAKh3F6IA/Tt4zxZtd7UoM1BazEjSqf8rDrPiyxMvJKxCI7959Y+cJrVQHdPp8
	 sO+K95ZVjoTZe34GNOfJ/mQvtiLcm7kNn5pcQkGo5lRGmG6oO2FtgpuNxRCZiilC+nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GwqoHCxQUNoLY+MG4NWfpK4gIVVu94v1Yt7jQHsioBw=;
	b=eknWipmVTmsxbcsH1IvbQnKWiAnWj6VdsHeV/cFPrIEWUluQD+J6fTSl2SwM615ivLIk
	 gb/YA/ncNgz7H7SF8hW3pCCvNPZYVcCNLlP0NCG32ZL3jtF9ZsCi3mVQ6bKuTr4QlVR59
	 ILod10KTj2iKRwF58furR5wot/y4p9eevo4laVziMV21FEOK8DLPzN9Zi2SYPfLtgAo6V
	 hwp164a5WfanskgOyCaXOccwtCipBtohNDHt9swRQN8n4bAiDc6xRlrj3cqjJel1Jcl42
	 W+srFY2jmIB9mtFr9jUqrYkdby8vmYOiMskk5x/Moja/ocDOTOCYlSKYTjDM1joI4+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3EE60A2630;
	Wed, 28 Oct 2026 19:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB87A1F031E2;
	Wed, 28 Oct 2026 19:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214003;
	bh=GwqoHCxQUNoLY+MG4NWfpK4gIVVu94v1Yt7jQHsioBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gN+tQBO8giwZKIZccalsfsqa9OjT6W4u+KFbk7mc7PyrEoKipxhcYm1zltuAWkbqD
	 fnzWN46eUs9dt43mozvLb1oeqlGjGGAG2mRI69K8K9N6JEonLvHhpxicot/eFVYbgX
	 w2kmgULC8laQX8XjGgX7epwv2zoICXZGVTpg/9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0704/1887] netfilter: IDLETIMER: Fix for possible ABBA deadlock
Date: Wed, 28 Oct 2026 17:46:40 +0100
Message-ID: <20261028170515.432303806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9733f49847a6d..aa93c812317e2 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -415,21 +415,23 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 
 	mutex_lock(&list_mutex);
 
-	if (--info->timer->refcnt == 0) {
-		pr_debug("deleting timer %s\n", info->label);
-
-		list_del(&info->timer->entry);
-		del_timer_sync(&info->timer->timer);
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
+	del_timer_sync(&info->timer->timer);
+	cancel_work_sync(&info->timer->work);
+	sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
+	kfree(info->timer->attr.attr.name);
+	kfree(info->timer);
 }
 
 static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
@@ -440,25 +442,27 @@ static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
 
 	mutex_lock(&list_mutex);
 
-	if (--info->timer->refcnt == 0) {
-		pr_debug("deleting timer %s\n", info->label);
-
-		list_del(&info->timer->entry);
-		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
-			alarm_cancel(&info->timer->alarm);
-		} else {
-			del_timer_sync(&info->timer->timer);
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
+		del_timer_sync(&info->timer->timer);
+	}
+	cancel_work_sync(&info->timer->work);
+	sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
+	kfree(info->timer->attr.attr.name);
+	kfree(info->timer);
 }
 
 
-- 
2.53.0



