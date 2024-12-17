Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FC41F707D;
	Tue, 17 Dec 2024 17:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455610; cv=none; b=UnuIWSi69LWcYWIoYTZ3O60+Lu7AQHT9aZNo95Hxci4arKATdO5faXD+jvlortlq1+aVFPL6uyOWcvwiD6x1zB5P/V82iGAH5D0jheIZMfzoeSjPA8hkwApNCja48anYo0DsEUj8gtKEWflyfCQ+8cRnCCYsiMp6rKD7nVPZgqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455610; c=relaxed/simple;
	bh=lpsKyKZs8iQ2IQR5zstdtDFRALbXuhHBHoxH3raypNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkF7YP34MfaMLbv7eNaQ4BzH1pWfAZRHe8hJtWRmJ+j5I7cNjS6AoYivhItrWKy7jEalvnwwRAjdhDZqs0HiDoT8gDwkazO0FC5EHrb6H/CbacRThr87y0aiNf5J1ptJG488W8BsGmv+VAohLaWadaLCpRI/kMC15gDkvDRE3ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZGdg08d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZGdg08d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04F7C4CED7;
	Tue, 17 Dec 2024 17:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455610;
	bh=lpsKyKZs8iQ2IQR5zstdtDFRALbXuhHBHoxH3raypNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZGdg08dUZt/0qftEOHfFIIytuz+i229OAGLA4QXavXPxeIq3DCr7rfRtec4UteVe
	 DmgtTt0oinok+aX9xKXysWQ3ZJWrF+0gQ4o0NCM+TgbdzoyLNaAXhfSaABvcgHxAhw
	 /FtFsAvn2U3s1rqg2EzLNSfWJ8c9Ee4r1DobW1Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/51] ptp: kvm: Use decrypted memory in confidential guest on x86
Date: Tue, 17 Dec 2024 18:07:18 +0100
Message-ID: <20241217170521.323102040@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>

[ Upstream commit 6365ba64b4dbe8b59ddaeaa724b281f3787715d5 ]

KVM_HC_CLOCK_PAIRING currently fails inside SEV-SNP guests because the
guest passes an address to static data to the host. In confidential
computing the host can't access arbitrary guest memory so handling the
hypercall runs into an "rmpfault". To make the hypercall work, the guest
needs to explicitly mark the memory as decrypted. Do that in
kvm_arch_ptp_init(), but retain the previous behavior for
non-confidential guests to save us from having to allocate memory.

Add a new arch-specific function (kvm_arch_ptp_exit()) to free the
allocation and mark the memory as encrypted again.

Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Link: https://lore.kernel.org/r/20230308150531.477741-1-jpiotrowski@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5e7aa97c7acf ("ptp: kvm: x86: Return EOPNOTSUPP instead of ENODEV from kvm_arch_ptp_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_kvm_arm.c    |  4 +++
 drivers/ptp/ptp_kvm_common.c |  1 +
 drivers/ptp/ptp_kvm_x86.c    | 59 +++++++++++++++++++++++++++++-------
 include/linux/ptp_kvm.h      |  1 +
 4 files changed, 54 insertions(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c
index b7d28c8dfb84..e68e6943167b 100644
--- a/drivers/ptp/ptp_kvm_arm.c
+++ b/drivers/ptp/ptp_kvm_arm.c
@@ -22,6 +22,10 @@ int kvm_arch_ptp_init(void)
 	return 0;
 }
 
+void kvm_arch_ptp_exit(void)
+{
+}
+
 int kvm_arch_ptp_get_clock(struct timespec64 *ts)
 {
 	return kvm_arch_ptp_get_crosststamp(NULL, ts, NULL);
diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index fcae32f56f25..051114a59286 100644
--- a/drivers/ptp/ptp_kvm_common.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -130,6 +130,7 @@ static struct kvm_ptp_clock kvm_ptp_clock;
 static void __exit ptp_kvm_exit(void)
 {
 	ptp_clock_unregister(kvm_ptp_clock.ptp_clock);
+	kvm_arch_ptp_exit();
 }
 
 static int __init ptp_kvm_init(void)
diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 4991054a2135..902844cc1a17 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -14,27 +14,64 @@
 #include <uapi/linux/kvm_para.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/ptp_kvm.h>
+#include <linux/set_memory.h>
 
 static phys_addr_t clock_pair_gpa;
-static struct kvm_clock_pairing clock_pair;
+static struct kvm_clock_pairing clock_pair_glbl;
+static struct kvm_clock_pairing *clock_pair;
 
 int kvm_arch_ptp_init(void)
 {
+	struct page *p;
 	long ret;
 
 	if (!kvm_para_available())
 		return -ENODEV;
 
-	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
-	if (!pvclock_get_pvti_cpu0_va())
-		return -ENODEV;
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		p = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!p)
+			return -ENOMEM;
+
+		clock_pair = page_address(p);
+		ret = set_memory_decrypted((unsigned long)clock_pair, 1);
+		if (ret) {
+			__free_page(p);
+			clock_pair = NULL;
+			goto nofree;
+		}
+	} else {
+		clock_pair = &clock_pair_glbl;
+	}
+
+	clock_pair_gpa = slow_virt_to_phys(clock_pair);
+	if (!pvclock_get_pvti_cpu0_va()) {
+		ret = -ENODEV;
+		goto err;
+	}
 
 	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
 			     KVM_CLOCK_PAIRING_WALLCLOCK);
-	if (ret == -KVM_ENOSYS)
-		return -ENODEV;
+	if (ret == -KVM_ENOSYS) {
+		ret = -ENODEV;
+		goto err;
+	}
 
 	return ret;
+
+err:
+	kvm_arch_ptp_exit();
+nofree:
+	return ret;
+}
+
+void kvm_arch_ptp_exit(void)
+{
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		WARN_ON(set_memory_encrypted((unsigned long)clock_pair, 1));
+		free_page((unsigned long)clock_pair);
+		clock_pair = NULL;
+	}
 }
 
 int kvm_arch_ptp_get_clock(struct timespec64 *ts)
@@ -49,8 +86,8 @@ int kvm_arch_ptp_get_clock(struct timespec64 *ts)
 		return -EOPNOTSUPP;
 	}
 
-	ts->tv_sec = clock_pair.sec;
-	ts->tv_nsec = clock_pair.nsec;
+	ts->tv_sec = clock_pair->sec;
+	ts->tv_nsec = clock_pair->nsec;
 
 	return 0;
 }
@@ -81,9 +118,9 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
 			pr_err_ratelimited("clock pairing hypercall ret %lu\n", ret);
 			return -EOPNOTSUPP;
 		}
-		tspec->tv_sec = clock_pair.sec;
-		tspec->tv_nsec = clock_pair.nsec;
-		*cycle = __pvclock_read_cycles(src, clock_pair.tsc);
+		tspec->tv_sec = clock_pair->sec;
+		tspec->tv_nsec = clock_pair->nsec;
+		*cycle = __pvclock_read_cycles(src, clock_pair->tsc);
 	} while (pvclock_read_retry(src, version));
 
 	*cs = &kvm_clock;
diff --git a/include/linux/ptp_kvm.h b/include/linux/ptp_kvm.h
index f960a719f0d5..c1636ce76bd2 100644
--- a/include/linux/ptp_kvm.h
+++ b/include/linux/ptp_kvm.h
@@ -12,6 +12,7 @@ struct timespec64;
 struct clocksource;
 
 int kvm_arch_ptp_init(void);
+void kvm_arch_ptp_exit(void);
 int kvm_arch_ptp_get_clock(struct timespec64 *ts);
 int kvm_arch_ptp_get_crosststamp(u64 *cycle,
 		struct timespec64 *tspec, struct clocksource **cs);
-- 
2.39.5



