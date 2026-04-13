Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535282D5A19;
	Mon, 13 Apr 2026 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098259; cv=none; b=mcEOwLyRC7K4FRoosCQLIqnX1uw+ZTQhFgex94DCE0r91DXpBesQA8jKWLLRohNUm63zYRH+h/+L9zE1lLmtAuEPrrwqvuPdZYbJEoX2N6EhMf3yKPPc2IpA2bWdrKnFFGB5GU3OzVRkbTLX2eELnAdeKCf7rEWGX4n7cqLEEU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098259; c=relaxed/simple;
	bh=pIgoliJQYo58L41uhBdYUMp0JeapLI9QEei3sTTrzKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9le+6T5zKaKm41kKNx1jR6nMosR3U/m6Ih8XWE349a4P0CQD+leZ0rFTRXHG8x/gvY9zeZzmPDyeoLmKKtidd9zrPX1p4+ET1SdZVgtDGTF0Qc63pzfmMBukwqRexkXm2ELO03tqpXTr0iPjZQBD8NnWPwNCRD0eEXBdybVDZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1U4VDXwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1U4VDXwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC75CC2BCAF;
	Mon, 13 Apr 2026 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098259;
	bh=pIgoliJQYo58L41uhBdYUMp0JeapLI9QEei3sTTrzKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1U4VDXwzlVd6vQtGcm4SH1mTLjFeeoewnZ4SWUOF551LsAo+5lu7f0jROrzetOXI9
	 ZuAONcRQE0zoOlPJ5qdIPH7bQ6vuk+pr4s+07v6dKxPY2+oJAWkI7ytz0LulhBNTDV
	 DSiqX/67PYie8f6IHEz6o7mtUqrB4Yw3SFstmtlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 438/570] bpf: reject direct access to nullable PTR_TO_BUF pointers
Date: Mon, 13 Apr 2026 17:59:29 +0200
Message-ID: <20260413155846.882998353@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Qi Tang <tpluszz77@gmail.com>

[ Upstream commit b0db1accbc7395657c2b79db59fa9fae0d6656f3 ]

check_mem_access() matches PTR_TO_BUF via base_type() which strips
PTR_MAYBE_NULL, allowing direct dereference without a null check.

Map iterator ctx->key and ctx->value are PTR_TO_BUF | PTR_MAYBE_NULL.
On stop callbacks these are NULL, causing a kernel NULL dereference.

Add a type_may_be_null() guard to the PTR_TO_BUF branch, matching the
existing PTR_TO_BTF_ID pattern.

Fixes: 20b2aff4bc15 ("bpf: Introduce MEM_RDONLY flag")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260402092923.38357-2-tpluszz77@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 13eede4c43d48..e2d49eab8c3d5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4572,7 +4572,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 	} else if (reg->type == CONST_PTR_TO_MAP) {
 		err = check_ptr_to_map_access(env, regs, regno, off, size, t,
 					      value_regno);
-	} else if (base_type(reg->type) == PTR_TO_BUF) {
+	} else if (base_type(reg->type) == PTR_TO_BUF &&
+		   !type_may_be_null(reg->type)) {
 		bool rdonly_mem = type_is_rdonly_mem(reg->type);
 		const char *buf_info;
 		u32 *max_access;
-- 
2.53.0



