Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066811DE8AA;
	Tue,  8 Oct 2024 12:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392147; cv=none; b=MCKdt+5twwoat/boecHd/FxXMfUPiRT5QAhCJW/Cfr0NNmpbOzUWXlLZYdx+gR9YUo1qCGECa1lMEC2aQJ278UMCvAGascgvMikgQjBy34VnBFuLGh+JMnRzn5PEE3nwb4tOGctB+lRjiUKthjOIB4/7U+MdHDCpaQt9H7Gspyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392147; c=relaxed/simple;
	bh=1op2iDL3VbUkVu5GvSbbf4Wd2ctxjUBTo+r3/YbNVYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJKxJpJRetN0ZZF2Cozf+sR1d2hHnoWEpdrqfT8zYDQj/TISvvthhkiK1DCTGQlVbUP/F6g+abjN0i7iwMbjgHtHzZGS96EybVTGreap17X2YdNZMW5Q01MYpOTKU+RROqYNOyGORr9s1KOM66Ay7xSw+UZG3LiIGYscj7x/Kw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsuhVKFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsuhVKFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9F9C4CEC7;
	Tue,  8 Oct 2024 12:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392146;
	bh=1op2iDL3VbUkVu5GvSbbf4Wd2ctxjUBTo+r3/YbNVYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsuhVKFFqiHKsrKtEkDV1ST5PcvxDwXmnEfWM4Q+peQStaQ4OIF+X1e163KQcDK0x
	 fwGanWdcbDy77xElyWi4xKqH3/nYZMFi5MRIGdb7nnt7erjm2lputLKUFfrVkO3viy
	 8vR9RL6LbP96/qTSvudHMLaTYwfYNAjxRTHS00AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 329/558] selftests: vDSO: fix vDSO name for powerpc
Date: Tue,  8 Oct 2024 14:05:59 +0200
Message-ID: <20241008115715.251322249@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



