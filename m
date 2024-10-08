Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E11DED7D;
	Tue,  8 Oct 2024 13:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393695; cv=none; b=lAzSvsC9lwvetYmPtVIftzW5txkVKJ1H7hgB7711hqE1ISkLCaYgI69Vkuoa+GMXPACvdtSNeecMvP9IJkGnCIiv4G5P7p6wHs9nFOQ8GMHcc7cayEghn7oj7a27/j8FSQ1VY57HniNJnG9tz6qdo8rt8zaJWDqctNP4T5lmbaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393695; c=relaxed/simple;
	bh=l26c+m1UxV+/REX2J39chheficli1+fxegmrf1MGUjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCEFyPZMUR26QfgZzcdFWY5tLHkCzoOkzMPyOWZLJ94TIfXmtoZgdrIKBZtRAmVdLEmAHYxs5HabmQKyUEhHoQRkKwX3+4lFucb1AyjuhieADsXzZspNavdFCrLxu/kfWwOTby5CPesVy5pK1Y6RS277ER7ndNbyKyf8fYznIvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w12L4mGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w12L4mGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E601DC4CECC;
	Tue,  8 Oct 2024 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393695;
	bh=l26c+m1UxV+/REX2J39chheficli1+fxegmrf1MGUjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w12L4mGQKv4QuZRKG0FB+iqY3i1hcAWg+hkK0ulE/54dTl9/yRwRT9S8v93vqYwQ6
	 r/+qMMHVR/14MToIW6M2nlgoyGqks3yPj465MXZn+ly9rEPmdaGByxVwssmGum/F81
	 Vpe3CzsBrB2sLotfUaZX0aBZji3O4Xx7gE+FxOW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/386] selftests: vDSO: fix vDSO name for powerpc
Date: Tue,  8 Oct 2024 14:07:22 +0200
Message-ID: <20241008115637.159815271@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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



