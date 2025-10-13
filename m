Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D1E30C61F;
	Mon, 13 Oct 2025 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368202; cv=none; b=MdYW4Mzy/SCM+jbsWEJTs9byzhlS0yj5f5UJUx9ndBXtH0VFftejzI8Dk6+2bG5UFKuxP+YJOLYR4cAPCopj1Bi1qRiNA+Xgd1lsOlG3syQH+0jTw3RLvgirTiyOs/7z6o0QN1ZAk+Ky0Ou8Qqh5bu4OYHZ7SOsVuxRSM/p7MgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368202; c=relaxed/simple;
	bh=LCB3Jnjtzu/j2U+0Aofnveqtskv/L7xl0Qq91BOSmds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXwoC08qi7O6ZrR/9YdKpaK0rsXoDMoNBWhKIypyxBGz9n5wDuhGBcbVxHtZrFfdQjEHF6UzqnCdfKJy+C1k0K9PAZuuJ3o7hfqeiU4wpwfiCZv1VkIIwNK+GTP3ekcxMJnXmQhMNezX5GyzAcKWq0WLsrM4GkmxPY1VpgWqjqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFYwlF+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFYwlF+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6539AC4CEE7;
	Mon, 13 Oct 2025 15:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368202;
	bh=LCB3Jnjtzu/j2U+0Aofnveqtskv/L7xl0Qq91BOSmds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFYwlF+Vx+/nfB/L5/ohqURq5OzejKmpqJedEqfYu1HnlY6e3E+MjJcQbQY+kn0ma
	 E4fXuwt8I8lfIEk8bWYnNRPI3mFDzN/d3VbuGIp6I2Bx9YMFUW3/W0KFPxDN+8lOlG
	 12c0z09L1V5/fpnjwkp9thNSCjnOEPj5+8yDJHvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Vernet <void@manifault.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrea Righi <arighi@nvidia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/262] bpf: Mark kfuncs as __noclone
Date: Mon, 13 Oct 2025 16:43:42 +0200
Message-ID: <20251013144329.009344933@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit d4680a11e14c7baf683cb8453d91d71d2e0b9d3e ]

Some distributions (e.g., CachyOS) support building the kernel with -O3,
but doing so may break kfuncs, resulting in their symbols not being
properly exported.

In fact, with gcc -O3, some kfuncs may be optimized away despite being
annotated as noinline. This happens because gcc can still clone the
function during IPA optimizations, e.g., by duplicating or inlining it
into callers, and then dropping the standalone symbol. This breaks BTF
ID resolution since resolve_btfids relies on the presence of a global
symbol for each kfunc.

Currently, this is not an issue for upstream, because we don't allow
building the kernel with -O3, but it may be safer to address it anyway,
to prevent potential issues in the future if compilers become more
aggressive with optimizations.

Therefore, add __noclone to __bpf_kfunc to ensure kfuncs are never
cloned and remain distinct, globally visible symbols, regardless of
the optimization level.

Fixes: 57e7c169cd6af ("bpf: Add __bpf_kfunc tag for marking kernel functions as kfuncs")
Acked-by: David Vernet <void@manifault.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Link: https://lore.kernel.org/r/20250924081426.156934-1-arighi@nvidia.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/btf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index d99178ce01d21..e473bbfe41286 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -82,7 +82,7 @@
  * as to avoid issues such as the compiler inlining or eliding either a static
  * kfunc, or a global kfunc in an LTO build.
  */
-#define __bpf_kfunc __used __retain noinline
+#define __bpf_kfunc __used __retain __noclone noinline
 
 #define __bpf_kfunc_start_defs()					       \
 	__diag_push();							       \
-- 
2.51.0



