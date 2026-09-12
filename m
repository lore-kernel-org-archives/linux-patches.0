Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4378C3F12E0;
	Sat, 12 Sep 2026 07:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198150; cv=none; b=uFRKL22/Skl96k6eqPkekD/Y909BG/JdsgXwilMmNmjGnfqOukSPi2epMbkj/SNfCbJkdWnV34zrj4WzE7N6BrpZcg+1DStLNczLzvs2fiqQVd/AP+vx8BUD2D2Zn04uw16jtasUgqE9v2C3SEGD+vBFtLcWgDA3g1mTL6UBSK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198150; c=relaxed/simple;
	bh=xuojB/s6lepZwG8zC0uPiEREWRtwndFG/Dwo/G+yu8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsSyh4SjJCSgDdLNmR6fIDm2y0sNKYB/uYKvvCwirUH/fL6n5iDAMiQWun+yu3Jnpnd3pDq6bPm872aZmOlO6+/OK9KJ2vsUxoc33le9Z3OMo5FdvK1BiVbHNhKnHMoiTA4Vmtq2UDP+HVVAlTLNiTbhibBwrk8o1dtQ6s7Hfnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhjqcLK1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhjqcLK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B951F000FF;
	Sat, 12 Sep 2026 07:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198149;
	bh=LJuFms/Sam9qehwGmdYEplGIvQMZNIRADdPxmatQ0xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhjqcLK13TH5OgNWhhp35drETf9D7LMIuf2wFJdV55ovJGs2CNvf/DIykSDPxyweF
	 Yz8nE90/YD2Y/Cedq0Iwuhb6dZvdTPhBcgnQY/kpw5TLjbIeHM7KB79itNg82nERwc
	 ZMMe/uKS1BuH7pgtmjz41vEauqxQA8/BC8fI5JTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0279/1815] bpf: Fix vmlinux BTF prep race in bpf_get_btf_vmlinux
Date: Sat, 12 Sep 2026 08:33:49 +0200
Message-ID: <20260912065655.513605189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 6f78dd4043e54..1f3df9104552e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19490,13 +19490,25 @@ int bpf_check_attach_btf_id_multi(struct btf *btf, struct bpf_prog *prog, u32 bt
 
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
 
 /*
-- 
2.53.0



