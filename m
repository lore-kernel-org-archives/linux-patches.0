Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2091825E473;
	Tue, 11 Mar 2025 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705414; cv=none; b=jc+rieUS1y2WavfWcEhnFnqknc3gYDnwposqSC3QYnBfWGyRpfavF/F2teHEymTmYVRo3tVyz02xg0Ifr9FBddzokS8UCMMJbsIjzSuSHmtGL/8uvfBuj0HnJOc1MhEcIMWW4Z9Cw7DkKsjlJM/ONzSDlFD1pmLFsv/nyypSTp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705414; c=relaxed/simple;
	bh=njWWHQmVLqH08qxXoLW2zmUcKdX8Ggzyhr+MgImjY+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btKbpNtUl3E2AzF3JoIYHpktmHxF2lwLgsv98M9mkCzJcWBG7QVEc9RDcFfTeb7sKhF25lD4EYcKYp9V2nDWbZhbAHZDNi9YX1iA5ugTAWu6Tb6jUBg8HL3oNy47CPtkK4GYWcKSArMInL3B/xEhgZE3HN1v7i5J2x5PUNpzJOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyYRvv6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyYRvv6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98609C4CEE9;
	Tue, 11 Mar 2025 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705414;
	bh=njWWHQmVLqH08qxXoLW2zmUcKdX8Ggzyhr+MgImjY+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyYRvv6e1CraB7jG+GJ5dSZ0a/zLMnmYvXaKHMg9MbehrjV+1J0lAqV4xOOlNSwvh
	 I490lMHjg/5LHspmmbvm4oA4zDfZMaJMBAyItiMjt8mtWVfd+6NpGh1Wcemn7qklsm
	 kpfw0IrkP5DUyRTl0L8reyaLetMCZW95v0vt2lXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/328] selftests/harness: Display signed values correctly
Date: Tue, 11 Mar 2025 15:56:37 +0100
Message-ID: <20250311145715.970556675@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit d088c92802549fc1cf77a12a4e3986160d63662a ]

Since forever the harness output for signed value tests have reported
unsigned values to avoid casting. Instead, actually test the variable
types and perform the correct casts and choose the correct format
specifiers.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 02bc220dc6dc ("selftests: harness: fix printing of mismatch values in __EXPECT()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 42 ++++++++++++++++++---
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 5336b26506ab2..f393fe8cf3725 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -603,17 +603,49 @@
 	if (_metadata->passed && _metadata->step < 255) \
 		_metadata->step++;
 
+#define is_signed_type(var)       (!!(((__typeof__(var))(-1)) < (__typeof__(var))1))
+
 #define __EXPECT(_expected, _expected_str, _seen, _seen_str, _t, _assert) do { \
 	/* Avoid multiple evaluation of the cases */ \
 	__typeof__(_expected) __exp = (_expected); \
 	__typeof__(_seen) __seen = (_seen); \
 	if (_assert) __INC_STEP(_metadata); \
 	if (!(__exp _t __seen)) { \
-		unsigned long long __exp_print = (uintptr_t)__exp; \
-		unsigned long long __seen_print = (uintptr_t)__seen; \
-		__TH_LOG("Expected %s (%llu) %s %s (%llu)", \
-			 _expected_str, __exp_print, #_t, \
-			 _seen_str, __seen_print); \
+		/* Report with actual signedness to avoid weird output. */ \
+		switch (is_signed_type(__exp) * 2 + is_signed_type(__seen)) { \
+		case 0: { \
+			unsigned long long __exp_print = (uintptr_t)__exp; \
+			unsigned long long __seen_print = (uintptr_t)__seen; \
+			__TH_LOG("Expected %s (%llu) %s %s (%llu)", \
+				 _expected_str, __exp_print, #_t, \
+				 _seen_str, __seen_print); \
+			break; \
+			} \
+		case 1: { \
+			unsigned long long __exp_print = (uintptr_t)__exp; \
+			long long __seen_print = (intptr_t)__seen; \
+			__TH_LOG("Expected %s (%llu) %s %s (%lld)", \
+				 _expected_str, __exp_print, #_t, \
+				 _seen_str, __seen_print); \
+			break; \
+			} \
+		case 2: { \
+			long long __exp_print = (intptr_t)__exp; \
+			unsigned long long __seen_print = (uintptr_t)__seen; \
+			__TH_LOG("Expected %s (%lld) %s %s (%llu)", \
+				 _expected_str, __exp_print, #_t, \
+				 _seen_str, __seen_print); \
+			break; \
+			} \
+		case 3: { \
+			long long __exp_print = (intptr_t)__exp; \
+			long long __seen_print = (intptr_t)__seen; \
+			__TH_LOG("Expected %s (%lld) %s %s (%lld)", \
+				 _expected_str, __exp_print, #_t, \
+				 _seen_str, __seen_print); \
+			break; \
+			} \
+		} \
 		_metadata->passed = 0; \
 		/* Ensure the optional handler is triggered */ \
 		_metadata->trigger = 1; \
-- 
2.39.5



