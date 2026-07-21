Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3333130F80C;
	Tue, 21 Jul 2026 17:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655682; cv=none; b=MngnbZzF3A7O/XlrEUQqJcos4ue0anNyi/ZtMbEFcn64s/R4mQ2gsL9lzUC0YiPy5wUfjZ4f5Wdu1cBJpjRFHSOhmmZ4U4BVIBLFK5zoT+cDav57k7kJLjguEPbOrp/mOkIHXr8T+Z925sl2SaIxsl1Rap0ynUJRsoEHXczOxnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655682; c=relaxed/simple;
	bh=/OrUtkU/1UOKx/H28UDGmAesa9g1vRQ1yqg6rmL8qZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VarwfHcnCbcd1kJIo4wWCKumXE24pc8Hg876SL1lyhp6aapRO6AfMP8QhkoHA/ilVujXoExyE+Ftea+sbbw5qeLRTf2S7KrhUqKGai2zfZ8geI7xRXF1v0BYxpMxH3UjHMWeD0QegtEYelKbXZWMEg6OIJ1J5xeHjGbCPXWILYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4gW4nh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4gW4nh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710451F000E9;
	Tue, 21 Jul 2026 17:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655680;
	bh=vvoqYKsG4wcGbfs3imUX7dEVXzUUAOkllh5TDUk/lXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4gW4nh8K3NaPCqRl3/+1O3bFm30DVqumYgjyr3xtRCjpTgqRaEqmdiAYXruSVHTt
	 WbytR/EENYgBPrgGVFSvb8C5VSowFXXzJNDfNjNapEzeLJtt0ttILEJ4CpR/rJRhhu
	 kritk+C0VbxGRWB8FsGz3xqsmOU+StpyQbeMIL5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0057/1611] openrisc: mm: Fix section mismatch between map_page and __set_fixmap
Date: Tue, 21 Jul 2026 17:02:53 +0200
Message-ID: <20260721152516.111294079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9382d9a0ec7888..c47ec1237a5214 100644
--- a/arch/openrisc/mm/init.c
+++ b/arch/openrisc/mm/init.c
@@ -202,7 +202,7 @@ void __init mem_init(void)
 	return;
 }
 
-static int __init map_page(unsigned long va, phys_addr_t pa, pgprot_t prot)
+static int map_page(unsigned long va, phys_addr_t pa, pgprot_t prot)
 {
 	p4d_t *p4d;
 	pud_t *pud;
-- 
2.53.0



