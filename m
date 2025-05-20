Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E75C2459FE;
	Tue, 20 May 2025 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749749; cv=none; b=aCLE97yOL764GR81kYTmQTCUEY0/j5SJ+eEKd3HmW7ngagX6I01Ih1JO7pE3sJiFbxlmtPLJhFMwrPVzopkmN4+N+CVGFaAlV2Qn9OEllKGxRJtWHLHozdoCr1PSOLhvJaRf6CxWX03UfrjtCz1ugMniHm4rXJvA74sYhAuNUGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749749; c=relaxed/simple;
	bh=k41ZPdspR/lgCLxQjIhMjkFLmoogAVOiTWuIm5oc9mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTlRskdnhrLxIkpBPeuM4V8J8N1TpLx55goZQp7xyL+/FHtdzDvMlewYo+MZLRgdxDeVD6txCW2knKu2drLbxbGfD5Y/4IesrF57kNlTKVozrdg0z9TuyIqJ4BxRUCmdpGR4JEQOTWmZWMbd9UOFaSwMFKjCd6RXfaNoqhgWcTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YeUuO+n5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeUuO+n5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22DAC4CEE9;
	Tue, 20 May 2025 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749749;
	bh=k41ZPdspR/lgCLxQjIhMjkFLmoogAVOiTWuIm5oc9mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeUuO+n5mg7KFyp4JVKisI/WsTP2qW30uu+u7VC5MBMyyPfiPZkW8Vp6GsE2cv9mL
	 aLigiJiaK+YwsuyJwYxrsQ825v7rPR5U18r5lkZIZzVxnd5ji/iaW2grgp8akr0Y6t
	 jtb3e1PWvm0A110qjP/gR6HeraPfxpS7cAt59Vm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kees Cook <kees@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/117] nvme-pci: make nvme_pci_npages_prp() __always_inline
Date: Tue, 20 May 2025 15:50:11 +0200
Message-ID: <20250520125805.819326663@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fdde38903ebcd..08280bd65d03d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -386,7 +386,7 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
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



