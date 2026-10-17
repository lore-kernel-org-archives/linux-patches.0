Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10123C1085;
	Sat, 17 Oct 2026 16:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255379; cv=none; b=mvCz9R1HYwiYcK1wwEltcMly4Y8faxdxB3RLdQ02hWInOCf6wPvEfElzCCGqkWdvUnrP/8lFFeLzQGmr2bxPJxh1Tao85jZoBgIF6DlolGjyuI2O3SWUvBe0lEQpnAFjPnPXj6oMxkI4eBjdC/GoPTFh7ZDrlu8K+HgY1N5im+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255379; c=relaxed/simple;
	bh=Domi25pwu6lahWR5UsOWVR73YbrucP3fwRBL1FnI1IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rkd4QDIq23hRCod1o9NfyBimfdEErCiavHKpS3JrKxa59k13vX+WR0JsOrB8/oIl4VXwTDloiNB35DIChXOVuexYyBEq0O2fpywJA/Eu8e57fz+gIyxXpgnPDdUXkLIg4RgJDl7pQjQwQOtmQ+5S2qu9+JHH3xrWhwQHjH8hmK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgQDrcem; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgQDrcem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E861F000CF;
	Sat, 17 Oct 2026 16:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255377;
	bh=A4vercVOJMpr98+XJqI37otTCk6XRyH9jA/VmUeVyKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgQDrcemgWzCYCvlbpt0rzUU99qLQ2QTGdLRs63mg4kk2NRJ3zX1kfE12Ic76+AUN
	 6IKj+iGCQXkwAXMagULXFnrVsvwgdyxXAZDeSX/hsVAPq/i9SRy6xyAJiXt1F2mUzG
	 3X1yNUrl/6uY6Nh/6tCjBQpc3luy1ZT8+RNibakw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 757/869] genirq/proc: Size interrupt directory names for 10-digit interrupt numbers
Date: Sat, 17 Oct 2026 17:59:58 +0200
Message-ID: <20261017160056.338110836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6cb9e19e710cf..2ad08b9a41016 100644
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



