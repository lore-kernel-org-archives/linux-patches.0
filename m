Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33263331A48;
	Fri,  9 Oct 2026 14:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557619; cv=none; b=kQx5tjlyzwqUKUOJcudwwgwUMhqa1BezLPkvXSh3U/r0OJtSX2jQLVdspo6zvtZAb+yqDA73QsObMCwrZtN56YvS0Zt+814JKbnQS968unfzLD393Wj0XPBYEDwPwGABwlbhEG+7hm1C+Yqjf9rAJLJNh0fhqpbgOH+V3Yg34WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557619; c=relaxed/simple;
	bh=0ObbRyyuwLob1ZB8euAxGFFVgvaZF9MYApr9wp+VuWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eB6aDGTgFR1TD1RUSQh1KXHP6yT3fiJU0LHRDgtl+CdfxSkZnv9fUFasvvbidKu2eDLgTKZCmjQX1WapTQ5icMVmQhKuPh1qHfBsbyVgoJb8lcynMyfecpqH0oSAMmRUGOB1t3hieC87Tpct06HeixZ/BK9DSVHjBa5KXhjkiTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyIk/w9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyIk/w9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376B71F000FF;
	Fri,  9 Oct 2026 14:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557617;
	bh=2gURMHjZRb+FCWlKvv9nSuzRqsG/S1if8VwAlE3vJfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyIk/w9Y7Tz8go/D893THjA2cC9vMoj7+3AHPTg8UvQZIUAZjFAa03jkciJc/dyA7
	 L3fUyQjWqc4AyWSWT53LvqC1QRB29O1HQbhbfBcmvKGox//nCteZv+OtVrFGOx+UbS
	 0ZwcaMQ2OOAtLQy12yGptr8DtYzZUEe/8e3Mp/rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 421/428] perf/core: Check kernel access when kernel callchains are requested
Date: Fri,  9 Oct 2026 16:12:38 +0200
Message-ID: <20261009140955.488009659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit a4573a3838ae4fc73b70019cfa1dac9aaea7cc2f ]

perf_event_open() currently gates perf_allow_kernel() only on
!attr.exclude_kernel.

However, users can still request kernel callchain collection with
attr.exclude_callchain_kernel == 0 even when attr.exclude_kernel == 1.
That still requires kernel profiling privilege, but the existing check
does not enforce it.

Update the permission check to call perf_allow_kernel() when either
kernel sampling is requested or kernel callchains are requested.

This keeps permission checks aligned with requested data and prevents
unprivileged use of kernel callchain capture.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260616044654.3468742-9-dapeng1.mi@linux.intel.com
Stable-dep-of: 357e8a77a501 ("perf: Require kernel access for text poke events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -13882,7 +13882,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
-	if (!attr.exclude_kernel) {
+	if (!attr.exclude_kernel ||
+	    ((attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+	     !attr.exclude_callchain_kernel)) {
 		err = perf_allow_kernel();
 		if (err)
 			return err;


