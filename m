Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A992572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC4BC433EF;
	Tue, 18 Apr 2023 12:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821862;
	bh=h5jL3Hg6H9iEd2qDvmvKK5sVY5mnyz3R/S0IEYbD0vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFNGamubDYD5Nn2gR/lb9HdhzQZoS7JWcr9eZvROTVdNykmuu5LhZar8wuQw47wvR
	 oSIq7nNxHPde3AiW+jkFJnaWnD3U3CWhcEZqWxQvbzgtN7rnEmRO1K/ztkvvkxnogo
	 P6JPugM1TqrQOC+tul3lPbZ5DP8L4DHWGpamdFxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/134] libbpf: Fix single-line struct definition output in btf_dump
Date: Tue, 18 Apr 2023 14:22:05 +0200
Message-Id: <20230418120315.394059906@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
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
index 80a15a6802094..4cd1d49c94d6d 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1015,9 +1015,12 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
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



