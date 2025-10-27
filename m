Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB0E21576E;
	Mon, 27 Oct 2025 19:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592586; cv=none; b=nKZeMKBdbXz5ywPgMwVA2SJycn9odXT4ePPt5lWU4lJu5vm/aZHgfePdCFvHTuB4iYH9//luFN3OkRYRIqEMxhlMUP43zHlbpiVYoN8LiAZ4n3cYBKru0+c/fQ36voWbFlhCKENwflr+17Wt55Zhg7QJDHDw2dry7qHYEobScic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592586; c=relaxed/simple;
	bh=6bS/9IDZvQ59383AOb0msmKKbW8ZtcyRT1PiyFLvQ3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhiJJb43UcUwWu3QYh9NqznDWXzOtE2vzvaFui+wNxi7uUg7WWQyrTadprgiaDQeaU6br8OibrzNkodi7I+8x84ysu1IW+X6x5HKYlM2NPYiel7xp02YsCqHUcmmSiJO2jN7kz4GIJv0Tl5fDnafIFhjqX7qXaX5nmYDu0dlc/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoAF7NOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoAF7NOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E21CC4CEF1;
	Mon, 27 Oct 2025 19:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592585;
	bh=6bS/9IDZvQ59383AOb0msmKKbW8ZtcyRT1PiyFLvQ3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoAF7NOaovOKyLPksTIbPR/kKHnyNbbNMwEUuEk1Vqj7dT4g5qZ/ZqNdM0xqoYKzX
	 bODj7G552qXHaRUa298XfM6G/Ql5hKklf0YFHlZlujTzMK/xLX+nbEXoPrKYpfHV3Y
	 zXNdI8ytne9kFroRo8ysxgLwkak2wq8lWyvdC1Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	Andreas Oetken <andreas.oetken@siemens-energy.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/84] nios2: ensure that memblock.current_limit is set when setting pfn limits
Date: Mon, 27 Oct 2025 19:35:51 +0100
Message-ID: <20251027183438.884074461@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8582ed9658447..5308c76122817 100644
--- a/arch/nios2/kernel/setup.c
+++ b/arch/nios2/kernel/setup.c
@@ -147,6 +147,20 @@ static void __init find_limits(unsigned long *min, unsigned long *max_low,
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
@@ -160,6 +174,7 @@ void __init setup_arch(char **cmdline_p)
 	/* Keep a copy of command line */
 	*cmdline_p = boot_command_line;
 
+	adjust_lowmem_bounds();
 	find_limits(&min_low_pfn, &max_low_pfn, &max_pfn);
 	max_mapnr = max_low_pfn;
 
-- 
2.51.0



