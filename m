Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91113415F15;
	Tue, 21 Jul 2026 19:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663709; cv=none; b=YnyD3dZ3JwJOoYQBlmcd49vq3n7bV/4Re777aNHJK0rUAtM5KufjAQAml1lIqCddsTggnckwfj7RjbBTzcEXdHFzyUdj8IZ2GzubaXJdRx/y0C5dLBI5urdpCsX54F3XQp5tzyq7oi9auvnmat4fqMq3BIXZH2VZ28CkKgUv3SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663709; c=relaxed/simple;
	bh=3UZrYLztSJhlsYhvD/YrA++Q3zEKe1zaqC2axktU6+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riT5uc4n7M5xopDmLQvM1wXxNTsHQRosI7V8aGfxtSkscKScTltW43wZVRP12/SuTTj7UGZI+flSukGweswRLeVYL77whiZAyh6pCV/TK0AojNxlu8Pos5rA+yRKkQf+kxa2WAKnjKw+fFPWZMl7Z28vm60B9PCPxhpYYeJip7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpQ+orFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpQ+orFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0259B1F000E9;
	Tue, 21 Jul 2026 19:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663708;
	bh=3+FANhUu7wYX7IRtaPf8h2YADgeq+HnRvH+MbsVJVCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpQ+orFW9PAIMbGsFgTVYK0apD67Y9oqbymbrtfS6oo2KAMa6vMqpLZzwuTHwdrlR
	 zr1ypvNj00ogCefieNN2xvV0QZF7yOarhBCjIBCmOer7qPqrgxh3RLUtDdJqHveTv6
	 obu7ejEZAADokEdXmcPMCW64TT1pc76vDsNDpU0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 0881/1276] s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_event_init()
Date: Tue, 21 Jul 2026 17:22:04 +0200
Message-ID: <20260721152505.766115976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -17,6 +17,7 @@
 #include <linux/export.h>
 #include <linux/miscdevice.h>
 #include <linux/perf_event.h>
+#include <linux/nospec.h>
 
 #include <asm/cpu_mf.h>
 #include <asm/hwctrset.h>
@@ -770,6 +771,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_user))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_user));
 				ev = cpumf_generic_events_user[ev];
 			}
 		} else if (!attr->exclude_kernel && attr->exclude_user) {
@@ -780,6 +782,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_basic))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_basic));
 				ev = cpumf_generic_events_basic[ev];
 			}
 		}


