Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A393DFC80;
	Thu, 17 Sep 2026 18:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670428; cv=none; b=aqZTLrh6YE7nuFlRzIMxcPCWncR8JkWmMn5cFkzviynZL5dBGkyKrC1SND9R0cH98pomatAmq1f4+2TeVYGKHeft+YvTmCP8yPnmen9D2Qm8Myk86YYKv7odAI1w8dIVUqiHaHlQXzZs61Nu1LaRIcKSlhKt+2XQy1qgGvuNepQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670428; c=relaxed/simple;
	bh=D7KBnziKpyEhEkw1amMxXU3ANnSKH1DUtRXs2x/uNG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7ts2tyDjLvB2DAqs3vXaJEoI5tlCg7zT2/p9D+QzF7Qj4rRzhZM4PVbpC9aBobt9JWh/eKOOYPE0KV3Zww06696ozBBIX0TjerRRNH1Ftfm2G+YbI9/NT5Pii84A5+rpgCikGHXiaMzlGIY/8TB4etmoZFH2fDM3Yi7FgXp3r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtQV/xNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtQV/xNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438D71F000FF;
	Thu, 17 Sep 2026 18:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670427;
	bh=5XdCjeBRxflodQlnr0gZ9h3lMHaMUO7flkmH0A1PmZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtQV/xNfEWnQ25foklk1AoHj6y0hCzj3gylxcqG/hDP+fyfW44Yc9kSqOoq2Xhjab
	 +Ib9uuZ1oTVrZqhnXlzYcc0imPjMR00KeHCLW6lmY1zmfgi0+9xxWj2RO29RnOCCs/
	 /c/rxKycyteGGwIIJfHzIUepSwthHk6msi+2olQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0658/1102] bpf: Require MEM_PERCPU for percpu kptr stores
Date: Thu, 17 Sep 2026 16:10:01 +0100
Message-ID: <20260917151556.702861966@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 048029ba1c793f8cabc4ad5eea765da01903f8f1 ]

map_kptr_match_type() treats perm_flags as the set of register type flags
that a kptr field permits. Adding MEM_PERCPU to that set for
BPF_KPTR_PERCPU does not require the source register to carry it, however.
The subset test consequently accepts both a plain bpf_obj_new() allocation
and a referenced kernel pointer into a __percpu_kptr map field.

Loads from the field are always marked MEM_PERCPU. Consumers then treat the
stored value as the cookie returned by bpf_percpu_obj_new(): per-CPU pointer
helpers relocate it, and map teardown selects the per-CPU free path. A plain
allocation can therefore provide an arbitrary kernel read/write, while a
kernel pointer can be relocated into an invalid address or sent through a
missing destructor.

Require the source MEM_PERCPU flag to match the destination field kind.
This preserves valid bpf_percpu_obj_new() stores and rejects both the
program-BTF and kernel-BTF variants.

Fixes: 36d8bdf75a93 ("bpf: Add alloc/xchg/direct_access support for local percpu kptr")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260904084325.52250-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0177fb8ea6ee2..d6ab9b57f0135 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5495,6 +5495,13 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 	if (type_flag(reg->type) & ~perm_flags)
 		goto bad_type;
 
+	/*
+	 * A BPF_KPTR_PERCPU field is read back as MEM_PERCPU, so the value
+	 * stored in it must carry the same flag.
+	 */
+	if ((kptr_field->type == BPF_KPTR_PERCPU) != !!(reg->type & MEM_PERCPU))
+		goto bad_type;
+
 	/* We need to verify reg->type and reg->btf, before accessing reg->btf */
 	reg_name = btf_type_name(reg->btf, reg->btf_id);
 
-- 
2.53.0



