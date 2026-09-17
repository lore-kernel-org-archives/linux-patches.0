Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681F24ED190;
	Thu, 17 Sep 2026 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665787; cv=none; b=qMjthy+T1UpOSwA0We171CekXeLrdvuU7Kaf92RZc2fNkFjCFqJI30gcCebO0jSGGusx/j1YJlOImFomexWaN4RYscadq8nDOJ622ZIa3vUh91MYq1ftJI2BZJvCAMaGE0VCxqVdStFWjRTg/Tvv+UFXO9vSIp/66AvGSmWxiFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665787; c=relaxed/simple;
	bh=qjMMpbcOKuWOLzN8Wuzy4rcY8cWDi12H1uAgaWIo69k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szWk6wpXDMdA92HCHOG+q9tMM9uaLvuTSlZFkcF9BtTH/qhPp0sxuLhxCA0/M8vAWQzKFqczNd5Fwy8HlA4bR6rTSNusNwhzMG1q223Ww45+LBPaK3BvP7sSY5NtMr+4C1mHu2CfpKbhEhYJz3FgiOBh05Mt1D1KRKJYtHf1tTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8opjOIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8opjOIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3781F000FF;
	Thu, 17 Sep 2026 17:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665786;
	bh=4aDHldY11++kcoYefGzG/1q8CG+egmXOGIh8K84cA/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8opjOICQGns1yw3wXaKc73SgQskxzPwpDvlZv6Dekxn5venJkIAbUxKG/wcjS/1u
	 bd6ifHRihlCaCgUo+pIGXjcMfNsRPG23OJU+QuAC0Lv0lZY566unyzHflLY04R2Pcs
	 pwa9tnwwi2tiGw41V1Iq9kAMw1oaDEy8UhH72VoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0781/1250] bpf: Dont predict JMP32 pointer vs zero comparisons
Date: Thu, 17 Sep 2026 16:09:36 +0100
Message-ID: <20260917151613.060143925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 46ab5178985a5..e0ec0f47febeb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16572,6 +16572,13 @@ static int is_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_state *reg
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



