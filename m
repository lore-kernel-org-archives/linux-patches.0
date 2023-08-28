Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C1311C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A79CC433C7;
	Mon, 28 Aug 2023 10:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219542;
	bh=MWghyhnyl92tvQoALg4AsuxMi9fq1qcrzsxk0imtp+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwj09xUGplHwL3lfo8SbjUi4bMq3gnqxPi2C+a3v0kWmKui9FJKgkZvkakohfQ5G7
	 dv6d5DzKLuBbEvkYkizPFJIdOV179HLqRK9yVASqkVEpoBMWzdinx1IlKXxwIvnxUJ
	 HC6vf4GGvrfEECubNWSnMXWoUwtuabWTBr+ZPfXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul McKenney <paulmck@kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Zhouyi Zhou <zhouzhouyi@gmail.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 5.15 73/89] torture: Fix hang during kthread shutdown phase
Date: Mon, 28 Aug 2023 12:14:14 +0200
Message-ID: <20230828101152.657057854@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
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

From: Joel Fernandes (Google) <joel@joelfernandes.org>

commit d52d3a2bf408ff86f3a79560b5cce80efb340239 upstream.

During rcutorture shutdown, the rcu_torture_cleanup() function calls
torture_cleanup_begin(), which sets the fullstop global variable to
FULLSTOP_RMMOD. This causes the rcutorture threads for readers and
fakewriters to exit all of their "while" loops and start shutting down.

They then call torture_kthread_stopping(), which in turn waits for
kthread_stop() to be called.  However, rcu_torture_cleanup() has
not yet called kthread_stop() on those threads, and before it gets a
chance to do so, multiple instances of torture_kthread_stopping() invoke
schedule_timeout_interruptible(1) in a tight loop.  Tracing confirms that
TIMER_SOFTIRQ can then continuously execute timer callbacks.  If that
TIMER_SOFTIRQ preempts the task executing rcu_torture_cleanup(), that
task might never invoke kthread_stop().

This commit improves this situation by increasing the timeout passed to
schedule_timeout_interruptible() from one jiffy to 1/20th of a second.
This change prevents TIMER_SOFTIRQ from monopolizing its CPU, thus
allowing rcu_torture_cleanup() to carry out the needed kthread_stop()
invocations.  Testing has shown 100 runs of TREE07 passing reliably,
as oppose to the tens-of-percent failure rates seen beforehand.

Cc: Paul McKenney <paulmck@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Tested-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/torture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -915,7 +915,7 @@ void torture_kthread_stopping(char *titl
 	VERBOSE_TOROUT_STRING(buf);
 	while (!kthread_should_stop()) {
 		torture_shutdown_absorb(title);
-		schedule_timeout_uninterruptible(1);
+		schedule_timeout_uninterruptible(HZ / 20);
 	}
 }
 EXPORT_SYMBOL_GPL(torture_kthread_stopping);


