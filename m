Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CDE403E9B;
	Tue, 21 Jul 2026 18:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658572; cv=none; b=uQTQxQb8X8MfKOFNuQL8BDw7O6ziImYJbTLrtT9NyhPnuil2/6okfxqf/g/UFW5JM5pOYdtyjfg/itr+mss4QOpG1gJRbOxh1FnM4c81KkeWopX+ucfKXZ13US2CPaePnmQWcz7ZNBeLawl2t2YTCxMBGxn09BZDAx/JsKupJ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658572; c=relaxed/simple;
	bh=htaOBslQambctLLvVdAa/7K0fTO0Ms0mliEoh2aRp1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibiNBbeGJTWt1XnZUlQ5m7TmoRffhU0VjqjzY9LoCzAUgX2IO8IB2LkecgGr/s0cTW54O8P7sDQRN7zPiLJ8hPFTETlUTjwk8qC7/Ju/QGpvS/+PZudsjh4kcwiTHBc8gx1R90tp4Ifxb2CUAtdCkKxnHIaOSDxk4XliiebA6Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSe14GT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSe14GT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336801F000E9;
	Tue, 21 Jul 2026 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658571;
	bh=2SRM4kTXeQYYPmu8sqMh1iR29WXMANLUs194N1n7ELY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSe14GT4nlF3n3OFl14aCHKwsVzXaaQAsTdg1uNfkSGIv8yZfS71s57QNzlNbM/3L
	 KFoPFrmUFDwDtyD/VH9DB9lLZJclIHq9RMFVTVGe0pVj18axj8m0JzQsbEmxmgYakP
	 kwctZB/sy0tzMCVOOnr6DyPfhp6K45/foT29WJEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1193/1611] s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_event_init()
Date: Tue, 21 Jul 2026 17:21:49 +0200
Message-ID: <20260721152542.265929786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/perf_event.h>
+#include <linux/nospec.h>
 
 #include <asm/cpu_mf.h>
 #include <asm/hwctrset.h>
@@ -769,6 +770,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_user))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_user));
 				ev = cpumf_generic_events_user[ev];
 			}
 		} else if (!attr->exclude_kernel && attr->exclude_user) {
@@ -779,6 +781,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_basic))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_basic));
 				ev = cpumf_generic_events_basic[ev];
 			}
 		}


