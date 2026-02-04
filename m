Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8838841B352;
	Wed,  4 Feb 2026 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216816; cv=none; b=nre2qv0FY2kt5pm8otgmGJ2swSOXja857gMlUtu7RFaTITnutv6GBZ5U0fHCTmMFVHpwtLerDiE7MZ8q1STr6/evRZCJrDgUbvJKWaXNtrQyBDnTN1UKMNVQC0E5k0LNxjmxC3LZU1PagnO/b6VO5RBFtZ/DiaRamkkW1pxQCHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216816; c=relaxed/simple;
	bh=/Yft/O9nqTLU4WNHvSMnxYGrdLygB3hY6WJxJGnxjLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Whuh/WSRZdKcVtx1ic4gSH9sfkRQCK1UZ0SWBA16X3Y7PmNLaXADt/Qxj1I747PTc847gBrVt0CXS8KFWU8W9ucTfro30sxzou38/oxLOfvfb4thuV3rJsd0REGpMNrpjiELAgW1bqnpjOvaPFxMl06ZJ3uGRYfStpdOZgIJVGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3i73/1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3i73/1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB136C4CEF7;
	Wed,  4 Feb 2026 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216816;
	bh=/Yft/O9nqTLU4WNHvSMnxYGrdLygB3hY6WJxJGnxjLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3i73/1ga27ibfQe4hWceHWyX+oGp8/Ppl7xlSer7oztDODdQlP109nob+l+KK7kU
	 23uvZM78haZpsa4o/QndKlM0rCCZnOMsEFpHP6VpMoITjCejQgdAJW/b+o6ueFrq3a
	 IkTOOEH8G3sGQr6eY9LzBEwNMdWidPLEvEvQX9co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaochen Shen <shenxiaochen@open-hieco.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.15 039/206] x86/resctrl: Fix memory bandwidth counter width for Hygon
Date: Wed,  4 Feb 2026 15:37:50 +0100
Message-ID: <20260204143859.619873455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaochen Shen <shenxiaochen@open-hieco.net>

commit 7517e899e1b87b4c22a92c7e40d8733c48e4ec3c upstream.

The memory bandwidth calculation relies on reading the hardware counter
and measuring the delta between samples. To ensure accurate measurement,
the software reads the counter frequently enough to prevent it from
rolling over twice between reads.

The default Memory Bandwidth Monitoring (MBM) counter width is 24 bits.
Hygon CPUs provide a 32-bit width counter, but they do not support the
MBM capability CPUID leaf (0xF.[ECX=1]:EAX) to report the width offset
(from 24 bits).

Consequently, the kernel falls back to the 24-bit default counter width,
which causes incorrect overflow handling on Hygon CPUs.

Fix this by explicitly setting the counter width offset to 8 bits (resulting
in a 32-bit total counter width) for Hygon CPUs.

Fixes: d8df126349da ("x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper")
Signed-off-by: Xiaochen Shen <shenxiaochen@open-hieco.net>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251209062650.1536952-3-shenxiaochen@open-hieco.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/core.c     |   15 +++++++++++++--
 arch/x86/kernel/cpu/resctrl/internal.h |    3 +++
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -937,8 +937,19 @@ void resctrl_cpu_detect(struct cpuinfo_x
 		c->x86_cache_occ_scale = ebx;
 		c->x86_cache_mbm_width_offset = eax & 0xff;
 
-		if (c->x86_vendor == X86_VENDOR_AMD && !c->x86_cache_mbm_width_offset)
-			c->x86_cache_mbm_width_offset = MBM_CNTR_WIDTH_OFFSET_AMD;
+		if (!c->x86_cache_mbm_width_offset) {
+			switch (c->x86_vendor) {
+			case X86_VENDOR_AMD:
+				c->x86_cache_mbm_width_offset = MBM_CNTR_WIDTH_OFFSET_AMD;
+				break;
+			case X86_VENDOR_HYGON:
+				c->x86_cache_mbm_width_offset = MBM_CNTR_WIDTH_OFFSET_HYGON;
+				break;
+			default:
+				/* Leave c->x86_cache_mbm_width_offset as 0 */
+				break;
+			}
+		}
 	}
 }
 
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -40,6 +40,9 @@
 #define MAX_MBA_BW_AMD			0x800
 #define MBM_CNTR_WIDTH_OFFSET_AMD	20
 
+/* Hygon MBM counter width as an offset from MBM_CNTR_WIDTH_BASE */
+#define MBM_CNTR_WIDTH_OFFSET_HYGON	8
+
 #define RMID_VAL_ERROR			BIT_ULL(63)
 #define RMID_VAL_UNAVAIL		BIT_ULL(62)
 /*


