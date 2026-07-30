Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBC339A801;
	Thu, 30 Jul 2026 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423664; cv=none; b=tZRtOnVoslJv6lLPM2N+pAGNn/wH0xKEOO5yO4gOgSqgsXqJOleSfZKsMkg4rlj5l61XHHqsqAfhxGQWanG+UGzuy1vw+NE/xUQgXKFryJUZ+ASpFHpjihnpdJf3Bz4eiO+lDFPFVFauJdYsdJUL+fRE3G3V+hTFxukQODnsQb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423664; c=relaxed/simple;
	bh=u3Vq2UfGVMUo57rGYb5JeSEzIU7poG68lQm+9hLiRu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfIu6n40A56BJpEMSApDwzJPjTAXHeYRyNRYJUOE580uV7OEfRO2l9ZHy5Vx0G19CV4Fj7Xo419JQiZfZWDmdPR2TmydSnRH3LDDlgv9EKJVZbZIeCVFQI9zFWsdafp0VShyW9C8dEAqT+0xXrKYfn1hwMzrhasEu+U88v/h8zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hR6Ld10n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hR6Ld10n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B631F000E9;
	Thu, 30 Jul 2026 15:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423663;
	bh=GMSA2Sv8DrfDGhEvRe7RMXJoJkll9vgwRS80pjORn6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hR6Ld10nSyBlBPhYDb7rDM6x9abRSgRL9h5yLz4bc+BrjgStGwzfYKlmx5zwh1/mw
	 AGviEqHW21pTU376D4e9HIDgQIXpgikL4hU0x9t1dEPlL5LER+u1CfmhoWi/+9/G8P
	 6+4QMrd8Xft2qJJcqygfZUF/QQNmPsdSxly0BDTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/675] s390/checksum: Fix csum_partial() without vector facility
Date: Thu, 30 Jul 2026 16:07:31 +0200
Message-ID: <20260730141447.717162525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



