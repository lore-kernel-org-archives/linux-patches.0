Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16740343893;
	Sat, 12 Sep 2026 09:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206649; cv=none; b=JTiHNxw+fKFwakHjZp95P+Ff+nXamT5wG2AWBtDnjezjIUjqUvkW9ZEQukATSIAl1WX/423e3wG+qqAZwP6whNPuWcYHIhe7r6R3l6RIptgq/O8L/YMcHuFB1N3+S7DUmpzVEPNFZFL/fCQTFLUVqXwuam28TF8/bq8tDvHOm/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206649; c=relaxed/simple;
	bh=q1wwjRIZd3tvtWReG/CJFiXnJB08iqutImsX2g5ubGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdXakfoxWYwUEPkvCCUmLf3MZFDntjqgk0pwVe6ySMPtUOBis3Iyrx/YRdYw+qeLsV+1RFVPDeoD+bcGzvBODif+paA9RNKirSzcz0+CiP2hk0R7kDzGM9vKN1JZtJAxDVvliTDKooc1CTHvjbiNo8HXVMH/uIta2VXYUUDQ+JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCRKw+SG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCRKw+SG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CA41F000FF;
	Sat, 12 Sep 2026 09:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206648;
	bh=Ej4OKJVAe7G+2liPYZ75k1ODVz6wlKUbX2zdZNsPwHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCRKw+SGdy0LCRucZ26R0giCOBHy7A+nGQuI5a/tk5ebh7srbag2ymL3vQQ44SHxO
	 gzD7XtSUF4Usf1SaWHvA/XzZiVTDTXa0toN/SaJWWKjs77JEZQRej5LWQmx6ps7jJe
	 K0S0Svc9Ng7DaDhcvL/TYdNZGxFGlhx1S4Qap/2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0250/1518] timens: Simplify some calls to put_time_ns()
Date: Sat, 12 Sep 2026 08:40:19 +0200
Message-ID: <20260912065629.138623643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 3fa3aeb4a5cb19e372680ef8860a0381cd5409e9 ]

Use the new __free() based cleanup helpers to simplify some functions.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260330-timens-cleanup-v1-2-936e91c9dd30@linutronix.de
Stable-dep-of: 06aba58e5849 ("time/namespace: Validate nanosecond field in proc_timens_set_offset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/namespace.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index 9191899289fcb..6feb75b52b5cd 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -18,6 +18,7 @@
 #include <linux/cred.h>
 #include <linux/err.h>
 #include <linux/mm.h>
+#include <linux/cleanup.h>
 
 #include "namespace_internal.h"
 
@@ -251,36 +252,33 @@ static void show_offset(struct seq_file *m, int clockid, struct timespec64 *ts)
 
 void proc_timens_show_offsets(struct task_struct *p, struct seq_file *m)
 {
-	struct ns_common *ns;
-	struct time_namespace *time_ns;
+	struct time_namespace *time_ns __free(time_ns) = NULL;
+	struct ns_common *ns = timens_for_children_get(p);
 
-	ns = timens_for_children_get(p);
 	if (!ns)
 		return;
+
 	time_ns = to_time_ns(ns);
 
 	show_offset(m, CLOCK_MONOTONIC, &time_ns->offsets.monotonic);
 	show_offset(m, CLOCK_BOOTTIME, &time_ns->offsets.boottime);
-	put_time_ns(time_ns);
 }
 
 int proc_timens_set_offset(struct file *file, struct task_struct *p,
 			   struct proc_timens_offset *offsets, int noffsets)
 {
-	struct ns_common *ns;
-	struct time_namespace *time_ns;
+	struct time_namespace *time_ns __free(time_ns) = NULL;
+	struct ns_common *ns = timens_for_children_get(p);
 	struct timespec64 tp;
 	int i, err;
 
-	ns = timens_for_children_get(p);
 	if (!ns)
 		return -ESRCH;
+
 	time_ns = to_time_ns(ns);
 
-	if (!file_ns_capable(file, time_ns->user_ns, CAP_SYS_TIME)) {
-		put_time_ns(time_ns);
+	if (!file_ns_capable(file, time_ns->user_ns, CAP_SYS_TIME))
 		return -EPERM;
-	}
 
 	for (i = 0; i < noffsets; i++) {
 		struct proc_timens_offset *off = &offsets[i];
@@ -293,15 +291,12 @@ int proc_timens_set_offset(struct file *file, struct task_struct *p,
 			ktime_get_boottime_ts64(&tp);
 			break;
 		default:
-			err = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
-		err = -ERANGE;
-
 		if (off->val.tv_sec > KTIME_SEC_MAX ||
 		    off->val.tv_sec < -KTIME_SEC_MAX)
-			goto out;
+			return -ERANGE;
 
 		tp = timespec64_add(tp, off->val);
 		/*
@@ -309,7 +304,7 @@ int proc_timens_set_offset(struct file *file, struct task_struct *p,
 		 * still unreachable.
 		 */
 		if (tp.tv_sec < 0 || tp.tv_sec > KTIME_SEC_MAX / 2)
-			goto out;
+			return -ERANGE;
 	}
 
 	mutex_lock(&timens_offset_lock);
@@ -338,8 +333,6 @@ int proc_timens_set_offset(struct file *file, struct task_struct *p,
 
 out_unlock:
 	mutex_unlock(&timens_offset_lock);
-out:
-	put_time_ns(time_ns);
 
 	return err;
 }
-- 
2.53.0



