Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E4B26F288;
	Thu, 12 Mar 2026 20:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347222; cv=none; b=KdLRfut8lLkc3gKaSiWOgOAVJ76QysciNzlPQMBdJA9J9O/WzceGMJ0yL+vskuSlMBmwXUmEbUSEtrpHnTNaamlSU6M4bVF7TGncoGMMbjATPG4CNMrNCTgjT7Tcq4sDCdoeRhtFBy+lqmQ681B1SxX8DQNZ+ndwqLJ7XgqMO1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347222; c=relaxed/simple;
	bh=yM1YS4jwbNNj9WX3KdDhCOiZC3U8VyCz60QtWiILnU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmN9j+I0f0U2sjQVBiiAe5Ydi2uuAsiZ3P01zuASQZVkwqG+WlqhtIZdgrCdY4xC1d9+km8yo77G9ZENqMoQDi7CdpZbPh9ayAKfD2k2hKJCCNIHqPgpNjZg9DAkYzdWldMAr9Omn/ZFpCOJyWQuiF1U4r/qU7rj8cnVOTko6Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmmOpqXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmmOpqXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191C2C4CEF7;
	Thu, 12 Mar 2026 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347222;
	bh=yM1YS4jwbNNj9WX3KdDhCOiZC3U8VyCz60QtWiILnU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmmOpqXld6crG0320cblX3K6LP2h9fZlAecapxtTF9QxvHp7AFKr5dCQx21MJbVvL
	 WrqEARZyhkbL1W981Kq8Jh5ls3Do+wf5fI7G22bifZiKSul55jzkS9enSPQEErfwOb
	 UlVL5NhG4+s/t8HDlGgiDYHDGQF0gLk3VPOTHqVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/265] selftests/harness: order TEST_F and XFAIL_ADD constructors
Date: Thu, 12 Mar 2026 21:10:24 +0100
Message-ID: <20260312201026.895011168@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
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
index d67ec4d762db3..a4e5b8613babf 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -75,6 +75,9 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 		memset(s, c, n);
 }
 
+#define KSELFTEST_PRIO_TEST_F  20000
+#define KSELFTEST_PRIO_XFAIL   20001
+
 #define TEST_TIMEOUT_DEFAULT 30
 
 /* Utilities exposed to the test definitions */
@@ -465,7 +468,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 		__test_check_assert(_metadata); \
 	} \
 	static struct __test_metadata *_##fixture_name##_##test_name##_object; \
-	static void __attribute__((constructor)) \
+	static void __attribute__((constructor(KSELFTEST_PRIO_TEST_F))) \
 			_register_##fixture_name##_##test_name(void) \
 	{ \
 		struct __test_metadata *object = mmap(NULL, sizeof(*object), \
@@ -879,7 +882,7 @@ struct __test_xfail {
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



