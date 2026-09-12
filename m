Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EB73491C9;
	Sat, 12 Sep 2026 18:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238520; cv=none; b=hQ+bsXUb7h/EtOHQgtXGkqVA2gXkb7b8qjXef71uVAaq9iUtisKeujC7NS5JlnFXABmfipg2lDPAGxPJi3fGtaxyCsmBG33GntpU0CntexUYoGs2crfM4Q5RjJs6qlknbufKkpldXrI5Ce9Ad3yRFG84Q/zlbyFqIKUy/hgDoSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238520; c=relaxed/simple;
	bh=wtBbPIUM1nqmB1cWCxREzx5f5psDDE2cundEa/NzLIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olM75kSLrmvdujiHWh2ecZG5TuA3jBy1Oo6srZ8Gm5GmdAoCOKaQuo+lk5x2QiUYs3zTrgV/VUvoue0ZDR/5JZqAlqVA1mqWRo/cLHuYQhBlimO3TkKXgoIju/bVDcAJ+f7XTwSUmQUvWG/7jBAbtt2bNvNIoSSqdonunOetmCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujnNDJNN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujnNDJNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244A71F000FF;
	Sat, 12 Sep 2026 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238518;
	bh=u1iMaUUEb9cZWLD1dvOTEXzsiiLRJ1CJBi4J0cr7jtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujnNDJNN7m4eNhQHxQOzq191mVH4qZ40a31IHodeIxiNyLHJAtgNzqsVw0Io2PrG8
	 Duo18U4NSki0r2q5mNFKFkgT664B1+b3lje9MQ/s9GEUFaV691LxfDRAERs8JCAOc4
	 g7tcIktimoBhxdg00eO0/COTSMcX0YXa7MyYBtd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/935] bpf: Fix vmlinux BTF prep race in bpf_get_btf_vmlinux
Date: Sat, 12 Sep 2026 08:58:27 +0200
Message-ID: <20260912065537.765734042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

[ Upstream commit 92863e678070f57c17c868e4bfa2441a5c61ad2b ]

bpf_get_btf_vmlinux() lazily parses the vmlinux BTF under the
bpf_verifier_lock, but publishes the result through a plain store
and re-checks it through a plain lockless load. Nothing orders
the stores initializing the struct btf inside btf_parse_vmlinux()
against the store publishing the pointer: On a weakly ordered
arch, a concurrent first-time caller taking the lockless fast
path could in principle observe the pointer before the parsed
contents are visible. The mutex_unlock() does not help such a
reader given it only synchronizes with a later acquisition of the
same lock. Thus, publish the pointer with smp_store_release()
and read it on the fast path with smp_load_acquire().

Acquire semantics are needed rather than a dependency-ordered
READ_ONCE(): btf_parse_vmlinux() also populates globals outside
the returned object (e.g. bpf_ctx_convert.t). An address
dependency would only order accesses performed through the
pointer and not cover other globals.

Fixes: 8580ac9404f6 ("bpf: Process in-kernel BTF")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260708211537.371874-2-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8950f949377a3..4e2d49b0d1f1c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14040,13 +14040,25 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 
 struct btf *bpf_get_btf_vmlinux(void)
 {
-	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
+	/* Pairs with the smp_store_release() on the parse path below. */
+	struct btf *btf = smp_load_acquire(&btf_vmlinux);
+
+	if (!btf && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
 		mutex_lock(&bpf_verifier_lock);
-		if (!btf_vmlinux)
-			btf_vmlinux = btf_parse_vmlinux();
+		btf = btf_vmlinux;
+		if (!btf) {
+			btf = btf_parse_vmlinux();
+			/*
+			 * Order the parsed BTF contents and the globals the
+			 * parse populated (e.g. bpf_ctx_convert.t) before
+			 * the pointer publication. Pairs with the acquire
+			 * on the lockless fast path above.
+			 */
+			smp_store_release(&btf_vmlinux, btf);
+		}
 		mutex_unlock(&bpf_verifier_lock);
 	}
-	return btf_vmlinux;
+	return btf;
 }
 
 int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
-- 
2.53.0



