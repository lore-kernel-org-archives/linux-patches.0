Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D9D4CF461;
	Sat, 17 Oct 2026 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260560; cv=none; b=NcLCNlIYwsral5K6UeZbicAMiixc28waNYnvq1YuEvfRw/xqMSGatw4LBWy6XKnia930JwwPWJyDVOO+9JRH7qSSzjYeSunVi3wETc6s0+GDRPajJPJnd4SnCg5ueCleInNwBnbcGWkQirGpLLtjMZR67OMQ6WpSsVa3YS4Iu/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260560; c=relaxed/simple;
	bh=k/krU6oRUaxPF42qefJ/xf9cg4/W9HHRTSFllpHRO7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlfkdejL0LVsPO17ZJlpmGvgsYyH5dz+597P8Hzlo/It1nrqpn+FjxqTQuVQcUubIMof7UhJH7avCvva7iAa7hcrjBCmVsiVZEk5D5gZwoPf+giHCU3tdvRkqtz3Cd2plWFRPXOGID3JG/IvXNx/9Dv9W3fjIZkzcfmHwSa4mfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6TG2YAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6TG2YAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A941F000C4;
	Sat, 17 Oct 2026 18:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260559;
	bh=X4q5Jp7X0OIuDhLw4csbHRp+LTgnXQexPNu2ORFtR7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6TG2YAZZUSRy/BMlLLjzZoY3a3mFmFAo6jUtD6bn5AYZ13tAzf0wN/6c5EpQRIqY
	 4DpfqasLVs9MWvJRjlwK7RKFSy95RRue1CdIKRt2WBNbY8OeRKl4lQy+3dwBiwWxKe
	 U/zotlfNy80jiGFy9OXGsRbUtakdexVbUHb76RjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1544/1674] genirq/proc: Size interrupt directory names for 10-digit interrupt numbers
Date: Sat, 17 Oct 2026 18:03:36 +0200
Message-ID: <20261017160510.741000561@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit c2c7983c93f5d86962318be7e7298f1bc3feb1a6 ]

/proc/irq/<n>/ directory names are built in `char name[10]` buffers
with `sprintf(name, "%u", irq)`.

Ten-digit IRQ numbers already need 11 bytes including the trailing NUL, and
current sparse-IRQ configurations allow interrupt numbers in that range.

Size the temporary name buffer for the current decimal form and switch
to bounded formatting when creating or removing the proc entry.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260404101001.1-genirq-proc-pengpeng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/proc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 623b8136e9af3..1dccdbbd76970 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -10,6 +10,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/kernel.h>
 #include <linux/kernel_stat.h>
 #include <linux/mutex.h>
 
@@ -333,7 +334,7 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 
 #undef MAX_NAMELEN
 
-#define MAX_NAMELEN 10
+#define MAX_NAMELEN 11
 
 void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
@@ -354,7 +355,7 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 	if (desc->dir)
 		goto out_unlock;
 
-	sprintf(name, "%d", irq);
+	snprintf(name, MAX_NAMELEN, "%u", irq);
 
 	/* create /proc/irq/1234 */
 	desc->dir = proc_mkdir(name, root_irq_dir);
@@ -408,7 +409,7 @@ void unregister_irq_proc(unsigned int irq, struct irq_desc *desc)
 #endif
 	remove_proc_entry("spurious", desc->dir);
 
-	sprintf(name, "%u", irq);
+	snprintf(name, MAX_NAMELEN, "%u", irq);
 	remove_proc_entry(name, root_irq_dir);
 }
 
-- 
2.53.0



