Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B37542F715;
	Thu, 30 Jul 2026 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421484; cv=none; b=t7uQsgpD7ApnNVWxgjJQ3Fko7mWrBHO1C3gccN/ThBaUn+37xK+G6/zXbbwr5ogdcpN40VsgXW9wCsc0uHWU74KTz3kbRMgV3rqX3V2diy/EtDHb5wyKRuqzmppwO4+fXrplizgInZJ0g2hCXYAS1rcoDxKqYHlVRcSw1LWvAVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421484; c=relaxed/simple;
	bh=mRwpPyFMdcZhlWihQmAx3zpVMz3oy6lKScvke8jqmFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIpvTWgZCz8ne/9CBmfbPr2P8ETr2UdRIjj7zeYRSEIlELN/ZYmoEpetaD92swbz4FNkrtlOHLC+aOuS8I6MW9+dgimOhuFv+i4eltnXWebSHPGGAlyqwz+beeDmfndya6ajszoMqmP1axxyYnXUEYYrG63uQhmPkfieafhbwqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myXQBaz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myXQBaz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD801F000E9;
	Thu, 30 Jul 2026 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421483;
	bh=mMimzRaUUVkinNfAFk99vmocN9/kFiUV5DW3/Mapq8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myXQBaz3I2UHCBvBu+kAIg5EwvoIIKqIjvpXtSfTPUt+pUxhZoRTIZaiY2Z3tSRrS
	 j1DvCZJXALBvYqjOa8tpPEEG/0OE0td+sR1aooQ7CY4ub8+NchE6azLslSSOqruQHb
	 qvY+KZHIJZSmtnSffM0OZqq/+BWe+ELJVEng/bqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 117/744] s390/checksum: Fix csum_partial() without vector facility
Date: Thu, 30 Jul 2026 16:06:30 +0200
Message-ID: <20260730141446.766901427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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



