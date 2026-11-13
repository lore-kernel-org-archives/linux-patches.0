Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585795;
	b=CwKfLwVrAessRFN43Oyxr5b8S2oDHhcuPOHgWf1HFI0mocZ2pYqZSGPDUTmwNaPQ+U+h
	 ewK9SftnMnq0Wi7MLfLsz8Oj70loLfFc+zdn3dQO0zqs1fYOkJkgFfrWFlDkjKvBclnht
	 FfFVYKVQnA9u0fSh8JU9tKV8nZhmqPL+FsO7/3E+NVQeTREiX6Y0EdqcqqBra0C2yUyjt
	 P+cwi+wFhN/lGOmyxoAq65HB/ZzkAJvkYv5XGPYVeMSnWXucqWeb8a5jx7VV0wTLfSzAY
	 Mh1BRRnVpW7hCVCYa0AKDhhp6tH88eH0AItufEZenNRaVKOxj2Q/jxh6IoGjM8Q12Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9stWh08rJoY9R8AcTZzvCtFCG6L9OnFIfZ25HL3+4mo=;
	b=EIGcDtqAkxNyGJN7H4EBe5dFE0OYrbDyIjmHfnzzhjkXBR6axF/GXBGg9fU9lqdAyBHF
	 OHhIDEh9U0x15X0ULkyuP2bkeG/b/ZxI1mMhjy+iGJB6H1IgDQi7BhZY6scLuIejeag7w
	 b4O4pfNq9cY20WEwHv7Ym9sJjgv53jQcHUvgDBEsnIazAnvRGkhK0O49WSikVMd0or8Ep
	 nPP1NG5+jcHBZZXEPyGHIzyvQfrCuV/ZKsVbRTZF2YXznUtD9nrr72gfylZ+THX9ul+qz
	 CiprXxI962Haj7g4hOa1mbxRY8C0xRbqzeVOcPpuYCHQJQZx1TMLiST6uVrlOhyKMJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtTdsPDi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0850606BA93;
	Fri, 13 Nov 2026 16:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtTdsPDi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C461F000C5;
	Fri, 13 Nov 2026 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585795;
	bh=9stWh08rJoY9R8AcTZzvCtFCG6L9OnFIfZ25HL3+4mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtTdsPDi8Zjc7xb/5OZD6frC2KjJfjPhPY+mRsyusO3OVQ9L3CZgJJB2EXU4CFVYX
	 Mvu3+CFcevgy+0FCBnOcQCjIXkKeRcO5NWRphixUbBXVZXUxxa2hcgcq21t3r0JbLk
	 I148KdUWW38FzJ3j3X67SCH958ltlay6LJj+cK9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 383/507] arm64: mm: validate /dev/mem mmap ranges without overflow
Date: Fri, 13 Nov 2026 10:51:27 -0500
Message-ID: <20261113153809.394860384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 32e0771d6477b..e212270d4e09a 100644
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



