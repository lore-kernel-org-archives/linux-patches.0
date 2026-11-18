Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046595;
	b=EPSLBSPnJrCuPiLVC3wydG3gq1eUlJpj24EB5vOpqcW/8C03zYzhYCJDNDWcboU6CQZ8
	 Ff1+jy930PXTHPOTvBA5y8EfeMm64VWsvY/Ykout8RRZkhQ0yMmRPkJc1z5dr7YzhODmu
	 2X5nIU3FrdfNDZOzjdH+301MzgcdI/p31IuasllkbuUC7FKl5xVz5w2G/6zaNhAQiBdqy
	 cz0hwUBXmdwGK2v1zoDHOaXIhxBMy39299PadV7jc7EpaSdgbIojYlIXkacZMMlzTJeqs
	 0/zlvB7dmkqUFl+k2b94wpwt+pb4a6cZg/1PSVvFB0izmV+2dGRQx4EvEQVCIP1/1wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2rD2XnA8bvADQtEQLGaNB2bvfMByyqwbJI/65fhkdP8=;
	b=sOzR9FnBM6ZZ3Nu0lcDhpLIDoHL7PTlMfUtQZAkSf5iEXC9mFONzmhSYvhd4DGk6//ez
	 dRfMhs/f9//ij6xSIZ2eC5hw5GKDHFk/rP7Dv4kVrO8cjh7TIjOCt9r5AQKBAkH7AztEQ
	 8u17xrXcCl9F8zRSFAibEB8JttoMzbyWSM/pALPBpt9cv9lcc1K8v+Nm/sHxUa0pY2a5j
	 FyWdg4nvT5QNFe2rbjMs1k5wJYwL5Oi3NDAlVkp1xY/qYq3hCMk9CnzNyTE24aqX2wMEi
	 jMovNxmFAOZ2VT/6q8NLK98jvH2ixaDxildwEZlumZBzCRnIViVb5oaGdcHAKV0Opxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RthiYPKw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC98606A334;
	Thu, 19 Nov 2026 00:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RthiYPKw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569F21F000C4;
	Thu, 19 Nov 2026 00:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046594;
	bh=2rD2XnA8bvADQtEQLGaNB2bvfMByyqwbJI/65fhkdP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RthiYPKwFvD982Kt11W2pWMKA9vAqeiZFYsvu4bm6HkPhUhLRVl5TGCAaHnu8s7iP
	 ojHX13WaOlbSCm6KLq4d9gaWLf0Shwk/sm4InkRCL+Nz75O0fwTM40XKmuLEW4L8QF
	 jey8/a7z3vCr1ngg2HC6VDS2LiKm/Sdeoe3zj/TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1296/2857] arm64: mm: validate /dev/mem mmap ranges without overflow
Date: Wed, 18 Nov 2026 15:38:50 +0100
Message-ID: <20261118150248.148065019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



