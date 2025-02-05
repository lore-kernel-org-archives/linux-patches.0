Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F5115198D;
	Wed,  5 Feb 2025 14:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764127; cv=none; b=c+WmKfYN2Q6eDxR+bnCPoe0YSRsPkEIsrVKML14ics+Q1THH1m/YkDX/207QdFr/1PS9HYAa3NiI41E4TawXSn7jXA7RYzh0e9tadBHk617HtrgDc00Kz4zbXS4WYbkkgr/j3Qbn3N+bxnhRodAq3zej8LAgs1BTiD4JnfSp04M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764127; c=relaxed/simple;
	bh=aMV2d9QLE8MvgYigmgYE80cq7mC+vC4UzK6YfJ5E3hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYvmL3py2JzGN6zBHjx1thcLd+y/K98BHdf8e4aEiX4zVukVU2Iy3IVEHZ2EM+B3XcSPpyv3CioCpgKUkgOVAF/e4j+RTxn8FolJviqT5cyAMzdjnz9gAqox27J1ZSaZdfYjgKAWy0Vmwo+KUgMuDj6Xwk6jt2DEZq6SYb5y9a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ru7G5cGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ru7G5cGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05152C4CED1;
	Wed,  5 Feb 2025 14:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764127;
	bh=aMV2d9QLE8MvgYigmgYE80cq7mC+vC4UzK6YfJ5E3hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ru7G5cGqhlUmrovgKVZR6qnZjMqqyaI7D1V4/ysYuvbOJlBmJd8XP78CUP/DXgRWz
	 4cZJDGWGT44nAe37NFE3duu6NfohHNF2cEt233TZFKEx6JyIgm1DOtEkA2nOzux5E2
	 1Kj99VH9r541V3Jrym9ycnQo918B/Yx3zm7xP+3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dmitry V. Levin" <ldv@strace.io>,
	Kees Cook <kees@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/393] selftests: harness: fix printing of mismatch values in __EXPECT()
Date: Wed,  5 Feb 2025 14:40:52 +0100
Message-ID: <20250205134425.385509958@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Dmitry V. Levin <ldv@strace.io>

[ Upstream commit 02bc220dc6dc7c56edc4859bc5dd2c08b95d5fb5 ]

intptr_t and uintptr_t are not big enough types on 32-bit architectures
when printing 64-bit values, resulting to the following incorrect
diagnostic output:

  # get_syscall_info.c:209:get_syscall_info:Expected exp_args[2] (3134324433) == info.entry.args[1] (3134324433)

Replace intptr_t and uintptr_t with intmax_t and uintmax_t, respectively.
With this fix, the same test produces more usable diagnostic output:

  # get_syscall_info.c:209:get_syscall_info:Expected exp_args[2] (3134324433) == info.entry.args[1] (18446744072548908753)

Link: https://lore.kernel.org/r/20250108170757.GA6723@strace.io
Fixes: b5bb6d3068ea ("selftests/seccomp: fix 32-bit build warnings")
Signed-off-by: Dmitry V. Levin <ldv@strace.io>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 24 ++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index e05ac82610467..878aac3b5ed54 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -710,33 +710,33 @@
 		/* Report with actual signedness to avoid weird output. */ \
 		switch (is_signed_type(__exp) * 2 + is_signed_type(__seen)) { \
 		case 0: { \
-			unsigned long long __exp_print = (uintptr_t)__exp; \
-			unsigned long long __seen_print = (uintptr_t)__seen; \
-			__TH_LOG("Expected %s (%llu) %s %s (%llu)", \
+			uintmax_t __exp_print = (uintmax_t)__exp; \
+			uintmax_t __seen_print = (uintmax_t)__seen; \
+			__TH_LOG("Expected %s (%ju) %s %s (%ju)", \
 				 _expected_str, __exp_print, #_t, \
 				 _seen_str, __seen_print); \
 			break; \
 			} \
 		case 1: { \
-			unsigned long long __exp_print = (uintptr_t)__exp; \
-			long long __seen_print = (intptr_t)__seen; \
-			__TH_LOG("Expected %s (%llu) %s %s (%lld)", \
+			uintmax_t __exp_print = (uintmax_t)__exp; \
+			intmax_t  __seen_print = (intmax_t)__seen; \
+			__TH_LOG("Expected %s (%ju) %s %s (%jd)", \
 				 _expected_str, __exp_print, #_t, \
 				 _seen_str, __seen_print); \
 			break; \
 			} \
 		case 2: { \
-			long long __exp_print = (intptr_t)__exp; \
-			unsigned long long __seen_print = (uintptr_t)__seen; \
-			__TH_LOG("Expected %s (%lld) %s %s (%llu)", \
+			intmax_t  __exp_print = (intmax_t)__exp; \
+			uintmax_t __seen_print = (uintmax_t)__seen; \
+			__TH_LOG("Expected %s (%jd) %s %s (%ju)", \
 				 _expected_str, __exp_print, #_t, \
 				 _seen_str, __seen_print); \
 			break; \
 			} \
 		case 3: { \
-			long long __exp_print = (intptr_t)__exp; \
-			long long __seen_print = (intptr_t)__seen; \
-			__TH_LOG("Expected %s (%lld) %s %s (%lld)", \
+			intmax_t  __exp_print = (intmax_t)__exp; \
+			intmax_t  __seen_print = (intmax_t)__seen; \
+			__TH_LOG("Expected %s (%jd) %s %s (%jd)", \
 				 _expected_str, __exp_print, #_t, \
 				 _seen_str, __seen_print); \
 			break; \
-- 
2.39.5



