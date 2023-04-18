Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBAC2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974B9C433D2;
	Tue, 18 Apr 2023 12:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821551;
	bh=PWo7MQgWV7E7p8VWro5IUDYhkqLQYkJLflOtYdSNA4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGxGkoRouedLlk23cStw7bCplHvQ/hoNEsaZ6ejX83RK4JWVD9olufwjyZA9Kdj+4
	 y3m2zlAmBk5plCz+yPdPI/ATjXFdqVfBhZt1GkDxINp4oSqQx/MFcWv6WnwVWFUhDy
	 eoGoFYf5fM2kSPtymX3d1U8ie0Wau1a05Uk8qTlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/91] libbpf: Fix single-line struct definition output in btf_dump
Date: Tue, 18 Apr 2023 14:21:41 +0200
Message-Id: <20230418120306.867382472@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 872aec4b5f635d94111d48ec3c57fbe078d64e7d ]

btf_dump APIs emit unnecessary tabs when emitting struct/union
definition that fits on the single line. Before this patch we'd get:

struct blah {<tab>};

This patch fixes this and makes sure that we get more natural:

struct blah {};

Fixes: 44a726c3f23c ("bpftool: Print newline before '}' for struct with padding only fields")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221212211505.558851-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index a9f974e5fb856..98cb3831aa18c 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1003,9 +1003,12 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 	 * Keep `struct empty {}` on a single line,
 	 * only print newline when there are regular or padding fields.
 	 */
-	if (vlen || t->size)
+	if (vlen || t->size) {
 		btf_dump_printf(d, "\n");
-	btf_dump_printf(d, "%s}", pfx(lvl));
+		btf_dump_printf(d, "%s}", pfx(lvl));
+	} else {
+		btf_dump_printf(d, "}");
+	}
 	if (packed)
 		btf_dump_printf(d, " __attribute__((packed))");
 }
-- 
2.39.2



