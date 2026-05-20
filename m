Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A841B3EAC82;
	Wed, 20 May 2026 18:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302373; cv=none; b=YipJd6qefXjQM6sBJl0PvTL9Y2rK8Wv7hedsH/izNEg9o/9Y90eZiMsH+5u+q/32Kf6AIPug/r9NdNw0MrXJ/BdsGY0pifCqO2fSdS1WZfIqb9wl4lmXaLPpgY/+e8o4dO5TPKhkMk70bOlH2VZNmN0Gr2M3RzCn8D+UNkzLjWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302373; c=relaxed/simple;
	bh=vVI0a8LGCq97SCtgGMJp8AwrRe6dJRE+n/HxexKubt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/QA0HQARhW8c2bCBKw7EtXGjXofJnopdUwYcuuv2WbspfJ8q1erDnVf9WFDK8uRl8w1n8SfrRk6oY5TGHqH6oyI7zkzj+KqzN7ZdHu9yE7RCIYcpL3NffZWzBlsIuvQS3KwQEbhKSdoU+kDMapDYzEzFOP+uhD1xokkBWCN7r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITkHX5A6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITkHX5A6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3BB1F00893;
	Wed, 20 May 2026 18:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302372;
	bh=Gf6c+pT0ImdzD+F+cvJBM63XnmEodfmi2VN6wJoPpn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITkHX5A6p9+LuvbKns1Mb0c9WNb0dYOxBoY+X1mXjalPdZ7GbuinPr3fNpREdofHh
	 I1cF6nG/fbH6WjHosohoiU+YpKfXbU500muCetb5sJx4TkqO8oZXzENEp3vI096jWU
	 IiXXdU7AnbFjbbdUt2R6TxbNs6yhCnztEwif11yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hiker Cl <clhiker365@gmail.com>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/508] bpf: Fix NULL deref in map_kptr_match_type for scalar regs
Date: Wed, 20 May 2026 18:21:04 +0200
Message-ID: <20260520162103.871394698@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 4d0a375887ab4d49e4da1ff10f9606cab8f7c3ad ]

Commit ab6c637ad027 ("bpf: Fix a bpf_kptr_xchg() issue with local
kptr") refactored map_kptr_match_type() to branch on btf_is_kernel()
before checking base_type(). A scalar register stored into a kptr
slot has no btf, so the btf_is_kernel(reg->btf) call dereferences
NULL.

Move the base_type() != PTR_TO_BTF_ID guard before any reg->btf
access.

Fixes: ab6c637ad027 ("bpf: Fix a bpf_kptr_xchg() issue with local kptr")
Reported-by: Hiker Cl <clhiker365@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221372
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260416-kptr_crash-v1-1-5589356584b4@meta.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b7fd3995538bf..0d90236d0ad94 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5336,6 +5336,9 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 	int perm_flags;
 	const char *reg_name = "";
 
+	if (base_type(reg->type) != PTR_TO_BTF_ID)
+		goto bad_type;
+
 	if (btf_is_kernel(reg->btf)) {
 		perm_flags = PTR_MAYBE_NULL | PTR_TRUSTED | MEM_RCU;
 
@@ -5346,7 +5349,7 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 		perm_flags = PTR_MAYBE_NULL | MEM_ALLOC;
 	}
 
-	if (base_type(reg->type) != PTR_TO_BTF_ID || (type_flag(reg->type) & ~perm_flags))
+	if (type_flag(reg->type) & ~perm_flags)
 		goto bad_type;
 
 	/* We need to verify reg->type and reg->btf, before accessing reg->btf */
-- 
2.53.0



