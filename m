Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905F54E3231;
	Thu, 17 Sep 2026 17:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667746; cv=none; b=pW34eQyHufUSay7GZXps6AFkILythd0ww8VnqBHlYeIhEDA1/0JHEiVAlDrG4OWxJBPT+xQPFW5FykUv4x+AGaa4ghNnu+lKkxtOXVLcrcdpNzf0TDjuUJ+64L1dX7oJjO25/Hnle1vDtuxJrzydCnz0gW8e9U170JXlPAU5p3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667746; c=relaxed/simple;
	bh=sgX/kdDcBiSc3nXx6UKTHCuFdxFFOkkgE6NDShiwmAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsuPl7DrOheathivaDdGXFwI7HR4ZjXqOKrtHLqXI/lgOlVR+CdScNerpwIdtZU52nW64ct40ffnhhzrb9nODz0h00EGnu86xcXQlA2CSgzKgkwokAZPp4kRuC24d8lqxcrjAKU4aXB/f1xrdsgZI2Ni6fUqsiD4abhzTM4eIzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbJgpv/J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbJgpv/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76921F000FF;
	Thu, 17 Sep 2026 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667745;
	bh=3Bw6bY8T86GBkDgnMY55n69tY6q4HFMMoiEgL1uby+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbJgpv/J/pXc1JfBgP0Wqdw+P0MQPyOw+LZi9dJtrj/+OZIhnX1VUr2FtEtjRbImn
	 Wnyirlbu/IFc1O1mP4YYCJ+iIQK9pCCiJRkJayU+0OaYGsYfjSEIhmsbtTLqCErSfk
	 wFLLpPUyeN+EZpw1Tgp/cI/jCQ7hxmzi2Jf3hPlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0195/1102] libbpf: Also reset {insn,data}_cur on realloc failure
Date: Thu, 17 Sep 2026 16:02:18 +0100
Message-ID: <20260917151544.464429882@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d2f7bd066ed492aeaf82864fbf1f06770f9d9f9d ]

realloc_insn_buf() as well as realloc_data_buf() free and NULL
gen->insn_start / gen->data_start on -ENOMEM but leave gen->insn_cur /
gen->data_cur pointing into the old, freed buffer. Just reset the
cursors to NULL alongside the base pointers so the freed state is
coherent.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260529094119.307264-3-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index cf3323fd47b88..a3fd073b16c8b 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -63,6 +63,7 @@ static int realloc_insn_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->insn_start);
 		gen->insn_start = NULL;
+		gen->insn_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->insn_start = insn_start;
@@ -86,6 +87,7 @@ static int realloc_data_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->data_start);
 		gen->data_start = NULL;
+		gen->data_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->data_start = data_start;
-- 
2.53.0



