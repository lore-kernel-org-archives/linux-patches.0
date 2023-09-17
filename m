Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F276FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C38DC433CC;
	Sun, 17 Sep 2023 20:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981564;
	bh=xBbZEOyj9VcpV/RCbkEdbLY+tg635D8puTW+lJY0jCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuRfuQL676GroMIy+0Msybpxj/25xGw566G0FMGqzM9BUD7YdbhEmZyrtxh2R0Gd3
	 faF3CX0XE2i1xEIdlGbBRcC4p9KIfrHZnZnW4rm3PWZ7j0sySUOIgZLJ/vX11LYRxD
	 fuLanQmyGYF8UURlggSB9au3sLG19wuVQkRwl5O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nysal Jan K.A" <nysal@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/511] selftests/futex: Order calls to futex_lock_pi
Date: Sun, 17 Sep 2023 21:08:19 +0200
Message-ID: <20230917191115.618123281@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Nysal Jan K.A <nysal@linux.ibm.com>

[ Upstream commit fbf4dec702774286db409815ffb077711a96b824 ]

Observed occassional failures in the futex_wait_timeout test:

ok 1 futex_wait relative succeeds
ok 2 futex_wait_bitset realtime succeeds
ok 3 futex_wait_bitset monotonic succeeds
ok 4 futex_wait_requeue_pi realtime succeeds
ok 5 futex_wait_requeue_pi monotonic succeeds
not ok 6 futex_lock_pi realtime returned 0
......

The test expects the child thread to complete some steps before
the parent thread gets to run. There is an implicit expectation
of the order of invocation of futex_lock_pi between the child thread
and the parent thread. Make this order explicit. If the order is
not met, the futex_lock_pi call in the parent thread succeeds and
will not timeout.

Fixes: f4addd54b161 ("selftests: futex: Expand timeout test")
Signed-off-by: Nysal Jan K.A <nysal@linux.ibm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/futex/functional/futex_wait_timeout.c        | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/futex/functional/futex_wait_timeout.c b/tools/testing/selftests/futex/functional/futex_wait_timeout.c
index 1f8f6daaf1e70..86ac205ea8e18 100644
--- a/tools/testing/selftests/futex/functional/futex_wait_timeout.c
+++ b/tools/testing/selftests/futex/functional/futex_wait_timeout.c
@@ -23,6 +23,7 @@
 
 static long timeout_ns = 100000;	/* 100us default timeout */
 static futex_t futex_pi;
+static pthread_barrier_t barrier;
 
 void usage(char *prog)
 {
@@ -47,6 +48,8 @@ void *get_pi_lock(void *arg)
 	if (ret != 0)
 		error("futex_lock_pi failed\n", ret);
 
+	pthread_barrier_wait(&barrier);
+
 	/* Blocks forever */
 	ret = futex_wait(&lock, 0, NULL, 0);
 	error("futex_wait failed\n", ret);
@@ -123,6 +126,7 @@ int main(int argc, char *argv[])
 	       basename(argv[0]));
 	ksft_print_msg("\tArguments: timeout=%ldns\n", timeout_ns);
 
+	pthread_barrier_init(&barrier, NULL, 2);
 	pthread_create(&thread, NULL, get_pi_lock, NULL);
 
 	/* initialize relative timeout */
@@ -156,6 +160,9 @@ int main(int argc, char *argv[])
 	res = futex_wait_requeue_pi(&f1, f1, &futex_pi, &to, 0);
 	test_timeout(res, &ret, "futex_wait_requeue_pi monotonic", ETIMEDOUT);
 
+	/* Wait until the other thread calls futex_lock_pi() */
+	pthread_barrier_wait(&barrier);
+	pthread_barrier_destroy(&barrier);
 	/*
 	 * FUTEX_LOCK_PI with CLOCK_REALTIME
 	 * Due to historical reasons, FUTEX_LOCK_PI supports only realtime
-- 
2.40.1



