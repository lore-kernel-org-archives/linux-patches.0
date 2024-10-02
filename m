Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F641D0B91;
	Wed,  2 Oct 2024 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879737; cv=none; b=NWLDK/AyZj2kqu/xXhm5TWYXt/nmg5f1GRVsPUFesL8AkyPXqtXgQ0PSZFzPotx1Si2WgB+ao1AEaBD4+zlfmBdwaoEnPAK0QZ8zvqUgQna7WeO2m9vLXa0KAbYDBpDLxyE6cWjED4HLb2rOZTCnZQugU8VQQRNyXnMsoD7DiIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879737; c=relaxed/simple;
	bh=5HYpQxAjI8yWKV05mWQ7ocNbzcD12hIb7LYWpQ1AxcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V07XYFN2kc7/+GG9DsXGGMCKYX2sm/Tcr8qJ2fB48e0TfeG4RJA9TZff/j0R2Y1EEsQ4RZcWM/OF46KkQHHiGw5F4GLPbkVnXBYgCwDT0GtvawpLOxgvtvcSuc+AkQkbpr3mH3k3KdBtWkwjRb+0dpeqCVh5JKlpATrQSP5iOSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JShYJZi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JShYJZi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8C0C4CEC2;
	Wed,  2 Oct 2024 14:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879737;
	bh=5HYpQxAjI8yWKV05mWQ7ocNbzcD12hIb7LYWpQ1AxcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JShYJZi5FQCgu3V4mQ8x6yv1RtjzE7HD7mT3mgGAWR9cVWTH/ir7xdyq6k1L0p0h+
	 hNw6xOxDt5KL9VtedvO4znudq5OxSDA7uJzz/SiMfawPCxbvp5S7pXwZTNJzjzPNUJ
	 g38xf0dJqpUiVfz3PbiQzG4VJfJhmYA+qAuOltoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu RuiTong <cnitlrt@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/538] bpf: correctly handle malformed BPF_CORE_TYPE_ID_LOCAL relos
Date: Wed,  2 Oct 2024 14:57:40 +0200
Message-ID: <20241002125800.978939907@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 3d2786d65aaa954ebd3fcc033ada433e10da21c4 ]

In case of malformed relocation record of kind BPF_CORE_TYPE_ID_LOCAL
referencing a non-existing BTF type, function bpf_core_calc_relo_insn
would cause a null pointer deference.

Fix this by adding a proper check upper in call stack, as malformed
relocation records could be passed from user space.

Simplest reproducer is a program:

    r0 = 0
    exit

With a single relocation record:

    .insn_off = 0,          /* patch first instruction */
    .type_id = 100500,      /* this type id does not exist */
    .access_str_off = 6,    /* offset of string "0" */
    .kind = BPF_CORE_TYPE_ID_LOCAL,

See the link for original reproducer or next commit for a test case.

Fixes: 74753e1462e7 ("libbpf: Replace btf__type_by_id() with btf_type_by_id().")
Reported-by: Liu RuiTong <cnitlrt@gmail.com>
Closes: https://lore.kernel.org/bpf/CAK55_s6do7C+DVwbwY_7nKfUz0YLDoiA1v6X3Y9+p0sWzipFSA@mail.gmail.com/
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240822080124.2995724-2-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index fbf9721ba21b6..e0e4d4f490e87 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -8421,6 +8421,7 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 	struct bpf_core_cand_list cands = {};
 	struct bpf_core_relo_res targ_res;
 	struct bpf_core_spec *specs;
+	const struct btf_type *type;
 	int err;
 
 	/* ~4k of temp memory necessary to convert LLVM spec like "0:1:0:5"
@@ -8430,6 +8431,13 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 	if (!specs)
 		return -ENOMEM;
 
+	type = btf_type_by_id(ctx->btf, relo->type_id);
+	if (!type) {
+		bpf_log(ctx->log, "relo #%u: bad type id %u\n",
+			relo_idx, relo->type_id);
+		return -EINVAL;
+	}
+
 	if (need_cands) {
 		struct bpf_cand_cache *cc;
 		int i;
-- 
2.43.0



