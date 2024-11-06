Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A2C1EF080;
	Wed,  6 Nov 2024 12:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897545; cv=none; b=LkKW3M1jPLfL0BIgnMICXgm7TW8QxPM+J5Rs/dVoCODyorw8dGq+HgKiLvDwe6MS8FA2A5SdFswzIVZj6sin8HQ6LoTidA5w8fKLPrShK7mFdaIAAt/g9K6Vpl3b13fahC44APIj8RZsBiY4CeNxxhN8manher1Opk/T6glO81I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897545; c=relaxed/simple;
	bh=0kzl131ivLMwKJgew6enX+op9w6Z6h9p1IveNeNsfzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0Zqph3xoU5UZcaogNKuZ5jHyv02RPPb2rqJxwmjyGq5V1rqsp2OD9R7GjfwCvecy8zgu6W7f6q38jh57P/BV2NijcUFepBar2gBnHbQTV6/lai1Dk6ipqkv9WC3eZPoXFOJ+66ybHLas/GaplUTT5VWPpzJs5y0c/iYB+Fe/h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Iy1fWnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Iy1fWnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE4BC4CECD;
	Wed,  6 Nov 2024 12:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897545;
	bh=0kzl131ivLMwKJgew6enX+op9w6Z6h9p1IveNeNsfzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Iy1fWnnkwDLO4dAKgUC7/BoXNvUnxLnICn2B2l8n7FD/d6kH0nX1ENfHQUIV1vU/
	 ChvR1X/CTFT0+ij5Nc1xkPpmmnr3QcMbQwX42irB7nJMVv4PW8B/o3D/NFazioYLxy
	 16U68DOVbJuJTyRjmTJEZH3+e1lNVjBIEMrdkIF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 090/151] Revert "selftests/mm: fix deadlock for fork after pthread_create on ARM"
Date: Wed,  6 Nov 2024 13:04:38 +0100
Message-ID: <20241106120311.351226183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Edward Liaw <edliaw@google.com>

commit 5bb1f4c9340e01003b00b94d539eadb0da88f48e upstream.

Patch series "selftests/mm: revert pthread_barrier change"

On Android arm, pthread_create followed by a fork caused a deadlock in
the case where the fork required work to be completed by the created
thread.

The previous patches incorrectly assumed that the parent would
always initialize the pthread_barrier for the child thread.  This
reverts the change and replaces the fix for wp-fork-with-event with the
original use of atomic_bool.


This patch (of 3):

This reverts commit e142cc87ac4ec618f2ccf5f68aedcd6e28a59d9d.

fork_event_consumer may be called by other tests that do not initialize
the pthread_barrier, so this approach is not correct.  The subsequent
patch will revert to using atomic_bool instead.

Link: https://lkml.kernel.org/r/20241018171734.2315053-1-edliaw@google.com
Link: https://lkml.kernel.org/r/20241018171734.2315053-2-edliaw@google.com
Fixes: e142cc87ac4e ("fix deadlock for fork after pthread_create on ARM")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -237,9 +237,6 @@ static void *fork_event_consumer(void *d
 	fork_event_args *args = data;
 	struct uffd_msg msg = { 0 };
 
-	/* Ready for parent thread to fork */
-	pthread_barrier_wait(&ready_for_fork);
-
 	/* Read until a full msg received */
 	while (uffd_read_msg(args->parent_uffd, &msg));
 
@@ -307,12 +304,8 @@ static int pagemap_test_fork(int uffd, b
 
 	/* Prepare a thread to resolve EVENT_FORK */
 	if (with_event) {
-		pthread_barrier_init(&ready_for_fork, NULL, 2);
 		if (pthread_create(&thread, NULL, fork_event_consumer, &args))
 			err("pthread_create()");
-		/* Wait for child thread to start before forking */
-		pthread_barrier_wait(&ready_for_fork);
-		pthread_barrier_destroy(&ready_for_fork);
 	}
 
 	child = fork();


