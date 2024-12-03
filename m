Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D4D1EE00B;
	Tue,  3 Dec 2024 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242552; cv=none; b=dvjoiJBpWS3yVvYrQRB2eT3PPmha9HcYdXv88fBxfaT+51ghOp6meh27Gy4sd4OdcM55bY1kIaRhh+RPtZeNg4/M3DQku/rt4f6brfjWMDx5G9Www+taeBpzzINZBWEP0n9cI1q2rPH/DVRIuX0i9cTmlH8KAukldK+C9YF0DTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242552; c=relaxed/simple;
	bh=nZspasAx/GDhvT8hA4RLPAn8J0DtVhLWa7Q+F7IMpRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaqDc7qwEiH27ylt0faFJlg7N+PtWAZ4RtcWlz9E5ODn5Pe1SDyg8YylMby7LVRRXXtNYLWNktfUh1tTVV35t6zEhDese9QqTZFU/YYWRHujJAEM7N2E2woZ4G3HtMgrseuIsRo3LMkZtxb86eX5oL5/u7/EZN6lSHBwXPDSHJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeptmOIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeptmOIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3252CC4CECF;
	Tue,  3 Dec 2024 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242552;
	bh=nZspasAx/GDhvT8hA4RLPAn8J0DtVhLWa7Q+F7IMpRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeptmOIVCltJG2kJ4KaAeNTKIvVS+htbre9IdTSybTZxjA9q8U1HoyTvOOZn/7xSA
	 IdD5+CvoFNUE1nFy6jJGBOF8N/XcGhdUF/tJPTHqkVTsas3WFM4LZh0OJrtaYwQpJU
	 usmqZhADSHFv8oYzizuKuUUgQT/0tGnoZd/XduiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 738/826] x86/mm: Carve out INVLPG inline asm for use by others
Date: Tue,  3 Dec 2024 15:47:45 +0100
Message-ID: <20241203144812.552787116@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit f1d84b59cbb9547c243d93991acf187fdbe9fbe9 upstream.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/ZyulbYuvrkshfsd2@antipodes
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/tlb.h |    4 ++++
 arch/x86/mm/tlb.c          |    3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -34,4 +34,8 @@ static inline void __tlb_remove_table(vo
 	free_page_and_swap_cache(table);
 }
 
+static inline void invlpg(unsigned long addr)
+{
+	asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
+}
 #endif /* _ASM_X86_TLB_H */
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -20,6 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/apic.h>
 #include <asm/perf_event.h>
+#include <asm/tlb.h>
 
 #include "mm_internal.h"
 
@@ -1140,7 +1141,7 @@ STATIC_NOPV void native_flush_tlb_one_us
 	bool cpu_pcide;
 
 	/* Flush 'addr' from the kernel PCID: */
-	asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
+	invlpg(addr);
 
 	/* If PTI is off there is no user PCID and nothing to flush. */
 	if (!static_cpu_has(X86_FEATURE_PTI))


