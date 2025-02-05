Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC92DF59;
	Wed,  5 Feb 2025 15:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767912; cv=none; b=NsGbwpdTgVb+A2YTe9XhcIrXVI0IglQJxLg0DzV/2jAbi9nPqX7WS7vj0KVKOMyof3Cn12P28GuHHmed8QMpdYnbRbRf8OpywYI1ANI2Li06KcLOdwvQsm7qrjoBkZ3IjIX1z1QyjqQAF7TTl+u9h8zsgzPVM4KLkIWQDbE8fIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767912; c=relaxed/simple;
	bh=4eCJ0YbZWLTHF7thvebAyNacMxChocG4ZWisjkgX29w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ft9JPcQjf/w9rttZv+dozYMUm6krSMaRutQVCwU6CBawNkfZy3QZDxvn4u8eBkk/PhJNyuUpbK7DtBAqT5rP4hXHDtPNle7dzuCtpYGhSK2wc/9ysjSKk56sTTbePBWbZS3bQSw9vdZl4+tKTWHNA82C/47ATynDFFEnawF9YOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ON8YHVS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ON8YHVS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E87C4CED1;
	Wed,  5 Feb 2025 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767911;
	bh=4eCJ0YbZWLTHF7thvebAyNacMxChocG4ZWisjkgX29w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ON8YHVS2fC/y0qjBlwhu85tlCMf/CRReV+/RQ44qqIQ0Rs+3kS8vf73GQFIP9MXUo
	 eFnm5PODtjW49uUosYGaa5xyc0xGcj1/nlyGeDUTvgEDsQ77AFY7DNCjQCflVJsDpB
	 UXL0uJviAHL7hq5SqK6/AbMwvY/uN8oFG2XkKNL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 524/590] tools/power turbostat: Fix PMT mmaped file size rounding
Date: Wed,  5 Feb 2025 14:44:39 +0100
Message-ID: <20250205134515.313480685@linuxfoundation.org>
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
index 38363f11f49f0..da97f4327650b 100644
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
@@ -8853,7 +8855,7 @@ struct pmt_mmio *pmt_mmio_open(unsigned int target_guid)
 		if (fd_pmt == -1)
 			goto loop_cleanup_and_break;
 
-		mmap_size = (size + 0x1000UL) & (~0x1000UL);
+		mmap_size = ROUND_UP_TO_PAGE_SIZE(size);
 		mmio = mmap(0, mmap_size, PROT_READ, MAP_SHARED, fd_pmt, 0);
 		if (mmio != MAP_FAILED) {
 
-- 
2.39.5



