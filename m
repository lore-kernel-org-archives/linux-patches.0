Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E3F17C7BA;
	Wed,  3 Jul 2024 11:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006063; cv=none; b=q2ddx4K//2nJSmkRJd2uLfEW1XCOmVwRl+9xbKnLWULapBq2vSML84MfbuEoWVWWt3vdXFaW98L1s2znwtxQwNTk/6OPX339EG6m/xV4UP2dnc3Sr2xQP/Lb0shcRAmd9sgrGzfgoacDnyqIhEf7ATJ19WwWkP6isBywBhJsDk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006063; c=relaxed/simple;
	bh=CZ4XQPEdlcu0v6nmGW6+nAdjQtBqaAf6u4a1SBAdWiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPN7+WbMlwrzp61yXTYfmTzMbv3QDWMXgkj4Xl5DGE9tz/gYG9gwIm+L8LpKh13tHO99aoIPRUgPpf9y6hvPwydLth9/9I4hg9hq00T8sN2AI9BjIWe3PkFm2dm0uBTnft9uYh0Z6hUiuZZgr407OyBgedm8nbrSiRlpCPqV7Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqvsoZqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqvsoZqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A29C2BD10;
	Wed,  3 Jul 2024 11:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006063;
	bh=CZ4XQPEdlcu0v6nmGW6+nAdjQtBqaAf6u4a1SBAdWiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqvsoZqyXhQJlaeppszCFIOIX5fPEnXr8ZnU0HFGeQqAKr7vgknaaWtD361n7pP0I
	 dmXPN1LTFaXz8lYB/YRZj1kV3Q0/K1PbZ/CKmVhPSjhVeCqYvAG9wW494jdqW2xkV6
	 0erDMhJpYyX+96J9wL2OHQ4hb4hAzWSDhjfg5TJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Anton Protopopov <aspsk@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/356] bpf: Add a check for struct bpf_fib_lookup size
Date: Wed,  3 Jul 2024 12:40:25 +0200
Message-ID: <20240703102924.053298760@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 47eb1bd47aa6e..a873c8fd51b67 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -79,6 +79,9 @@
 #include <net/tls.h>
 #include <net/xdp.h>
 
+/* Keep the struct bpf_fib_lookup small so that it fits into a cacheline */
+static_assert(sizeof(struct bpf_fib_lookup) == 64, "struct bpf_fib_lookup size check");
+
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
 
-- 
2.43.0



