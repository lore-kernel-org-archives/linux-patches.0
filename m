Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49764D487C;
	Thu, 17 Sep 2026 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670421; cv=none; b=qbb03nILw4a1LM4OzJy4A3gRUgRVQS9iG59FIm0MC+aMav0+7yqS1eoCvN22MmXmGw7uY+QCqxQQjTVldtESrqF2h0x1eHL4ov8vI65EjAck7mSm+ER6qgbULG/eGg9hLR+bayo90xiFgNMc3bBoHWkAdhHYQ3m/R5Uje0B4Oys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670421; c=relaxed/simple;
	bh=Zq/QYRNEUij2/ItEzmDMtr3rOG2Gzlh3Nw0J5E5x4hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwhiAE16vmJyGa7rCBqQ0pLi2LLjmqYcpAcSwg2tQtQqba0/ViTFSStwDEwDGXXWEQ7eOfgKsDo59oU8qiZmlpbHQLyz4/PjePE/SXrL178fzpxZlb+fDeMezKjKHTY70cUzUBSAd7/YG8VaBZkvvq0DtkFCL+zc5wwrP6cqCig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fh9QOFfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fh9QOFfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4381F000FF;
	Thu, 17 Sep 2026 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670419;
	bh=+RxTT1oTsc9/fYPa2Fh3g/wT/cLwl50zgv/lKJaAeEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fh9QOFfDimZLcl7ANpdVdnXVjJjQsId/SDRMWbO1vq2i151LD32z+T5wa2db86dF8
	 Va3BJgbU82NQjVHMqZAJArjXfwgWhye7QdJvcx1cLD1rNC4rTepy3FHX2kJ9r1fmdh
	 3Isx2ohHwfx3ygXdhcaNxzAd//Gz0EqwGH2Fnnzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0656/1102] bpf: Dont predict JMP32 pointer vs zero comparisons
Date: Thu, 17 Sep 2026 16:09:59 +0100
Message-ID: <20260917151556.645822798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit e51179a4e09846f8fd0f26a05068520de2b301bf ]

Consider the following program:

        r1 = map_value;      /* low 32 bits are zero at runtime */
        r6 = 0xdead000000000000;
        if w1 != 0 goto l1;
    l0: r1 += r6;
        r2 = *(u64 *)(r1 + 0);
        exit;
    l1: r6 = 0;
        goto l0;

At the moment is_branch_taken() reports the jump as always taken,
because it does not distinguish between BPF_JMP and BPF_JMP32
comparisons when processing 'if w1 != 0 ...'.

Fixes: cac616db39c2 ("bpf: Verifier track null pointer branch_taken with JNE and JEQ")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260904083325.2083493-5-eddyz87@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 97742b0f3f8c6..0177fb8ea6ee2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15109,6 +15109,13 @@ static int is_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_state *reg
 	if (__is_pointer_value(false, reg1) || __is_pointer_value(false, reg2)) {
 		u64 val;
 
+		/*
+		 * The low 32 bits of a valid pointer may well be zero, hence
+		 * nothing below applies to a 32-bit comparison.
+		 */
+		if (is_jmp32)
+			return -1;
+
 		/* arrange that reg2 is a scalar, and reg1 is a pointer */
 		if (!is_reg_const(reg2, is_jmp32)) {
 			opcode = flip_opcode(opcode);
-- 
2.53.0



