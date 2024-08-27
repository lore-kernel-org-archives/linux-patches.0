Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE6C1C5783;
	Tue, 27 Aug 2024 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770536; cv=none; b=fdKn5iksKC1GYzNopWYAmBiRmtqSSIOt33pTK9xhlEHCX/FOF4bQzFUMJJynYpItyaDB3S5xinjMb9DHw9s+ro/B85BobRj4YU2dIh0yB6dJSTZ4FlAFaNYShCrlclaQyfaaWvzMJ7S/EmYr2BLUPj7ika+Nhg6FsYGKjLSwSGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770536; c=relaxed/simple;
	bh=1E34GTEh5bkvwkJOZETrfZ2QIQGsHFdr+TUAcbV0GkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1tTSApUsD7Ix2IsZ3DWJrtL+s3GCWxvUsSFtO8k1a5C/ZaDCVteYCpgVaFjKUHUuQGHYgZLJeNhJI8a9pXEEY64T023S8wtHUTfDjkNtrenH5TgHpB/3hw/qFZJL9EaaQ/ehxtb0VcsHrmSN3/1yiN+mIJDOpWnn3QE6bb7CNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLJfbY62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLJfbY62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877EEC4E698;
	Tue, 27 Aug 2024 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770535;
	bh=1E34GTEh5bkvwkJOZETrfZ2QIQGsHFdr+TUAcbV0GkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLJfbY62jlHYmzpkQclMR/JinF+kd9dI3a0YRYuPnScW7kpOzA43FQfBPjWLoYiKc
	 BbrpQvRcaieU0k0QnyrMIlCTt6V99eHPDyCUPvBjtm4E0Arz1/ialuL8y/IWFHnnYE
	 BWvX+UCWz3y3OOnWubKwW2vD1rAbs3Ka7CplD8T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Itaru Kitayama <itaru.kitayama@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/341] tools/testing/selftests/mm/run_vmtests.sh: lower the ptrace permissions
Date: Tue, 27 Aug 2024 16:37:38 +0200
Message-ID: <20240827143852.050709895@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Itaru Kitayama <itaru.kitayama@linux.dev>

[ Upstream commit 2ffc27b15b11c9584ac46335c2ed2248d2aa4137 ]

On Ubuntu and probably other distros, ptrace permissions are tightend a
bit by default; i.e., /proc/sys/kernel/yama/ptrace_score is set to 1.
This cases memfd_secret's ptrace attach test fails with a permission
error.  Set it to 0 piror to running the program.

Link: https://lkml.kernel.org/r/20231030-selftest-v1-1-743df68bb996@linux.dev
Signed-off-by: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7c5e8d212d7d ("selftests: memfd_secret: don't build memfd_secret test on unsupported arches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/run_vmtests.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 3e2bc818d566f..7d31718ce8343 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -303,6 +303,7 @@ CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
 CATEGORY="memfd_secret" run_test ./memfd_secret
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
-- 
2.43.0



