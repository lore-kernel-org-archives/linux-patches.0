Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BA1401A13;
	Tue, 21 Jul 2026 17:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654260; cv=none; b=J0cQxUFRVfmcvz5Fcd3LI0skvOQihfScd+NJwnD6sUePGInNPw892Emf2yy9++7Fe8qlBH6BZCjG3b2iFLX8wVkQ8QkdEWvGfB/DXC7ClPkZG4zUJ56XMpcdkSNCk+s098hur/FJWmksf3Hlp5ba0dV8rMaJ9KXcVd9ndeaSe9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654260; c=relaxed/simple;
	bh=8zrpVYVsdSLr3EX8rOSqSsuAcVxVJCGV4MyqJLvhCk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pyts+pC1+HvwuTajTFbIIMaAPkXoHDFlRRuBJsCGKC+3pp3avHK/H/OGizRxhdMz4iHFMJBfORYfSYDKULB+lY7qCH7mSRhgz6ylt621ot1hkvhgERTXqr33FElPpdnq3NlihhUOSR5N/YCH2fcskrCT6pQi2m0JOETDnkkQ8Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQDnD4Wo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQDnD4Wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA681F000E9;
	Tue, 21 Jul 2026 17:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654259;
	bh=iCn9ljFNMZzg7kcAimbD6FbzNzZIafXSnFKQeaXDuXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQDnD4WogqaS9j9acT1iJyDDoGbLx5D0+6vAstSAZNjLbP27T86KBUjt9KTislFcE
	 RdWaqhOfwMmfpABgVJZzYIrIprgZNjzcFV568CHMG25avW30H1338NeAUtZSLkLLB0
	 v6UBoJZRNsNYEqiXJR9go+bHU47CVc+Lf2BPDWxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.1 1637/2077] s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_event_init()
Date: Tue, 21 Jul 2026 17:21:50 +0200
Message-ID: <20260721152631.362000919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

commit 49145bce539117db4b6e9e83c0e5ef528e361050 upstream.

ev variable is userspace controlled via event->attr.config and used
as an array index after bounds checking, but without speculation
barriers.

Add the missing array_index_nospec() call to prevent speculative
execution.

Cc: stable@vger.kernel.org
Fixes: 212188a596d1 ("[S390] perf: add support for s390x CPU counters")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_cpum_cf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/perf_event.h>
+#include <linux/nospec.h>
 
 #include <asm/cpu_mf.h>
 #include <asm/hwctrset.h>
@@ -768,6 +769,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_user))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_user));
 				ev = cpumf_generic_events_user[ev];
 			}
 		} else if (!attr->exclude_kernel && attr->exclude_user) {
@@ -778,6 +780,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_basic))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_basic));
 				ev = cpumf_generic_events_basic[ev];
 			}
 		}


