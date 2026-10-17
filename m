Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0B717BED0;
	Sat, 17 Oct 2026 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257676; cv=none; b=VcrycAsihPW0vXd2UPWOZ+dOm0GyKyG/G9rd0RGtpc/G0fJBxQhUhTSyiMaihn7b79jjYByAoa8hH3cfe7/4tYYWmLVNQtcVsUnYvrJZonnyfw1b19pDYSBS7WDd340mt3oGIjWKaTOeYNZT5Pob/931ueQ/W0UAkes+TYQ+70U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257676; c=relaxed/simple;
	bh=EluhUze+r+khMRZ7Yi7n5rp1a8+huzGjtZaAmLb44tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOGXjwczXpV4bXCtjp8O7la2K3cuhUB9C35SWToEdJ+FzS7m7O2vH88E1Yvv/yrzrFl8SjDHT8TXdM5DMD6oXrMJmxb9ITDgbk98/tTnz0AJrv5pziK3aZs6pOpSsKz5jxDvvSciwhTagFV8+dO4r+90Jkh4d3OoDn/kuN7KoL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EO9MlHbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EO9MlHbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A971F000C4;
	Sat, 17 Oct 2026 17:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257675;
	bh=zX8Tisa4dlFBUV4S0NjiOS2Q/Mz8aji60jYB2FfYcxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EO9MlHbx08VP1dotAOvhHHP+KRBVTRgUdRJNfEoLegEiAGZc9yBojNboRtXsYLbR8
	 A6AMA6UlLb00bhRuXx7d8y5uqDPXV4kbGtBbG/mGtqNfjHNmYPajwXmcVV6jHkTN24
	 Z9SVRx8U6NHPp2NpcG6Ilaneiym/BwEYnKx01mfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0635/1674] pktgen: use cpus_read_lock() in pg_net_init()
Date: Sat, 17 Oct 2026 17:48:27 +0200
Message-ID: <20261017160447.396997744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 979b581e4c69257acab1af415ddad6b2d78a2fa5 ]

I have seen the WARN_ON(smp_processor_id() != cpu) firing
in pktgen_thread_worker() during tests.

We must use cpus_read_lock()/cpus_read_unlock()
around the for_each_online_cpu(cpu) loop.

While we are at it use WARN_ON_ONCE() to avoid a possible syslog flood.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240821175339.1191779-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index cbb916f9edcac..f1385e41c0ae8 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -128,6 +128,7 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/capability.h>
+#include <linux/cpu.h>
 #include <linux/hrtimer.h>
 #include <linux/freezer.h>
 #include <linux/delay.h>
@@ -3613,7 +3614,7 @@ static int pktgen_thread_worker(void *arg)
 	struct pktgen_dev *pkt_dev = NULL;
 	int cpu = t->cpu;
 
-	WARN_ON(smp_processor_id() != cpu);
+	WARN_ON_ONCE(smp_processor_id() != cpu);
 
 	init_waitqueue_head(&t->queue);
 	complete(&t->start_done);
@@ -3949,6 +3950,7 @@ static int __net_init pg_net_init(struct net *net)
 		goto remove;
 	}
 
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
 		int err;
 
@@ -3957,6 +3959,7 @@ static int __net_init pg_net_init(struct net *net)
 			pr_warn("Cannot create thread for cpu %d (%d)\n",
 				   cpu, err);
 	}
+	cpus_read_unlock();
 
 	if (list_empty(&pn->pktgen_threads)) {
 		pr_err("Initialization failed for all threads\n");
-- 
2.53.0



