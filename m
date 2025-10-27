Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C095E30FC0F;
	Mon, 27 Oct 2025 18:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591436; cv=none; b=oZO5zkfWZNjXDCd6oJZo1S+NErYI4eoDSmp6UQl6K7htG5zroIawWsyERsBEyCuIjFEY0MavRcEBu+zSVLxLG7LIO88w5wktyjzAAFMDHQI4KOL9HuGEPD8BqnDNG13Z1/u2+LhwKE2nPcb+zDhO9XxubfI/MZ4T+dTth7Xf25M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591436; c=relaxed/simple;
	bh=q0dQtuQ5LtVRf4pGOXjqSDZOLF05WFUcfNaS3CtACZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCetO+9BV7A3M04/xnRGcO5obflZ1U2tyjSKhXAW+0/SAG0ubMsVv/2S3TqMxPBO00eWRyiqgzD9aRLOB0108+ustvfXuhj6NXJEz5Jc+34E26bhJzl16oXh4Hh1UPGB/6+6LFxEyXmkwSE452uuEPmu3byRPIg7Rd6FrJwuGeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fArcmcn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fArcmcn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E0FC4CEF1;
	Mon, 27 Oct 2025 18:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591436;
	bh=q0dQtuQ5LtVRf4pGOXjqSDZOLF05WFUcfNaS3CtACZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fArcmcn6nQ90Q+4mrAt22M6/AjJ9vb6uZqRl5CKjGYhf6VaVSW8yWavu7ie9y+Njz
	 W8Kmzr3YAsncXTJ/1rByyIju7tA8L5h5Ft28ih1Vgg0rdlFRuPdHdm5zzCaPT4+w/N
	 bcC44dvJMdTwjXlp6ksAudiBufkhfF5MbNw8Vv98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 197/332] minmax: clamp more efficiently by avoiding extra comparison
Date: Mon, 27 Oct 2025 19:34:10 +0100
Message-ID: <20251027183529.905678806@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 2122e2a4efc2cd139474079e11939b6e07adfacd ]

Currently the clamp algorithm does:

    if (val > hi)
        val = hi;
    if (val < lo)
        val = lo;

But since hi > lo by definition, this can be made more efficient with:

    if (val > hi)
        val = hi;
    else if (val < lo)
        val = lo;

So fix up the clamp and clamp_t functions to do this, adding the same
argument checking as for min and min_t.

For simple cases, code generation on x86_64 and aarch64 stay about the
same:

    before:
            cmp     edi, edx
            mov     eax, esi
            cmova   edi, edx
            cmp     edi, esi
            cmovnb  eax, edi
            ret
    after:
            cmp     edi, esi
            mov     eax, edx
            cmovnb  esi, edi
            cmp     edi, edx
            cmovb   eax, esi
            ret

    before:
            cmp     w0, w2
            csel    w8, w0, w2, lo
            cmp     w8, w1
            csel    w0, w8, w1, hi
            ret
    after:
            cmp     w0, w1
            csel    w8, w0, w1, hi
            cmp     w0, w2
            csel    w0, w8, w2, lo
            ret

On MIPS64, however, code generation improves, by removing arithmetic in
the second branch:

    before:
            sltu    $3,$6,$4
            bne     $3,$0,.L2
            move    $2,$6

            move    $2,$4
    .L2:
            sltu    $3,$2,$5
            bnel    $3,$0,.L7
            move    $2,$5

    .L7:
            jr      $31
            nop
    after:
            sltu    $3,$4,$6
            beq     $3,$0,.L13
            move    $2,$6

            sltu    $3,$4,$5
            bne     $3,$0,.L12
            move    $2,$4

    .L13:
            jr      $31
            nop

    .L12:
            jr      $31
            move    $2,$5

For more complex cases with surrounding code, the effects are a bit
more complicated. For example, consider this simplified version of
timestamp_truncate() from fs/inode.c on x86_64:

    struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode)
    {
        struct super_block *sb = inode->i_sb;
        unsigned int gran = sb->s_time_gran;

        t.tv_sec = clamp(t.tv_sec, sb->s_time_min, sb->s_time_max);
        if (t.tv_sec == sb->s_time_max || t.tv_sec == sb->s_time_min)
            t.tv_nsec = 0;
        return t;
    }

    before:
            mov     r8, rdx
            mov     rdx, rsi
            mov     rcx, QWORD PTR [r8]
            mov     rax, QWORD PTR [rcx+8]
            mov     rcx, QWORD PTR [rcx+16]
            cmp     rax, rdi
            mov     r8, rcx
            cmovge  rdi, rax
            cmp     rdi, rcx
            cmovle  r8, rdi
            cmp     rax, r8
            je      .L4
            cmp     rdi, rcx
            jge     .L4
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            mov     rax, r8
            ret

    after:
            mov     rax, QWORD PTR [rdx]
            mov     rdx, QWORD PTR [rax+8]
            mov     rax, QWORD PTR [rax+16]
            cmp     rax, rdi
            jg      .L6
            mov     r8, rax
            xor     edx, edx
    .L2:
            mov     rax, r8
            ret
    .L6:
            cmp     rdx, rdi
            mov     r8, rdi
            cmovge  r8, rdx
            cmp     rax, r8
            je      .L4
            xor     eax, eax
            cmp     rdx, rdi
            cmovl   rax, rsi
            mov     rdx, rax
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            jmp     .L2

In this case, we actually gain a branch, unfortunately, because the
compiler's replacement axioms no longer as cleanly apply.

So all and all, this change is a bit of a mixed bag.

Link: https://lkml.kernel.org/r/20220926133435.1333846-2-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -38,7 +38,7 @@
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
 #define __clamp(val, lo, hi)	\
-	__cmp(__cmp(val, lo, >), hi, <)
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
 #define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
 		typeof(val) unique_val = (val);				\


