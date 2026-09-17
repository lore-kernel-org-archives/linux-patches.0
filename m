Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D1F4EB86B;
	Thu, 17 Sep 2026 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659444; cv=none; b=WG9PoGd5nXhbbedc/b8n33N79WDo8yfJrKu3VMi4S2nNybthl26Bpm4NF6fCqpqOODW9gxJ+xZJiVxwErrQ4C3YJtjCVT3Qd8G0xyj0pnGbA92Fjdlp3fj9dcbhFpaOg24NbkNtjSipEOpHKZCflmgLFJ8Yge4u7mwTar8Sg4xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659444; c=relaxed/simple;
	bh=HZsMfE7tDsFJMZbMBaL3St2A4osJGOqKDKDb2NvLUKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UG2iNHXSwXckdKUH77iFpECYFrDA1SG3702dZTFilizyZOT55wIZ6uj5OERi8b4fExQGIENaZdbJrIO8UqkX4B7i4fit6V39P4n8eqIUsHd7xcrRLnDXSOc6+dull3jApaZiH7aUapIiC8dOU3qGwk6o6RGDIFl07i31/NXhs1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRIq9rKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRIq9rKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4728C1F00893;
	Thu, 17 Sep 2026 15:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659433;
	bh=bOxd8n1QtNFIL9ABV42Szl6hqhCA5B2DUuwkrM8Z4fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRIq9rKykFyyKwIFu+NAX6/IQK7bCMmqH+bFyezAlX5WnzF73TXgsl12Dio8DIzDu
	 uSvxNbblhNF6GBjPUNA1DpxXnPsc8NiOWoFKelsLiNlSohb3b3YPlKsAjXA1491xZn
	 qJjOGExw4gIiZy6BwR2CTeTkpeiZy2nt5kJ1uWKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 256/733] bpf: Dont predict JMP32 pointer vs zero comparisons
Date: Thu, 17 Sep 2026 16:09:24 +0100
Message-ID: <20260917151357.682030742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2c1da0d38450c..d68f54a53c644 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15576,6 +15576,13 @@ static int is_branch_taken(struct bpf_verifier_env *env, struct bpf_reg_state *r
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



