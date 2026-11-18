Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019500;
	b=1lMuezvQAZcuOdePioAwbTrnI1dufZKYGcSWzTmAG5q+mxMXbLZO2foliBy/myrVQo3f
	 eOZ5tYa+BkaVcNtag1H3JQnbQ4BMxFhZo44CKcADvk0FkJOH1ndrIVM2E6/cyG7mjrxt7
	 KmmZMq4bNYfc/xxGgFJ08OxHFHzBVvtHRTSmN5+bb6TFWEnXA32ohnlx2SdBOM3eCyR5d
	 Fjzmtw93C5YgVhIZZYUqQG+ZJcEIgO9S7S3jU/xthwy/xwZR/es6UaCayPEycy0U4gEso
	 uPtZPEATfDGXK6/Qcs9lw+LIQ4B+gRycQE59j7pjz9KudSdNrCwbPIgvifEEyQJxOeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h6kPG60iPBwEIeM4qyZA0VZ7x7XGxa8RCXxpzfobeSQ=;
	b=CWQmaHB3XFusFQ+OwYHGqvoNsmTjx4lXvEqFx6ze8F60KeSr4fKvrRNqE2f9eyYJVo1X
	 s5HTO3GKi59sxQXPs8NxBW7WlQZXGOSQE3Gm+llxrIyvsYA5MFpfObI1LaszcGFCbHYxY
	 Bw6nNwds5mXJ0PhXqkvu+ZfrrGCAmBblp8gowtErLA8xsswrVGUt41H8dNxxwZLolRZJJ
	 xpkoPaYa42ngP1uuwfrkitCd0ADfohQPRIkjibOKnZ3u5WLfSdFmyjPKR3KfN/cWapR/4
	 eBieZdTrIe8j5emv/LusUIBYmsLSH/gezyh8iRS5ZJ1v9PeV88neoebt2nw0k/sO8pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S564jCGb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5487D606A7DE;
	Wed, 18 Nov 2026 16:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S564jCGb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EE61F0092B;
	Wed, 18 Nov 2026 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019500;
	bh=h6kPG60iPBwEIeM4qyZA0VZ7x7XGxa8RCXxpzfobeSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S564jCGbR+8PLsb/UKovvbjz3ERgXxv7EOduuMB/250UD4g6j9hdmv16BJbmrNDbC
	 Mp3px3kCz4TOc3/gdc6tah3QkA9DtTFQUEE5taFNtLt14vahj3Mqi9UaYzyrbPdBCe
	 qgDGO2mSFj9UolDC61ABYm9f+PveWtAQkB+lriwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1576/2651] bpf: Widen the stack slot index in the jump history
Date: Wed, 18 Nov 2026 15:46:56 +0100
Message-ID: <20261118150344.662122862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit a9082d8a54c6b68ea4bc3417eda5b22138ac06c0 ]

Jump history entries record the stack slot touched by a spill or fill in
a 6-bit field, which only fits the 64 slots of a 512-byte frame and is
pinned to that size by a static_assert on MAX_BPF_STACK. Move the flags
into the first word and give the slot index 12 bits of the second word
instead, so the entry stays 16 bytes while frames of up to 32 KiB can
be recorded.

Introduce MAX_BPF_STACK_SLOTS for the number of 8-byte slots a frame can
have and use it for the static_assert and for BPF_ID_MAP_SIZE, so the
verifier expresses per-frame capacity through one constant.

No functional change.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260924165740.2146806-3-memxor@gmail.com
Stable-dep-of: 13cffb883180 ("bpf: Fix arg_track_xfer() for atomic stack spills and fills")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index d7a297527f49b..1dfad3c3646f5 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -243,6 +243,14 @@ enum bpf_stack_slot_type {
 
 #define BPF_REG_SIZE 8	/* size of eBPF register in bytes */
 
+/*
+ * Largest number of BPF_REG_SIZE stack slots a single frame can have. A frame
+ * may use any part of the MAX_BPF_STACK budget; check_max_stack_depth()
+ * enforces the bound on the combined depth of frames sharing the kernel stack
+ * and on each frame using a private stack.
+ */
+#define MAX_BPF_STACK_SLOTS	(MAX_BPF_STACK / BPF_REG_SIZE)
+
 /* 4-byte stack slot granularity for liveness analysis */
 #define BPF_HALF_REG_SIZE	4
 #define STACK_SLOT_SZ		4
@@ -425,12 +433,11 @@ struct bpf_jmp_history_entry {
 	/* insn idx can't be bigger than 1 million */
 	u32 idx : 20;
 	u32 frame : 4;	/* stack access frame number */
-	u32 spi : 6;	/* stack slot index (0..63) */
-	u32 : 2;
-	u32 prev_idx : 20;
 	/* special INSN_F_xxx flags */
 	u32 flags : 4;
-	u32 : 8;
+	u32 : 4;
+	u32 prev_idx : 20;
+	u32 spi : 12;	/* stack slot index */
 	/*
 	 * additional registers that need precision tracking when this
 	 * jump is backtracked, vector of five 11-bit records
@@ -439,12 +446,12 @@ struct bpf_jmp_history_entry {
 };
 
 static_assert(MAX_CALL_FRAMES <= (1 << 4));
-static_assert(MAX_BPF_STACK / 8 <= (1 << 6));
+static_assert(MAX_BPF_STACK_SLOTS <= (1 << 12));
 
 /* Maximum number of bpf_reg_state objects that can exist at once */
 #define MAX_STACK_ARG_SLOTS (MAX_BPF_FUNC_ARGS - MAX_BPF_FUNC_REG_ARGS)
-#define BPF_ID_MAP_SIZE ((MAX_BPF_REG + MAX_BPF_STACK / BPF_REG_SIZE + \
-			  MAX_STACK_ARG_SLOTS) * MAX_CALL_FRAMES)
+#define BPF_ID_MAP_SIZE ((MAX_BPF_REG + MAX_BPF_STACK_SLOTS + MAX_STACK_ARG_SLOTS) * \
+			 MAX_CALL_FRAMES)
 struct bpf_verifier_state {
 	/* call stack tracking */
 	struct bpf_func_state *frame[MAX_CALL_FRAMES];
-- 
2.53.0



