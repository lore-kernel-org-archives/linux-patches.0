Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2151365A08;
	Tue, 16 Dec 2025 12:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887148; cv=none; b=WO7ceH5xswEjgDchBjYl2Y5thre2slHJExD17jJ6Mzif4vToKsDBWUzt1lknz2fa57XUtcRj32rB0gWc27d+btmgrcVWIt2MKoZRLqUE4Do2mPCJnLLoJ9eJ+/SOiUSrPQZ6UYoqYd2CzpH9+xw79o1IJj97bVAzI63cJojgFl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887148; c=relaxed/simple;
	bh=coozyttKnIgaCKmbdwvywM8LUfQEZIA/UQS8gZiMNrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtDxKq831YTcnplPYgRn+UWkSjEUkz5aXdDhBBRqX8dpbQVsFk6zHm4/LmvQTb32QupSM/VIxuCtaSsOZDdsOkuCYb+Rdq93Nd9VQpIQ06ewzAAGQUXTEgcId5tXqUwgp/Zy0yrZdzPDIGqQzFELInvCwJ/vh8b0vbvMRyB1AdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDQjmo90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDQjmo90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A6DC4CEF5;
	Tue, 16 Dec 2025 12:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887148;
	bh=coozyttKnIgaCKmbdwvywM8LUfQEZIA/UQS8gZiMNrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDQjmo90YMGW6OLVz9y3dFSUYDx5CRQKPlFcqQr8N3oiiisbBNavKCM8YhfcBajjE
	 PNMAtpo5F/P6yF1DlebsTC13zhOxOllO1DtYTFgav9rY9/CmFxYBz4UpN3HHbrsdUE
	 sIeU6/krj/C7F43wEW74Nded01mtluZz+jqdnOF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/614] task_work: Fix NMI race condition
Date: Tue, 16 Dec 2025 12:08:29 +0100
Message-ID: <20251216111406.481388821@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ef1ea98c8fffe227e5319215d84a53fa2a4bcebc ]

  __schedule()
  // disable irqs
      <NMI>
	  task_work_add(current, work, TWA_NMI_CURRENT);
      </NMI>
  // current = next;
  // enable irqs
      <IRQ>
	  task_work_set_notify_irq()
	  test_and_set_tsk_thread_flag(current,
                                       TIF_NOTIFY_RESUME); // wrong task!
      </IRQ>
  // original task skips task work on its next return to user (or exit!)

Fixes: 466e4d801cd4 ("task_work: Add TWA_NMI_CURRENT as an additional notify mode.")
Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://patch.msgid.link/20250924080118.425949403@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/task_work.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index d1efec571a4a4..0f7519f8e7c93 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -9,7 +9,12 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
 #ifdef CONFIG_IRQ_WORK
 static void task_work_set_notify_irq(struct irq_work *entry)
 {
-	test_and_set_tsk_thread_flag(current, TIF_NOTIFY_RESUME);
+	/*
+	 * no-op IPI
+	 *
+	 * TWA_NMI_CURRENT will already have set the TIF flag, all
+	 * this interrupt does it tickle the return-to-user path.
+	 */
 }
 static DEFINE_PER_CPU(struct irq_work, irq_work_NMI_resume) =
 	IRQ_WORK_INIT_HARD(task_work_set_notify_irq);
@@ -86,6 +91,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 		break;
 #ifdef CONFIG_IRQ_WORK
 	case TWA_NMI_CURRENT:
+		set_tsk_thread_flag(current, TIF_NOTIFY_RESUME);
 		irq_work_queue(this_cpu_ptr(&irq_work_NMI_resume));
 		break;
 #endif
-- 
2.51.0



