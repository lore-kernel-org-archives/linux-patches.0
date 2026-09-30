Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CC93AF66E;
	Wed, 30 Sep 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790860; cv=none; b=jfCWHLzGTeQvsUi+5PegobECcRV3p5skmE5erKBkzzBIRSt2zHBY51jzA95lN1TaEf3C/DuerXfQZiOHuRBVu/0fMOMEOPSuw1w5wme+o/1kSdQa0/HjskTmAwhTmzrNZ7+n1z/ykR0bSm/nWc7ZtOCugkZ28ogiuqBk0WhfT1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790860; c=relaxed/simple;
	bh=1NfLWlmOB7GIxFYHEYfv52ddqsxKk77SftkPmN9Qoho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nET/ZojFXyGhf/PY9lTykTOO1WD/3MtzAB+rcsyqMh5FXHfUNdIkqr4DFYUOZuMiOcQFBiJUJNUDZm7Q02seFwVluYeol9MROQvOv9E733pW4FYcs8KgZXH4d3HeG8HyxUROFxwvkDI3buDBU6wCj0PhuLrhzLHJ1RKk80Rq5Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqu3C6KI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqu3C6KI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D035C1F000FF;
	Wed, 30 Sep 2026 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790858;
	bh=LWuARUNQ6RNbAHYONkmhWu55e3ApK0TVzVsRwCJo+K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qqu3C6KIABhAaURZoPNjCUyrjTQoMOM/bD3zpaqSjOpo8E96NDNIyhsUc2/hA9aRM
	 2GT7A0ZESEhrPxiALnVL2aOGibLN48P5+nygf6fAkeZrCUQTPL9aYaUicGQuIVHOE9
	 9j+iChpIO+y7SRwxIWciD4VPDDPAGy75cRwhpcqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/752] libbpf: Also reset {insn,data}_cur on realloc failure
Date: Wed, 30 Sep 2026 17:19:29 +0200
Message-ID: <20260930152400.309961080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 4435c09fe132f..aec28a0bddc11 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -55,6 +55,7 @@ static int realloc_insn_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->insn_start);
 		gen->insn_start = NULL;
+		gen->insn_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->insn_start = insn_start;
@@ -78,6 +79,7 @@ static int realloc_data_buf(struct bpf_gen *gen, __u32 size)
 		gen->error = -ENOMEM;
 		free(gen->data_start);
 		gen->data_start = NULL;
+		gen->data_cur = NULL;
 		return -ENOMEM;
 	}
 	gen->data_start = data_start;
-- 
2.53.0



