Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC45BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B95C4339C;
	Tue,  7 Mar 2023 17:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209356;
	bh=FilJwXeAzkXCfLs3DsWd4aSiJRlsDMU9txis/EN/Z5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6HRRSeNQH1am3KA+BBYt7WPWyPfE2qtWllDwuQPflG+192lGcq+rb2mXBSNMfRx7
	 79ANv9Orx28/pgYi6FXMehUfvrABzP5Qc5zSZRhvTYtttNoeHFv6Alg46bgrS9Ds7C
	 wmPe6btDdNq5v0vNB4F6WDIKNYu0f9U+WGYqGzqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0160/1001] libbpf: Fix single-line struct definition output in btf_dump
Date: Tue,  7 Mar 2023 17:48:52 +0100
Message-Id: <20230307170028.970103365@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index deb2bc9a0a7b0..69e80ee5f70e2 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -959,9 +959,12 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
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



