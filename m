Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647C92ECE94;
	Tue, 17 Jun 2025 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175837; cv=none; b=YUWHLWu/o/W0NPkQkwX8oy0qoTtPks8gchdgt7BzzPqxc/y17/PM+q0U/8v1vjBD3aDI7Fe7YUbgLtObe1WmLo0aMLnxo4kpyP25DBWW3eq2uI1iyOY9MA/CBYr9/tsJkjkLVz0l0k4cRQvkknGnauWOuddTKxChdel3HAS7BqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175837; c=relaxed/simple;
	bh=+5Gtjn8DbwxtcszkNbyt2IkqKQcHWS+WcJbRHYxLtvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/iu4pEawY/DOnyVN3C791d4XjKKUeoFwXbXgDDe0GfNLoppqduAhT4QhFqOm1x/EnTCnExseckL5ufM0UaViTspe7wYniifS2pLQsGs4txKXi8UcEZZlsbR3Fb0FMu5VI7X06OHbaljbFZ3WyaFf1vD4hUKQG5Fk2IhFn3vE8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLEIQTd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLEIQTd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E158CC4CEE3;
	Tue, 17 Jun 2025 15:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175837;
	bh=+5Gtjn8DbwxtcszkNbyt2IkqKQcHWS+WcJbRHYxLtvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLEIQTd/vL52anvldWzn3+INpemI70nSuLeqgezXtpcnW9945ebbUXYpJBA4Xai3y
	 CeHpLikljHmp291oWvltLU5utL23AW8gJVKTHFSMYjyqBxNmrSPz+pzLtPc7Jc/MZw
	 USf4TBe3zaVJ8B6OcU5A/hIqoVeqP5/VK5qvojKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neill Kapron <nkapron@google.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 127/780] selftests/seccomp: fix syscall_restart test for arm compat
Date: Tue, 17 Jun 2025 17:17:15 +0200
Message-ID: <20250617152456.680576057@linuxfoundation.org>
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

From: Neill Kapron <nkapron@google.com>

[ Upstream commit 797002deed03491215a352ace891749b39741b69 ]

The inconsistencies in the systcall ABI between arm and arm-compat can
can cause a failure in the syscall_restart test due to the logic
attempting to work around the differences. The 'machine' field for an
ARM64 device running in compat mode can report 'armv8l' or 'armv8b'
which matches with the string 'arm' when only examining the first three
characters of the string.

This change adds additional validation to the workaround logic to make
sure we only take the arm path when running natively, not in arm-compat.

Fixes: 256d0afb11d6 ("selftests/seccomp: build and pass on arm64")
Signed-off-by: Neill Kapron <nkapron@google.com>
Link: https://lore.kernel.org/r/20250427094103.3488304-2-nkapron@google.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index b2f76a52215ad..53bf6a9c801f8 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3166,12 +3166,15 @@ TEST(syscall_restart)
 	ret = get_syscall(_metadata, child_pid);
 #if defined(__arm__)
 	/*
-	 * FIXME:
 	 * - native ARM registers do NOT expose true syscall.
 	 * - compat ARM registers on ARM64 DO expose true syscall.
+	 * - values of utsbuf.machine include 'armv8l' or 'armb8b'
+	 *   for ARM64 running in compat mode.
 	 */
 	ASSERT_EQ(0, uname(&utsbuf));
-	if (strncmp(utsbuf.machine, "arm", 3) == 0) {
+	if ((strncmp(utsbuf.machine, "arm", 3) == 0) &&
+	    (strncmp(utsbuf.machine, "armv8l", 6) != 0) &&
+	    (strncmp(utsbuf.machine, "armv8b", 6) != 0)) {
 		EXPECT_EQ(__NR_nanosleep, ret);
 	} else
 #endif
-- 
2.39.5



