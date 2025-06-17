Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E991F2F234A;
	Tue, 17 Jun 2025 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175323; cv=none; b=PggvE91Q0EnmpaivJKtp70vhW9WD97Zj5Agt3bP4NTQXUOMiclzi+Ghmd04jPTyz38ZLs3DLNNrQNMyYRJ4sA7ifTicpCL9HJVfTfNMrLCPzaDEn7xvZMExd0kWtGjmnJS1Ex10qD8vN55wjWkwnqCryftoy8I64iJxESL/XDxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175323; c=relaxed/simple;
	bh=y5kBlYa1MC5SP7OzcAnKFlBYVm+NhAvDE3MYjsWJFIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TovgRIjKYKShBiN0zGnyMEWHHA5jgZgEfMyIBGSLXbrSaRVbKkySWYcV2KMggDSsN9qKeJMnvCN5kSSJElJEi0q7r73feL5K6D/T2pppj21plp4xm8FXdWsFLcj7tO9uB3HkNH5k66XieeWraSgIy7sn8FJAbSwuusIlSBB3tto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBMpGqw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBMpGqw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597F4C4CEE3;
	Tue, 17 Jun 2025 15:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175322;
	bh=y5kBlYa1MC5SP7OzcAnKFlBYVm+NhAvDE3MYjsWJFIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBMpGqw+hUQM1EfOEiPW6U6on+5Yg9IFCZ4gqUom477nUKjXmBUyf/0Rp5lqN2sgs
	 8OTO7iRkUy+HmNBl/Z0j5jhnAcnaAA9VXYJSpMv1i9V0qNXP5WeSTBX5NDmX5zef8g
	 fpfA1GL7bCsCGE79f30J5hzhsp0Cuawv2vIvKmkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/512] selftests/seccomp: fix negative_ENOSYS tracer tests on arm32
Date: Tue, 17 Jun 2025 17:21:03 +0200
Message-ID: <20250617152423.512368053@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Tritton <terry.tritton@linaro.org>

[ Upstream commit 73989c998814d82c71d523c104c398925470d59e ]

TRACE_syscall.ptrace.negative_ENOSYS and TRACE_syscall.seccomp.negative_ENOSYS
on arm32 are being reported as failures instead of skipping.

The teardown_trace_fixture function sets the test to KSFT_FAIL in case of a
non 0 return value from the tracer process.
Due to _metadata now being shared between the forked processes the tracer is
returning the KSFT_SKIP value set by the tracee which is non 0.

Remove the setting of the _metadata.exit_code in teardown_trace_fixture.

Fixes: 24cf65a62266 ("selftests/harness: Share _metadata between forked processes")
Signed-off-by: Terry Tritton <terry.tritton@linaro.org>
Link: https://lore.kernel.org/r/20250509115622.64775-1-terry.tritton@linaro.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index abc32e4352df3..60c84d935a2b0 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1618,14 +1618,8 @@ void teardown_trace_fixture(struct __test_metadata *_metadata,
 {
 	if (tracer) {
 		int status;
-		/*
-		 * Extract the exit code from the other process and
-		 * adopt it for ourselves in case its asserts failed.
-		 */
 		ASSERT_EQ(0, kill(tracer, SIGUSR1));
 		ASSERT_EQ(tracer, waitpid(tracer, &status, 0));
-		if (WEXITSTATUS(status))
-			_metadata->exit_code = KSFT_FAIL;
 	}
 }
 
-- 
2.39.5



