Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026D22FC4E;
	Fri, 24 Nov 2023 18:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaJRF5RQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85476C433C8;
	Fri, 24 Nov 2023 18:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851251;
	bh=gBSRHvzzNXDxt/WLVhQSxGZzuOMinhYdHjaktU0LC1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaJRF5RQxeYoBFQ2N5zXjLL+jHOw6adk4rB0H2PfKCehZJqS6tU1BjkvFYIFCqnyQ
	 SGEHDKR56da8gIf4n5mrDTDaQ7fYVEywfnK0lS6FDQQEOWHHWQDgdtt9MqUoZXyNjv
	 aFNfQGozdrg6mGVlkcWNOEf9GY7NofBBKbSsVe3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	kernel-team@android.com,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 373/491] torture: Add a kthread-creation callback to _torture_create_kthread()
Date: Fri, 24 Nov 2023 17:50:09 +0000
Message-ID: <20231124172035.787391972@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 67d5404d274376890d6d095a10e6565854918f8e ]

This commit adds a kthread-creation callback to the
_torture_create_kthread() function, which allows callers of a new
torture_create_kthread_cb() macro to specify a function to be invoked
after the kthread is created but before it is awakened for the first time.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: kernel-team@android.com
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Acked-by: John Stultz <jstultz@google.com>
Stable-dep-of: cca42bd8eb1b ("rcutorture: Fix stuttering races and other issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/torture.h | 7 +++++--
 kernel/torture.c        | 6 +++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 7038104463e48..bb466eec01e42 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -108,12 +108,15 @@ bool torture_must_stop(void);
 bool torture_must_stop_irq(void);
 void torture_kthread_stopping(char *title);
 int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
-			     char *f, struct task_struct **tp);
+			     char *f, struct task_struct **tp, void (*cbf)(struct task_struct *tp));
 void _torture_stop_kthread(char *m, struct task_struct **tp);
 
 #define torture_create_kthread(n, arg, tp) \
 	_torture_create_kthread(n, (arg), #n, "Creating " #n " task", \
-				"Failed to create " #n, &(tp))
+				"Failed to create " #n, &(tp), NULL)
+#define torture_create_kthread_cb(n, arg, tp, cbf) \
+	_torture_create_kthread(n, (arg), #n, "Creating " #n " task", \
+				"Failed to create " #n, &(tp), cbf)
 #define torture_stop_kthread(n, tp) \
 	_torture_stop_kthread("Stopping " #n " task", &(tp))
 
diff --git a/kernel/torture.c b/kernel/torture.c
index 1a0519b836ac9..1da48f3816f61 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -926,7 +926,7 @@ EXPORT_SYMBOL_GPL(torture_kthread_stopping);
  * it starts, you will need to open-code your own.
  */
 int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
-			    char *f, struct task_struct **tp)
+			    char *f, struct task_struct **tp, void (*cbf)(struct task_struct *tp))
 {
 	int ret = 0;
 
@@ -938,6 +938,10 @@ int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
 		*tp = NULL;
 		return ret;
 	}
+
+	if (cbf)
+		cbf(*tp);
+
 	wake_up_process(*tp);  // Process is sleeping, so ordering provided.
 	torture_shuffle_task_register(*tp);
 	return ret;
-- 
2.42.0



