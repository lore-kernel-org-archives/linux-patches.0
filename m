Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD16711C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BE7C433C7;
	Mon, 28 Aug 2023 10:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219764;
	bh=Z092d5NLjo7Ug59mMqxLITYylBl62zxmI8w5Fy2htLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHqNCATkOxTK/sSwX6OLKiFFLhKKbwYxNMrVPOeBJpCYunVL2idJqwjgntcXIhfH0
	 1LwU/z4Wrr9ZCdz8nxOLCUW2G5ie9UmQa4LHS0Vut7PgRTm3UeS1F29JYAw57EJ6I7
	 qCdGYw2zP/0X+rXYqP+M5YnV4dxXbxrkxYSyxPEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul McKenney <paulmck@kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Zhouyi Zhou <zhouzhouyi@gmail.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 5.10 63/84] torture: Fix hang during kthread shutdown phase
Date: Mon, 28 Aug 2023 12:14:20 +0200
Message-ID: <20230828101151.397401371@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -788,7 +788,7 @@ void torture_kthread_stopping(char *titl
 	VERBOSE_TOROUT_STRING(buf);
 	while (!kthread_should_stop()) {
 		torture_shutdown_absorb(title);
-		schedule_timeout_uninterruptible(1);
+		schedule_timeout_uninterruptible(HZ / 20);
 	}
 }
 EXPORT_SYMBOL_GPL(torture_kthread_stopping);


