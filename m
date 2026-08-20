Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55302476CFA;
	Thu, 20 Aug 2026 17:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248068; cv=none; b=GMNr/306eEvdRvnbx6KDGs9GDXwmBNY6NxXALjapL+NlhfyCORcptv5XAM0j7H/Cyny8vvvX5oCIPGnz7oaw+iO5UhtV7Bu7TkoNbJ+RjQQSp0uRA/caYiZNKZBJYYMHNHkyL9HJclR90CvDkIdNqXtQtjXQIv6g9imNDwCYmE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248068; c=relaxed/simple;
	bh=33HfgPqv5wv8Js0YokV2NnFSSE0rstJEySwP+6KrJfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2xHqzIRUTyVjEaO7w6GinyD8vUuGgbGNnWGa9CNAO7PtWC7Y8p3WhCxSxuP6Yvx3hqdj+5PwVbMe4u7oL1UID0jwHIooE+gsjY6w+PFrc5EE/vL3PavEnCZtb3dexAjXDHLSAqiQ2L25UlG412fr101ivYtJQ1mIn4Qtuj+MXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYMsO7r8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYMsO7r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25851F00A3E;
	Thu, 20 Aug 2026 17:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248067;
	bh=BP2ulOs6zOhq9YarNj6qJZUpM6smwca8bQGSDjr+PO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYMsO7r8goM+3auIlnWneOLOdzjuIv70gar1AsHPPxCHRB6SL2nr0/nPfFkr//BXH
	 jTcY3Q1hxNIfTdUZ3KKmhkVKN4QDG3t/Fnl1RlEaB3oIShrR2EGFfXGavZkQz1fgEi
	 BFmGhT/7mUn3f39zHIrfOKANXRzMojGuwU85l4vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/303] s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_event_init()
Date: Thu, 20 Aug 2026 16:53:54 +0200
Message-ID: <20260820145256.237281306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

[ Upstream commit 49145bce539117db4b6e9e83c0e5ef528e361050 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
@@ -633,6 +634,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_user))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_user));
 				ev = cpumf_generic_events_user[ev];
 			}
 		} else if (!attr->exclude_kernel && attr->exclude_user) {
@@ -643,6 +645,7 @@ static int __hw_perf_event_init(struct p
 			if (!is_userspace_event(ev)) {
 				if (ev >= ARRAY_SIZE(cpumf_generic_events_basic))
 					return -EOPNOTSUPP;
+				ev = array_index_nospec(ev, ARRAY_SIZE(cpumf_generic_events_basic));
 				ev = cpumf_generic_events_basic[ev];
 			}
 		}


