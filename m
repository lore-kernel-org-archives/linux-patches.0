Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DBBF9E1
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB451C433C8;
	Mon, 11 Sep 2023 14:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442801;
	bh=vfvCvHA7+BFf7bkTP5O73ZyMqE6Z8+fSQvIFzqiVDSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIl77r7t2/LWmOQxEQdI+obv9DGbcTsR1Gnv6TM1CiBMmlH2RiaPfFkVewSLqXt+C
	 yOjr9136n5sIMLZm9A8h6w2amMsFBtQQ8jgvBY1klvNlSBnH9UwIiwB6k/CoMxu9nH
	 REuvLxB4DftvGex3ewJwwxD8wpV+q36nNtLYcB9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nysal Jan K.A" <nysal@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 125/737] selftests/futex: Order calls to futex_lock_pi
Date: Mon, 11 Sep 2023 15:39:44 +0200
Message-ID: <20230911134653.995986374@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3651ce17beeb9..d183f878360bc 100644
--- a/tools/testing/selftests/futex/functional/futex_wait_timeout.c
+++ b/tools/testing/selftests/futex/functional/futex_wait_timeout.c
@@ -24,6 +24,7 @@
 
 static long timeout_ns = 100000;	/* 100us default timeout */
 static futex_t futex_pi;
+static pthread_barrier_t barrier;
 
 void usage(char *prog)
 {
@@ -48,6 +49,8 @@ void *get_pi_lock(void *arg)
 	if (ret != 0)
 		error("futex_lock_pi failed\n", ret);
 
+	pthread_barrier_wait(&barrier);
+
 	/* Blocks forever */
 	ret = futex_wait(&lock, 0, NULL, 0);
 	error("futex_wait failed\n", ret);
@@ -130,6 +133,7 @@ int main(int argc, char *argv[])
 	       basename(argv[0]));
 	ksft_print_msg("\tArguments: timeout=%ldns\n", timeout_ns);
 
+	pthread_barrier_init(&barrier, NULL, 2);
 	pthread_create(&thread, NULL, get_pi_lock, NULL);
 
 	/* initialize relative timeout */
@@ -163,6 +167,9 @@ int main(int argc, char *argv[])
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



