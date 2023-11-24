Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C42539FE3;
	Fri, 24 Nov 2023 18:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaA1neDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C281C433C7;
	Fri, 24 Nov 2023 18:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849825;
	bh=nqKkn1LS4kfevw/E/ycbKhBnu8IH9pG3iOKkyCb7NnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaA1neDOR18/4x/EkhTA0rI+ke3oPl527EQhnOas7zqMlwviO8h5TryEXjzdpE3Ou
	 gDILmP6bO5vOS/o352h/Dr3dfeiy4zYhmxmembelea04ffb9sRhbwv7CE5gkpw/2tN
	 NQbWMFnw9FIcn/W/Omogvi5/kw6gzuOCq2mH0Oig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoph Paasch <cpaasch@apple.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 6.6 336/530] rcu: kmemleak: Ignore kmemleak false positives when RCU-freeing objects
Date: Fri, 24 Nov 2023 17:48:22 +0000
Message-ID: <20231124172038.256882509@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 5f98fd034ca6fd1ab8c91a3488968a0e9caaabf6 upstream.

Since the actual slab freeing is deferred when calling kvfree_rcu(), so
is the kmemleak_free() callback informing kmemleak of the object
deletion. From the perspective of the kvfree_rcu() caller, the object is
freed and it may remove any references to it. Since kmemleak does not
scan RCU internal data storing the pointer, it will report such objects
as leaks during the grace period.

Tell kmemleak to ignore such objects on the kvfree_call_rcu() path. Note
that the tiny RCU implementation does not have such issue since the
objects can be tracked from the rcu_ctrlblk structure.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://lore.kernel.org/all/F903A825-F05F-4B77-A2B5-7356282FBA2C@apple.com/
Cc: <stable@vger.kernel.org>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -31,6 +31,7 @@
 #include <linux/bitops.h>
 #include <linux/export.h>
 #include <linux/completion.h>
+#include <linux/kmemleak.h>
 #include <linux/moduleparam.h>
 #include <linux/panic.h>
 #include <linux/panic_notifier.h>
@@ -3401,6 +3402,14 @@ void kvfree_call_rcu(struct rcu_head *he
 		success = true;
 	}
 
+	/*
+	 * The kvfree_rcu() caller considers the pointer freed at this point
+	 * and likely removes any references to it. Since the actual slab
+	 * freeing (and kmemleak_free()) is deferred, tell kmemleak to ignore
+	 * this object (no scanning or false positives reporting).
+	 */
+	kmemleak_ignore(ptr);
+
 	// Set timer to drain after KFREE_DRAIN_JIFFIES.
 	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING)
 		schedule_delayed_monitor_work(krcp);


