Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE251DDA15;
	Wed,  6 Nov 2024 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896298; cv=none; b=dgS3IZSuhEnFUaRzvwPwvV48x0nch9qs79DmymK21KcCaWVoPZQbuNwg6tXuXQ3q2WuVk8gQMJUW1S0OpYpMMSdyQtO5jSCJ6QL+CQ2ej+OuRSv5cHf9QdGD1eKkgFVAUUwwcQCm59OBArcDtjZ9+PI/2yDIPiJyYSghPfTxdo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896298; c=relaxed/simple;
	bh=vDOK5SYWJONzcaG1mSJYuak3Ljzo0uFahVoljiDRcLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9VVdXA7IhH+gq4RnOMLb8hkDssLrs342jV2lKLgiqR3tSlkuPssXfpGZKMdaf7GXbLE55gV28s3cKep/EmnYDecQohyjujhgI9azEtN6Cvz3dRMTBPlLlWTYiMjETH6y1PDeYif2Iv9RGrnlrk2StjiBXsZZnQszeyueKZq8A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJyDQeer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJyDQeer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A9FC4CECD;
	Wed,  6 Nov 2024 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896297;
	bh=vDOK5SYWJONzcaG1mSJYuak3Ljzo0uFahVoljiDRcLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJyDQeer4GzRRABpS+GniN0o4PhmQhmV4bBxyvciqxtBJMEbIHBZYZQuGQAvKBYEP
	 XXJl1X+JnwZhTQPxy/xQisxneAFP8dR0fJFw2903bf2W7u4Dz+JzP7BRIQhwAPQpEV
	 Ut+tq3zstXmaVGLPx6zEgc2UtFFLDu379+8Y/BLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 120/245] Revert "selftests/mm: fix deadlock for fork after pthread_create on ARM"
Date: Wed,  6 Nov 2024 13:02:53 +0100
Message-ID: <20241106120322.175711173@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -241,9 +241,6 @@ static void *fork_event_consumer(void *d
 	fork_event_args *args = data;
 	struct uffd_msg msg = { 0 };
 
-	/* Ready for parent thread to fork */
-	pthread_barrier_wait(&ready_for_fork);
-
 	/* Read until a full msg received */
 	while (uffd_read_msg(args->parent_uffd, &msg));
 
@@ -311,12 +308,8 @@ static int pagemap_test_fork(int uffd, b
 
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


