Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395A16FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BA7C433C8;
	Sun, 17 Sep 2023 20:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981473;
	bh=ksnFQqd8QVyl/TCJtoA49RjD6rBwcsdQwTdvUAvfOuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nr8nB3aLx5wB8ryH4/d/bk6LTEhiKXkGtGqJ8SfRWdB/RMC05Cw7ln90R858sZIyQ
	 koSVbzPQgwyCWv1oWOHWXOm3Hr7+D+Ea7ld4UttJrt08GPGj8DoLWAViV3AsNX/PTL
	 C9GzQ+wxIPYl0v9RpHHz3caTscoirKQLxjiYtI6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <shuah@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	linux-kselftest@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/511] selftests/harness: Actually report SKIP for signal tests
Date: Sun, 17 Sep 2023 21:08:07 +0200
Message-ID: <20230917191115.336254135@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit b3d46e11fec0c5a8972e5061bb1462119ae5736d ]

Tests that were expecting a signal were not correctly checking for a
SKIP condition. Move the check before the signal checking when
processing test result.

Cc: Shuah Khan <shuah@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: linux-kselftest@vger.kernel.org
Fixes: 9847d24af95c ("selftests/harness: Refactor XFAIL into SKIP")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 11779405dc804..a6ea2bd63a831 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -916,7 +916,11 @@ void __wait_for_test(struct __test_metadata *t)
 		fprintf(TH_LOG_STREAM,
 			"# %s: Test terminated by timeout\n", t->name);
 	} else if (WIFEXITED(status)) {
-		if (t->termsig != -1) {
+		if (WEXITSTATUS(status) == 255) {
+			/* SKIP */
+			t->passed = 1;
+			t->skip = 1;
+		} else if (t->termsig != -1) {
 			t->passed = 0;
 			fprintf(TH_LOG_STREAM,
 				"# %s: Test exited normally instead of by signal (code: %d)\n",
@@ -928,11 +932,6 @@ void __wait_for_test(struct __test_metadata *t)
 			case 0:
 				t->passed = 1;
 				break;
-			/* SKIP */
-			case 255:
-				t->passed = 1;
-				t->skip = 1;
-				break;
 			/* Other failure, assume step report. */
 			default:
 				t->passed = 0;
-- 
2.40.1



