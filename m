Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284C8321F43;
	Mon, 18 Aug 2025 13:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524739; cv=none; b=rAtX6viyyvuH8Pa2zNoI/YQSZ61E24N78sZZrMknbgMugyahAnfcKoGjgNqHkUMtBNO2QhFSxS+sAGj8RR60GAJBqtJb7CDJoacMz7RECHYWefUclKy8Giiu7Z7tqUTUzYy4jhic0aWd8WCLFA68wKuCZxyfZI1Z2QMSRVuMGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524739; c=relaxed/simple;
	bh=/pbhzvPcwzz33B+kPqnUBWx983wcT9cgHpJj7YOOWW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKklx0OHsZrDFm+WvZnkg7UwavZO8IkM+vs+wB8wukzCc/ycyJXuK5R0cSKYRHy5TrxEGXneQv/0bWUI57V95aB5u9cPGaz/33lkymRiSVUb3WgCcok5a4/pOOssjzQTenxpTDwaBR95YlJaiehkbScvamqvByTW8S6hO9F0THk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sl/y/m7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sl/y/m7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A0CC4CEEB;
	Mon, 18 Aug 2025 13:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524739;
	bh=/pbhzvPcwzz33B+kPqnUBWx983wcT9cgHpJj7YOOWW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sl/y/m7LJaO9BetoK3CYV8cqWmT4Fy4ivC2wq+YNKExzC7tiw2fqi9rVpJ/a9krgN
	 MNlbGW4M7L1D462OZOKvDEOVUemYrKchfVQn1KJqkTNmIkxYNzkBkVXkhfbouLULxt
	 qhCwlYmf1JE3zHtuIUFap0MuRcWAe0WhfvHLzZp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.16 047/570] lib/crypto: x86/poly1305: Fix performance regression on short messages
Date: Mon, 18 Aug 2025 14:40:34 +0200
Message-ID: <20250818124507.627592923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 9f65592b7e1f24569bb6ced064df5b4319f725ce upstream.

Restore the len >= 288 condition on using the AVX implementation, which
was incidentally removed by commit 318c53ae02f2 ("crypto: x86/poly1305 -
Add block-only interface").  This check took into account the overhead
in key power computation, kernel-mode "FPU", and tail handling
associated with the AVX code.  Indeed, restoring this check slightly
improves performance for len < 256 as measured using poly1305_kunit on
an "AMD Ryzen AI 9 365" (Zen 5) CPU:

    Length      Before       After
    ======  ==========  ==========
         1     30 MB/s     36 MB/s
        16    516 MB/s    598 MB/s
        64   1700 MB/s   1882 MB/s
       127   2265 MB/s   2651 MB/s
       128   2457 MB/s   2827 MB/s
       200   2702 MB/s   3238 MB/s
       256   3841 MB/s   3768 MB/s
       511   4580 MB/s   4585 MB/s
       512   5430 MB/s   5398 MB/s
      1024   7268 MB/s   7305 MB/s
      3173   8999 MB/s   8948 MB/s
      4096   9942 MB/s   9921 MB/s
     16384  10557 MB/s  10545 MB/s

While the optimal threshold for this CPU might be slightly lower than
288 (see the len == 256 case), other CPUs would need to be tested too,
and these sorts of benchmarks can underestimate the true cost of
kernel-mode "FPU".  Therefore, for now just restore the 288 threshold.

Fixes: 318c53ae02f2 ("crypto: x86/poly1305 - Add block-only interface")
Cc: stable@vger.kernel.org
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20250706231100.176113-6-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/crypto/poly1305_glue.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/lib/crypto/poly1305_glue.c
+++ b/arch/x86/lib/crypto/poly1305_glue.c
@@ -98,7 +98,15 @@ void poly1305_blocks_arch(struct poly130
 	BUILD_BUG_ON(SZ_4K < POLY1305_BLOCK_SIZE ||
 		     SZ_4K % POLY1305_BLOCK_SIZE);
 
+	/*
+	 * The AVX implementations have significant setup overhead (e.g. key
+	 * power computation, kernel FPU enabling) which makes them slower for
+	 * short messages.  Fall back to the scalar implementation for messages
+	 * shorter than 288 bytes, unless the AVX-specific key setup has already
+	 * been performed (indicated by ctx->is_base2_26).
+	 */
 	if (!static_branch_likely(&poly1305_use_avx) ||
+	    (len < POLY1305_BLOCK_SIZE * 18 && !ctx->is_base2_26) ||
 	    unlikely(!irq_fpu_usable())) {
 		convert_to_base2_64(ctx);
 		poly1305_blocks_x86_64(ctx, inp, len, padbit);


