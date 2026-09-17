Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EEF4F3912;
	Thu, 17 Sep 2026 16:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661133; cv=none; b=TXUkE1ZK9r0Nb6cohpUaRRaazfinwa3pxpRsu8SLXuvsv5Ay7w6lR0sEHwhWsccBqAUPpdkt/ly9Ji0TD+TzuINUDbSCuFyHW0PocXQ5qP517sy+ck76Fvcd1S4LBszcblLng3sFvioFnnv5sey1OpOF1HzTd6/mofDUgxuGfGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661133; c=relaxed/simple;
	bh=ZVi1J7n5Py3OzTBWtOQF9Jg7z9EeCYl867dtNS9gGP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhBuWNlZv4GhBmdA6nSPBqx9DaqCy/uA/l0SQReAsFzYuuKc9y3emzVxrl3l/M+vpb7IL1oDce3g30WT/UeboUB+FMZ6M6JgWrwYILmsJiCOfFjjR7is7NnhKA0q6W9I+Km/ek7SsjrfSfTeUGw+1oamKqEzeYd+Y6WTkA2hT5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4eg3QQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4eg3QQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9526A1F000FF;
	Thu, 17 Sep 2026 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661132;
	bh=/TzgDJdcAd9v6VhvUnfhcRr4HZxB4y9Q9XYzDuqRvBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4eg3QQwkuqLyeothTNjUGalG4OTopCwuzSh1MpSMnQtS2UimW8yPheLGVtDYg8Yk
	 cSxDhIy5XUfhftCuyAlFxgrYLXRXsjDHjw6vcRhZbOogdI+UNcECl0MZv1BzRNzlDs
	 +TtTRpvpuloZfrnVCpFVQoSsEKfpoLRZtuagI3CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0094/1250] genirq/proc: Size interrupt directory names for 10-digit interrupt numbers
Date: Thu, 17 Sep 2026 15:58:09 +0100
Message-ID: <20260917151554.533697093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 29c2404e743be..0537d330abb82 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -10,6 +10,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/kernel.h>
 #include <linux/kernel_stat.h>
 #include <linux/mutex.h>
 
@@ -323,7 +324,7 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 
 #undef MAX_NAMELEN
 
-#define MAX_NAMELEN 10
+#define MAX_NAMELEN 11
 
 void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
@@ -345,7 +346,7 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 		return;
 
 	/* create /proc/irq/1234 */
-	sprintf(name, "%u", irq);
+	snprintf(name, MAX_NAMELEN, "%u", irq);
 	desc->dir = proc_mkdir(name, root_irq_dir);
 	if (!desc->dir)
 		return;
@@ -398,7 +399,7 @@ void unregister_irq_proc(unsigned int irq, struct irq_desc *desc)
 #endif
 	remove_proc_entry("spurious", desc->dir);
 
-	sprintf(name, "%u", irq);
+	snprintf(name, MAX_NAMELEN, "%u", irq);
 	remove_proc_entry(name, root_irq_dir);
 }
 
-- 
2.53.0



