Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAFC2F2375;
	Tue, 17 Jun 2025 16:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176021; cv=none; b=gMj8zk3t4ZXOYlM7CwBLiQzvpBepKrsh5U61Lz8mRpEKPcPpKt+Q3Q7lW61ldOvoY/sm6iFn6djpfPXKArsrc9Kf0gi9lkoG9APr63Kpzt5SKUd6Bl7O6Zllzbt+wKu6b7ohld6oj7blqJx0BcyMubqPYSUzlg51uFch9oXzA/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176021; c=relaxed/simple;
	bh=qLpyNS7sjXgpREz10xhMyCD4WhAOlppPSPf3OwGkGrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIojRH8/FL5faj51ND/qSzXb+pzZtLqOnHSOS8z5maZDTY+IDJ/DTBvZaA/SQ9fGvq6KqXM3p+jd3seeCq/we6VS+D6EZ9YEtbvgcz+RwwgD3K5UEREF8fM2khpnNvim7Zm49eHSkVxNUVQeqF6x+rXNcy/dONlhn4IzGO6ZmCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoVQBzyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoVQBzyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4F8C4CEF4;
	Tue, 17 Jun 2025 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176021;
	bh=qLpyNS7sjXgpREz10xhMyCD4WhAOlppPSPf3OwGkGrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoVQBzyUtuA4ipee9y8/K4iiF5ZjaJ6fiJtFFrLCYpMkjUODBdPM9gl9NJZC0uvVZ
	 bFtRJFCSGrCIpVfM5XfiRy+GkfWv0/7r3293S9D2cn00e6kKqW1WWY/Nlk/9Dwjhh6
	 azLmt72gqLY+NLKDspwyn1FxaZ1ADujCltyQ713M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Tritton <terry.tritton@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 144/780] selftests/seccomp: fix negative_ENOSYS tracer tests on arm32
Date: Tue, 17 Jun 2025 17:17:32 +0200
Message-ID: <20250617152457.371781705@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 53bf6a9c801f8..61acbd45ffaaf 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1629,14 +1629,8 @@ void teardown_trace_fixture(struct __test_metadata *_metadata,
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



