Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D702922F1B;
	Thu, 18 Jan 2024 10:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575496; cv=none; b=Yj+KRf0l2oMaiwrxG9fMGhiMRMCSjD18Z58u99+2eRNIgS5bg1jRQNNbu8Hn8BXYDUMTkblVRzoZuZJEXm9g48sDrn/fuZNNzQjmsTrvwe5YwcVDJizCvH0icVrdWhFDPRha/GMKHiMIyE3XKEoFYiSnbmDhaMWmesW4yQo5CCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575496; c=relaxed/simple;
	bh=g9qeelaSFK7GXmXJxPNxsQjYa/pohyVRPJihl50o5kY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=a8LhZf7QX+A7dleUdpeMsKJesSGJx/7uWitnSIwkgCJDvQeodOLQ5aVk9ll/wn4pssHV49Y9Nyyg8MrlT3dEOKDn17lQ28HicbSvC4EUxKj1vJjo0QaLfJBZogIQ2qLs7Q8tZ3oVyzlVXrBP2OyJ9ac0dleJ4KYENkY/IbO1iEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKB6ZvXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKB6ZvXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F6BC433C7;
	Thu, 18 Jan 2024 10:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575496;
	bh=g9qeelaSFK7GXmXJxPNxsQjYa/pohyVRPJihl50o5kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKB6ZvXV0k6hxobc1T0oN6G7ifZuOoI/1QFFjRL9TvDI8hQzpBwnnnw98iIlfsS7l
	 h0ZBOn0WJjokO5jepxCf7+d0zAo7A9w+1YMNFfqEomV3d4Gbk4GHJ0aQtV6agk0qoO
	 EBDSAVjw1jfyTNNxKpoNmXR7o1ekIFO3HuymAPak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/150] x86/csum: clean up `csum_partial further
Date: Thu, 18 Jan 2024 11:49:09 +0100
Message-ID: <20240118104325.934413736@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit a476aae3f1dc78a162a0d2e7945feea7d2b29401 ]

Commit 688eb8191b47 ("x86/csum: Improve performance of `csum_partial`")
ended up improving the code generation for the IP csum calculations, and
in particular special-casing the 40-byte case that is a hot case for
IPv6 headers.

It then had _another_ special case for the 64-byte unrolled loop, which
did two chains of 32-byte blocks, which allows modern CPU's to improve
performance by doing the chains in parallel thanks to renaming the carry
flag.

This just unifies the special cases and combines them into just one
single helper the 40-byte csum case, and replaces the 64-byte case by a
80-byte case that just does that single helper twice.  It avoids having
all these different versions of inline assembly, and actually improved
performance further in my tests.

There was never anything magical about the 64-byte unrolled case, even
though it happens to be a common size (and typically is the cacheline
size).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/csum-partial_64.c | 81 ++++++++++++++++------------------
 1 file changed, 37 insertions(+), 44 deletions(-)

diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
index 557e42ede68e..c9dae65ac01b 100644
--- a/arch/x86/lib/csum-partial_64.c
+++ b/arch/x86/lib/csum-partial_64.c
@@ -16,6 +16,20 @@ static inline __wsum csum_finalize_sum(u64 temp64)
 	return (__force __wsum)((temp64 + ror64(temp64, 32)) >> 32);
 }
 
+static inline unsigned long update_csum_40b(unsigned long sum, const unsigned long m[5])
+{
+	asm("addq %1,%0\n\t"
+	     "adcq %2,%0\n\t"
+	     "adcq %3,%0\n\t"
+	     "adcq %4,%0\n\t"
+	     "adcq %5,%0\n\t"
+	     "adcq $0,%0"
+		:"+r" (sum)
+		:"m" (m[0]), "m" (m[1]), "m" (m[2]),
+		 "m" (m[3]), "m" (m[4]));
+	return sum;
+}
+
 /*
  * Do a checksum on an arbitrary memory area.
  * Returns a 32bit checksum.
@@ -31,52 +45,31 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
 {
 	u64 temp64 = (__force u64)sum;
 
-	/*
-	 * len == 40 is the hot case due to IPv6 headers, but annotating it likely()
-	 * has noticeable negative affect on codegen for all other cases with
-	 * minimal performance benefit here.
-	 */
-	if (len == 40) {
-		asm("addq 0*8(%[src]),%[res]\n\t"
-		    "adcq 1*8(%[src]),%[res]\n\t"
-		    "adcq 2*8(%[src]),%[res]\n\t"
-		    "adcq 3*8(%[src]),%[res]\n\t"
-		    "adcq 4*8(%[src]),%[res]\n\t"
-		    "adcq $0,%[res]"
-		    : [res] "+r"(temp64)
-		    : [src] "r"(buff), "m"(*(const char(*)[40])buff));
-		return csum_finalize_sum(temp64);
+	/* Do two 40-byte chunks in parallel to get better ILP */
+	if (likely(len >= 80)) {
+		u64 temp64_2 = 0;
+		do {
+			temp64 = update_csum_40b(temp64, buff);
+			temp64_2 = update_csum_40b(temp64_2, buff + 40);
+			buff += 80;
+			len -= 80;
+		} while (len >= 80);
+
+		asm("addq %1,%0\n\t"
+		    "adcq $0,%0"
+		    :"+r" (temp64): "r" (temp64_2));
 	}
-	if (unlikely(len >= 64)) {
-		/*
-		 * Extra accumulators for better ILP in the loop.
-		 */
-		u64 tmp_accum, tmp_carries;
 
-		asm("xorl %k[tmp_accum],%k[tmp_accum]\n\t"
-		    "xorl %k[tmp_carries],%k[tmp_carries]\n\t"
-		    "subl $64, %[len]\n\t"
-		    "1:\n\t"
-		    "addq 0*8(%[src]),%[res]\n\t"
-		    "adcq 1*8(%[src]),%[res]\n\t"
-		    "adcq 2*8(%[src]),%[res]\n\t"
-		    "adcq 3*8(%[src]),%[res]\n\t"
-		    "adcl $0,%k[tmp_carries]\n\t"
-		    "addq 4*8(%[src]),%[tmp_accum]\n\t"
-		    "adcq 5*8(%[src]),%[tmp_accum]\n\t"
-		    "adcq 6*8(%[src]),%[tmp_accum]\n\t"
-		    "adcq 7*8(%[src]),%[tmp_accum]\n\t"
-		    "adcl $0,%k[tmp_carries]\n\t"
-		    "addq $64, %[src]\n\t"
-		    "subl $64, %[len]\n\t"
-		    "jge 1b\n\t"
-		    "addq %[tmp_accum],%[res]\n\t"
-		    "adcq %[tmp_carries],%[res]\n\t"
-		    "adcq $0,%[res]"
-		    : [tmp_accum] "=&r"(tmp_accum),
-		      [tmp_carries] "=&r"(tmp_carries), [res] "+r"(temp64),
-		      [len] "+r"(len), [src] "+r"(buff)
-		    : "m"(*(const char *)buff));
+	/*
+	 * len == 40 is the hot case due to IPv6 headers, so return
+	 * early for that exact case without checking the tail bytes.
+	 */
+	if (len >= 40) {
+		temp64 = update_csum_40b(temp64, buff);
+		len -= 40;
+		if (!len)
+			return csum_finalize_sum(temp64);
+		buff += 40;
 	}
 
 	if (len & 32) {
-- 
2.43.0



