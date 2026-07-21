Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2F53B8BA4;
	Tue, 21 Jul 2026 20:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667129; cv=none; b=nD3sm68ZCAk+uSPGlf6sXBzVfMOpS7paH58mzUc3kj3KSR9k1VAlGcnjSkAvGwU4qnI2If/MtJhqqjr7WqEf/yvVPFDmtEbvO+EDQlIbwE1skRfvHIgk+uv7DGfBc9fjvOm/vVDh7B84K3rax8AdtGk0g1gMBqkhLSyNHL6QWF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667129; c=relaxed/simple;
	bh=zTwANm4Mi4jxidbtpYrHQ4PtlmLaI/iKv/KmYP8sET4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3fb186twkWCHVBF4Ydz2VxdoeM9XaBERYEhIFvxl7Orst0GwfG4/mP0G6iWRRCX1DZ7kVcBBZIhzIpK6HKwV8MBcEB1tVl2byBX9ADtbmA1Xo/QweFP020b0pquy4mE/NI+eOZolw832di/FZ66CWmOVg3QGKepcAVcfG4BKck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywKIIzOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywKIIzOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77851F000E9;
	Tue, 21 Jul 2026 20:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667128;
	bh=6/HaMUVvuivhznOmdsNAFaLBu1HZGgXOiYT7yQeOQaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywKIIzOkpEcff/ZBn2UvAmI5IsLNiq4gNuslGkmS02lsni9XkfW+HaVuw2jNW8J/Q
	 f3xZRYwgh54tQEVcXTNmxbIlVu2fIWZN5RIAxpHq9DtpbptTbkPUF1oSF+Fj+OIJpT
	 yG8zEMUW57tYvz/3+gG9TNvaiP6Oo3ue03B9XLCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 0944/1266] s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_event_init()
Date: Tue, 21 Jul 2026 17:23:01 +0200
Message-ID: <20260721152502.955774576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -766,6 +767,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_user))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_user));
 				ev = cpumf_generic_events_user[ev];
 			}
 		} else if (!attr->exclude_kernel && attr->exclude_user) {
@@ -776,6 +778,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_basic))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_basic));
 				ev = cpumf_generic_events_basic[ev];
 			}
 		}


