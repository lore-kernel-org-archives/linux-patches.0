Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFB42F619D;
	Thu, 15 Jan 2026 17:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497203; cv=none; b=fmyURFtWui4UXZyc84rGp3+VQe1BgOT8ZKWBjtz6QMmGzfZ9OZyXCngYfFsW1ECpSLgg1R/BF2hPcR59ZFZ16/r1CHFc87GQPBB877hC3TaN6dO1EUJvbqudBBhFLG2EnlsNgUov5elJS+udkTsiax1LUN8Ca596425C4rnAJLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497203; c=relaxed/simple;
	bh=Ww0isepZsg3RL47S7CM/H+lLjC/Qlxav8eHwApMPlio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdpOOT4C2FrukQVgRre6iHnxGjcBp7yki4BfI53TTWJRLtfS7I/bFgRlRYA0zx5IhaoCycrS4INkPgp0RI9DfLqpHuqAixGQAfSN4KdOZjZX4OdacpvcbRkxEQSRqmiD9E/gWZ0Zpr9BUESe0nyImq0T2CyyklMTimo0AGV6Q2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtVw/ewF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtVw/ewF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440B3C116D0;
	Thu, 15 Jan 2026 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497203;
	bh=Ww0isepZsg3RL47S7CM/H+lLjC/Qlxav8eHwApMPlio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtVw/ewF75QGhdZ+1ogTI3hzldrj0QsLuXgD8vYQ1Pq4m/Ui5SiGTXk4PEL2YLuZy
	 ri61MyV+/tk6Epo4BMmuTNh/G5+YefDkxUNDk+XkhQrtJGJaU/RsvBi5FGT9pjKdFW
	 HgTzpOoeaHc0O0OBkHt2H3fbxVR/Xw2ZyhXRMCK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardulsb08@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.1 72/72] bpf: test_run: Fix ctx leak in bpf_prog_test_run_xdp error path
Date: Thu, 15 Jan 2026 17:49:22 +0100
Message-ID: <20260115164146.114481975@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1344,7 +1344,7 @@ int bpf_prog_test_run_xdp(struct bpf_pro
 		goto free_ctx;
 
 	if (kattr->test.data_size_in - meta_sz < ETH_HLEN)
-		return -EINVAL;
+		goto free_ctx;
 
 	data = bpf_test_init(kattr, linear_sz, max_linear_sz, headroom, tailroom);
 	if (IS_ERR(data)) {


