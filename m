Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FFD2135DD;
	Tue, 29 Apr 2025 17:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948733; cv=none; b=Q3gtE74384O+Jq059riUoM2trl3HknYUh4jrz9RNfzDcNn2VfNwsXTBcqoYyvbvONTOnobQesUMbw4KS3LMQ69ixFkX7KzTWZcp2ND6DSjrMXbesvBmyIGEkfiglNQ8KdtJQa6ZzYLoKM90dfUWG8oD10whPoWknunv87sWTD1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948733; c=relaxed/simple;
	bh=SA7pAnDHE6KfMH1UZZ/FQxzR4MxGITZganFAmNhQXAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omVFvoRJGH/e7NSKg2Sh+afbQ5QulIOCIhAKhnODV54uNY6JmKMXcGIdzyKp9q9uO5D+Qxe9AnnbnZrAPNXXT50iBWQpUn+JOSYen6XW7nDsKqOCipq7e2m+2k1ek4FCU3COjLXCA81+8rIwNJKaU0stbzU6zvCcnAzhJVGz6I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVv37biI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVv37biI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9CBC4CEE3;
	Tue, 29 Apr 2025 17:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948732;
	bh=SA7pAnDHE6KfMH1UZZ/FQxzR4MxGITZganFAmNhQXAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVv37biIMVYpKWF72HJelwf/hoU86qULKPmwHgkvA52eH8HsAD5L1O+UtPmTyPrkG
	 cEpPq+wx0FekLHoAMBVD+t2ZoMbswnjaT4mkocPtRN8dGVvTJygIwBlydOC7NLmBa/
	 CtWsl+vrU5ZvWwdrrfL/9X+TfYof1DQ9XQBF4uz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@sifive.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/373] bpf: Add endian modifiers to fix endian warnings
Date: Tue, 29 Apr 2025 18:38:52 +0200
Message-ID: <20250429161125.390756386@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 84ec1b14b23f3..45cde12e41284 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -239,7 +239,7 @@ BPF_CALL_2(bpf_skb_load_helper_8_no_cache, const struct sk_buff *, skb,
 BPF_CALL_4(bpf_skb_load_helper_16, const struct sk_buff *, skb, const void *,
 	   data, int, headlen, int, offset)
 {
-	u16 tmp, *ptr;
+	__be16 tmp, *ptr;
 	const int len = sizeof(tmp);
 
 	if (offset >= 0) {
@@ -266,7 +266,7 @@ BPF_CALL_2(bpf_skb_load_helper_16_no_cache, const struct sk_buff *, skb,
 BPF_CALL_4(bpf_skb_load_helper_32, const struct sk_buff *, skb, const void *,
 	   data, int, headlen, int, offset)
 {
-	u32 tmp, *ptr;
+	__be32 tmp, *ptr;
 	const int len = sizeof(tmp);
 
 	if (likely(offset >= 0)) {
-- 
2.39.5



