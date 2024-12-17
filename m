Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BB8149DFA;
	Tue, 17 Dec 2024 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455549; cv=none; b=fcabr/TDrgYmATswg7ItziWGUmk9k8s+CMjJDTkd4/C7dwE3+OZEf2B6yoxcSnneWVV3UA25k4djE1pU3akpnSvoEcPux0vkmQ9vlYINC1ANVMan8sSPtIJCADgVlHm5F9R9Q7+kAWpxcNUw1kI251D/dhUdqviX6CdKrDpiHKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455549; c=relaxed/simple;
	bh=nXG3OKXvEm40OGVHDzM54CLhsC73E27Fka5CDuUm+84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4LGC7y/ySebcaWyJxWOOfQSR/asJXrqitCHVC9gfNIghQAk4R3D8lYb7GVY+OsRANf7IcsSdMvewCOhlwzGZ4cr3PB0rqg9iaLz0GMtJBIA+Ihl/9KaWUDruCl55FbuLB+6P5BijJvzCeNrmne2RyKD7PAxIanCunStcN0tbYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kf/d+wYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kf/d+wYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD1DC4CED3;
	Tue, 17 Dec 2024 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455549;
	bh=nXG3OKXvEm40OGVHDzM54CLhsC73E27Fka5CDuUm+84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kf/d+wYNgctFU85/QH3iRZSrrAdcL2E4EhIyDcJR2lDs2zQT1HAhOutP9DJ4NsHCu
	 DHl+NSqgXmefZ9tdb7FvVVVwjqz/L5BOINisNlQIwV1jEyzPcMgXKtwX6u2De6uQ2L
	 iwbaVZ0Nqv+dME+Lx71uDp5JfGfv/XZUw3UCI3Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 36/43] x86: make get_cpu_vendor() accessible from Xen code
Date: Tue, 17 Dec 2024 18:07:27 +0100
Message-ID: <20241217170522.165121640@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit efbcd61d9bebb771c836a3b8bfced8165633db7c upstream.

In order to be able to differentiate between AMD and Intel based
systems for very early hypercalls without having to rely on the Xen
hypercall page, make get_cpu_vendor() non-static.

Refactor early_cpu_init() for the same reason by splitting out the
loop initializing cpu_devs() into an externally callable function.

This is part of XSA-466 / CVE-2024-53241.

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/common.c     |   36 +++++++++++++++++++++---------------
 2 files changed, 23 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -194,6 +194,8 @@ static inline unsigned long long l1tf_pf
 	return BIT_ULL(boot_cpu_data.x86_cache_bits - 1 - PAGE_SHIFT);
 }
 
+void init_cpu_devs(void);
+void get_cpu_vendor(struct cpuinfo_x86 *c);
 extern void early_cpu_init(void);
 extern void identify_boot_cpu(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -792,7 +792,7 @@ void detect_ht(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void get_cpu_vendor(struct cpuinfo_x86 *c)
+void get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
 	int i;
@@ -1505,15 +1505,11 @@ static void __init early_identify_cpu(st
 	detect_nopl();
 }
 
-void __init early_cpu_init(void)
+void __init init_cpu_devs(void)
 {
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
-#ifdef CONFIG_PROCESSOR_SELECT
-	pr_info("KERNEL supported cpus:\n");
-#endif
-
 	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
 		const struct cpu_dev *cpudev = *cdev;
 
@@ -1521,20 +1517,30 @@ void __init early_cpu_init(void)
 			break;
 		cpu_devs[count] = cpudev;
 		count++;
+	}
+}
 
+void __init early_cpu_init(void)
+{
 #ifdef CONFIG_PROCESSOR_SELECT
-		{
-			unsigned int j;
+	unsigned int i, j;
 
-			for (j = 0; j < 2; j++) {
-				if (!cpudev->c_ident[j])
-					continue;
-				pr_info("  %s %s\n", cpudev->c_vendor,
-					cpudev->c_ident[j]);
-			}
-		}
+	pr_info("KERNEL supported cpus:\n");
 #endif
+
+	init_cpu_devs();
+
+#ifdef CONFIG_PROCESSOR_SELECT
+	for (i = 0; i < X86_VENDOR_NUM && cpu_devs[i]; i++) {
+		for (j = 0; j < 2; j++) {
+			if (!cpu_devs[i]->c_ident[j])
+				continue;
+			pr_info("  %s %s\n", cpu_devs[i]->c_vendor,
+				cpu_devs[i]->c_ident[j]);
+		}
 	}
+#endif
+
 	early_identify_cpu(&boot_cpu_data);
 }
 


