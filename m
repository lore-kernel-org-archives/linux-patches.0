Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D9F3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DE0C4339C;
	Mon, 30 Jan 2023 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088736;
	bh=wpQUoThYgChk0EVCIFKLitbpu5eTHuhAPSuymSPocus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJIiI+ajJbPdtb5YObRDsHeFhfLKmX3ZrTVxi0plQTo9l3uywvxPKSTBXrD9LSyOM
	 2cYz3LwYy5jKyycWUZGJhYNwhI+n/EGFIHisvumrejWkJjSIgD0bhg4tmTx9Hx+g2e
	 jdStczhNL5/zs/VLoK5obHHIEtTC0FLVG2+1NSiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	tangmeng <tangmeng@uniontech.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/143] panic: Separate sysctl logic from CONFIG_SMP
Date: Mon, 30 Jan 2023 14:52:27 +0100
Message-Id: <20230130134310.607813846@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

commit 9360d035a579d95d1e76c471061b9065b18a0eb1 upstream.

In preparation for adding more sysctls directly in kernel/panic.c, split
CONFIG_SMP from the logic that adds sysctls.

Cc: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: tangmeng <tangmeng@uniontech.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221117234328.594699-1-keescook@chromium.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 960c2be2759c..09f0802212c3 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -72,8 +72,9 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
-#if defined(CONFIG_SMP) && defined(CONFIG_SYSCTL)
+#ifdef CONFIG_SYSCTL
 static struct ctl_table kern_panic_table[] = {
+#ifdef CONFIG_SMP
 	{
 		.procname       = "oops_all_cpu_backtrace",
 		.data           = &sysctl_oops_all_cpu_backtrace,
@@ -83,6 +84,7 @@ static struct ctl_table kern_panic_table[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = SYSCTL_ONE,
 	},
+#endif
 	{ }
 };
 
-- 
2.39.0



