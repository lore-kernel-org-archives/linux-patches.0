Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590066453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227F1C340EC;
	Tue, 22 Mar 2022 21:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985459;
	bh=Ri4lzkNYEUnyFRxMfVz3fD4DiHzvZjtn2EJnYhjyP0E=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=dfjxQ7naSq8Ej2j0s1C8uPHdOjh9Kn/HvJdoCIbABZ+UsBULmOeMGixy3lPr8kCsp
	 EzhbAbejzX9uqWrXzvCmwLuiR1sUgKKT77Ke9Gof2ajsJ63Ewq3wScrhNRfubvZDnx
	 FWrpdIwT3R6a92DsPLF7VHhqEKYySZr/f9xu7q1k=
Date: Tue, 22 Mar 2022 14:44:18 -0700
To: naoya.horiguchi@nec.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 114/227] mm/memory-failure.c: rework the signaling logic in kill_proc
Message-Id: <20220322214419.227F1C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: rework the signaling logic in kill_proc

BUS_MCEERR_AR code is only sent when MF_ACTION_REQUIRED is set and the
target is current.  Rework the code to make this clear.

Link: https://lkml.kernel.org/r/20220218090118.1105-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-rework-the-signaling-logic-in-kill_proc
+++ a/mm/memory-failure.c
@@ -258,16 +258,13 @@ static int kill_proc(struct to_kill *tk,
 	pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware memory corruption\n",
 			pfn, t->comm, t->pid);
 
-	if (flags & MF_ACTION_REQUIRED) {
-		if (t == current)
-			ret = force_sig_mceerr(BUS_MCEERR_AR,
-					 (void __user *)tk->addr, addr_lsb);
-		else
-			/* Signal other processes sharing the page if they have PF_MCE_EARLY set. */
-			ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
-				addr_lsb, t);
-	} else {
+	if ((flags & MF_ACTION_REQUIRED) && (t == current))
+		ret = force_sig_mceerr(BUS_MCEERR_AR,
+				 (void __user *)tk->addr, addr_lsb);
+	else
 		/*
+		 * Signal other processes sharing the page if they have
+		 * PF_MCE_EARLY set.
 		 * Don't use force here, it's convenient if the signal
 		 * can be temporarily blocked.
 		 * This could cause a loop when the user sets SIGBUS
@@ -275,7 +272,6 @@ static int kill_proc(struct to_kill *tk,
 		 */
 		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
 				      addr_lsb, t);  /* synchronous? */
-	}
 	if (ret < 0)
 		pr_info("Memory failure: Error sending signal to %s:%d: %d\n",
 			t->comm, t->pid, ret);
_
