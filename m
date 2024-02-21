Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631047993D;
	Wed, 21 Feb 2024 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522332; cv=none; b=Cxv8U/nnJDCxnbGtbdJmHPEJf8AIcZ0ODgOhADerRxDy6To+3fO+Skoh1hSYvUFQ3PE3LcruGkE3RMJVvU7sQiGhSGQlWw1z5N1Jd5HFlsSBRM5PbePeE4w04lZ1pcc14fqU6cL9LNqMeIGub52qKak8Rr6e4HcR5k+HSQfz7KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522332; c=relaxed/simple;
	bh=blZvTnffSLajbZWCPna45jzn6StyNrABklb03wn/V8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcnwTFaYFia6abHAj6uBCbIidFG9c7OC76V5Zt2XsULdTDAH/xdYnrMwQAv6qMuywXbM+wiLJp3MYv78GRI+kQj/QxNzSAvWpX8TIaQLhJ6AFget9lyowGcH9v3UlZQJA7zMiBXRVYihYubd5xW0RXBPZdPjG4mThTSwy9j4X2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4KTNfJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4KTNfJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403FBC433F1;
	Wed, 21 Feb 2024 13:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522331;
	bh=blZvTnffSLajbZWCPna45jzn6StyNrABklb03wn/V8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4KTNfJ0Pro9bN0U7eAX8Yqc1t66I3b+qR+n//PFkmlWFVKJMrttRtXUUqpTxJXpi
	 TXit2AaKu2sIiMrzkMa64yZCyisXkJYZF/n6a4TREx6dsNzTVqQNKJdiGrEIKfUE47
	 Z8Au63YCPWWHLpHu5uVThYcrp3yncdVsSipyFOjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youquan Song <youquan.song@intel.com>,
	Zhiquan Li <zhiquan1.li@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/476] x86/mce: Mark fatal MCEs page as poison to avoid panic in the kdump kernel
Date: Wed, 21 Feb 2024 14:03:05 +0100
Message-ID: <20240221130012.908778246@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiquan Li <zhiquan1.li@intel.com>

[ Upstream commit 9f3b130048bfa2e44a8cfb1b616f826d9d5d8188 ]

Memory errors don't happen very often, especially fatal ones. However,
in large-scale scenarios such as data centers, that probability
increases with the amount of machines present.

When a fatal machine check happens, mce_panic() is called based on the
severity grading of that error. The page containing the error is not
marked as poison.

However, when kexec is enabled, tools like makedumpfile understand when
pages are marked as poison and do not touch them so as not to cause
a fatal machine check exception again while dumping the previous
kernel's memory.

Therefore, mark the page containing the error as poisoned so that the
kexec'ed kernel can avoid accessing the page.

  [ bp: Rewrite commit message and comment. ]

Co-developed-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Link: https://lore.kernel.org/r/20231014051754.3759099-1-zhiquan1.li@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index a0727723676b..eb48729e220e 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -44,6 +44,7 @@
 #include <linux/sync_core.h>
 #include <linux/task_work.h>
 #include <linux/hardirq.h>
+#include <linux/kexec.h>
 
 #include <asm/intel-family.h>
 #include <asm/processor.h>
@@ -274,6 +275,7 @@ static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
 	struct llist_node *pending;
 	struct mce_evt_llist *l;
 	int apei_err = 0;
+	struct page *p;
 
 	/*
 	 * Allow instrumentation around external facilities usage. Not that it
@@ -329,6 +331,20 @@ static noinstr void mce_panic(const char *msg, struct mce *final, char *exp)
 	if (!fake_panic) {
 		if (panic_timeout == 0)
 			panic_timeout = mca_cfg.panic_timeout;
+
+		/*
+		 * Kdump skips the poisoned page in order to avoid
+		 * touching the error bits again. Poison the page even
+		 * if the error is fatal and the machine is about to
+		 * panic.
+		 */
+		if (kexec_crash_loaded()) {
+			if (final && (final->status & MCI_STATUS_ADDRV)) {
+				p = pfn_to_online_page(final->addr >> PAGE_SHIFT);
+				if (p)
+					SetPageHWPoison(p);
+			}
+		}
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
-- 
2.43.0



