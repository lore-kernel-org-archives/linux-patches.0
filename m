Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35185A47;
	Tue, 23 Jan 2024 01:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972144; cv=none; b=CvuqBXuO+D+mMnW4a63fQH0zsOq4Efp0tIycSBe99jjSCSFK+MMktw6Z6x3mXRKGwQMzcpxyi0p09FrgTvLNjEL3xzfONP6tyxg89+eWP1gB24MedqHoMARLdtJlDDf5Jk10k17uv7E21IrichqvQtF3NLlWchyHKOpobT+BYF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972144; c=relaxed/simple;
	bh=WfE7gzqkv1K71xf2lWgSZ4hzxKWC3kEEPo9runqji4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0wPrWMaPDP8GDHtLGILkzT92heyu6tTHQ5WAb0T+46RzBVuZWlT453aF8EgOgRImKRILM9MLlkr+zpt7l1RBkk2Otf/rCA95oAQ+HA2IG7+O/v1cmrRhfXfvnk2TSbTDgz2y4YhQliPr/daGg/ZwX85Btjt9OT3HIZMUoJwpW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiNSeIQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiNSeIQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84A1C43390;
	Tue, 23 Jan 2024 01:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972144;
	bh=WfE7gzqkv1K71xf2lWgSZ4hzxKWC3kEEPo9runqji4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiNSeIQNax8JAgOoZbebrrwK4ev++aryp3fiNCqg6+qsxIwrKO2Tg+Z+UoRySfZff
	 DGZMzHjLRiTJEfa6wpC6W7+Puu+/l8Za6+pGMqFV7Q12dUa4mSmJeskJjs576pPC9v
	 JTRf1nr7+ewLv2jJJZEVn0vG08HgjCkLUSTqsoGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/374] selftests/powerpc: Fix error handling in FPU/VMX preemption tests
Date: Mon, 22 Jan 2024 15:55:29 -0800
Message-ID: <20240122235747.155622726@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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



