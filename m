Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037840;
	b=HEAUzxXvdEnBFnruusF41SDF1ohZS4P2RgpyDIHeowT/lJJPvZhAzptQWlaw8efJwOEu
	 TPUsWletSRgCaj/LKJZZfsdXWXZMIEos+BusdvweiXzNsPQbpFw45+zkyA/Tr8fZvajjL
	 OJPGjldKN7E+fpv97GvgM8ln/P30pNKFilP6D2W3+NBRhP7Zny0Cmg0Wl1z5ERlQON6Ro
	 2dSb8s267rUQ9cXOb/rPxonKipd5WFrypK9jgJRwdAUOXJ8EuTLMCYQ+Nd1/3mIrmHaHd
	 FzwI2K9Xb2mpJNKlUuXhhF7G3QKGpBL6hxfI8E+WUvj1LrCioieb/W3TQKSPrr/9ghA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hhZXqg8PPxTO/pvVUC3IWzipzu0BYdwl04slUfagsQk=;
	b=DOKciGRvt/ZvH73nxnZLOsRcviIP7niOu2/YVaW00eomJmU73eA0nyqVA9DQPyBv0Lms
	 Z8WmsgNQJfyXQuuCRRtefc9Qpy0sjCM7G90aifQzWOxgCHlGP2CiRrAUkfLg8pjLARKzu
	 +nqqiKtI98xRXMcqPqDxva/57YecVxACD88HW+7mLU3nIB80Mp0MO1BrN715JfDCBixEQ
	 0lVCI9QsgOYG+t+Jq9Kc/UJVsvRHgYSiFw8mOFk/xuzuEKtCzbzK8DHYU9SguSbi6h8rG
	 jqqeQbOmV4xhVxYIbt0MkeazIfMcm3rRu3XQ50ZX3mJTiMiyH32t76spnf77dfl2hWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tYlpZeAK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE473606A320;
	Wed, 18 Nov 2026 21:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tYlpZeAK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75E21F000C4;
	Wed, 18 Nov 2026 21:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037840;
	bh=hhZXqg8PPxTO/pvVUC3IWzipzu0BYdwl04slUfagsQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYlpZeAKWVVNnlqoVe5vg95SuBAhaMVSQ+LDBZBFJKB5/o/AQGQI8AuBOykQkKMGW
	 1q91DMKlSzCVOVu0eHC5dsEZljgDB/TCI0x+dwYUEU4J9Q1KvDA5cmOcPO6P3czmCD
	 OuVHB1sILhdVK5bUvq+ufKbKqGtbN6hiY/SPn7tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1536/3318] arm64: mm: validate /dev/mem mmap ranges without overflow
Date: Wed, 18 Nov 2026 15:35:58 +0100
Message-ID: <20261118150407.053123704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8f5b7ce857ed4..77fa580724665 100644
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



