Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6559846AA67;
	Tue, 21 Jul 2026 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648138; cv=none; b=rf4ONXIGG2bK/dvbQzCgTJfkricExfnnLDomqSTjTb+sPgkddmE6h2r5w0cgud3Vi5iqjSlXBKGvT6NcaMq5kar3BRXEEu0RRMNV7EfoFYpEbmYCpMHyNaHK4OSoAHwfprkfPoHNH8f4najSMOMd1icUg0q9CHg0U2V0B/ez9Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648138; c=relaxed/simple;
	bh=1bta/gukVvGZSIr40vGaTo6iOLpJUilrQ7I1Sw2wFC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKw2IeEwPCkT/if9ryjpltOb1YUk0BqviLrkXEi9nsRfwcdoWqNTUVv1O6rervPEBbrhiQ21KFMSqUwyntCKfQY+BSwYex49ewzbxhjtLqNEhA9zvTCZdPF7DzSmJKHt0VZ7B0DW4jO2oR+D+hD/KUzKsF2LWAvpo8vQrdB+eK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ri+mtbcT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ri+mtbcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA871F000E9;
	Tue, 21 Jul 2026 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648137;
	bh=nAxK9K82Bio6j4JfI3L7O4tuhmavb21JoIwWYJZM4Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ri+mtbcTt9md2Ujy06uSZ1ItoNxSDQB+v3vWWo9Q6hk8lucjnhknuhOKWG4el/ufd
	 7nZd0wecq7AH0jnt9luYOdNM9drP0Cd6j3GbeGoXWmTemRM6/KLfQG5tIWhGuJ5V90
	 i0350el+/moN/STUrDjsQuzpa9nA+JCel4VZafzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0042/2077] openrisc: mm: Fix section mismatch between map_page and __set_fixmap
Date: Tue, 21 Jul 2026 16:55:15 +0200
Message-ID: <20260721152553.680549274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 431400d49cac4bac944fc2d989921003314667ae ]

This warning was reported by the kernel test robot:

  WARNING: modpost: vmlinux: section mismatch in reference: __set_fixmap+0x84 (section: .text.unlikely) -> map_page.isra.0 (section: .init.text)

With commit 4735037b5d9b ("openrisc: Add text patching API support") the
__set_fixmap function was moved out of the .init.text section.
However, the map_page helper that it uses was not moved.  This was not
noticed on gcc 15.1.0 where map_page gets inlined unlike lkp@intel.com
which uses gcc 10.5.0.

Fix this by also moving the map_page helper function out of the init
section.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603211503.E8mMETO3-lkp@intel.com/
Fixes: 4735037b5d9b ("openrisc: Add text patching API support")
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
index 89d8c6df885511..db7c844faeeb62 100644
--- a/arch/openrisc/mm/init.c
+++ b/arch/openrisc/mm/init.c
@@ -193,7 +193,7 @@ void __init mem_init(void)
 	return;
 }
 
-static int __init map_page(unsigned long va, phys_addr_t pa, pgprot_t prot)
+static int map_page(unsigned long va, phys_addr_t pa, pgprot_t prot)
 {
 	p4d_t *p4d;
 	pud_t *pud;
-- 
2.53.0



