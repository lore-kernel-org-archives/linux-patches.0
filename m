Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB8A66B5E;
	Tue, 14 May 2024 11:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687409; cv=none; b=VP5TOSTcZFXrSH22Zd004NH6Zie2zqP/GZYz8vX4fNKIwbagZpVBEc+XuDBrFxKbcJ6zE8MipQKTqJNNacYtyM0gQHlFftbfRgIN2bvbMcThx6i+APz1Wf/Wk0ppGpeWu/5rU0XUZVNxXT8wzlfaxxBtqNwuZC/pH2J3+2GPAIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687409; c=relaxed/simple;
	bh=IKD1G8Fc2p52fIWDXBeceo+acW5r5mM1BzPJGEQpHeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm4nw389Q+c4SqEEYe4qcDjEJktcXsrfXhPZ1PfXvP3J/hpIXlaxycj8jdHAS2vU4sMMT6Iur8elu4iN9/Bf9ASfsoBOG03cOqhhqGHCvBItlgLFRSz4usP87sAaDUr0WHuEPv0UPsBv0XluQrFKMTk++Kp8UwPPRmmV2JV0vV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWwhzX2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWwhzX2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BA7C2BD10;
	Tue, 14 May 2024 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687409;
	bh=IKD1G8Fc2p52fIWDXBeceo+acW5r5mM1BzPJGEQpHeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWwhzX2aijd6puHwOdlpG1G0jOopnaNUZWPlNbEdZIEtVNpJ3HGMJuvuy8mtE5nv/
	 o+Vc8m9qiuGm8rm5o9juj005IbM40qB/BXU4bQyYjHiNT2LspWQ3giXEDcJXUDIfEL
	 XZJiLoyjn9yg85kxG2TR3q/El7ZnL/FlBWxuWWzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrey Konovalov <andreyknvl@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/111] kcov: Remove kcov include from sched.h and move it to its users.
Date: Tue, 14 May 2024 12:20:23 +0200
Message-ID: <20240514101000.361183064@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 183f47fcaa54a5ffe671d990186d330ac8c63b10 ]

The recent addition of in_serving_softirq() to kconv.h results in
compile failure on PREEMPT_RT because it requires
task_struct::softirq_disable_cnt. This is not available if kconv.h is
included from sched.h.

It is not needed to include kconv.h from sched.h. All but the net/ user
already include the kconv header file.

Move the include of the kconv.h header from sched.h it its users.
Additionally include sched.h from kconv.h to ensure that everything
task_struct related is available.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Andrey Konovalov <andreyknvl@google.com>
Link: https://lkml.kernel.org/r/20210218173124.iy5iyqv3a4oia4vv@linutronix.de
Stable-dep-of: 19e35f24750d ("nfc: nci: Fix kcov check in nci_rx_work()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/usbip_common.h | 1 +
 include/linux/kcov.h             | 1 +
 include/linux/sched.h            | 1 -
 net/core/skbuff.c                | 1 +
 net/mac80211/iface.c             | 1 +
 net/mac80211/rx.c                | 1 +
 6 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
index a7e6ce96f62c7..02cd91cb3f831 100644
--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -18,6 +18,7 @@
 #include <linux/usb.h>
 #include <linux/wait.h>
 #include <linux/sched/task.h>
+#include <linux/kcov.h>
 #include <uapi/linux/usbip.h>
 
 #undef pr_fmt
diff --git a/include/linux/kcov.h b/include/linux/kcov.h
index a10e84707d820..b48128b717f1f 100644
--- a/include/linux/kcov.h
+++ b/include/linux/kcov.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_KCOV_H
 #define _LINUX_KCOV_H
 
+#include <linux/sched.h>
 #include <uapi/linux/kcov.h>
 
 struct task_struct;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index aa015416c5693..3613c3f43b83e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -14,7 +14,6 @@
 #include <linux/pid.h>
 #include <linux/sem.h>
 #include <linux/shm.h>
-#include <linux/kcov.h>
 #include <linux/mutex.h>
 #include <linux/plist.h>
 #include <linux/hrtimer.h>
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fd53b66f2ca1d..b0c2d6f018003 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -60,6 +60,7 @@
 #include <linux/prefetch.h>
 #include <linux/if_vlan.h>
 #include <linux/mpls.h>
+#include <linux/kcov.h>
 
 #include <net/protocol.h>
 #include <net/dst.h>
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3a15ef8dd3228..06ce138eedf1b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -15,6 +15,7 @@
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/kcov.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 #include "ieee80211_i.h"
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 97a63b940482d..65fea564c9c00 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 #include <linux/rcupdate.h>
 #include <linux/export.h>
+#include <linux/kcov.h>
 #include <linux/bitops.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
-- 
2.43.0



