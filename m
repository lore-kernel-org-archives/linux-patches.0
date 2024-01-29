Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE89915EA9D;
	Mon, 29 Jan 2024 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548528; cv=none; b=QLf8+ggoFHDf7HS1gI4c8rPU0pUPJcF1CT7/UgZRSbg82KjH7b0HvDVzHCc5m11APMwQx0XFd1pe0w5mkyVcUKQbiFW91rcN8htBCQd68y5jIDGUgl8jhdxkG/Ye1s0ZWMAeac3gvUDk3TZxsh0y/a6d2jhGJ3OMVHkTHrme7aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548528; c=relaxed/simple;
	bh=BhIWq2+UYqGWjJU1NJOhubwoLISEdkGzjqW6x0ZHdZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnPxSu6QLlWHb2CujG7A7m08BSnlohUWgWNct1JRa4g6RpJWjovu68bI+y9RhIvcRpZZMdvoe6Lq+v7s63ytuEUQBBU1CxwJfAJr42+0yC1EUSgRAGjoCoIdhbkrp9gdVPC8A+4zDAykW+cK+A8ZUFfI36OuG0a+h0UeaxdQd+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtf6vDti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtf6vDti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B918BC433A6;
	Mon, 29 Jan 2024 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548527;
	bh=BhIWq2+UYqGWjJU1NJOhubwoLISEdkGzjqW6x0ZHdZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtf6vDtiT0hlOCrJpIYxFEzcs24pOYf8IZUBH2TOEKTnji6ChzpjIBE2YaK7HgSGT
	 2SmijjLRA6i+wNIqeghKMsT4U46KZ4u5N7j7IEdOxtTPZftQv7dxe165hwqskXQM3p
	 VX+6RCRiREWztQVTvUEkIt34+o8u9e+9+UlUyE74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 162/331] selftests/bpf: check if max number of bpf_loop iterations is tracked
Date: Mon, 29 Jan 2024 09:03:46 -0800
Message-ID: <20240129170019.669994724@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

commit 57e2a52deeb12ab84c15c6d0fb93638b5b94001b upstream.

Check that even if bpf_loop() callback simulation does not converge to
a specific state, verification could proceed via "brute force"
simulation of maximal number of callback calls.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231121020701.26440-12-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_iterating_callbacks.c |   75 ++++++++++
 1 file changed, 75 insertions(+)

--- a/tools/testing/selftests/bpf/progs/verifier_iterating_callbacks.c
+++ b/tools/testing/selftests/bpf/progs/verifier_iterating_callbacks.c
@@ -164,4 +164,79 @@ int unsafe_find_vma(void *unused)
 	return choice_arr[loop_ctx.i];
 }
 
+static int iter_limit_cb(__u32 idx, struct num_context *ctx)
+{
+	ctx->i++;
+	return 0;
+}
+
+SEC("?raw_tp")
+__success
+int bpf_loop_iter_limit_ok(void *unused)
+{
+	struct num_context ctx = { .i = 0 };
+
+	bpf_loop(1, iter_limit_cb, &ctx, 0);
+	return choice_arr[ctx.i];
+}
+
+SEC("?raw_tp")
+__failure __msg("invalid access to map value, value_size=2 off=2 size=1")
+int bpf_loop_iter_limit_overflow(void *unused)
+{
+	struct num_context ctx = { .i = 0 };
+
+	bpf_loop(2, iter_limit_cb, &ctx, 0);
+	return choice_arr[ctx.i];
+}
+
+static int iter_limit_level2a_cb(__u32 idx, struct num_context *ctx)
+{
+	ctx->i += 100;
+	return 0;
+}
+
+static int iter_limit_level2b_cb(__u32 idx, struct num_context *ctx)
+{
+	ctx->i += 10;
+	return 0;
+}
+
+static int iter_limit_level1_cb(__u32 idx, struct num_context *ctx)
+{
+	ctx->i += 1;
+	bpf_loop(1, iter_limit_level2a_cb, ctx, 0);
+	bpf_loop(1, iter_limit_level2b_cb, ctx, 0);
+	return 0;
+}
+
+/* Check that path visiting every callback function once had been
+ * reached by verifier. Variables 'ctx{1,2}i' below serve as flags,
+ * with each decimal digit corresponding to a callback visit marker.
+ */
+SEC("socket")
+__success __retval(111111)
+int bpf_loop_iter_limit_nested(void *unused)
+{
+	struct num_context ctx1 = { .i = 0 };
+	struct num_context ctx2 = { .i = 0 };
+	__u64 a, b, c;
+
+	bpf_loop(1, iter_limit_level1_cb, &ctx1, 0);
+	bpf_loop(1, iter_limit_level1_cb, &ctx2, 0);
+	a = ctx1.i;
+	b = ctx2.i;
+	/* Force 'ctx1.i' and 'ctx2.i' precise. */
+	c = choice_arr[(a + b) % 2];
+	/* This makes 'c' zero, but neither clang nor verifier know it. */
+	c /= 10;
+	/* Make sure that verifier does not visit 'impossible' states:
+	 * enumerate all possible callback visit masks.
+	 */
+	if (a != 0 && a != 1 && a != 11 && a != 101 && a != 111 &&
+	    b != 0 && b != 1 && b != 11 && b != 101 && b != 111)
+		asm volatile ("r0 /= 0;" ::: "r0");
+	return 1000 * a + b + c;
+}
+
 char _license[] SEC("license") = "GPL";


