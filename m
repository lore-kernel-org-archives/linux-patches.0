Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589ED36EA89;
	Tue, 10 Mar 2026 11:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141288; cv=none; b=uhIgLWe8riqgYUXaD8y6TTGvn0ysMq3cUlwPk2zruCVESoCXFgJ8xSYXqJKujHL6uo5wEeAXg3QanlVkV8M/QY4Bgp8l079a72BQj5ypUwkxaQo7yA4c/01iATr3RQ5dSe/4754dhBpz7rKwGyoNGGsMY6oJRY9lhGDrhpS000M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141288; c=relaxed/simple;
	bh=EuWk9Q9mi2I8pDPH6wpMyAHTdblLXqUOSfkBFLF/0hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F003LJHgSHbKl1UVhF5C8ZKjNr9iLY3VFj8qgHqhSmSRys7+RBYrP/cCJjpMe0F2ZL8CZCEcD/mpSi4Oob76W/BDcTgYmgl39hFN8+UG9hzkSSFSZSRm9E4V0tOuR23Q6iWqNjj+aohk8Ddzeqe2HZCO/e3tVlCYvqRCdHwgXIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qXZfIIaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXZfIIaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF43C2BC86;
	Tue, 10 Mar 2026 11:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141288;
	bh=EuWk9Q9mi2I8pDPH6wpMyAHTdblLXqUOSfkBFLF/0hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXZfIIajxtKMn9bUf2YYrX18S45iy8oLjHU9ttCp4yh1SvTRJghOfvKaYONNtOV/L
	 YaomCG2YMrMt/SAuTEOL8Z8y/YXdHGfByPW1p9dXekC+DFVUZGq2C3lam9E6QmF/pM
	 aFZQM2/XKitnfttYsUFTPVLc5+K9DzUlSzqmlZP9uWtqi1uon+uHpX+6lO1lC1lRcD
	 SumWu9U7ZCXypMvTaaf/VPlt7xyQWSBqwa/VMFpQH0EB/haG3DagViJmJzEdlrF9dx
	 joCeNuef35FfqehTg5ty/cALWskEPTStLcTBCCT2mdLDj3AdDNHeYOKku/yu0NhPc4
	 9Gr7Gtu4Wfeag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sun Jian <sun.jian.kdev@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 292/311] selftests/harness: order TEST_F and XFAIL_ADD constructors
Date: Tue, 10 Mar 2026 07:05:39 -0400
Message-ID: <c3781058423033fc405b757e41c38055121a1e8c.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sun Jian <sun.jian.kdev@gmail.com>

[ Upstream commit 6be2681514261324c8ee8a1c6f76cefdf700220f ]

TEST_F() allocates and registers its struct __test_metadata via mmap()
inside its constructor, and only then assigns the
_##fixture_##test##_object pointer.

XFAIL_ADD() runs in a constructor too and reads
_##fixture_##test##_object to initialize xfail->test. If XFAIL_ADD runs
first, xfail->test can be NULL and the expected failure will be reported
as FAIL.

Use constructor priorities to ensure TEST_F registration runs before
XFAIL_ADD, without adding extra state or runtime lookups.

Fixes: 2709473c9386 ("selftests: kselftest_harness: support using xfail")
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Link: https://patch.msgid.link/20260225111451.347923-1-sun.jian.kdev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 16a119a4656c7..4afaef01c22e9 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -76,6 +76,9 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 		memset(s, c, n);
 }
 
+#define KSELFTEST_PRIO_TEST_F  20000
+#define KSELFTEST_PRIO_XFAIL   20001
+
 #define TEST_TIMEOUT_DEFAULT 30
 
 /* Utilities exposed to the test definitions */
@@ -465,7 +468,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 			fixture_name##_teardown(_metadata, self, variant); \
 	} \
 	static struct __test_metadata *_##fixture_name##_##test_name##_object; \
-	static void __attribute__((constructor)) \
+	static void __attribute__((constructor(KSELFTEST_PRIO_TEST_F))) \
 			_register_##fixture_name##_##test_name(void) \
 	{ \
 		struct __test_metadata *object = mmap(NULL, sizeof(*object), \
@@ -880,7 +883,7 @@ struct __test_xfail {
 		.fixture = &_##fixture_name##_fixture_object, \
 		.variant = &_##fixture_name##_##variant_name##_object, \
 	}; \
-	static void __attribute__((constructor)) \
+	static void __attribute__((constructor(KSELFTEST_PRIO_XFAIL))) \
 		_register_##fixture_name##_##variant_name##_##test_name##_xfail(void) \
 	{ \
 		_##fixture_name##_##variant_name##_##test_name##_xfail.test = \
-- 
2.51.0

