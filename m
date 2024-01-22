Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7855313173A;
	Tue, 23 Jan 2024 00:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969086; cv=none; b=GIDl0nDqhlyLBOi3Z5fZsrCjTE6KfMqnDoiZZLU8He3aHcef8AgK3JbVoUan1rRS3bw4uRz0j7CL/u3Q+biWx2q0j/IalLLGECT9iOb/1rU1m40z35hO1L2loy4CSq59PfbQdpZSnJ3O/P5kJlbXNfzhWwaL93snEeG+EkKA38A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969086; c=relaxed/simple;
	bh=ymhm9ePzqMpsA7CqH2bjO5QV+rrv1Sqlufi2ySSs0pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQAtx7iGZrVaCUXrVvtgIPYndsK9RB9ZhtHDr35po4jnZjDY7e9swF6bkCVkKlwhXj90edYsFHShRQ4PJ3wWHYtYtGzj4pSmyscit4Bg/MENv+YHNHr9xWgTk8mSaQV9tvVmXmAmjYN90SRB95l990Do5ffsb3zteZRRI+H6JQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HczHGr9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HczHGr9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE0BC433C7;
	Tue, 23 Jan 2024 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969086;
	bh=ymhm9ePzqMpsA7CqH2bjO5QV+rrv1Sqlufi2ySSs0pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HczHGr9+q0uuRDCE+TvRpCOqTq3TPRS19wQ4j2XZK7tTnJi1hpXGK/P7Kfo8Rin6r
	 X3v3TCOXlAOuF9lMpHxLhRuL+o2VMlg+kH+Zb0S0KaumKOikiS2Te/VS/Alw3oYvk6
	 pxRQnLffe2rGZYQm3eMfxC7Zz8ZbteCukBSk2wmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 013/641] selftests/powerpc: Fix error handling in FPU/VMX preemption tests
Date: Mon, 22 Jan 2024 15:48:37 -0800
Message-ID: <20240122235818.527166174@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 9dbd5927408c4a0707de73ae9dd9306b184e8fee ]

The FPU & VMX preemption tests do not check for errors returned by the
low-level asm routines, preempt_fpu() / preempt_vsx() respectively.
That means any register corruption detected by the asm routines does not
result in a test failure.

Fix it by returning the return value of the asm routines from the
pthread child routines.

Fixes: e5ab8be68e44 ("selftests/powerpc: Test preservation of FPU and VMX regs across preemption")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231128132748.1990179-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/math/fpu_preempt.c |  9 +++++----
 tools/testing/selftests/powerpc/math/vmx_preempt.c | 10 ++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/powerpc/math/fpu_preempt.c b/tools/testing/selftests/powerpc/math/fpu_preempt.c
index 5235bdc8c0b1..3e5b5663d244 100644
--- a/tools/testing/selftests/powerpc/math/fpu_preempt.c
+++ b/tools/testing/selftests/powerpc/math/fpu_preempt.c
@@ -37,19 +37,20 @@ __thread double darray[] = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0,
 int threads_starting;
 int running;
 
-extern void preempt_fpu(double *darray, int *threads_starting, int *running);
+extern int preempt_fpu(double *darray, int *threads_starting, int *running);
 
 void *preempt_fpu_c(void *p)
 {
+	long rc;
 	int i;
+
 	srand(pthread_self());
 	for (i = 0; i < 21; i++)
 		darray[i] = rand();
 
-	/* Test failed if it ever returns */
-	preempt_fpu(darray, &threads_starting, &running);
+	rc = preempt_fpu(darray, &threads_starting, &running);
 
-	return p;
+	return (void *)rc;
 }
 
 int test_preempt_fpu(void)
diff --git a/tools/testing/selftests/powerpc/math/vmx_preempt.c b/tools/testing/selftests/powerpc/math/vmx_preempt.c
index 6761d6ce30ec..6f7cf400c687 100644
--- a/tools/testing/selftests/powerpc/math/vmx_preempt.c
+++ b/tools/testing/selftests/powerpc/math/vmx_preempt.c
@@ -37,19 +37,21 @@ __thread vector int varray[] = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10,11,12},
 int threads_starting;
 int running;
 
-extern void preempt_vmx(vector int *varray, int *threads_starting, int *running);
+extern int preempt_vmx(vector int *varray, int *threads_starting, int *running);
 
 void *preempt_vmx_c(void *p)
 {
 	int i, j;
+	long rc;
+
 	srand(pthread_self());
 	for (i = 0; i < 12; i++)
 		for (j = 0; j < 4; j++)
 			varray[i][j] = rand();
 
-	/* Test fails if it ever returns */
-	preempt_vmx(varray, &threads_starting, &running);
-	return p;
+	rc = preempt_vmx(varray, &threads_starting, &running);
+
+	return (void *)rc;
 }
 
 int test_preempt_vmx(void)
-- 
2.43.0



