Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DAB4D7D5B;
	Wed, 30 Sep 2026 16:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784364; cv=none; b=eRySZ6xRajaGR6kZ2G13NBKVetud4ilFvQSdDjDD2zsLS00lG1ai9+GhuavhbvYZc7QiAgbEeYTtTsQA56LuklxNrgZpIQ/uLIW8pCycRexeSYjQaxdqb340T3LVgZxfaa915a45RRtl/rbzX+mTG68eCXgstfVhI3tSFwzqlsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784364; c=relaxed/simple;
	bh=SjIlMmDwpK9QMKHyGmmFUECdRiV1sx/TdHywktR0OxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB6glrhGF7eciVoBGfjP2ew9/sSVv1Ror5ZnjD9+qxvngWxvXHdBqyfqELxZo1Jk/3sNZXFTFHh0XEH1CN+1irKOYyMtbtgEqsghAO5UXQdqjKngxXAI20pdS7iLoIDEM3vrtfNaQJ4NusdKij4YqWhOCFc9Z5GtbD9zIEfqGR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0XxM1F9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0XxM1F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1582C1F00898;
	Wed, 30 Sep 2026 16:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784360;
	bh=l3OayBBUq+QP+Yk9HsEAEvfZK9eRmg+BRd5vSQav04A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0XxM1F9rNdqN9+aDl2SPntDc5610LW65PvQULj3TjtaFjaUCewnHrTpXnYhzhfL7
	 psiDPY92hQMrazwo3zCMj2rYi+j2bdb8el/SASEppJz5/ibhFEHlvf5OlxFAlsQx/b
	 +QYSmxD4u4jDobl+69DNRkCuC673iJSny6j4EayA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/982] libbpf: Also reset {insn,data}_cur on realloc failure
Date: Wed, 30 Sep 2026 17:14:25 +0200
Message-ID: <20260930152419.584618991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b74c82bb831e6..13fac40d5fd92 100644
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



