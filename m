Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC868F5C;
	Mon,  1 Apr 2024 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990228; cv=none; b=Z2fYPD3VmLKNEKGy9m9AnKU5SV9TfqnY4WVM7YwDRKMILGHdxQddwjUlh9tEWSEnD0TKWyBAFzgmrVPRaedeDdcOLFX/OfbGi701YokCQTDxdgVQpgWWyID18mW8JSlg57WAFVIGnGH8v4HUjVSoHMrIoY68dPNXW1eQte/cKi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990228; c=relaxed/simple;
	bh=KqfnW2k/QWselBQYZacYYscbYIcVau2/MYm4fYDjazA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m4bKG0822KjKCTGheAezOTU+VaqnlW1cejJBC/3mdtjopCsentih5JuNpfz0emMemdTIxhNAqyaZ0RfpQ7fL/eIKKgS4ZuXifrLzQzgwr55o/3yq6YUB6A+py/7IbAqQOB0J+KXt7q4DBUdet+Z4slZ1e9hTG3NRgpI2VbswZ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMhp02Rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMhp02Rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4B7C433C7;
	Mon,  1 Apr 2024 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990228;
	bh=KqfnW2k/QWselBQYZacYYscbYIcVau2/MYm4fYDjazA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMhp02Rkh/5zcOjIpJti0OfJBGeb0TXz4kARcXj7cZMpz+TMgHxz7QRlVaoVTdd8k
	 tCgM4fr5Pn3Ut/SMJuM4iTa+kCZeUKaEmcMmPQw+4mt4jwTebo2cwmxC6o5FSKAgB+
	 Ja9GZc/pqR6mq7HBN+6O5Ndn1bcWdVdDDxye0nxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rapoport <rppt@linux.ibm.com>,
	Yongqiang Liu <liuyongqiang13@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/396] ARM: 9359/1: flush: check if the folio is reserved for no-mapping addresses
Date: Mon,  1 Apr 2024 17:45:35 +0200
Message-ID: <20240401152556.434036404@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Liu <liuyongqiang13@huawei.com>

[ Upstream commit 0c66c6f4e21cb22220cbd8821c5c73fc157d20dc ]

Since commit a4d5613c4dc6 ("arm: extend pfn_valid to take into account
freed memory map alignment") changes the semantics of pfn_valid() to check
presence of the memory map for a PFN. A valid page for an address which
is reserved but not mapped by the kernel[1], the system crashed during
some uio test with the following memory layout:

 node   0: [mem 0x00000000c0a00000-0x00000000cc8fffff]
 node   0: [mem 0x00000000d0000000-0x00000000da1fffff]
 the uio layout is：0xc0900000, 0x100000

the crash backtrace like:

  Unable to handle kernel paging request at virtual address bff00000
  [...]
  CPU: 1 PID: 465 Comm: startapp.bin Tainted: G           O      5.10.0 #1
  Hardware name: Generic DT based system
  PC is at b15_flush_kern_dcache_area+0x24/0x3c
  LR is at __sync_icache_dcache+0x6c/0x98
  [...]
   (b15_flush_kern_dcache_area) from (__sync_icache_dcache+0x6c/0x98)
   (__sync_icache_dcache) from (set_pte_at+0x28/0x54)
   (set_pte_at) from (remap_pfn_range+0x1a0/0x274)
   (remap_pfn_range) from (uio_mmap+0x184/0x1b8 [uio])
   (uio_mmap [uio]) from (__mmap_region+0x264/0x5f4)
   (__mmap_region) from (__do_mmap_mm+0x3ec/0x440)
   (__do_mmap_mm) from (do_mmap+0x50/0x58)
   (do_mmap) from (vm_mmap_pgoff+0xfc/0x188)
   (vm_mmap_pgoff) from (ksys_mmap_pgoff+0xac/0xc4)
   (ksys_mmap_pgoff) from (ret_fast_syscall+0x0/0x5c)
  Code: e0801001 e2423001 e1c00003 f57ff04f (ee070f3e)
  ---[ end trace 09cf0734c3805d52 ]---
  Kernel panic - not syncing: Fatal exception

So check if PG_reserved was set to solve this issue.

[1]: https://lore.kernel.org/lkml/Zbtdue57RO0QScJM@linux.ibm.com/

Fixes: a4d5613c4dc6 ("arm: extend pfn_valid to take into account freed memory map alignment")
Suggested-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/flush.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index d19d140a10c7d..0749cf8a66371 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -296,6 +296,9 @@ void __sync_icache_dcache(pte_t pteval)
 		return;
 
 	folio = page_folio(pfn_to_page(pfn));
+	if (folio_test_reserved(folio))
+		return;
+
 	if (cache_is_vipt_aliasing())
 		mapping = folio_flush_mapping(folio);
 	else
-- 
2.43.0



