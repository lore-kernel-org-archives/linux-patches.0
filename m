Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD3A1519B4;
	Wed,  5 Feb 2025 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768377; cv=none; b=ggsXuGdfaYLe4zkUkKa2/MBBzRcT51z3nPn2+VN6RTODVaclvab+tjH0HC5pbRnyQl8yqEW9DIYT9b2CrL/zjfOOP4WpXbYZjAFsf+fMLHUwlFnE0DLOI5yienOsFBII4TiCz3Vdp/0+Vn2JFk8U5R53+HBOzbcrCSMkrhkquOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768377; c=relaxed/simple;
	bh=b5MWfYxjBHkSCE9CVJwQgiMxnQdSEAJaACXK1gsKGig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaDY9xMppLfBTR+gpp77e3zR0TF8mtGOMiVf1G4vyKoHjm0XvVD2C9sfFTQRZDuFuFKjDJjVZXHSZjtebgh3LwMJ0fFn2QVY/wgx77RCm5T9AyYKPk9qTB8Q1BvKVSfkzu5D9SovtIAkS6m6HE8mdXIGzi3c1Q13ACRX8nyjx7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GF6J32hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GF6J32hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A545FC4CED1;
	Wed,  5 Feb 2025 15:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768377;
	bh=b5MWfYxjBHkSCE9CVJwQgiMxnQdSEAJaACXK1gsKGig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GF6J32hgYhbl6ezZu/f50OEoHLa15prOlT/+rqW3V5z7Ho3800CDk5JrVRVbGRTWi
	 OtB1wK9xcx385Xd/cj6c7q4tSagCvevbyGdOCdRXyyKHgS+cC596Nd7kXeJ0QrdZxo
	 kVdCdXrLnNlK5FOTpDQY0WB6sqEpRmbK/iOOAJyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheshu Ramanandan <sheshu.ramanandan@ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 538/623] s390/sclp: Initialize sclp subsystem via arch_cpu_finalize_init()
Date: Wed,  5 Feb 2025 14:44:40 +0100
Message-ID: <20250205134516.805197530@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 3bcc8a1af581af152d43e42b53db3534018301b5 ]

With the switch to GENERIC_CPU_DEVICES an early call to the sclp subsystem
was added to smp_prepare_cpus(). This will usually succeed since the sclp
subsystem is implicitly initialized early enough if an sclp based console
is present.

If no such console is present the initialization happens with an
arch_initcall(); in such cases calls to the sclp subsystem will fail.
For CPU detection this means that the fallback sigp loop will be used
permanently to detect CPUs instead of the preferred READ_CPU_INFO sclp
request.

Fix this by adding an explicit early sclp_init() call via
arch_cpu_finalize_init().

Reported-by: Sheshu Ramanandan <sheshu.ramanandan@ibm.com>
Fixes: 4a39f12e753d ("s390/smp: Switch to GENERIC_CPU_DEVICES")
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig            |  1 +
 arch/s390/include/asm/sclp.h |  1 +
 arch/s390/kernel/setup.c     |  5 +++++
 drivers/s390/char/sclp.c     | 12 ++----------
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 0077969170e8b..83b1d7bbd8880 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -72,6 +72,7 @@ config S390
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
+	select ARCH_HAS_CPU_FINALIZE_INIT
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE
diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index eb00fa1771da0..ad17d91ad2e66 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -137,6 +137,7 @@ void sclp_early_printk(const char *s);
 void __sclp_early_printk(const char *s, unsigned int len);
 void sclp_emergency_printk(const char *s);
 
+int sclp_init(void);
 int sclp_early_get_memsize(unsigned long *mem);
 int sclp_early_get_hsa_size(unsigned long *hsa_size);
 int _sclp_get_core_info(struct sclp_core_info *info);
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index a3fea683b2270..99f165726ca9e 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1006,3 +1006,8 @@ void __init setup_arch(char **cmdline_p)
 	/* Add system specific data to the random pool */
 	setup_randomness();
 }
+
+void __init arch_cpu_finalize_init(void)
+{
+	sclp_init();
+}
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index fbffd451031fd..45bd001206a2b 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -245,7 +245,6 @@ static void sclp_request_timeout(bool force_restart);
 static void sclp_process_queue(void);
 static void __sclp_make_read_req(void);
 static int sclp_init_mask(int calculate);
-static int sclp_init(void);
 
 static void
 __sclp_queue_read_req(void)
@@ -1251,8 +1250,7 @@ static struct platform_driver sclp_pdrv = {
 
 /* Initialize SCLP driver. Return zero if driver is operational, non-zero
  * otherwise. */
-static int
-sclp_init(void)
+int sclp_init(void)
 {
 	unsigned long flags;
 	int rc = 0;
@@ -1305,13 +1303,7 @@ sclp_init(void)
 
 static __init int sclp_initcall(void)
 {
-	int rc;
-
-	rc = platform_driver_register(&sclp_pdrv);
-	if (rc)
-		return rc;
-
-	return sclp_init();
+	return platform_driver_register(&sclp_pdrv);
 }
 
 arch_initcall(sclp_initcall);
-- 
2.39.5



