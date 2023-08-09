Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D2715AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5955C433C8;
	Wed,  9 Aug 2023 10:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578021;
	bh=+7xrCzg2jqH0q0/YVq5rnv//pL5Hjw01irjiVhjf4PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FElxd0lxK2f+vU46WjnwIS8gSACN1hlLQguaE3hZ56+YKRQqYY4RB7H6bUUcQeGEi
	 TbYmKkwTuP15aDNhLZ52Qb6UuJKkNx+UOAM4hJ4ufxcTYiWtmerxMxynR9YHUfIi23
	 CNnAwf+9eBxIVAV+P5wTr3JtIJjonYWVW5wW/8YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 078/165] selftest: net: Assert on a proper value in so_incoming_cpu.c.
Date: Wed,  9 Aug 2023 12:40:09 +0200
Message-ID: <20230809103645.353270435@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 3ff1617450eceb290ac17120fc172815e09a93cf ]

Dan Carpenter reported an error spotted by Smatch.

  ./tools/testing/selftests/net/so_incoming_cpu.c:163 create_clients()
  error: uninitialized symbol 'ret'.

The returned value of sched_setaffinity() should be checked with
ASSERT_EQ(), but the value was not saved in a proper variable,
resulting in an error above.

Let's save the returned value of with sched_setaffinity().

Fixes: 6df96146b202 ("selftest: Add test for SO_INCOMING_CPU.")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-kselftest/fe376760-33b6-4fc9-88e8-178e809af1ac@moroto.mountain/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230731181553.5392-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/so_incoming_cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/so_incoming_cpu.c b/tools/testing/selftests/net/so_incoming_cpu.c
index 0e04f9fef9867..a148181641026 100644
--- a/tools/testing/selftests/net/so_incoming_cpu.c
+++ b/tools/testing/selftests/net/so_incoming_cpu.c
@@ -159,7 +159,7 @@ void create_clients(struct __test_metadata *_metadata,
 		/* Make sure SYN will be processed on the i-th CPU
 		 * and finally distributed to the i-th listener.
 		 */
-		sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
+		ret = sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
 		ASSERT_EQ(ret, 0);
 
 		for (j = 0; j < CLIENT_PER_SERVER; j++) {
-- 
2.40.1



