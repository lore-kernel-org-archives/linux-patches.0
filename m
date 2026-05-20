Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29A5371D13;
	Wed, 20 May 2026 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294670; cv=none; b=qfSDf3XexzYdae2j6mzpjjzlWNOW71nNIWAWEgb/L6uU7ZtURxBx7COCTW7xRSlROOc+p6mYvPb1ZKV5icCgZiYrk+5+lnoNCOVyEGWcKiumlBzQnHdpFlCFIkx56BsZFjVk+FqxaKDCib3JjnGlm3bsz9UIDWYMCBK0gEW2mPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294670; c=relaxed/simple;
	bh=2XADbOG0u6AixjVkgsT0ii1YR9wpAR2I1w6ptVOwjpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O92tid1JVduEDfOQBcUoHpRqAQn/AZgu1ef+kZxSzAk7K7osYu7LiFjRxMxvSPyoARkAIWTtS7szDoBzqRZRHuQlEShemk1DTEttlAsiODUzIue59o9sj9FhqkqBeV2XS7/EbS/nnrEqDUg+N05jIl6DKsVrLlH2D5XrtliauUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnU64FGf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnU64FGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C161F000E9;
	Wed, 20 May 2026 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294668;
	bh=+ZmyFt+XdLAFo7e8QjUoZbNfkWfL/ddAItXBcrqhYV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnU64FGfbz4A/Mvjsc4yW9gqb+lTFfUb/CYoucT7ZHxI7//vZwklaRN4i9UAlzesN
	 EcvGu90m0WvopqYbeO24k4joRV5k7zfSeR3fXkcSTDUPyBbBIMskf7PMW5lJwH1HYT
	 Od6xvuf3YynDtmFzYXBA8IOl5u1S0yRh20PhGTgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0087/1146] selftests/nolibc: fix test_file_stream() on musl libc
Date: Wed, 20 May 2026 18:05:37 +0200
Message-ID: <20260520162150.320365417@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 8ba600aa577f73cc551747fdf121afc7d04afcea ]

fwrite() modifying errno is non-standard.

Only validate this behavior on those libc implementations which
implement it.

Fixes: a5f00be9b3b0 ("tools/nolibc: Add a simple test for writing to a FILE and reading it back")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index 1b9d3b2e2491c..1aca8468eac4b 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -74,6 +74,14 @@ static const int is_nolibc =
 #endif
 ;
 
+static const int is_glibc =
+#ifdef __GLIBC__
+	1
+#else
+	0
+#endif
+;
+
 /* definition of a series of tests */
 struct test {
 	const char *name;              /* test name */
@@ -866,7 +874,7 @@ int test_file_stream(void)
 
 	errno = 0;
 	r = fwrite("foo", 1, 3, f);
-	if (r != 0 || errno != EBADF) {
+	if (r != 0 || ((is_nolibc || is_glibc) && errno != EBADF)) {
 		fclose(f);
 		return -1;
 	}
-- 
2.53.0



