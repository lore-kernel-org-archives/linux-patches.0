Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4EA1774B;
	Thu, 18 Jan 2024 10:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575494; cv=none; b=aVLNjcjBbjvlY9EEmHS8VHGqIFNFvY5l6oafIaqkDtYyPMtrzwjUuqL5ozZ1tlPYs/UPXxY1KGkW/oukJa8wbkBoEruu92QWvovqstn4FulgAeHilY/RKa2B9LRROPIVv5gR3tcTn9/P95m/EuzK2inboI/LR3LuNsIWqE/whIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575494; c=relaxed/simple;
	bh=Oavlt241vqNi4eABnd9AJGwmujRnQdMYb8vmGlGSSfg=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=SXqem2McL52Tkds/xauPmsNEjPcnyL4slbTPk5ppmlgkAVu1VqPF0byot7SNeOhxZDrqQWgovN0xWv25OIjJ+I6qPViIwy6XnoPNFf9O/qw1tnuj4DXji0j+QnWT8oW9zQdXkyQTB0bHFMJ6/+7qDLd8g7MjAK2zxcbXhau4eMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRBS0zYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRBS0zYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DC7C433F1;
	Thu, 18 Jan 2024 10:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575493;
	bh=Oavlt241vqNi4eABnd9AJGwmujRnQdMYb8vmGlGSSfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRBS0zYqK6Qqasmmt/5+ZvoqNxoid0rnRyGM15B9teU9Ag7RS+cFb9Re8DsR+nsTK
	 VVIxJMLZfANbrBXhI0X7nCz6ePg3GcbhX0jGDWIpyRNRbj1zGA0lUT2z7NOjfJMpYD
	 Dbt44rkIJ6WO8n6ixmGGpkCoiAzIETvaSGMFRhHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noah Goldstein <goldstein.w.n@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	David Laight <david.laight@aculab.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/150] x86/csum: Remove unnecessary odd handling
Date: Thu, 18 Jan 2024 11:49:08 +0100
Message-ID: <20240118104325.884602830@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Noah Goldstein <goldstein.w.n@gmail.com>

[ Upstream commit 5d4acb62853abac1da2deebcb1c1c5b79219bf3b ]

The special case for odd aligned buffers is unnecessary and mostly
just adds overhead. Aligned buffers is the expectations, and even for
unaligned buffer, the only case that was helped is if the buffer was
1-byte from word aligned which is ~1/7 of the cases. Overall it seems
highly unlikely to be worth to extra branch.

It was left in the previous perf improvement patch because I was
erroneously comparing the exact output of `csum_partial(...)`, but
really we only need `csum_fold(csum_partial(...))` to match so its
safe to remove.

All csum kunit tests pass.

Signed-off-by: Noah Goldstein <goldstein.w.n@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Laight <david.laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/csum-partial_64.c | 36 ++++------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index cea25ca8b8cf..557e42ede68e 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -11,26 +11,9 @@
 #include <asm/checksum.h>
 #include <asm/word-at-a-time.h>
 
-static inline unsigned short from32to16(unsigned a)
+static inline __wsum csum_finalize_sum(u64 temp64)
 {
-	unsigned short b = a >> 16;
-	asm("addw %w2,%w0\n\t"
-	    "adcw $0,%w0\n"
-	    : "=r" (b)
-	    : "0" (b), "r" (a));
-	return b;
-}
-
-static inline __wsum csum_tail(u64 temp64, int odd)
-{
-	unsigned int result;
-
-	result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
-	if (unlikely(odd)) {
-		result = from32to16(result);
-		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
-	}
-	return (__force __wsum)result;
+	return (__force __wsum)((temp64 + ror64(temp64, 32)) >> 32);
 }
 
 /*
@@ -47,17 +30,6 @@ static inline __wsum csum_tail(u64 temp64, int odd)
 __wsum csum_partial(const void *buff, int len, __wsum sum)
 {
 	u64 temp64 = (__force u64)sum;
-	unsigned odd;
-
-	odd = 1 & (unsigned long) buff;
-	if (unlikely(odd)) {
-		if (unlikely(len == 0))
-			return sum;
-		temp64 = ror32((__force u32)sum, 8);
-		temp64 += (*(unsigned char *)buff << 8);
-		len--;
-		buff++;
-	}
 
 	/*
 	 * len == 40 is the hot case due to IPv6 headers, but annotating it likely()
@@ -73,7 +45,7 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
 		    "adcq $0,%[res]"
 		    : [res] "+r"(temp64)
 		    : [src] "r"(buff), "m"(*(const char(*)[40])buff));
-		return csum_tail(temp64, odd);
+		return csum_finalize_sum(temp64);
 	}
 	if (unlikely(len >= 64)) {
 		/*
@@ -143,7 +115,7 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
 		    : [res] "+r"(temp64)
 		    : [trail] "r"(trail));
 	}
-	return csum_tail(temp64, odd);
+	return csum_finalize_sum(temp64);
 }
 EXPORT_SYMBOL(csum_partial);
 
-- 
2.43.0



