Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D543435A9E;
	Thu, 30 Jul 2026 15:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425530; cv=none; b=M8VVLtFuDOhioTDqXb9m+JHvzYvgq30qSHiG1zpfiuLz2Af6bms/engnK8Rn/YjszPJ1PWYnqX2XSE/4FADS6iiu7AoNDqUInR97rUZWhyyIen9YYdNSSwqF2Z7p+MuG5Fs7jNpXJlYhq+Fbazi2L94hCYbx3gU3HGdYVm+aoKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425530; c=relaxed/simple;
	bh=prVWdOsjQw0v/q5/n2SmrJo/wSK0FhQaXrGBzAYGqsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOxcJCqTWsIGC2ZGmukF0TuT3Tlyj2xOLpboJkwcnXjniAMVN1DNd69XxtlZzE7oMbJbJFGXH+dTTTHB7wkOPLxc8eE+DYupVtoQCAlrsqoNs9olDxoE79HbpwnO7PZKTJQfoFQGsE2enMLlahgM7W0DPxuSjYavv2kuegXmg6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZ7FVpa2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZ7FVpa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0F21F000E9;
	Thu, 30 Jul 2026 15:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425528;
	bh=UWP5+wYcWpoROmWec6X9g5H10nBx03Pis1ENPQ5Pl7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZ7FVpa2Eb9iS2WAMKdhWcR/4GW3WOrmBVj7d3NpNPA/arEXSXGSHJShkWDZiD8SW
	 1ToSLahOBrGZ4jNXjNgu8VHWKscIBnphqXR/si+f+ias5O5Eq/eHE12nXJeccoBNVu
	 WeobbHR4yPsLDk5JaTaj09gQnYDiHCh6AIEGDye8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/602] s390/checksum: Fix csum_partial() without vector facility
Date: Thu, 30 Jul 2026 16:08:14 +0200
Message-ID: <20260730141438.137760216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 4bb06b60d982355e22647b3d12d6619419f8c1fa ]

Currently csum_partial() calls csum_copy() with copy=false and dst=NULL.
On machines without the vector facility, csum_copy() falls back to
cksm(dst, ...), causing the checksum to be calculated from address zero
instead of the source buffer.

The VX implementation already checksums data loaded from src. Make the
fallback do the same by passing src to cksm().

Fixes: dcd3e1de9d17 ("s390/checksum: provide csum_partial_copy_nocheck()")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/lib/csum-partial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/lib/csum-partial.c b/arch/s390/lib/csum-partial.c
index 458abd9bac7025..9d74ceff136c54 100644
--- a/arch/s390/lib/csum-partial.c
+++ b/arch/s390/lib/csum-partial.c
@@ -23,7 +23,7 @@ static __always_inline __wsum csum_copy(void *dst, const void *src, int len, __w
 	if (!cpu_has_vx()) {
 		if (copy)
 			memcpy(dst, src, len);
-		return cksm(dst, len, sum);
+		return cksm(src, len, sum);
 	}
 	kernel_fpu_begin(&vxstate, KERNEL_VXR_V16V23);
 	fpu_vlvgf(16, (__force u32)sum, 1);
-- 
2.53.0



