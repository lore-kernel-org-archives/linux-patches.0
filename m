Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA8D1F4FB0;
	Mon, 21 Oct 2024 10:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507014; cv=none; b=iSCt76cbhqKzVW7VCw96dMcq45dSda7cG7Op9ZiTDAFdB78ihdUIOwgKWVAMm8TQZpEr2XltWk8XHFqFMIAQ1akw83tqPLNzffgyUVnG4vhOHRM6xn1Tftz6EnU2fXxt1/yijQ0N9UGUZkbd0f1guyCB589G9rwrXF0WPi7RcNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507014; c=relaxed/simple;
	bh=fzLEba1XYABICshWu+p5m07qK08WnnV72VnC2rKTZmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuolF1zYY6LD6H1Zc6Xtxr8vv8XCst4M4KvU9u3l2Hjh1z10p3DTCK/bAixCnNPlEf0QGT3BcsTCwwN+PSUOPsMnTW1iBOCNPgkrZ+AXx3m027bzxqm73T1AOIYNut7dWBfNIQHCvvwXZOrIkL/tZqmqfrXyuIbKtI2GhmaORGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTPkfVF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTPkfVF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE65C4CEE7;
	Mon, 21 Oct 2024 10:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507013;
	bh=fzLEba1XYABICshWu+p5m07qK08WnnV72VnC2rKTZmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTPkfVF7OA5EyTcEg3zAH3aFC5Bh32r3CCOTgXMnVIjdXmlNmQ9gmGZjh4yy7116/
	 /Ulh6/S9bRODB3EIPFqin7KvCniFCxNva3shS/LLgd+iJh5svqHWwTUya5I4lBMoVV
	 VqLp6n3jcCjsjYL+I+Di735EWDTJHhog9GYEciIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 020/124] selftests/mm: fix deadlock for fork after pthread_create on ARM
Date: Mon, 21 Oct 2024 12:23:44 +0200
Message-ID: <20241021102257.505196777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

commit e142cc87ac4ec618f2ccf5f68aedcd6e28a59d9d upstream.

On Android with arm, there is some synchronization needed to avoid a
deadlock when forking after pthread_create.

Link: https://lkml.kernel.org/r/20241003211716.371786-3-edliaw@google.com
Fixes: cff294582798 ("selftests/mm: extend and rename uffd pagemap test")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -237,6 +237,9 @@ static void *fork_event_consumer(void *d
 	fork_event_args *args = data;
 	struct uffd_msg msg = { 0 };
 
+	/* Ready for parent thread to fork */
+	pthread_barrier_wait(&ready_for_fork);
+
 	/* Read until a full msg received */
 	while (uffd_read_msg(args->parent_uffd, &msg));
 
@@ -304,8 +307,12 @@ static int pagemap_test_fork(int uffd, b
 
 	/* Prepare a thread to resolve EVENT_FORK */
 	if (with_event) {
+		pthread_barrier_init(&ready_for_fork, NULL, 2);
 		if (pthread_create(&thread, NULL, fork_event_consumer, &args))
 			err("pthread_create()");
+		/* Wait for child thread to start before forking */
+		pthread_barrier_wait(&ready_for_fork);
+		pthread_barrier_destroy(&ready_for_fork);
 	}
 
 	child = fork();


