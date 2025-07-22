Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A33C1DF991;
	Tue, 22 Jul 2025 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192607; cv=none; b=esh3BUBNduRTFN6ZtWXUYO7crd88z/UWszUugfFtlSqdFaPA4jN4kQ7omA9szktE51fAwjcBfw3wOqiH0xvZ5PjCL8CuhMzvogzqsWsuG3WJXZ079Jhy/IozMkGe7H3+BORwq5j5iNbzDeCkqXMmzNgMbA7RxK+8jdFgm783cuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192607; c=relaxed/simple;
	bh=jky8xJodTtgMP/csX2ecfwPB0uC3gtjYgsruZaLyA7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So7OT7pcjDHC2epbx8nl9m50NGr4RdcJCU5kM+i6oc+7LellEGxeCQReZwn/09j/+A9dcy3ok6kmK3b+7u5V9mwoSqmWP+5I29PikEmg/fOiFF7GMOZ/ugU4OMrs1D0m0hc419m8MZDwxmC+0HBbAOV+QyS/S6PY02v1GpLiP8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxbe3Oij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxbe3Oij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2209C4CEF1;
	Tue, 22 Jul 2025 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192607;
	bh=jky8xJodTtgMP/csX2ecfwPB0uC3gtjYgsruZaLyA7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxbe3OijGXAh5ypIO0uWdU633SkAS7Kbt8rr7e8rDYfP6TwpIIXKuuBJa6kOFPcC5
	 vgY9fp8A147syDVZq7MC673sGGNY2Nx88iJv+wT0e/lPhq31ZO9VxxQwmPnQVG6v4D
	 7YDTHInkoni9CYl32LvZgvhILPGf8z6+dObJVK+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 109/111] Revert "selftests/bpf: dummy_st_ops should reject 0 for non-nullable params"
Date: Tue, 22 Jul 2025 15:45:24 +0200
Message-ID: <20250722134337.481914175@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

This reverts commit e7d193073a223663612301c659e53795b991ca89 which is
commit 6a2d30d3c5bf9f088dcfd5f3746b04d84f2fab83 upstream.

The dummy_st_ops/dummy_sleepable_reject_null test requires commit 980ca8ceeae6
("bpf: check bpf_dummy_struct_ops program params for test runs"), which in turn
depends on "Support PTR_MAYBE_NULL for struct_ops arguments" series (see link
below), neither are backported to stable 6.6.

Link: https://lore.kernel.org/all/20240209023750.1153905-1-thinker.li@gmail.com/
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c |   27 ------------------
 1 file changed, 27 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
+++ b/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
@@ -147,31 +147,6 @@ static void test_dummy_sleepable(void)
 	dummy_st_ops_success__destroy(skel);
 }
 
-/* dummy_st_ops.test_sleepable() parameter is not marked as nullable,
- * thus bpf_prog_test_run_opts() below should be rejected as it tries
- * to pass NULL for this parameter.
- */
-static void test_dummy_sleepable_reject_null(void)
-{
-	__u64 args[1] = {0};
-	LIBBPF_OPTS(bpf_test_run_opts, attr,
-		.ctx_in = args,
-		.ctx_size_in = sizeof(args),
-	);
-	struct dummy_st_ops_success *skel;
-	int fd, err;
-
-	skel = dummy_st_ops_success__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "dummy_st_ops_load"))
-		return;
-
-	fd = bpf_program__fd(skel->progs.test_sleepable);
-	err = bpf_prog_test_run_opts(fd, &attr);
-	ASSERT_EQ(err, -EINVAL, "test_run");
-
-	dummy_st_ops_success__destroy(skel);
-}
-
 void test_dummy_st_ops(void)
 {
 	if (test__start_subtest("dummy_st_ops_attach"))
@@ -184,8 +159,6 @@ void test_dummy_st_ops(void)
 		test_dummy_multiple_args();
 	if (test__start_subtest("dummy_sleepable"))
 		test_dummy_sleepable();
-	if (test__start_subtest("dummy_sleepable_reject_null"))
-		test_dummy_sleepable_reject_null();
 
 	RUN_TESTS(dummy_st_ops_fail);
 }


