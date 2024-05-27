Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192C417E90E;
	Mon, 27 May 2024 19:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836807; cv=none; b=fzLfsPHaa1MDx0w0cTUfVouiyLiHHQW+DzP9VHpMydqQx9TVLjfAp9jaR5rD4+29yHFwkKKZmuqS6G3EisqEua0QMZ6rh3pdWrqpy+HNq7NgAYJY0Z1HI/mAnAMi9TImQCpggF/jxRNtLmYtJZS2oGnLV09VyM6+U2Ugwg/MTFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836807; c=relaxed/simple;
	bh=rCE8lrPPz+O59vKIdmXqHMozhn6INqUoHawZKJWeI6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtiQbh13ikhGhc4fxGWaGTL9dL/Ha1LnKYyFovm7KU8eQkhl9H8kzoRzS34h3xetow+NV2wZG3C5PAHiwQPuCmL/fQraSvI+mgN6IVMolf66HychIBap+CG+RkOhloFTen/7YKkoIXChmlRjQN2qa2uH5xzV5nqKU9cdt5o4p9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnPI3U3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnPI3U3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2ECBC2BBFC;
	Mon, 27 May 2024 19:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836807;
	bh=rCE8lrPPz+O59vKIdmXqHMozhn6INqUoHawZKJWeI6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnPI3U3XwNESsZqAOa9vsEydhWZNSHVFLYmIbb841AcTKeL7iRqxLtoOY27YDkE30
	 8eJ4h4/vi0T0UBLvwG6UvWtAWKwujqWnZ2kcREqXcjnSkcH/Ye2LTD7GMdHAAOFfji
	 KschjwjRfrAKVGcQ8YC/5GPmrgh5BGlzHteE+Sg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 196/427] Revert "sh: Handle calling csum_partial with misaligned data"
Date: Mon, 27 May 2024 20:54:03 +0200
Message-ID: <20240527185620.543256607@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b5319c96292ff877f6b58d349acf0a9dc8d3b454 ]

This reverts commit cadc4e1a2b4d20d0cc0e81f2c6ba0588775e54e5.

Commit cadc4e1a2b4d ("sh: Handle calling csum_partial with misaligned
data") causes bad checksum calculations on unaligned data. Reverting
it fixes the problem.

    # Subtest: checksum
    # module: checksum_kunit
    1..5
    # test_csum_fixed_random_inputs: ASSERTION FAILED at lib/checksum_kunit.c:500
    Expected ( u64)result == ( u64)expec, but
        ( u64)result == 53378 (0xd082)
        ( u64)expec == 33488 (0x82d0)
    # test_csum_fixed_random_inputs: pass:0 fail:1 skip:0 total:1
    not ok 1 test_csum_fixed_random_inputs
    # test_csum_all_carry_inputs: ASSERTION FAILED at lib/checksum_kunit.c:525
    Expected ( u64)result == ( u64)expec, but
        ( u64)result == 65281 (0xff01)
        ( u64)expec == 65280 (0xff00)
    # test_csum_all_carry_inputs: pass:0 fail:1 skip:0 total:1
    not ok 2 test_csum_all_carry_inputs
    # test_csum_no_carry_inputs: ASSERTION FAILED at lib/checksum_kunit.c:573
    Expected ( u64)result == ( u64)expec, but
        ( u64)result == 65535 (0xffff)
        ( u64)expec == 65534 (0xfffe)
    # test_csum_no_carry_inputs: pass:0 fail:1 skip:0 total:1
    not ok 3 test_csum_no_carry_inputs
    # test_ip_fast_csum: pass:1 fail:0 skip:0 total:1
    ok 4 test_ip_fast_csum
    # test_csum_ipv6_magic: pass:1 fail:0 skip:0 total:1
    ok 5 test_csum_ipv6_magic
 # checksum: pass:2 fail:3 skip:0 total:5
 # Totals: pass:2 fail:3 skip:0 total:5
not ok 22 checksum

Fixes: cadc4e1a2b4d ("sh: Handle calling csum_partial with misaligned data")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20240324231804.841099-1-linux@roeck-us.net
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/lib/checksum.S | 67 ++++++++++++------------------------------
 1 file changed, 18 insertions(+), 49 deletions(-)

diff --git a/arch/sh/lib/checksum.S b/arch/sh/lib/checksum.S
index 3e07074e00981..06fed5a21e8ba 100644
--- a/arch/sh/lib/checksum.S
+++ b/arch/sh/lib/checksum.S
@@ -33,7 +33,8 @@
  */
 
 /*	
- * asmlinkage __wsum csum_partial(const void *buf, int len, __wsum sum);
+ * unsigned int csum_partial(const unsigned char *buf, int len,
+ *                           unsigned int sum);
  */
 
 .text
@@ -45,31 +46,11 @@ ENTRY(csum_partial)
 	   * Fortunately, it is easy to convert 2-byte alignment to 4-byte
 	   * alignment for the unrolled loop.
 	   */
+	mov	r5, r1
 	mov	r4, r0
-	tst	#3, r0		! Check alignment.
-	bt/s	2f		! Jump if alignment is ok.
-	 mov	r4, r7		! Keep a copy to check for alignment
+	tst	#2, r0		! Check alignment.
+	bt	2f		! Jump if alignment is ok.
 	!
-	tst	#1, r0		! Check alignment.
-	bt	21f		! Jump if alignment is boundary of 2bytes.
-
-	! buf is odd
-	tst	r5, r5
-	add	#-1, r5
-	bt	9f
-	mov.b	@r4+, r0
-	extu.b	r0, r0
-	addc	r0, r6		! t=0 from previous tst
-	mov	r6, r0
-	shll8	r6
-	shlr16	r0
-	shlr8	r0
-	or	r0, r6
-	mov	r4, r0
-	tst	#2, r0
-	bt	2f
-21:
-	! buf is 2 byte aligned (len could be 0)
 	add	#-2, r5		! Alignment uses up two bytes.
 	cmp/pz	r5		!
 	bt/s	1f		! Jump if we had at least two bytes.
@@ -77,17 +58,16 @@ ENTRY(csum_partial)
 	bra	6f
 	 add	#2, r5		! r5 was < 2.  Deal with it.
 1:
+	mov	r5, r1		! Save new len for later use.
 	mov.w	@r4+, r0
 	extu.w	r0, r0
 	addc	r0, r6
 	bf	2f
 	add	#1, r6
 2:
-	! buf is 4 byte aligned (len could be 0)
-	mov	r5, r1
 	mov	#-5, r0
-	shld	r0, r1
-	tst	r1, r1
+	shld	r0, r5
+	tst	r5, r5
 	bt/s	4f		! if it's =0, go to 4f
 	 clrt
 	.align	2
@@ -109,31 +89,30 @@ ENTRY(csum_partial)
 	addc	r0, r6
 	addc	r2, r6
 	movt	r0
-	dt	r1
+	dt	r5
 	bf/s	3b
 	 cmp/eq	#1, r0
-	! here, we know r1==0
-	addc	r1, r6			! add carry to r6
+	! here, we know r5==0
+	addc	r5, r6			! add carry to r6
 4:
-	mov	r5, r0
+	mov	r1, r0
 	and	#0x1c, r0
 	tst	r0, r0
-	bt	6f
-	! 4 bytes or more remaining
-	mov	r0, r1
-	shlr2	r1
+	bt/s	6f
+	 mov	r0, r5
+	shlr2	r5
 	mov	#0, r2
 5:
 	addc	r2, r6
 	mov.l	@r4+, r2
 	movt	r0
-	dt	r1
+	dt	r5
 	bf/s	5b
 	 cmp/eq	#1, r0
 	addc	r2, r6
-	addc	r1, r6		! r1==0 here, so it means add carry-bit
+	addc	r5, r6		! r5==0 here, so it means add carry-bit
 6:
-	! 3 bytes or less remaining
+	mov	r1, r5
 	mov	#3, r0
 	and	r0, r5
 	tst	r5, r5
@@ -159,16 +138,6 @@ ENTRY(csum_partial)
 	mov	#0, r0
 	addc	r0, r6
 9:
-	! Check if the buffer was misaligned, if so realign sum
-	mov	r7, r0
-	tst	#1, r0
-	bt	10f
-	mov	r6, r0
-	shll8	r6
-	shlr16	r0
-	shlr8	r0
-	or	r0, r6
-10:
 	rts
 	 mov	r6, r0
 
-- 
2.43.0



