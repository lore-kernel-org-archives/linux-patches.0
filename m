Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2323135FC1E;
	Tue, 26 Aug 2025 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219326; cv=none; b=u9sojrIC54X8vDNJj5yYrJmZ3htQBgHyA9PhotmFrZIT16SMy5ScAMT9EDw33zcbCVPVGRsHMxSMiib1W9ddH9o/bkO5wZ9SwRA3QGZYGwtAg2LcG+6cWic3Uvc8Q08wNrdJ02C4PC5ML3e4jHdYk7gSrG91D867qjrNWBG0K5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219326; c=relaxed/simple;
	bh=qvcDY7wh/80rY+4v29+tVIDjQ0cvjumB4vbUWyP1xD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5V6HZ16GFdb46bF+23lcG/eto1jfa/xUS51DAOiZpStDl4tmJjT+B4EbCBo978CyOgJjPmGZO6rC88JSZxQe6m7rXCfltaDSgzvV3ewWwdvmCnQxxkD92cn4BK4+4I/U8kwoASuWiMFCBev65J+lJSW5OxDMZxPuxT8hWiC/SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAXKydHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAXKydHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3427C116D0;
	Tue, 26 Aug 2025 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219326;
	bh=qvcDY7wh/80rY+4v29+tVIDjQ0cvjumB4vbUWyP1xD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAXKydHlvQu9j/Fm09Bv9WZubRjKjSMk3VnYhdVk0xpxnxrvLg29vB0c28FSukIit
	 1L5kz2PbsP3w6XH2mPPeaKZ6OhfTUECRkkgE/syQ3MgiR7co0IHZRv4rYf34aNVTge
	 h07+r2u16E9paPQdfyuwkBL5msTUT/I+BSCk7H30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Yoo <harry.yoo@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 338/403] mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n
Date: Tue, 26 Aug 2025 13:11:04 +0200
Message-ID: <20250826110916.189137255@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Yoo <harry.yoo@oracle.com>

[ Upstream commit 694d6b99923eb05a8fd188be44e26077d19f0e21 ]

Commit 48b4800a1c6a ("zsmalloc: page migration support") added support for
migrating zsmalloc pages using the movable_operations migration framework.
However, the commit did not take into account that zsmalloc supports
migration only when CONFIG_COMPACTION is enabled.  Tracing shows that
zsmalloc was still passing the __GFP_MOVABLE flag even when compaction is
not supported.

This can result in unmovable pages being allocated from movable page
blocks (even without stealing page blocks), ZONE_MOVABLE and CMA area.

Possible user visible effects:
- Some ZONE_MOVABLE memory can be not actually movable
- CMA allocation can fail because of this
- Increased memory fragmentation due to ignoring the page mobility
  grouping feature
I'm not really sure who uses kernels without compaction support, though :(

To fix this, clear the __GFP_MOVABLE flag when
!IS_ENABLED(CONFIG_COMPACTION).

Link: https://lkml.kernel.org/r/20250704103053.6913-1-harry.yoo@oracle.com
Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1067,6 +1067,9 @@ static struct zspage *alloc_zspage(struc
 	if (!zspage)
 		return NULL;
 
+	if (!IS_ENABLED(CONFIG_COMPACTION))
+		gfp &= ~__GFP_MOVABLE;
+
 	zspage->magic = ZSPAGE_MAGIC;
 	migrate_lock_init(zspage);
 


