Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7A426B0A5;
	Thu, 13 Feb 2025 15:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459892; cv=none; b=DAHKFJIGBH17XJf708M2wuzONVR8Dhwk+F6bMC29GShj4KoEbFknVqcHWqqiiPL5qaDRoLmHXBOocZ7YteFEIZ1nZO5dDSCV14UMJR/ZgXVNqTsvdMvmEpNcDzs6PU69hw2UqU6X/HXcrtvjkOYFGvW++VtHQmI77dHszvt/3fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459892; c=relaxed/simple;
	bh=0SaydzfisfsU6qMsLEVQ8QOs/CeKtooli9uHJ9PudkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbT7z5WA51Hi3YB7AWlznvLLyVu/Rr0AIrM75lnHkyWWLzVvLWOLQUjDADtPbt5VPtJvHEjtuYu23b7wEPXWQ09X/s6qCGkfPhPVIx2uN02n7cIuTNeNfppphc1asctYloScFhTqdVS4Pzzf2M0YPG4xGGZWe2/qESd0NCsMy5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gxlob1Ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gxlob1Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0F7C4CED1;
	Thu, 13 Feb 2025 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459892;
	bh=0SaydzfisfsU6qMsLEVQ8QOs/CeKtooli9uHJ9PudkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gxlob1Uia8lPNfkK5UxPTTyCrjFTteXa6b5QWMMo27Cy7EFd56fdV6z0l6dpOKAf8
	 wKi1CrKfNXaSsTTxn5zNjToVwjU62G2Phh5YCwLvG2BsRYI/rvFT5+vOk95e8GWG2R
	 cXX5YVZqkLAvSkWd3PrhWoRzlZN5M8jmwhyAzP5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Patrick Wang <patrick.wang.shcn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 377/443] mm: kmemleak: fix upper boundary check for physical address objects
Date: Thu, 13 Feb 2025 15:29:02 +0100
Message-ID: <20250213142455.153822442@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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
@@ -1689,7 +1689,7 @@ static void kmemleak_scan(void)
 			unsigned long phys = object->pointer;
 
 			if (PHYS_PFN(phys) < min_low_pfn ||
-			    PHYS_PFN(phys + object->size) >= max_low_pfn)
+			    PHYS_PFN(phys + object->size) > max_low_pfn)
 				__paint_it(object, KMEMLEAK_BLACK);
 		}
 


