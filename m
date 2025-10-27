Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C607430147E;
	Mon, 27 Oct 2025 19:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593153; cv=none; b=AVOU6+9Zms4DRimqkqwls4j7+kKHVPNnHXHZOY7kskWlpN01xY/cw1XeYLecdW4CQUN2ySTZ78oQoI2jA9W60hfBWYQZobsij3eelhR2KawPbc/2UGcjO43DMNoNXcLVcYMWcuFWHJox3GbV66YzpDNNmiie4/ShGEMwvu+qAV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593153; c=relaxed/simple;
	bh=9zNijjUfyA+iWE2uLH6+zjNwv/0FpWmQ3rTshNJz6b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=he4kETpprtb3UrBeottHO1cqwLOqRgQn8gRhtF4GEGK+KH97pPc6qk2BXmpjgx7P7qAyiJhXC/4kKW/sZ+jWjZXNe/ix1FpO/17mcF/9hqy+JNgK+AIpgwJBv806GpuxNL+vDIPil9OJ0qp2TD7tuww7C0iaqEvedMofu2NH4FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7wAE04D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7wAE04D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F444C4CEF1;
	Mon, 27 Oct 2025 19:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593153;
	bh=9zNijjUfyA+iWE2uLH6+zjNwv/0FpWmQ3rTshNJz6b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7wAE04DmU6XGIUg3irnBuUWUiXMMHyFHPVeanwRNBh5gl5dQKSta9xihUBoLXbkM
	 oVexnIPqDfP3PfjVqdJ6ui4470i2R/fuA2PN6P8URPmsc46KIVfYR/ImKQoh9PWV4u
	 eVas3xMJMGIdvh+nZA90gVp3+ZOGXCNm2XGw6kjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	Andreas Oetken <andreas.oetken@siemens-energy.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 007/184] nios2: ensure that memblock.current_limit is set when setting pfn limits
Date: Mon, 27 Oct 2025 19:34:49 +0100
Message-ID: <20251027183515.136818975@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Schuster <schuster.simon@siemens-energy.com>

[ Upstream commit a20b83cf45be2057f3d073506779e52c7fa17f94 ]

On nios2, with CONFIG_FLATMEM set, the kernel relies on
memblock_get_current_limit() to determine the limits of mem_map, in
particular for max_low_pfn.
Unfortunately, memblock.current_limit is only default initialized to
MEMBLOCK_ALLOC_ANYWHERE at this point of the bootup, potentially leading
to situations where max_low_pfn can erroneously exceed the value of
max_pfn and, thus, the valid range of available DRAM.

This can in turn cause kernel-level paging failures, e.g.:

[   76.900000] Unable to handle kernel paging request at virtual address 20303000
[   76.900000] ea = c0080890, ra = c000462c, cause = 14
[   76.900000] Kernel panic - not syncing: Oops
[   76.900000] ---[ end Kernel panic - not syncing: Oops ]---

This patch fixes this by pre-calculating memblock.current_limit
based on the upper limits of the available memory ranges via
adjust_lowmem_bounds, a simplified version of the equivalent
implementation within the arm architecture.

Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/kernel/setup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/nios2/kernel/setup.c b/arch/nios2/kernel/setup.c
index 2a40150142c36..f43f01c4ab934 100644
--- a/arch/nios2/kernel/setup.c
+++ b/arch/nios2/kernel/setup.c
@@ -142,6 +142,20 @@ static void __init find_limits(unsigned long *min, unsigned long *max_low,
 	*max_high = PFN_DOWN(memblock_end_of_DRAM());
 }
 
+static void __init adjust_lowmem_bounds(void)
+{
+	phys_addr_t block_start, block_end;
+	u64 i;
+	phys_addr_t memblock_limit = 0;
+
+	for_each_mem_range(i, &block_start, &block_end) {
+		if (block_end > memblock_limit)
+			memblock_limit = block_end;
+	}
+
+	memblock_set_current_limit(memblock_limit);
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	console_verbose();
@@ -157,6 +171,7 @@ void __init setup_arch(char **cmdline_p)
 	/* Keep a copy of command line */
 	*cmdline_p = boot_command_line;
 
+	adjust_lowmem_bounds();
 	find_limits(&min_low_pfn, &max_low_pfn, &max_pfn);
 
 	memblock_reserve(__pa_symbol(_stext), _end - _stext);
-- 
2.51.0



