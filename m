Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A69C18EFD4;
	Wed,  5 Feb 2025 15:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768538; cv=none; b=lhM0RB5m7Ha5SD+qmxIGGrTh89dYHfoHBLPXWqsnowtj6nl4Zefi/vQJrI8JQI+J39t3Ygi7WxF2La4G8+AopAEUGDGUUaQElN9lCtCEesfWL48XyGVpnV/PWgsIUUMu6EK8CIA0V7PjH0nixnzqctSlbDk2CMl84Qjz4/hKw9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768538; c=relaxed/simple;
	bh=p+D4nms3EoX5ehbYSmQ1LUkSlUoUGA7DGF2FjehZPss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a33NaZctv69seBOZS8F++HvFbmk+C5gPg85i6LkRfFin0FHDlGQreaxqePYnF7lXFcRhVI26iaAmusQ1M2+BG10f2XU1ER1ov3qZ/F0qkcG3GqIqxDRBbYB7Wvb6eALAI3FRm1gDjTkRZb497HEd6TqwQg7iOYZlcREnsCxsVxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0HOyS3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0HOyS3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1A2C4CED1;
	Wed,  5 Feb 2025 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768538;
	bh=p+D4nms3EoX5ehbYSmQ1LUkSlUoUGA7DGF2FjehZPss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0HOyS3ol+of2PaDIMSNONzFvGFjr0PP86nBCrWx5Sze9qiP8TNlGdkIlpsvW18Se
	 VkolPWo26V8PBuRvh+9VyZHM5xXIi0YTcLYO1Tl6mQ3fd0sZW4oNsdFouCY5MUhde+
	 xblYoMMJf4RtcsXHR9ZrG5CRyXvxp9ardLzRZgms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 555/623] tools/power turbostat: Fix PMT mmaped file size rounding
Date: Wed,  5 Feb 2025 14:44:57 +0100
Message-ID: <20250205134517.450192890@linuxfoundation.org>
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

From: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>

[ Upstream commit 2f60f03934a50bc1fb69bb4f47a25cddd6807b0b ]

This (the old code) is just not how you round up to a page size.
Noticed on a recent Intel platform. Previous ones must have been
reporting sizes already aligned to a page and so the bug was missed when
testing.

Fixes: f0e4ed752fda ("tools/power turbostat: Add early support for PMT counters")
Signed-off-by: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 58a487c225a73..82e427d597f0f 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -95,6 +95,8 @@
 #define INTEL_ECORE_TYPE	0x20
 #define INTEL_PCORE_TYPE	0x40
 
+#define ROUND_UP_TO_PAGE_SIZE(n) (((n) + 0x1000UL-1UL) & ~(0x1000UL-1UL))
+
 enum counter_scope { SCOPE_CPU, SCOPE_CORE, SCOPE_PACKAGE };
 enum counter_type { COUNTER_ITEMS, COUNTER_CYCLES, COUNTER_SECONDS, COUNTER_USEC, COUNTER_K2M };
 enum counter_format { FORMAT_RAW, FORMAT_DELTA, FORMAT_PERCENT, FORMAT_AVERAGE };
@@ -8924,7 +8926,7 @@ struct pmt_mmio *pmt_mmio_open(unsigned int target_guid)
 		if (fd_pmt == -1)
 			goto loop_cleanup_and_break;
 
-		mmap_size = (size + 0x1000UL) & (~0x1000UL);
+		mmap_size = ROUND_UP_TO_PAGE_SIZE(size);
 		mmio = mmap(0, mmap_size, PROT_READ, MAP_SHARED, fd_pmt, 0);
 		if (mmio != MAP_FAILED) {
 
-- 
2.39.5



