Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606CA24500C;
	Thu, 13 Feb 2025 14:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458341; cv=none; b=B4qsYyNwP4W05tmpqyLc7dG9iEiPrKQusEv1awAs/SEsRjSIdlTzwICOr6XODciqpS8jd+DPI7ASs4Pu24DMA5MhJUutZm8Rtw/brhwXaBu3uTXqBLvBmJmbBSjYh/3ZUlM+FTc1pp85nYg+yFqClZsysTbIpaAGcn5efCkpFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458341; c=relaxed/simple;
	bh=BTim2TsTFU1lhO3D5F/HjSu/MjEAc2lS8dJ0TwYnCtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuruR6eNkExT9ilT9NJlUatlgAHxb2M9PPVCSeMO6Yd9+vdPuYKHaLri34lxls7Nhr0rVyLUWiPiN3oWUl8mFh5nHljhsZ4S0m/Wxg91UHG+yOoHJePea4hqcYe+jZHEM7h4j0B/WudoTyc9anu+Oi+kVO2QwWgJH3PepL3NMR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L031dQFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L031dQFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36DFC4CED1;
	Thu, 13 Feb 2025 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458341;
	bh=BTim2TsTFU1lhO3D5F/HjSu/MjEAc2lS8dJ0TwYnCtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L031dQFZUJpw43pwhuZ6zaFyCGtVKAFmq5QAkagKmeJJgHktotTyaJLO1NV5opdKX
	 qBrGopi4xsr7JE7wmjlhgQgsD2NcIwWshwRE3dt24T8+dWgE4hN4voy3FK0FZUvixk
	 unuhwtpuDbxxqEHTeA+tvUiKapGg15derGmOTLs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Patrick Wang <patrick.wang.shcn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 340/422] mm: kmemleak: fix upper boundary check for physical address objects
Date: Thu, 13 Feb 2025 15:28:09 +0100
Message-ID: <20250213142449.674750999@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Catalin Marinas <catalin.marinas@arm.com>

commit 488b5b9eca68497b533ced059be5eff19578bbca upstream.

Memblock allocations are registered by kmemleak separately, based on their
physical address.  During the scanning stage, it checks whether an object
is within the min_low_pfn and max_low_pfn boundaries and ignores it
otherwise.

With the recent addition of __percpu pointer leak detection (commit
6c99d4eb7c5e ("kmemleak: enable tracking for percpu pointers")), kmemleak
started reporting leaks in setup_zone_pageset() and
setup_per_cpu_pageset().  These were caused by the node_data[0] object
(initialised in alloc_node_data()) ending on the PFN_PHYS(max_low_pfn)
boundary.  The non-strict upper boundary check introduced by commit
84c326299191 ("mm: kmemleak: check physical address when scan") causes the
pg_data_t object to be ignored (not scanned) and the __percpu pointers it
contains to be reported as leaks.

Make the max_low_pfn upper boundary check strict when deciding whether to
ignore a physical address object and not scan it.

Link: https://lkml.kernel.org/r/20250127184233.2974311-1-catalin.marinas@arm.com
Fixes: 84c326299191 ("mm: kmemleak: check physical address when scan")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: <stable@vger.kernel.org>	[6.0.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1650,7 +1650,7 @@ static void kmemleak_scan(void)
 			unsigned long phys = object->pointer;
 
 			if (PHYS_PFN(phys) < min_low_pfn ||
-			    PHYS_PFN(phys + object->size) >= max_low_pfn)
+			    PHYS_PFN(phys + object->size) > max_low_pfn)
 				__paint_it(object, KMEMLEAK_BLACK);
 		}
 


