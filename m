Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED113C28
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737E1C4339B;
	Mon,  3 Apr 2023 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532205;
	bh=iVDkv8kGe/IQdtLp0iSlgIIPgrNQvSUUR42GMN+nEuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUtRuRdQkjbFLerP4jB2Lnvqdgtr5qYrSiYz86w4fmbLgYjh+HwpyTTu35nWfBWFO
	 0C2NMHhC3zcrhRkKkIPbDBJSU1tb2Vb28NCCt4zC7zL5mAfNcwSJ4euMk113/RTwIX
	 4LAoM6dqzlPmNLNHiumXMp3DyCI1/UN0BVLKWNsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/173] selftests/bpf: Test btf dump for struct with padding only fields
Date: Mon,  3 Apr 2023 16:09:42 +0200
Message-Id: <20230403140419.847228278@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit d503f1176b14f722a40ea5110312614982f9a80b ]

Structures with zero regular fields but some padding constitute a
special case in btf_dump.c:btf_dump_emit_struct_def with regards to
newline before closing '}'.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221001104425.415768-2-eddyz87@gmail.com
Stable-dep-of: ea2ce1ba99aa ("libbpf: Fix BTF-to-C converter's padding logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/btf_dump_test_case_padding.c     | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index 35c512818a56b..db5458da61826 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -102,12 +102,21 @@ struct zone {
 	struct zone_padding __pad__;
 };
 
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct padding_wo_named_members {
+	long: 64;
+	long: 64;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
 int f(struct {
 	struct padded_implicitly _1;
 	struct padded_explicitly _2;
 	struct padded_a_lot _3;
 	struct padded_cache_line _4;
 	struct zone _5;
+	struct padding_wo_named_members _6;
 } *_)
 {
 	return 0;
-- 
2.39.2



