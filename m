Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF763BF30D;
	Thu, 15 Jan 2026 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496739; cv=none; b=H8u42eKIt6u5CHPa29RIypJXIRNKbqEv61Hlo2kpsmeG+X+QGnVGpvbQdTGlCBJba7gKunRBu1fsZ/SESmYr3yXIxMdbX5lUfIVIHWS5QIG9mWbTZyPoZo/Yq33uRgEVx2su7PC8CD9RYMKuSGZBc6MYOyRUL7NSVgkCwUDyWsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496739; c=relaxed/simple;
	bh=OUF+jZYzAiGW9TaAX6OZQ9nh+4CExnrHWLpnco4jRBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZORJkDX3MqgXBRy66r6hN4Kk22Y+xNGBqqg8FhMMaBiOauIR1aS5UcJQpo0JHwxtzlZH7en7ByPgChV1HeS7fGqQmaYu2kjNsoQ5UG7dUfGLN0kJaYMQ/ByCIZlI7aWo/Q30YDXHfcZXWGPmGJp45lzU04yNU27V0zL+QyR3Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETwFhP/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETwFhP/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B919C19423;
	Thu, 15 Jan 2026 17:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496739;
	bh=OUF+jZYzAiGW9TaAX6OZQ9nh+4CExnrHWLpnco4jRBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETwFhP/cTBtAjS0UI+ggSVUcDdhGZ2SwDwdEZNVv/3DheStA3VDnbZklFIMWL1XFd
	 MZkDa6lFRdR4gl68Z4l+LMV0mJefSp0kY3rmrz/iNsC7Hf7j7ZETG0GTOGB+bzrT3m
	 jIQk1Ap09tsfIIVD8O1FMtFyB3/vcPwjX6gUqx/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardulsb08@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.12 119/119] bpf: test_run: Fix ctx leak in bpf_prog_test_run_xdp error path
Date: Thu, 15 Jan 2026 17:48:54 +0100
Message-ID: <20260115164156.256690625@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shardul Bankar <shardulsb08@gmail.com>

commit 7f9ee5fc97e14682e36fe22ae2654c07e4998b82 upstream.

Fix a memory leak in bpf_prog_test_run_xdp() where the context buffer
allocated by bpf_ctx_init() is not freed when the function returns early
due to a data size check.

On the failing path:
  ctx = bpf_ctx_init(...);
  if (kattr->test.data_size_in - meta_sz < ETH_HLEN)
      return -EINVAL;

The early return bypasses the cleanup label that kfree()s ctx, leading to a
leak detectable by kmemleak under fuzzing. Change the return to jump to the
existing free_ctx label.

Fixes: fe9544ed1a2e ("bpf: Support specifying linear xdp packet data size for BPF_PROG_TEST_RUN")
Reported-by: BPF Runtime Fuzzer (BRF)
Signed-off-by: Shardul Bankar <shardulsb08@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://patch.msgid.link/20251014120037.1981316-1-shardulsb08@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bpf/test_run.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1270,7 +1270,7 @@ int bpf_prog_test_run_xdp(struct bpf_pro
 		goto free_ctx;
 
 	if (kattr->test.data_size_in - meta_sz < ETH_HLEN)
-		return -EINVAL;
+		goto free_ctx;
 
 	data = bpf_test_init(kattr, linear_sz, max_linear_sz, headroom, tailroom);
 	if (IS_ERR(data)) {


