Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B3433981;
	Tue,  8 Oct 2024 12:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390381; cv=none; b=ZOS85q79tit1kUKwa73B3WFfxfZxRz8UaAbQ+tRz28A6VF8bLKGCz05W2sktOm7XIcZ/s8dv71Y5ZChSDmO151B4QfvKNXfXd2KtUwv0puTOEUHOvFJuWjAjL44b3ET2BuHI9LbQiMLGAyFrNnfGqz3ZVTkE/6GiHzkRsGUfF1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390381; c=relaxed/simple;
	bh=4/bLjhEUTnkTRfXDrcJYRtkvXUHmC1n8wUC+XS2MrvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXoNukGkzXrb05uaHDgTU9SkWlu1PvLPUlB82bTGf9FhtO3NrTV0NHm7daPWV/adwFOjCMNwNRaYh9A0/uIAL5kn2nr7atPjJDJ/SZPdK2WDJnZVEPigKEsDQxI23Z4uDRH5HDSimiJhWZUBi2LNooqXtAbD3njOBUD8UaoyNjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrLLtrSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrLLtrSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FD3C4CEC7;
	Tue,  8 Oct 2024 12:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390381;
	bh=4/bLjhEUTnkTRfXDrcJYRtkvXUHmC1n8wUC+XS2MrvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrLLtrSVpu0a2U169zuGSLsT2QV1TDX24NdYWSoz/wWi1GrE9+f16DHBoLEQonLNp
	 JRvDyKNOKt6N95uNPf7yecBJRT3c5SZnqLbZpdAh4AmQluvVeXMvw/EheMCfjpm6VF
	 hwRjfV0fTKo8sUQnNgX4Yh9K/tsAL+UF1NrSk/sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 273/482] selftests: vDSO: fix vDSO name for powerpc
Date: Tue,  8 Oct 2024 14:05:36 +0200
Message-ID: <20241008115659.023593019@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



