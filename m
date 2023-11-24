Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639422E853;
	Fri, 24 Nov 2023 19:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zrw8gWUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2F4C433C8;
	Fri, 24 Nov 2023 19:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853733;
	bh=E2LFyLBrR+Mtc0ZdtrX07ZE6esTgNQdcAccg5w4GYss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zrw8gWUt6AWkOAWvT07umzEu9ndhdaPZ+7o+m7qim3ceFgyEAr701z/qE9qPuUes+
	 WdZIrAL+hkoYXwg6O6gp1BLZ+K05AYMdLKpjszCYQZRHSqyVue+Ig7CTstFuFvfAgc
	 jnV6m40qYPQCVrnlZpbIu5hPu0kkmWRxYC+G19zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/159] locking/ww_mutex/test: Fix potential workqueue corruption
Date: Fri, 24 Nov 2023 17:53:38 +0000
Message-ID: <20231124171941.971185677@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <jstultz@google.com>

[ Upstream commit bccdd808902f8c677317cec47c306e42b93b849e ]

In some cases running with the test-ww_mutex code, I was seeing
odd behavior where sometimes it seemed flush_workqueue was
returning before all the work threads were finished.

Often this would cause strange crashes as the mutexes would be
freed while they were being used.

Looking at the code, there is a lifetime problem as the
controlling thread that spawns the work allocates the
"struct stress" structures that are passed to the workqueue
threads. Then when the workqueue threads are finished,
they free the stress struct that was passed to them.

Unfortunately the workqueue work_struct node is in the stress
struct. Which means the work_struct is freed before the work
thread returns and while flush_workqueue is waiting.

It seems like a better idea to have the controlling thread
both allocate and free the stress structures, so that we can
be sure we don't corrupt the workqueue by freeing the structure
prematurely.

So this patch reworks the test to do so, and with this change
I no longer see the early flush_workqueue returns.

Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230922043616.19282-3-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/test-ww_mutex.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/locking/test-ww_mutex.c b/kernel/locking/test-ww_mutex.c
index 3e82f449b4ff7..da36997d8742c 100644
--- a/kernel/locking/test-ww_mutex.c
+++ b/kernel/locking/test-ww_mutex.c
@@ -426,7 +426,6 @@ static void stress_inorder_work(struct work_struct *work)
 	} while (!time_after(jiffies, stress->timeout));
 
 	kfree(order);
-	kfree(stress);
 }
 
 struct reorder_lock {
@@ -491,7 +490,6 @@ static void stress_reorder_work(struct work_struct *work)
 	list_for_each_entry_safe(ll, ln, &locks, link)
 		kfree(ll);
 	kfree(order);
-	kfree(stress);
 }
 
 static void stress_one_work(struct work_struct *work)
@@ -512,8 +510,6 @@ static void stress_one_work(struct work_struct *work)
 			break;
 		}
 	} while (!time_after(jiffies, stress->timeout));
-
-	kfree(stress);
 }
 
 #define STRESS_INORDER BIT(0)
@@ -524,15 +520,24 @@ static void stress_one_work(struct work_struct *work)
 static int stress(int nlocks, int nthreads, unsigned int flags)
 {
 	struct ww_mutex *locks;
-	int n;
+	struct stress *stress_array;
+	int n, count;
 
 	locks = kmalloc_array(nlocks, sizeof(*locks), GFP_KERNEL);
 	if (!locks)
 		return -ENOMEM;
 
+	stress_array = kmalloc_array(nthreads, sizeof(*stress_array),
+				     GFP_KERNEL);
+	if (!stress_array) {
+		kfree(locks);
+		return -ENOMEM;
+	}
+
 	for (n = 0; n < nlocks; n++)
 		ww_mutex_init(&locks[n], &ww_class);
 
+	count = 0;
 	for (n = 0; nthreads; n++) {
 		struct stress *stress;
 		void (*fn)(struct work_struct *work);
@@ -556,9 +561,7 @@ static int stress(int nlocks, int nthreads, unsigned int flags)
 		if (!fn)
 			continue;
 
-		stress = kmalloc(sizeof(*stress), GFP_KERNEL);
-		if (!stress)
-			break;
+		stress = &stress_array[count++];
 
 		INIT_WORK(&stress->work, fn);
 		stress->locks = locks;
@@ -573,6 +576,7 @@ static int stress(int nlocks, int nthreads, unsigned int flags)
 
 	for (n = 0; n < nlocks; n++)
 		ww_mutex_destroy(&locks[n]);
+	kfree(stress_array);
 	kfree(locks);
 
 	return 0;
-- 
2.42.0



