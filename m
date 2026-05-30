Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611DA33F590;
	Sat, 30 May 2026 17:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163040; cv=none; b=durqtrpPrGGUNacC8wqyG64SfCyjToWK4zBNuN4YB6uZ5xj7sLWZb01CtpIevnMDOMmLW7GKAbSmlZIFi1048m2oSQ1AHvIGmo45KfSolgALS7PZFnlhuo5djWU4RFCEGO0cvP5GNqe+qCGT+a/eWxcKo5MAEUmKggwSIxlcKD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163040; c=relaxed/simple;
	bh=WENBeocXTiu+MDMvxy/mX03/EEyhnn0MHz6q9th6OTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjwgTLqO0W2tek998ElD56ZsdHKK1IT/Ze46jproCbGAba2WxPBtF0SckHOROb4FNPynABsUjhODLdJymS7Jlle9oo3Kyf0f7JfrTBkdCKmqyP5vu0QkvHaIXu2G6r1ey1lcWDZBncXkZHXsQIJvbAvO4kloziyWNRmg7bIOfZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSZSXEwC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSZSXEwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AFA1F00893;
	Sat, 30 May 2026 17:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163039;
	bh=k/BP/D1bSAVbjDO9Fog9EA4dmo3M/g1svRFGM43L8Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSZSXEwC4vPvGuRaZLByVQT7qQlziCFheb2SRkjpCj/nyshIhbZ7+wd53xwdNb5yf
	 eTUs9cv7TaOX8Rlhd3bnVtc+3Dk3FRmAzLUiJES0D7D3NDXxCNFvCkmf4oT0PBptR0
	 Je0/yEkvs9XAcFDhjIa085DtaGuA47rWxfg9grrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Johnny Hao <johnny_haocn@sina.com>
Subject: [PATCH 5.15 137/776] bpf: Do mark_chain_precision for ARG_CONST_ALLOC_SIZE_OR_ZERO
Date: Sat, 30 May 2026 17:57:31 +0200
Message-ID: <20260530160243.948248655@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 2fc31465c5373b5ca4edf2e5238558cb62902311 ]

Precision markers need to be propagated whenever we have an ARG_CONST_*
style argument, as the verifier cannot consider imprecise scalars to be
equivalent for the purposes of states_equal check when such arguments
refine the return value (in this case, set mem_size for PTR_TO_MEM). The
resultant mem_size for the R0 is derived from the constant value, and if
the verifier incorrectly prunes states considering them equivalent where
such arguments exist (by seeing that both registers have reg->precise as
false in regsafe), we can end up with invalid programs passing the
verifier which can do access beyond what should have been the correct
mem_size in that explored state.

To show a concrete example of the problem:

0000000000000000 <prog>:
       0:       r2 = *(u32 *)(r1 + 80)
       1:       r1 = *(u32 *)(r1 + 76)
       2:       r3 = r1
       3:       r3 += 4
       4:       if r3 > r2 goto +18 <LBB5_5>
       5:       w2 = 0
       6:       *(u32 *)(r1 + 0) = r2
       7:       r1 = *(u32 *)(r1 + 0)
       8:       r2 = 1
       9:       if w1 == 0 goto +1 <LBB5_3>
      10:       r2 = -1

0000000000000058 <LBB5_3>:
      11:       r1 = 0 ll
      13:       r3 = 0
      14:       call bpf_ringbuf_reserve
      15:       if r0 == 0 goto +7 <LBB5_5>
      16:       r1 = r0
      17:       r1 += 16777215
      18:       w2 = 0
      19:       *(u8 *)(r1 + 0) = r2
      20:       r1 = r0
      21:       r2 = 0
      22:       call bpf_ringbuf_submit

00000000000000b8 <LBB5_5>:
      23:       w0 = 0
      24:       exit

For the first case, the single line execution's exploration will prune
the search at insn 14 for the branch insn 9's second leg as it will be
verified first using r2 = -1 (UINT_MAX), while as w1 at insn 9 will
always be 0 so at runtime we don't get error for being greater than
UINT_MAX/4 from bpf_ringbuf_reserve. The verifier during regsafe just
sees reg->precise as false for both r2 registers in both states, hence
considers them equal for purposes of states_equal.

If we propagated precise markers using the backtracking support, we
would use the precise marking to then ensure that old r2 (UINT_MAX) was
within the new r2 (1) and this would never be true, so the verification
would rightfully fail.

The end result is that the out of bounds access at instruction 19 would
be permitted without this fix.

Note that reg->precise is always set to true when user does not have
CAP_BPF (or when subprog count is greater than 1 (i.e. use of any static
or global functions)), hence this is only a problem when precision marks
need to be explicitly propagated (i.e. privileged users with CAP_BPF).

A simplified test case has been included in the next patch to prevent
future regressions.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220823185300.406-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ The context change is due to the commit 8ab4cdcf03d0
("bpf: Tidy up verifier check_func_arg()") in v6.0
which is irrelevant to the logic of this patch. ]
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5540,6 +5540,9 @@ skip_type_check:
 			return -EACCES;
 		}
 		meta->mem_size = reg->var_off.value;
+		err = mark_chain_precision(env, regno);
+		if (err)
+			return err;
 	} else if (arg_type_is_int_ptr(arg_type)) {
 		int size = int_ptr_type_to_size(arg_type);
 


