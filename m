Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9C715218A;
	Tue,  2 Jul 2024 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940187; cv=none; b=UIFMY7csylzokMAnLXhL4oa8ZUU/kfSiZW8N6tzfZwnmGIlKzQdcKNwbaozjbAx0G8hAeXjhfALxRDKBboLRBcic+BEBXqERlaF3Kgk/AJCggtloY9GXsDwJzuYGB0fZMXeJuhyYJz8RhfVUuzcmk/8OQSxBdc+GhgpIMgeblv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940187; c=relaxed/simple;
	bh=VlZNvkluJ4uPcmBUX/+kLuUn5w8secruD1PeX0LPK5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl63NynfYD/xrfxE20uhhS4iqgL9k+Xvv03J3+VeU6xOFPtrV8oGyFDUTW6CqhU8FjK1h0fqhjpZ1jkGSr8PsDcvw6IQNduBsZ6Ofq0p1AQXCNm0kNPNocKCgAtXIsfH1XUUPKlOBhJV2E+QooQzFCyGeqJapAwfQdZjQ5rC+1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBYO6HyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBYO6HyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464E3C116B1;
	Tue,  2 Jul 2024 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940187;
	bh=VlZNvkluJ4uPcmBUX/+kLuUn5w8secruD1PeX0LPK5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBYO6HyTzhZIc9fNxeBtemHcw57yz/4/ijpdlppn4sHY+bIyCi0hepmLkjpNQqG3m
	 w8m4dMP5H1QSkuouocUYygcfmAclxYk2u6MHj+AgFU2meFUUpuBaT/WQlxHx/t/nRh
	 8aqLb4o1sNUHfQ4Az/1wZtlz6aIF+31n8UVGSmEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Anton Protopopov <aspsk@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 077/222] bpf: Add a check for struct bpf_fib_lookup size
Date: Tue,  2 Jul 2024 19:01:55 +0200
Message-ID: <20240702170246.923592483@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <aspsk@isovalent.com>

[ Upstream commit 59b418c7063d30e0a3e1f592d47df096db83185c ]

The struct bpf_fib_lookup should not grow outside of its 64 bytes.
Add a static assert to validate this.

Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Anton Protopopov <aspsk@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240326101742.17421-4-aspsk@isovalent.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index ce255e0a2fbd9..15d850ea7d4ad 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -87,6 +87,9 @@
 
 #include "dev.h"
 
+/* Keep the struct bpf_fib_lookup small so that it fits into a cacheline */
+static_assert(sizeof(struct bpf_fib_lookup) == 64, "struct bpf_fib_lookup size check");
+
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog);
 
-- 
2.43.0



