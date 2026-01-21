Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40723A4AD4;
	Wed, 21 Jan 2026 18:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019878; cv=none; b=rOzwDLpsF9HlxZRISmFPIlXj1iOrceTbJCtVTlZB/m/u+Xt3Jfp04K40kT8AM980060P14U1R9Qxtw9NOy7oLJCR3C69BBOoZMVQnOsBUbD3JuYE/6jSrUTsoXtPawtHVKWHL3gHB89JFOLqCKjKaQOgtA/DsJM3nUREtjQTZnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019878; c=relaxed/simple;
	bh=R+Cjx9IbAkUD1pPQst4PMns1IJPcNeRR6e37u1KW85U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBfQVyPELeXZzvYkKX3HbPVSAXX1VhKUT5lSUph4bek+TiwjV8nGv/YC9jnYJEJMpbuOWhqFmjSJDSkP4tY5Lpxp45/lZHbGyl0oL4LX0iDCgBpvBIbRmbEB6qAJ8ia3csEMEQHmMQBpSSik13pKLzNiWQWMSyYHEmmOwyoDVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwMvYxAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwMvYxAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C9FC19422;
	Wed, 21 Jan 2026 18:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019878;
	bh=R+Cjx9IbAkUD1pPQst4PMns1IJPcNeRR6e37u1KW85U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwMvYxAz8MLTtXs43eqdTSxPq/a6woM3jUuzSgU5Az+P+n2zyIL/r16BNJgMWDC0w
	 Qaj1NaEIA1wbQ6Th7ST6peT2fDzDre17FfSbal1Ibe65yBE8GosEFRo7DEnfBm1JoM
	 8TVSliXNZUEkKSDy4Y+57o9R5ehpvLsQuzsG1JGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaochen Shen <shenxiaochen@open-hieco.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6.12 092/139] x86/resctrl: Fix memory bandwidth counter width for Hygon
Date: Wed, 21 Jan 2026 19:15:40 +0100
Message-ID: <20260121181414.765451588@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1076,8 +1076,19 @@ void resctrl_cpu_detect(struct cpuinfo_x
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
@@ -23,6 +23,9 @@
 #define MBA_IS_LINEAR			0x4
 #define MBM_CNTR_WIDTH_OFFSET_AMD	20
 
+/* Hygon MBM counter width as an offset from MBM_CNTR_WIDTH_BASE */
+#define MBM_CNTR_WIDTH_OFFSET_HYGON	8
+
 #define RMID_VAL_ERROR			BIT_ULL(63)
 #define RMID_VAL_UNAVAIL		BIT_ULL(62)
 /*


