Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EC08615A;
	Tue, 17 Dec 2024 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456267; cv=none; b=OlM3NZj/HD5BT8VZl7Kqohx0WKQWStw3AOafe1a+QZIhEoFJG5DDkk4RLTAjUFP9QzpNY4McqsZUBvkiDiV3HdY/vW+9RALktj7dOo1SnUmu9lsEfzY1l54Gv77IgxIBYnVQpz6eCEw7gu6ygHIFG65H+JpWX+fL2BwV+aWEyF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456267; c=relaxed/simple;
	bh=rP4wKt+TtCN5IJPj7/1CP5JR3c/sA2npmBkmfXZJe1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhvNUv9EudacjkRbtXDMs5hsLt2/UFt5mLKejjV1SAW8HcMM+KlfmGyCXP0C7tkdiMJmOuTWR9ouP53LU5lGvgyiZRP1/16ydtmN+r31TryC1D47cwTfwbs0HwE8mTQQI/9bz2Og086P8nvZVcgRl1fKApf47Pf3E6eo79r2enA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7nIWsoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7nIWsoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F22CC4CED3;
	Tue, 17 Dec 2024 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456267;
	bh=rP4wKt+TtCN5IJPj7/1CP5JR3c/sA2npmBkmfXZJe1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7nIWsoEqynDGJk6bei92txrJ2SWJ2j6NdiFOE36I5ZGIvmDyt681tQjlQ8HY7NV3
	 Y3M0bTutJwMWrRoAzjBla78q3VJMA6xcNUCg1FQicl2GrfKh3/2S4or6uIZs1kf/w8
	 89AJ+Ksd3tc3VWs61sJskTlEx8/ah4wH4R1Y7wzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.6 102/109] x86: make get_cpu_vendor() accessible from Xen code
Date: Tue, 17 Dec 2024 18:08:26 +0100
Message-ID: <20241217170537.658337925@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -190,6 +190,8 @@ static inline unsigned long long l1tf_pf
 	return BIT_ULL(boot_cpu_data.x86_cache_bits - 1 - PAGE_SHIFT);
 }
 
+void init_cpu_devs(void);
+void get_cpu_vendor(struct cpuinfo_x86 *c);
 extern void early_cpu_init(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -927,7 +927,7 @@ void detect_ht(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void get_cpu_vendor(struct cpuinfo_x86 *c)
+void get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
 	int i;
@@ -1692,15 +1692,11 @@ static void __init early_identify_cpu(st
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
 
@@ -1708,20 +1704,30 @@ void __init early_cpu_init(void)
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
 


