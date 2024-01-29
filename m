Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86746FDE1;
	Mon, 29 Jan 2024 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548495; cv=none; b=f1po9Xal2E4GKsB4z8lXNxEGmCAZWuEjen71RnubtrZQn+pJvVwknqi8ANjUhvm+p/5yp1qk7yDQ8XByzGO3qvyjMNE+l0EGMZJdA6ZWwcR/+7hNCFKC+b+1aS101ZoAy0anpir2sEVZ37H7lL9xTeo/vZfSPTzb4ay0xHe1KCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548495; c=relaxed/simple;
	bh=n2qbjTkPIbL6Yjm7zI12SRGADGUDQzhk+ztPYrzeBjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe6ZcW2+t7Md9PB9UcxTNL2HdajSBQdq34QU7k73fz9Y9DfeqRW330EWwgvNi86e1FI24OnWKchm8qCHLS/gpmzHX//4v9WuLKbmoR1eV51ZNbpSspi+HmzKWMYQanXicU7t0PZlp8GXFtilE5vwK3q2dIU6ItjCmPagc1CemZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtgT+pB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtgT+pB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90315C43390;
	Mon, 29 Jan 2024 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548495;
	bh=n2qbjTkPIbL6Yjm7zI12SRGADGUDQzhk+ztPYrzeBjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtgT+pB2AVXlE91I27Y72mAtOzcCHJDY9jCSQl6M8HunAngIJ0chhJ0/Z5gzu1R2Q
	 qewd3NL9gWDXywiuU9LvgwrSQ+D5JuELSTiPiS/jcs6lAGow9lELThxtY06iubax9I
	 rz6TQZa4yPBglw4dYdCtGUtyZ2WaWEqeRnLZ3OJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Wupeng <mawupeng1@huawei.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 121/331] efi: disable mirror feature during crashkernel
Date: Mon, 29 Jan 2024 09:03:05 -0800
Message-ID: <20240129170018.476856960@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Wupeng <mawupeng1@huawei.com>

commit 7ea6ec4c25294e8bc8788148ef854df92ee8dc5e upstream.

If the system has no mirrored memory or uses crashkernel.high while
kernelcore=mirror is enabled on the command line then during crashkernel,
there will be limited mirrored memory and this usually leads to OOM.

To solve this problem, disable the mirror feature during crashkernel.

Link: https://lkml.kernel.org/r/20240109041536.3903042-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mm_init.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -26,6 +26,7 @@
 #include <linux/pgtable.h>
 #include <linux/swap.h>
 #include <linux/cma.h>
+#include <linux/crash_dump.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -381,6 +382,11 @@ static void __init find_zone_movable_pfn
 			goto out;
 		}
 
+		if (is_kdump_kernel()) {
+			pr_warn("The system is under kdump, ignore kernelcore=mirror.\n");
+			goto out;
+		}
+
 		for_each_mem_region(r) {
 			if (memblock_is_mirror(r))
 				continue;


