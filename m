Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461D41AAE3B;
	Mon, 14 Oct 2024 15:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919111; cv=none; b=OT0wSGwHrLOcHdxjERp3nKbQa0Zi3sGomsVC0eWhl4VWAzCOJ+Z9phv5pmhIzXyacXy4sLn9Ob1/2BEANcWPNKGZSDF9ZG7CQ9itj+5nSyO7ZfVK0+3F7QI3j1HLbbsXsvlI5coxBbmuopi+STEdeIkgYEj0xH/vv+SJYHLJuBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919111; c=relaxed/simple;
	bh=/XpN1+7wOXGMHhBg78UgAKbwPI5c97zqfJzrp7+x7s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNqG0JB1xmTBuA0ZZrW/qRYQ16A4NWzZ/J3m51fftLFI8rCogDeeUvy8XZk5vIQLVn7zKF0gIjOgVY5xXLyTSzBwqnE7wduhKkQFBWmP0U5jIyKlr6FddocB9eBlTC8OT+RBcTiQvuWnGKoPr+NUni39VPFF/OEpeYLfnHw00Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igWgYdOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igWgYdOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7590C4CEC3;
	Mon, 14 Oct 2024 15:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919111;
	bh=/XpN1+7wOXGMHhBg78UgAKbwPI5c97zqfJzrp7+x7s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igWgYdOqEHVahoauEq/Kjz8FRmwsm1hkIVboffzqBNKZIk3Ic06dWcFPZDXef5YlE
	 QMDOZILk1YKjWBIYvHz76j3HH0h6FVWIsvQh5T3KATabdwmZvnFiatUmUdj+5ABgbe
	 iCHRwwqIYzOKdP7Tqkvmj9AoKWgKMX8Vh4axq/P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 516/798] selftests: vDSO: fix vDSO name for powerpc
Date: Mon, 14 Oct 2024 16:17:50 +0200
Message-ID: <20241014141238.251577729@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 59eb856c3ed9b3552befd240c0c339f22eed3fa1 ]

Following error occurs when running vdso_test_correctness on powerpc:

~ # ./vdso_test_correctness
[WARN]	failed to find vDSO
[SKIP]	No vDSO, so skipping clock_gettime() tests
[SKIP]	No vDSO, so skipping clock_gettime64() tests
[RUN]	Testing getcpu...
[OK]	CPU 0: syscall: cpu 0, node 0

On powerpc, vDSO is neither called linux-vdso.so.1 nor linux-gate.so.1
but linux-vdso32.so.1 or linux-vdso64.so.1.

Also search those two names before giving up.

Fixes: c7e5789b24d3 ("kselftest: Move test_vdso to the vDSO test suite")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vdso_test_correctness.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/vDSO/vdso_test_correctness.c b/tools/testing/selftests/vDSO/vdso_test_correctness.c
index e691a3cf14911..cdb697ae8343c 100644
--- a/tools/testing/selftests/vDSO/vdso_test_correctness.c
+++ b/tools/testing/selftests/vDSO/vdso_test_correctness.c
@@ -114,6 +114,12 @@ static void fill_function_pointers()
 	if (!vdso)
 		vdso = dlopen("linux-gate.so.1",
 			      RTLD_LAZY | RTLD_LOCAL | RTLD_NOLOAD);
+	if (!vdso)
+		vdso = dlopen("linux-vdso32.so.1",
+			      RTLD_LAZY | RTLD_LOCAL | RTLD_NOLOAD);
+	if (!vdso)
+		vdso = dlopen("linux-vdso64.so.1",
+			      RTLD_LAZY | RTLD_LOCAL | RTLD_NOLOAD);
 	if (!vdso) {
 		printf("[WARN]\tfailed to find vDSO\n");
 		return;
-- 
2.43.0



