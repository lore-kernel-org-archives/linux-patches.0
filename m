Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924911946D3;
	Wed,  3 Jul 2024 11:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005105; cv=none; b=JFrkrTZMYzWC1i7ViIGLb2pGXC+DLDhNixBkmjX+B/Fgl/jqMzY6GkhXjiAlv14MzKAAzkzU8rSM50axaFtCQdrb93+0vElWbWRPIBFNhQOJFTNvMoXdEvqRbQj8lCwRdKXw/03CHbdhJZnh9NEIssP8dBvqmyfubQLE+tx+0ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005105; c=relaxed/simple;
	bh=fO/9u5WMvuo086QSxbGqIPPfysZ9iYLd1JwqqETV0Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQX5raRKEBna1ZHU9ctAiLiiEahaP1GJJTPvZZ1M8UonUUwgpkOF2+zCvOCU6n4n/VZo88Zpx8DZc33z98F51SPV4Om3Eim6rebla2dVBpdRc/fVjDyf0xRadC865dCZdYiex7k/tn1+AuUqbWfkjxQwInKSqhtIN4Hy4hW6KBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MF95j1m1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MF95j1m1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADFCC2BD10;
	Wed,  3 Jul 2024 11:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005105;
	bh=fO/9u5WMvuo086QSxbGqIPPfysZ9iYLd1JwqqETV0Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MF95j1m1aBc/iEKcjABXoJ5HAn8mCNCDF+xV9DsiwbzI8/vpDYriPkL8Le1fgc2Gw
	 wbi3XpHZzWfl+bzAKhL2zJ3AHuKI4YXIgyoDGJoPCx+jFZqfBqtL9whFkV7A6LFJNd
	 +YiNIwIh8zQ0sN/U4tqne02a7FTn+zGdz8OLiuXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Anton Protopopov <aspsk@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/290] bpf: Add a check for struct bpf_fib_lookup size
Date: Wed,  3 Jul 2024 12:40:12 +0200
Message-ID: <20240703102912.879552417@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 49e4d1535cc82..a3101cdfd47b9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -78,6 +78,9 @@
 #include <linux/btf_ids.h>
 #include <net/tls.h>
 
+/* Keep the struct bpf_fib_lookup small so that it fits into a cacheline */
+static_assert(sizeof(struct bpf_fib_lookup) == 64, "struct bpf_fib_lookup size check");
+
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
 
-- 
2.43.0



