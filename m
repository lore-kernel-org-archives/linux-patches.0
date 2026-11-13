Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590464;
	b=aPl+WWFHPV92yMAWWu3qu/O0k30ZsspwHT8oN+Lri7RX/BfbzGxZZKh7L17/oT1CQ656
	 R9AJtIHrCfpkrxkY9jVbz7w9Gr7yiFi2bBpp4P8whGFzDuaXR+EOUVCSFKrRh1SsHlZON
	 afmK82XzwW7hQE8dYDEdZnDCTgTjpig4ybSAUUWS6nzqF6pZwIV81v/puJtu/HqLLNQMv
	 Pz7x98Lxgt4Y4njlGI/plIwLzhusaQVgZlA1hHMQHi5Im4+gF7XTLS111frBKlbHFetdJ
	 OGrmAsVcRM0QVxDKfv8e3fqzFdFKbCTKiWgbFN3YqvzVSB7ddnsCiaZJc3GnZo9vf3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d3ag0IXAxMYLRDwNnRjAtUO+89XBTeRSsTP9WyX33cg=;
	b=TyqRZgm9PdlFTZBnvBz2qx/CLhN3ZII49sVTqsa0kTXtRqJDz0QJfj0eiNJ808rOKVGh
	 RzrAmFp6F4a+V/jIeO7CMHAGKmkvERUHNeBNCdohAwRU1isFUE2BG3slUJn5Vvx7BqXjH
	 NfyqYodUBMiHJGFaMryBZ5dEy0YWgWXJH/iUUWH5iJj62iMQpJCwTqGHVUb6aiKMdkHct
	 N2u7m4i5hYYWDHN6dV5KMQWuWGMU57T+vHDHx5gpBcQwckDTkzssjg0aTFF5RY6z/fSql
	 XKkCbNJybzf5RfhjYDoeFG/aHp3iCsUK4H7HhT7uTgHgw+r8tVI8lgygGzQuuZvZfIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yaMIpGJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757A2606B34F;
	Fri, 13 Nov 2026 17:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yaMIpGJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88EB1F000CD;
	Fri, 13 Nov 2026 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590464;
	bh=d3ag0IXAxMYLRDwNnRjAtUO+89XBTeRSsTP9WyX33cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yaMIpGJyXVwMsKfBs4eCfgTUgh+gTK6803l7iEIdIjfvs2VmM6VbVzYb+RDjSFte/
	 CdzjIi8JQyC+0ZbZkehSwPKO2SokjGVFbwW3R4z35/7sQLX7Lq3hza6NW3gykM1QBv
	 L31NyuJ6Arrfh0Izy5KNvMsBPWMYoz93EM386WmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 420/686] arm64: mm: validate /dev/mem mmap ranges without overflow
Date: Fri, 13 Nov 2026 10:49:13 -0500
Message-ID: <20261113153835.184417286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Gongyi <zhaogongyi@bytedance.com>

[ Upstream commit b0958b1397fb5ffdb995c0ccc74349841929c08d ]

An arm64 syzkaller reproducer creates a FUSE character device with
major:minor 1:1, so opening it uses the /dev/mem file operations. It
maps one page from offset 0xfffffffffffff000 at user address zero.
The next openat() with a NULL pathname triggers a synchronous external
abort (SEA, ESR 0x96000010) in strncpy_from_user() via do_getname(),
panicking the kernel.

valid_mmap_phys_addr_range() checks the exclusive end by adding the
mapping size to the starting address. For this offset, the sum wraps
to zero and passes the PHYS_MASK test, allowing an out-of-range PFN to
reach remap_pfn_range(). The inclusive-end overflow check in
mmap_mem_prepare() does not catch it because the end is ULONG_MAX.

Reject starting PFNs outside PHYS_MASK and compare the inclusive length
against the remaining physical range without overflowing. This also
allows mappings that end exactly at PHYS_MASK, which the old check
incorrectly rejects.

Fixes: 1d18c47c735e ("arm64: MMU fault handling and page table management")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
[catalin.marinas@arm.com: changed the check to look more like __access_ok()]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 92b2f5097a96c..dabc61000ecc4 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -61,7 +61,9 @@ int valid_phys_addr_range(phys_addr_t addr, size_t size)
  */
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 {
-	return !(((pfn << PAGE_SHIFT) + size) & ~PHYS_MASK);
+	const phys_addr_t limit = PHYS_MASK + 1;
+
+	return size <= limit && pfn <= (limit - size) >> PAGE_SHIFT;
 }
 
 static int __init adjust_protection_map(void)
-- 
2.53.0



