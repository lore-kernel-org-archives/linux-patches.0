Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591227;
	b=YT965goiesvborYpeGHaoJWFeqQh3O4NiQedtp/XTsmPn8Ux6Uz2VLp5orCxSrx4eYJR
	 nAl7qAOZCEE51mKuBUKOfvPEtqxSTMB0AZxtab7WR7JIpxtLP21g+34OS9rKVnbuLrcty
	 1NgswxZDxyc9vackq0WM1S6f+XbffJvTxM9TaMfRJM6Pz1yNGXzm5t4JBAMvc5q3WqkD6
	 1DwFWJgsICSKN77AXog6nitqp+TQlJ5bivgli9jdhptHDYsCZsu4DGHxe6ZaHHMAjD7lN
	 Gvf/w+3pa+6njN2fTiG082UBGI5Qj1dT9RwonjvxIfJb5U/mQ2i40FrZm3TizD9l88g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9xomemAj0D5EnAZq6gsxaL4PzwV83NEoW+991Mb6VzY=;
	b=TprN2ACdN0EXAuztWn+Ec12ZMXL/FJLYdYw66n+rpp+XRQMbo7ktdBEKHIKqnQ58e15e
	 +2q/LpnypxX6UrDNSBdp+/jcRn9mvI54106uh2nbIiCR0MzrFHYCjTGiwhr6TD/QWKN0W
	 vUuzitQBQdlyaK2SWvLDWtN4ukF6Cir+iWH3M4Ye8qNEGmgD0K1aRKYsyP2P1/OG2jkDN
	 Z1zidoFejqJNWJXxwtW2REd8omlxT52m2/UhZjDPy4Fkka+ZnDE4isW9WHVX4tpYd6Sth
	 LwNt8vEdb50mgsI1/AxhQt5htuRoWpFCJuIJKInYbRdAr5XQlj334obrs/DN2sFCIfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ndCIvC96;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246DD6075E35;
	Fri, 13 Nov 2026 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ndCIvC96
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C508C1F000C4;
	Fri, 13 Nov 2026 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591227;
	bh=9xomemAj0D5EnAZq6gsxaL4PzwV83NEoW+991Mb6VzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndCIvC96EJf5x5bs7zUD4PMXiIaYNoVPQACWPniUXzoXn4Njr+Q8yl38+EIetEUnJ
	 qrbVXKoNljeHTUBRkAAeVOZmkrwohjfZ+VFIhNkUBOgbgES3+WfVoDxlG7KqBLIpEQ
	 5feAQyBKRo+ND7GpS6xs3fJmgT08bkzy1fY4KusY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 357/670] arm64: mm: validate /dev/mem mmap ranges without overflow
Date: Fri, 13 Nov 2026 10:48:41 -0500
Message-ID: <20261113153823.915009955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7e3ad97e27d80..61da56ed0b5af 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -59,7 +59,9 @@ int valid_phys_addr_range(phys_addr_t addr, size_t size)
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



