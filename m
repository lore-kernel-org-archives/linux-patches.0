Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4AA1E1C11;
	Mon, 21 Oct 2024 10:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506504; cv=none; b=RtR8+uBy0j8SWiUmGxTf+gjF+Fn5sVcl3ZWXpfDoH9FxRvAj58Gr5vj9opgTkUE2E0nffwuPWbXjl7+RVpOmA/IvZf6tTeSdqqyRfvxFNBETjkO8GRcv8AgvHFg6Ez7UNBm7L2oXfIuJxjx5Nffm64e2l3NMVqXtBnyRvIX3v/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506504; c=relaxed/simple;
	bh=5FHWwjaAhNRl7QznjSGKzqygG3BQ+orx/k+HwOCTFU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6+oCkaoffKczjJjQdr5DXDO7MaCBmNAPRms/AeFX1TPOt6TY47gdjdjuvgk82lTuuOuI2SyMPMJqq8orwhanyh8chNFRWDQwwjmXYo4sqc8dBSObXEdWjwRgo4GQx8i4vpkWP07dN8lCb7vwOFykWiuKLJP8Yp7kAzgEpKgki4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvG0D2f/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvG0D2f/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE83DC4CEC3;
	Mon, 21 Oct 2024 10:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506504;
	bh=5FHWwjaAhNRl7QznjSGKzqygG3BQ+orx/k+HwOCTFU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvG0D2f/V/Pe0djFf01Muf+caATC8fcZ4ovJzlQXS3ELicx4b8bwUWfP3ckAebViD
	 kb2mQH/hXQVXaSDe63lIswoqjMMxU0oOPl1xKz5pEGpjTac/WpLWllf9qvBqfbv8nr
	 u8cg3gnc6a+mS7CReJsv8c3J/hV2Jiz3LxaA9NK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Liaw <edliaw@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 026/135] selftests/mm: fix deadlock for fork after pthread_create on ARM
Date: Mon, 21 Oct 2024 12:23:02 +0200
Message-ID: <20241021102300.359222525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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
@@ -241,6 +241,9 @@ static void *fork_event_consumer(void *d
 	fork_event_args *args = data;
 	struct uffd_msg msg = { 0 };
 
+	/* Ready for parent thread to fork */
+	pthread_barrier_wait(&ready_for_fork);
+
 	/* Read until a full msg received */
 	while (uffd_read_msg(args->parent_uffd, &msg));
 
@@ -308,8 +311,12 @@ static int pagemap_test_fork(int uffd, b
 
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


