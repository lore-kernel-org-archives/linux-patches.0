Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1F936D9F7;
	Sat, 28 Feb 2026 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301435; cv=none; b=Yyxyz7SsZnptXb/FjvfXGhgcaiL7oT/SxK/LekwwPyH8c3u9h5+CeDf40rLorZmV7H7eq4had8iZV8VwyqZrXVDlPvpSrH8rn9a4y12w5SRk/6gu9DGrfx1M0xe0KSFKx/ZuSMRK2Vyt73WtAMN8e4DFv7Mqxpe4dfb85fVr4PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301435; c=relaxed/simple;
	bh=NG6KsHGhCYCyBAMOLAxtK7Ymu497bdXMUaieBzxkmTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsAXRjVM4x+SouNCcE4FZcrlOenof62lVv8Pq6tl64tKZeXeF9lXmbhSO4i+77H6ZTLKoJrBiWA5bQ+lNd6el7jZg9HNCHdM1telVTv2ssgO7GeI8Eaq9SPCnZcunpRsCTZp3rawM12A/SEYNaBQGUzEMDoD24/+olXjduGw08s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPgfVNSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPgfVNSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF277C116D0;
	Sat, 28 Feb 2026 17:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301435;
	bh=NG6KsHGhCYCyBAMOLAxtK7Ymu497bdXMUaieBzxkmTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPgfVNSR07m/XS6sywHGMegUz1itQhno+ohtjrZTIdrJuaw+rzKWuvJux4DjqABus
	 yQcChPMkVr3v7SlIs3BbtVTZjT+Y/NSXLaBbCBNxkUxiZ9WkpJWVu166L5nx3bK4bO
	 uK13RShR9dnPzQVnT/LVh7/01AJMVRgMOkbIFFqlGkKy7W4QsK5c6UK2aBa0ghmU1p
	 z/p94iGS2RI07BfkhCzo7EmhL+BRLLvCao3DIIsoPTn6Va1BumFzrZx5rigY+qujko
	 WBVClFfyc5lfttXmEPftd662h3sDlf1Fz7LA62Hh2PQPRT5H+D3B910dIPlzNMpKvu
	 DSYEKMErqb26g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Alexander Graf <graf@amazon.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Betkov <bp@alien8.de>,
	guoweikang <guoweikang.kernel@gmail.com>,
	Henry Willard <henry.willard@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Bohac <jbohac@suse.cz>,
	Joel Granados <joel.granados@kernel.org>,
	Jonathan McDowell <noodles@fb.com>,
	Mike Rapoport <rppt@kernel.org>,
	Paul Webb <paul.x.webb@oracle.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Yifei Liu <yifei.l.liu@oracle.com>,
	Baoquan He <bhe@redhat.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 624/752] ima: verify the previous kernel's IMA buffer lies in addressable RAM
Date: Sat, 28 Feb 2026 12:45:35 -0500
Message-ID: <20260228174750.1542406-624-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 10d1c75ed4382a8e79874379caa2ead8952734f9 ]

Patch series "Address page fault in ima_restore_measurement_list()", v3.

When the second-stage kernel is booted via kexec with a limiting command
line such as "mem=<size>" we observe a pafe fault that happens.

    BUG: unable to handle page fault for address: ffff97793ff47000
    RIP: ima_restore_measurement_list+0xdc/0x45a
    #PF: error_code(0x0000)  not-present page

This happens on x86_64 only, as this is already fixed in aarch64 in
commit: cbf9c4b9617b ("of: check previous kernel's ima-kexec-buffer
against memory bounds")

This patch (of 3):

When the second-stage kernel is booted with a limiting command line (e.g.
"mem=<size>"), the IMA measurement buffer handed over from the previous
kernel may fall outside the addressable RAM of the new kernel.  Accessing
such a buffer can fault during early restore.

Introduce a small generic helper, ima_validate_range(), which verifies
that a physical [start, end] range for the previous-kernel IMA buffer lies
within addressable memory:
	- On x86, use pfn_range_is_mapped().
	- On OF based architectures, use page_is_ram().

Link: https://lkml.kernel.org/r/20251231061609.907170-1-harshit.m.mogalapalli@oracle.com
Link: https://lkml.kernel.org/r/20251231061609.907170-2-harshit.m.mogalapalli@oracle.com
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Jonathan McDowell <noodles@fb.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Webb <paul.x.webb@oracle.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ima.h                |  1 +
 security/integrity/ima/ima_kexec.c | 35 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 8e29cb4e6a01d..abf8923f8fc51 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -69,6 +69,7 @@ static inline int ima_measure_critical_data(const char *event_label,
 #ifdef CONFIG_HAVE_IMA_KEXEC
 int __init ima_free_kexec_buffer(void);
 int __init ima_get_kexec_buffer(void **addr, size_t *size);
+int ima_validate_range(phys_addr_t phys, size_t size);
 #endif
 
 #ifdef CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT
diff --git a/security/integrity/ima/ima_kexec.c b/security/integrity/ima/ima_kexec.c
index 5beb69edd12fd..36a34c54de58b 100644
--- a/security/integrity/ima/ima_kexec.c
+++ b/security/integrity/ima/ima_kexec.c
@@ -12,6 +12,8 @@
 #include <linux/kexec.h>
 #include <linux/of.h>
 #include <linux/ima.h>
+#include <linux/mm.h>
+#include <linux/overflow.h>
 #include <linux/reboot.h>
 #include <asm/page.h>
 #include "ima.h"
@@ -294,3 +296,36 @@ void __init ima_load_kexec_buffer(void)
 		pr_debug("Error restoring the measurement list: %d\n", rc);
 	}
 }
+
+/*
+ * ima_validate_range - verify a physical buffer lies in addressable RAM
+ * @phys: physical start address of the buffer from previous kernel
+ * @size: size of the buffer
+ *
+ * On success return 0. On failure returns -EINVAL so callers can skip
+ * restoring.
+ */
+int ima_validate_range(phys_addr_t phys, size_t size)
+{
+	unsigned long start_pfn, end_pfn;
+	phys_addr_t end_phys;
+
+	if (check_add_overflow(phys, (phys_addr_t)size - 1, &end_phys))
+		return -EINVAL;
+
+	start_pfn = PHYS_PFN(phys);
+	end_pfn = PHYS_PFN(end_phys);
+
+#ifdef CONFIG_X86
+	if (!pfn_range_is_mapped(start_pfn, end_pfn))
+#else
+	if (!page_is_ram(start_pfn) || !page_is_ram(end_pfn))
+#endif
+	{
+		pr_warn("IMA: previous kernel measurement buffer %pa (size 0x%zx) lies outside available memory\n",
+			&phys, size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
-- 
2.51.0

