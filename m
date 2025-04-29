Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D105A1DF73C;
	Tue, 29 Apr 2025 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946723; cv=none; b=BeFgsPrjsyEgdpNGh4LZx8RxpEZcN4dPbFbkr9WF/ULlkARfXNHI4HaLA1+YVrsm2hfAdgFZlHEKoKpi3Edp9rqKKA/LaIcyAsgJWV91va4La7TAO3m5UF8nHUTPWT9Ly4oQRR8n3RgMYJcuGWpY+heYWPEb0GrZr0M0CLFvSAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946723; c=relaxed/simple;
	bh=jdKuOthgf/kigo3KqPxq8ZIkYhv079YoqYzwcRfmJVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFbvqVXebTd7MLVd5GGK77faBm4CeminIioj2YbB5lTTOi0U3DBL9Gn0btKR1L66pS3vkOPVmTwqwMAVYQitLojFNpPRcltmpfOoLVsTV6xb0vznVAALSq+aCSVwPUumS1CBnoNJdxrcfyHniub/BQwN1DUbxYVZKDULqUoUGHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6larwkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6larwkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62865C4CEE3;
	Tue, 29 Apr 2025 17:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946723;
	bh=jdKuOthgf/kigo3KqPxq8ZIkYhv079YoqYzwcRfmJVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6larwkpBme3ZefRvCBVuuu8y7IRZbcytoqrdLLcW/qg8Qay3hJMUzSKZug00LfAs
	 8Tg74FEbUGgj3i9voxAnudbDQGWPIUxR6ydQjQBBgO00JuJamMdKWh7YwJTimrzBIb
	 7efrjlYvYgXvWM/XwZj7Ziq6xaFsIIM7BXRMYJE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@sifive.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/286] bpf: Add endian modifiers to fix endian warnings
Date: Tue, 29 Apr 2025 18:39:13 +0200
Message-ID: <20250429161109.874358885@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@sifive.com>

[ Upstream commit 96a233e600df351bcb06e3c20efe048855552926 ]

A couple of the syscalls which load values (bpf_skb_load_helper_16() and
bpf_skb_load_helper_32()) are using u16/u32 types which are triggering
warnings as they are then converted from big-endian to CPU-endian. Fix
these by making the types __be instead.

Fixes the following sparse warnings:

  net/core/filter.c:246:32: warning: cast to restricted __be16
  net/core/filter.c:246:32: warning: cast to restricted __be16
  net/core/filter.c:246:32: warning: cast to restricted __be16
  net/core/filter.c:246:32: warning: cast to restricted __be16
  net/core/filter.c:273:32: warning: cast to restricted __be32
  net/core/filter.c:273:32: warning: cast to restricted __be32
  net/core/filter.c:273:32: warning: cast to restricted __be32
  net/core/filter.c:273:32: warning: cast to restricted __be32
  net/core/filter.c:273:32: warning: cast to restricted __be32
  net/core/filter.c:273:32: warning: cast to restricted __be32

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220714105101.297304-1-ben.dooks@sifive.com
Stable-dep-of: d4bac0288a2b ("bpf: support SKF_NET_OFF and SKF_LL_OFF on skb frags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d9f4d98acc45b..07fa811917380 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -238,7 +238,7 @@ BPF_CALL_2(bpf_skb_load_helper_8_no_cache, const struct sk_buff *, skb,
 BPF_CALL_4(bpf_skb_load_helper_16, const struct sk_buff *, skb, const void *,
 	   data, int, headlen, int, offset)
 {
-	u16 tmp, *ptr;
+	__be16 tmp, *ptr;
 	const int len = sizeof(tmp);
 
 	if (offset >= 0) {
@@ -265,7 +265,7 @@ BPF_CALL_2(bpf_skb_load_helper_16_no_cache, const struct sk_buff *, skb,
 BPF_CALL_4(bpf_skb_load_helper_32, const struct sk_buff *, skb, const void *,
 	   data, int, headlen, int, offset)
 {
-	u32 tmp, *ptr;
+	__be32 tmp, *ptr;
 	const int len = sizeof(tmp);
 
 	if (likely(offset >= 0)) {
-- 
2.39.5



