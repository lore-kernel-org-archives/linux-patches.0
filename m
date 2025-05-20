Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5032522A1;
	Tue, 20 May 2025 14:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750532; cv=none; b=qgrFjwYXkIOoQZ+y2povNePEBJQj8HjOM6dYES0S8+m/qMD7oK9piZ9KH/AozFc0nHvi3AQiDXBHNi963g8ngxyuve3DXF+jPDC1t47dlkWO4mPoPJTN7nRkT05juWWnSPN0DjmUjLhaABpZh6NjDTdILAoBxgYRQgqYgy8SbEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750532; c=relaxed/simple;
	bh=3rEe5wGHzYJNyrDrnFLsMmy8Hfr6dOF5OQM/Dcfkm1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PT35ohBMFhy6Z7sLa+gLJ/KNtmVfuSoH8FYHidsKOzxlJKI4xo6YDdVxm1c+lUZiWac+Hi+C92bzadfp+6pp267WskfP4ez4rpBWNqgTmUuYP0KVQAAK8s5aM9scruKbFGrWDcWFiyyksLyABlm/FtrSudT97FVfozLyiEz78oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJ8bHRzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJ8bHRzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC11EC4CEE9;
	Tue, 20 May 2025 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750532;
	bh=3rEe5wGHzYJNyrDrnFLsMmy8Hfr6dOF5OQM/Dcfkm1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJ8bHRzchJXMM4+yg2r7lfZLleV2+a+3qLPbFoGSrpqwS4/0DiP0Iprc10q3oMi6+
	 jMmhl/IBjEtJVnJzdTzKFyMCCholvLLRhN4HCrfQY54ZLVMiXruBarv/zrjqInGlKX
	 U1AKmupOAGtnyzBg8E1NVBB6do2oAtg3zVU10Xcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kees Cook <kees@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 038/145] nvme-pci: make nvme_pci_npages_prp() __always_inline
Date: Tue, 20 May 2025 15:50:08 +0200
Message-ID: <20250520125812.058276327@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 40696426b8c8c4f13cf6ac52f0470eed144be4b2 ]

The only reason nvme_pci_npages_prp() could be used as a compile-time
known result in BUILD_BUG_ON() is because the compiler was always choosing
to inline the function. Under special circumstances (sanitizer coverage
functions disabled for __init functions on ARCH=um), the compiler decided
to stop inlining it:

   drivers/nvme/host/pci.c: In function 'nvme_init':
   include/linux/compiler_types.h:557:45: error: call to '__compiletime_assert_678' declared with attribute error: BUILD_BUG_ON failed: nvme_pci_npages_prp() > NVME_MAX_NR_ALLOCATIONS
     557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:538:25: note: in definition of macro '__compiletime_assert'
     538 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:557:9: note: in expansion of macro '_compiletime_assert'
     557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/nvme/host/pci.c:3804:9: note: in expansion of macro 'BUILD_BUG_ON'
    3804 |         BUILD_BUG_ON(nvme_pci_npages_prp() > NVME_MAX_NR_ALLOCATIONS);
         |         ^~~~~~~~~~~~

Force it to be __always_inline to make sure it is always available for
use with BUILD_BUG_ON().

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505061846.12FMyRjj-lkp@intel.com/
Fixes: c372cdd1efdf ("nvme-pci: iod npages fits in s8")
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d49b69565d04c..7fdf7f24d46e6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -390,7 +390,7 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
  * as it only leads to a small amount of wasted memory for the lifetime of
  * the I/O.
  */
-static int nvme_pci_npages_prp(void)
+static __always_inline int nvme_pci_npages_prp(void)
 {
 	unsigned max_bytes = (NVME_MAX_KB_SZ * 1024) + NVME_CTRL_PAGE_SIZE;
 	unsigned nprps = DIV_ROUND_UP(max_bytes, NVME_CTRL_PAGE_SIZE);
-- 
2.39.5



