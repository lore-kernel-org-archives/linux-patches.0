Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6914A2E3B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300957; cv=none; b=YJpZsZO/q+xDHeILk/6B6pMyBg8o1FJvx9Z9+xor19u6LrcQ3+MHjblOAJlFjI3FayGkZZJAgqub7SBZGrGfk3BxwoRqLt1/q/njeCc2Xznd3qKehI38zm94H9D/MqErazNMzakRgZRt4hvE2pBK3k02kOyUfTa/r5x1yu6fQnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300957; c=relaxed/simple;
	bh=gwtE0C/HA4WXWj1SxfDqkRuaPdlFJr5XvrMKodsPQpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5ksBiEltjiTXF+uK1NRFKonVfHUMb/Cri5zi2Z73tYe/KGTeAVyxcMJUS190PqsnY8SlQp5O1+um3ypa7grD73YOuykLc+Ya1lAly9D5vK4Y84PEa4pIT2lEEpmPld5ZgLwdZJv3EIoxcPYkx4NcoQ6hMOIRdtWEKUht/SCqzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=St/V9MnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="St/V9MnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48EFC19424;
	Sat, 28 Feb 2026 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300957;
	bh=gwtE0C/HA4WXWj1SxfDqkRuaPdlFJr5XvrMKodsPQpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=St/V9MnHrBmXegkulwm6kFTJnaeoqu5dhq1oTfyvnfjTa5/R7OTfhEJjuwoTaUUFq
	 zcf9zBIFdl5potd2+xXNbG9XJXx8+tOhrrNDwxljfV0P1+5H6pftfvjCMI3dc+5Qq2
	 lLdWA5w35L9zlDU1Z4NMsFm2RtInEX3+7DVS79djtQJAdPNqbm/cpCZ1cjiXTFglzA
	 xK1Lkmt6b/+uwUk0tO4QIWPTSR2ZWqHG/RS8n5C+UngbPP4u0O8hkIami1jWbM3pS1
	 yJuaz5jZES+RLyi5B7K0Ob+vqXkf/WRcs5ELyBVIeqlU5C7hjNATzqkMNTWYOhkc0G
	 P6QJIu9OX8gww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Viktor Malik <vmalik@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/752] bpf: crypto: Use the correct destructor kfunc type
Date: Sat, 28 Feb 2026 12:36:32 -0500
Message-ID: <20260228174750.1542406-81-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit b40a5d724f29fc2eed23ff353808a9aae616b48a ]

With CONFIG_CFI enabled, the kernel strictly enforces that indirect
function calls use a function pointer type that matches the target
function. I ran into the following type mismatch when running BPF
self-tests:

  CFI failure at bpf_obj_free_fields+0x190/0x238 (target:
    bpf_crypto_ctx_release+0x0/0x94; expected type: 0xa488ebfc)
  Internal error: Oops - CFI: 00000000f2008228 [#1]  SMP
  ...

As bpf_crypto_ctx_release() is also used in BPF programs and using
a void pointer as the argument would make the verifier unhappy, add
a simple stub function with the correct type and register it as the
destructor kfunc instead.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Tested-by: Viktor Malik <vmalik@redhat.com>
Link: https://lore.kernel.org/r/20260110082548.113748-7-samitolvanen@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/crypto.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
index 83c4d9943084b..1d024fe7248ac 100644
--- a/kernel/bpf/crypto.c
+++ b/kernel/bpf/crypto.c
@@ -261,6 +261,12 @@ __bpf_kfunc void bpf_crypto_ctx_release(struct bpf_crypto_ctx *ctx)
 		call_rcu(&ctx->rcu, crypto_free_cb);
 }
 
+__bpf_kfunc void bpf_crypto_ctx_release_dtor(void *ctx)
+{
+	bpf_crypto_ctx_release(ctx);
+}
+CFI_NOSEAL(bpf_crypto_ctx_release_dtor);
+
 static int bpf_crypto_crypt(const struct bpf_crypto_ctx *ctx,
 			    const struct bpf_dynptr_kern *src,
 			    const struct bpf_dynptr_kern *dst,
@@ -368,7 +374,7 @@ static const struct btf_kfunc_id_set crypt_kfunc_set = {
 
 BTF_ID_LIST(bpf_crypto_dtor_ids)
 BTF_ID(struct, bpf_crypto_ctx)
-BTF_ID(func, bpf_crypto_ctx_release)
+BTF_ID(func, bpf_crypto_ctx_release_dtor)
 
 static int __init crypto_kfunc_init(void)
 {
-- 
2.51.0

