Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D475329C69;
	Wed, 21 Jan 2026 18:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020207; cv=none; b=aDtuR21LK1Mvm8Qx56+Qhsi0AlVzh+u7H6kytgoskxbxLnSCPYjoXLJetGFN+L+RMpJ3hIxMPrwsqpSNPrpqJ4r/QaDUP89U0uJn6j1uVDyTxYd+IRXLEoB6GOGF1j3UPN+c2j5SjsZfzYYVspHcY19nMwKBhGVDeFyA5j5Baho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020207; c=relaxed/simple;
	bh=pidOfu3l1w/d7xXb15Hj8i3dl9cU1OHupG5xr+SLb0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/635R2nnfSw7DXY7LXK5Iz6HH8nGxqUBOtzbk7l36ROHHmvp7PWkuddAL9Qk/RqBiOzPqi5kknfD8emlWF6AJWbe1rLiGg7An7klU79qGy0AadsMsx+ACNT2x5IQ+hlFrHFlZN9PQHhTXI5gWpxNYsxyeqIirfkLQb2/FovaVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJKQgOYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJKQgOYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726B3C19422;
	Wed, 21 Jan 2026 18:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020206;
	bh=pidOfu3l1w/d7xXb15Hj8i3dl9cU1OHupG5xr+SLb0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJKQgOYEFYoXdG8P51YemUABQOKxtiTStsmMTz/cUW4EGu6x3A4NeqnaAhxhHFI0n
	 Wg9hbPi9h88V/I+wVh8GOVwW4rnMw3asxUx8cEHc1F+Yx0VQ8Z27TddnFVxMfsWZM7
	 B9lfDoQCLjtYYY5Qc321PTr0spAGs55LuDx8VOtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.18 090/198] selftests/bpf: Fix selftest verif_scale_strobemeta failure with llvm22
Date: Wed, 21 Jan 2026 19:15:18 +0100
Message-ID: <20260121181421.795878025@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

commit 4f8543b5f20f851cedbb23f8eade159871d84e2a upstream.

With latest llvm22, I hit the verif_scale_strobemeta selftest failure
below:
  $ ./test_progs -n 618
  libbpf: prog 'on_event': BPF program load failed: -E2BIG
  libbpf: prog 'on_event': -- BEGIN PROG LOAD LOG --
  BPF program is too large. Processed 1000001 insn
  verification time 7019091 usec
  stack depth 488
  processed 1000001 insns (limit 1000000) max_states_per_insn 28 total_states 33927 peak_states 12813 mark_read 0
  -- END PROG LOAD LOG --
  libbpf: prog 'on_event': failed to load: -E2BIG
  libbpf: failed to load object 'strobemeta.bpf.o'
  scale_test:FAIL:expect_success unexpected error: -7 (errno 7)
  #618     verif_scale_strobemeta:FAIL

But if I increase the verificaiton insn limit from 1M to 10M, the above
test_progs run actually will succeed. The below is the result from veristat:
  $ ./veristat strobemeta.bpf.o
  Processing 'strobemeta.bpf.o'...
  File              Program   Verdict  Duration (us)    Insns  States  Program size  Jited size
  ----------------  --------  -------  -------------  -------  ------  ------------  ----------
  strobemeta.bpf.o  on_event  success       90250893  9777685  358230         15954       80794
  ----------------  --------  -------  -------------  -------  ------  ------------  ----------
  Done. Processed 1 files, 0 programs. Skipped 1 files, 0 programs.

Further debugging shows the llvm commit [1] is responsible for the verificaiton
failure as it tries to convert certain switch statement to if-condition. Such
change may cause different transformation compared to original switch statement.

In bpf program strobemeta.c case, the initial llvm ir for read_int_var() function is
  define internal void @read_int_var(ptr noundef %0, i64 noundef %1, ptr noundef %2,
      ptr noundef %3, ptr noundef %4) #2 !dbg !535 {
    %6 = alloca ptr, align 8
    %7 = alloca i64, align 8
    %8 = alloca ptr, align 8
    %9 = alloca ptr, align 8
    %10 = alloca ptr, align 8
    %11 = alloca ptr, align 8
    %12 = alloca i32, align 4
    ...
    %20 = icmp ne ptr %19, null, !dbg !561
    br i1 %20, label %22, label %21, !dbg !562

  21:                                               ; preds = %5
    store i32 1, ptr %12, align 4
    br label %48, !dbg !563

  22:
    %23 = load ptr, ptr %9, align 8, !dbg !564
    ...

  47:                                               ; preds = %38, %22
    store i32 0, ptr %12, align 4, !dbg !588
    br label %48, !dbg !588

  48:                                               ; preds = %47, %21
    call void @llvm.lifetime.end.p0(ptr %11) #4, !dbg !588
    %49 = load i32, ptr %12, align 4
    switch i32 %49, label %51 [
      i32 0, label %50
      i32 1, label %50
    ]

  50:                                               ; preds = %48, %48
    ret void, !dbg !589

  51:                                               ; preds = %48
    unreachable
  }

Note that the above 'switch' statement is added by clang frontend.
Without [1], the switch statement will survive until SelectionDag,
so the switch statement acts like a 'barrier' and prevents some
transformation involved with both 'before' and 'after' the switch statement.

But with [1], the switch statement will be removed during middle end
optimization and later middle end passes (esp. after inlining) have more
freedom to reorder the code.

The following is the related source code:

  static void *calc_location(struct strobe_value_loc *loc, void *tls_base):
        bpf_probe_read_user(&tls_ptr, sizeof(void *), dtv);
        /* if pointer has (void *)-1 value, then TLS wasn't initialized yet */
        return tls_ptr && tls_ptr != (void *)-1
                ? tls_ptr + tls_index.offset
                : NULL;

  In read_int_var() func, we have:
        void *location = calc_location(&cfg->int_locs[idx], tls_base);
        if (!location)
                return;

        bpf_probe_read_user(value, sizeof(struct strobe_value_generic), location);
        ...

The static func calc_location() is called inside read_int_var(). The asm code
without [1]:
     77: .123....89 (85) call bpf_probe_read_user#112
     78: ........89 (79) r1 = *(u64 *)(r10 -368)
     79: .1......89 (79) r2 = *(u64 *)(r10 -8)
     80: .12.....89 (bf) r3 = r2
     81: .123....89 (0f) r3 += r1
     82: ..23....89 (07) r2 += 1
     83: ..23....89 (79) r4 = *(u64 *)(r10 -464)
     84: ..234...89 (a5) if r2 < 0x2 goto pc+13
     85: ...34...89 (15) if r3 == 0x0 goto pc+12
     86: ...3....89 (bf) r1 = r10
     87: .1.3....89 (07) r1 += -400
     88: .1.3....89 (b4) w2 = 16
In this case, 'r2 < 0x2' and 'r3 == 0x0' go to null 'locaiton' place,
so the verifier actually prefers to do verification first at 'r1 = r10' etc.

The asm code with [1]:
    119: .123....89 (85) call bpf_probe_read_user#112
    120: ........89 (79) r1 = *(u64 *)(r10 -368)
    121: .1......89 (79) r2 = *(u64 *)(r10 -8)
    122: .12.....89 (bf) r3 = r2
    123: .123....89 (0f) r3 += r1
    124: ..23....89 (07) r2 += -1
    125: ..23....89 (a5) if r2 < 0xfffffffe goto pc+6
    126: ........89 (05) goto pc+17
    ...
    144: ........89 (b4) w1 = 0
    145: .1......89 (6b) *(u16 *)(r8 +80) = r1
In this case, if 'r2 < 0xfffffffe' is true, the control will go to
non-null 'location' branch, so 'goto pc+17' will actually go to
null 'location' branch. This seems causing tremendous amount of
verificaiton state.

To fix the issue, rewrite the following code
  return tls_ptr && tls_ptr != (void *)-1
                ? tls_ptr + tls_index.offset
                : NULL;
to if/then statement and hopefully these explicit if/then statements
are sticky during middle-end optimizations.

Test with llvm20 and llvm21 as well and all strobemeta related selftests
are passed.

  [1] https://github.com/llvm/llvm-project/pull/161000

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20251014051639.1996331-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/strobemeta.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/bpf/progs/strobemeta.h
+++ b/tools/testing/selftests/bpf/progs/strobemeta.h
@@ -330,9 +330,9 @@ static void *calc_location(struct strobe
 	}
 	bpf_probe_read_user(&tls_ptr, sizeof(void *), dtv);
 	/* if pointer has (void *)-1 value, then TLS wasn't initialized yet */
-	return tls_ptr && tls_ptr != (void *)-1
-		? tls_ptr + tls_index.offset
-		: NULL;
+	if (!tls_ptr || tls_ptr == (void *)-1)
+		return NULL;
+	return tls_ptr + tls_index.offset;
 }
 
 #ifdef SUBPROGS


