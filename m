Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D116522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46297C433C7;
	Sun,  9 Jul 2023 11:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901658;
	bh=ALvr9tLwj8dOZCytRoKNxeEaPiDWIBOBbpWktg0oKv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvmBKDAzAYdcFRRuIy5lDxthc9oumEsydtOZ+9iuVCKULTQV160Tj5dRRJKhyTird
	 mD+eCpuMCw9QUUgWIVDXarFQ6/QAD6b1zX/l5vMYbE9p2xTB3i5G8a69VKqbfGze9q
	 Py8Cu89ABQ8OKOEu+mthgI+JkUn0emHi2lvcd11s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <yujie.liu@intel.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 061/431] rcuscale: Move shutdown from wait_event() to wait_event_idle()
Date: Sun,  9 Jul 2023 13:10:09 +0200
Message-ID: <20230709111452.570455803@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit ef1ef3d47677dc191b88650a9f7f91413452cc1b ]

The rcu_scale_shutdown() and kfree_scale_shutdown() kthreads/functions
use wait_event() to wait for the rcuscale test to complete.  However,
each updater thread in such a test waits for at least 100 grace periods.
If each grace period takes more than 1.2 seconds, which is long, but
not insanely so, this can trigger the hung-task timeout.

This commit therefore replaces those wait_event() calls with calls to
wait_event_idle(), which do not trigger the hung-task timeout.

Reported-by: kernel test robot <yujie.liu@intel.com>
Reported-by: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Yujie Liu <yujie.liu@intel.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: 23fc8df26dea ("rcu/rcuscale: Stop kfree_scale_thread thread(s) after unloading rcuscale")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuscale.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/rcuscale.c b/kernel/rcu/rcuscale.c
index 91fb5905a008f..4120f94030c3c 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -631,8 +631,7 @@ static int compute_real(int n)
 static int
 rcu_scale_shutdown(void *arg)
 {
-	wait_event(shutdown_wq,
-		   atomic_read(&n_rcu_scale_writer_finished) >= nrealwriters);
+	wait_event_idle(shutdown_wq, atomic_read(&n_rcu_scale_writer_finished) >= nrealwriters);
 	smp_mb(); /* Wake before output. */
 	rcu_scale_cleanup();
 	kernel_power_off();
@@ -771,8 +770,8 @@ kfree_scale_cleanup(void)
 static int
 kfree_scale_shutdown(void *arg)
 {
-	wait_event(shutdown_wq,
-		   atomic_read(&n_kfree_scale_thread_ended) >= kfree_nrealthreads);
+	wait_event_idle(shutdown_wq,
+			atomic_read(&n_kfree_scale_thread_ended) >= kfree_nrealthreads);
 
 	smp_mb(); /* Wake before output. */
 
-- 
2.39.2



