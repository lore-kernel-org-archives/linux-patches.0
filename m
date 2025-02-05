Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F420E70825;
	Wed,  5 Feb 2025 15:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767764; cv=none; b=C0B96AVnn3mGQm7FWU5Bw70OQESRoUsViGuCBA9yDXlbsA/hfjUXU5AU9cggCsuYB6/i4fmX2iuHuTysVhXmaPpPZuFKcorx4Km3q8Ub64NNkmBSnjGJWjcxqwMxpTUD+cLMD6pIT9ta0wuwVGTWde2iU0g3EVMgv5gkVVZR6Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767764; c=relaxed/simple;
	bh=aYZ2Iwtuvc81o9jx3L4D6kZTphuq9vxqe/OmOzH07lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcL86q/UftyTUvVmhkopiIbzSWakfuePBbW7P3/enV8qSCopkj17krC3Kd4W8oQf8h4Npw2w83l34ilnuAWHw4LkNHOdbl4a6p+b4xxH2I+Ov2Y5d6S0BNkk9zGuEFwAwAm/O7u/+B/P/19RxuKVkZi++RGLWH1eNfHxGchOEFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVoqeujt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVoqeujt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49430C4CED1;
	Wed,  5 Feb 2025 15:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767763;
	bh=aYZ2Iwtuvc81o9jx3L4D6kZTphuq9vxqe/OmOzH07lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVoqeujtJcwMobhxLgOPgdcOFVNqAFJOZU78crmLjgGyFzSU+xDV10sTSrrY7Hf8e
	 oOtuG9J9ErnQRIu+4ZGvW3nooaKfayV8+kBdLo5lEjF44p/RBjmZ2KHG52W4zC5xus
	 J4whjpVH5ZaOJYEUSxwZ6BrH3MOyWdD3+2rF6lHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheshu Ramanandan <sheshu.ramanandan@ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 506/590] s390/sclp: Initialize sclp subsystem via arch_cpu_finalize_init()
Date: Wed,  5 Feb 2025 14:44:21 +0100
Message-ID: <20250205134514.627215513@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cc1f9cffe2a5f..62f2c9e8e05f7 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -65,6 +65,7 @@ config S390
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



