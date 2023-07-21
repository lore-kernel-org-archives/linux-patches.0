Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB85E1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB41C433CA;
	Fri, 21 Jul 2023 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956221;
	bh=QKg4sBedqvhdy39FPwOEy1xhGOjxj8ogiro2joN9/Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkWWloE8n8MZvIfFLqC/CNScHeMLFc7Ln1DeK9YDCPGmTci4Ari0X37VzqziUACiB
	 6TrBhoZ/U9GUOHvbDvqOlytqyDTOFNl09nmO42hct84MmqvX6b1u3q+AoNEavKilw0
	 r/9IqemzJEUrQxa69+Sf5dJgtB/mmT9DGvUIlL9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nageswara R Sastry <rnsastry@linux.ibm.com>,
	Russell Currey <ruscur@russell.cc>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.4 143/292] powerpc/security: Fix Speculation_Store_Bypass reporting on Power10
Date: Fri, 21 Jul 2023 18:04:12 +0200
Message-ID: <20230721160535.032102608@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Ellerman <mpe@ellerman.id.au>

commit 5bcedc5931e7bd6928a2d8207078d4cb476b3b55 upstream.

Nageswara reported that /proc/self/status was showing "vulnerable" for
the Speculation_Store_Bypass feature on Power10, eg:

  $ grep Speculation_Store_Bypass: /proc/self/status
  Speculation_Store_Bypass:       vulnerable

But at the same time the sysfs files, and lscpu, were showing "Not
affected".

This turns out to simply be a bug in the reporting of the
Speculation_Store_Bypass, aka. PR_SPEC_STORE_BYPASS, case.

When SEC_FTR_STF_BARRIER was added, so that firmware could communicate
the vulnerability was not present, the code in ssb_prctl_get() was not
updated to check the new flag.

So add the check for SEC_FTR_STF_BARRIER being disabled. Rather than
adding the new check to the existing if block and expanding the comment
to cover both cases, rewrite the three cases to be separate so they can
be commented separately for clarity.

Fixes: 84ed26fd00c5 ("powerpc/security: Add a security feature for STF barrier")
Cc: stable@vger.kernel.org # v5.14+
Reported-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Tested-by: Nageswara R Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230517074945.53188-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/security.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -364,26 +364,27 @@ ssize_t cpu_show_spec_store_bypass(struc
 
 static int ssb_prctl_get(struct task_struct *task)
 {
+	/*
+	 * The STF_BARRIER feature is on by default, so if it's off that means
+	 * firmware has explicitly said the CPU is not vulnerable via either
+	 * the hypercall or device tree.
+	 */
+	if (!security_ftr_enabled(SEC_FTR_STF_BARRIER))
+		return PR_SPEC_NOT_AFFECTED;
+
+	/*
+	 * If the system's CPU has no known barrier (see setup_stf_barrier())
+	 * then assume that the CPU is not vulnerable.
+	 */
 	if (stf_enabled_flush_types == STF_BARRIER_NONE)
-		/*
-		 * We don't have an explicit signal from firmware that we're
-		 * vulnerable or not, we only have certain CPU revisions that
-		 * are known to be vulnerable.
-		 *
-		 * We assume that if we're on another CPU, where the barrier is
-		 * NONE, then we are not vulnerable.
-		 */
 		return PR_SPEC_NOT_AFFECTED;
-	else
-		/*
-		 * If we do have a barrier type then we are vulnerable. The
-		 * barrier is not a global or per-process mitigation, so the
-		 * only value we can report here is PR_SPEC_ENABLE, which
-		 * appears as "vulnerable" in /proc.
-		 */
-		return PR_SPEC_ENABLE;
 
-	return -EINVAL;
+	/*
+	 * Otherwise the CPU is vulnerable. The barrier is not a global or
+	 * per-process mitigation, so the only value that can be reported here
+	 * is PR_SPEC_ENABLE, which appears as "vulnerable" in /proc.
+	 */
+	return PR_SPEC_ENABLE;
 }
 
 int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)


