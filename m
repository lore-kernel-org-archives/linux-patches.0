Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C65F230BC2;
	Mon, 23 Jun 2025 13:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685349; cv=none; b=AbZO7kFwDiB1nNsv4ME8WEzFIfsT/dBH6Zrzrylxgzw5pUIlG/KL348MzJjhyQZkQrO2wCbXcRvHqQEiR/50Q/huMFo5baVfEyBVvBOpwh+fk1LWMiAgMAJuJ9DmAn56RT9nQTARNv/5v9vlAlIZ2MKzaM+QDbhXObuZAEU90Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685349; c=relaxed/simple;
	bh=KRkhmAJmx7CwPdQJ0IKcRvsi1v6W20OE1l2OfxZb55E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8778SJYK2oEqT23oJdOEkSbK0+zLeWsRuEmcPop9dx1mw0Ksd3PNhU2KR2uLe8ePPy+QraJVAgZOOE/G7iCcgcuObdlc2PbGObMbS6lKD2KWHr+hk17zH/KtGclA7VnjkNvracrvySxfXzYzgGv0EElmHP8DbLaxzvTXtN4Y3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAPoI5jY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAPoI5jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A478BC4CEF0;
	Mon, 23 Jun 2025 13:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685349;
	bh=KRkhmAJmx7CwPdQJ0IKcRvsi1v6W20OE1l2OfxZb55E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAPoI5jYzF9E8ELjNMxmucBgNpI9KTwzYiiRkVGjQwZnJGabHoFJmBYQKutgnNqTw
	 p/rbG18aqMUtS/kwmgmGZjjWp3YMhN6pp6zwT94LppVINeKgklHFetBt6ccG5C2QI1
	 lt7PQ7CQEqZ7qXOsCKzxxUTrc61X/4bP+kOxEwz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/355] s390/bpf: Store backchain even for leaf progs
Date: Mon, 23 Jun 2025 15:04:09 +0200
Message-ID: <20250623130628.273695873@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 5f55f2168432298f5a55294831ab6a76a10cb3c3 ]

Currently a crash in a leaf prog (caused by a bug) produces the
following call trace:

     [<000003ff600ebf00>] bpf_prog_6df0139e1fbf2789_fentry+0x20/0x78
     [<0000000000000000>] 0x0

This is because leaf progs do not store backchain. Fix by making all
progs do it. This is what GCC and Clang-generated code does as well.
Now the call trace looks like this:

     [<000003ff600eb0f2>] bpf_prog_6df0139e1fbf2789_fentry+0x2a/0x80
     [<000003ff600ed096>] bpf_trampoline_201863462940+0x96/0xf4
     [<000003ff600e3a40>] bpf_prog_05f379658fdd72f2_classifier_0+0x58/0xc0
     [<000003ffe0aef070>] bpf_test_run+0x210/0x390
     [<000003ffe0af0dc2>] bpf_prog_test_run_skb+0x25a/0x668
     [<000003ffe038a90e>] __sys_bpf+0xa46/0xdb0
     [<000003ffe038ad0c>] __s390x_sys_bpf+0x44/0x50
     [<000003ffe0defea8>] __do_syscall+0x150/0x280
     [<000003ffe0e01d5c>] system_call+0x74/0x98

Fixes: 054623105728 ("s390/bpf: Add s390x eBPF JIT compiler backend")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/r/20250512122717.54878-1-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index cd0cbdafedbd2..03742d7cb61ac 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -543,17 +543,15 @@ static void bpf_jit_prologue(struct bpf_jit *jit, u32 stack_depth)
 	}
 	/* Setup stack and backchain */
 	if (is_first_pass(jit) || (jit->seen & SEEN_STACK)) {
-		if (is_first_pass(jit) || (jit->seen & SEEN_FUNC))
-			/* lgr %w1,%r15 (backchain) */
-			EMIT4(0xb9040000, REG_W1, REG_15);
+		/* lgr %w1,%r15 (backchain) */
+		EMIT4(0xb9040000, REG_W1, REG_15);
 		/* la %bfp,STK_160_UNUSED(%r15) (BPF frame pointer) */
 		EMIT4_DISP(0x41000000, BPF_REG_FP, REG_15, STK_160_UNUSED);
 		/* aghi %r15,-STK_OFF */
 		EMIT4_IMM(0xa70b0000, REG_15, -(STK_OFF + stack_depth));
-		if (is_first_pass(jit) || (jit->seen & SEEN_FUNC))
-			/* stg %w1,152(%r15) (backchain) */
-			EMIT6_DISP_LH(0xe3000000, 0x0024, REG_W1, REG_0,
-				      REG_15, 152);
+		/* stg %w1,152(%r15) (backchain) */
+		EMIT6_DISP_LH(0xe3000000, 0x0024, REG_W1, REG_0,
+			      REG_15, 152);
 	}
 }
 
-- 
2.39.5



