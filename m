Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7053E2D3733;
	Thu, 15 Jan 2026 17:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496989; cv=none; b=n2bTcHBswgqgvUPbbu9U3cLg643m0wdk36KJBvMw2Xkx5GZCWhCN5+dEwHOcQa6f5Pva1y4sSL0+AlrdfPieDpeKx4Ad3I7eHMvEblDf7RLbWnbb91A8yPEQAsR27Y7IJ9QIzKteI8laRCmMiedCTcri3TNTZW6hcGFJ+PPI0wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496989; c=relaxed/simple;
	bh=Y8htGl0oGdkdNjjSKOYcSpPWdZMSGHTWfBSMhkCOwJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icS8xDVZrekoBpKu1ujOxVelSWo0VeCQkjy2KT7rRqUrmh+AqqC9HJ7eFtwkHACOH+6RoB6SrcPwzl+9hhWe2fCwPZvtX8gceZxqLf2lMFwdkwFKe0XfbEsMu37LuVtmW1+FIUmRmiCuy5uBOdKXqNS5ts3qUSUxjrqcq6RrQ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h84CQtCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h84CQtCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0589C116D0;
	Thu, 15 Jan 2026 17:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496989;
	bh=Y8htGl0oGdkdNjjSKOYcSpPWdZMSGHTWfBSMhkCOwJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h84CQtCrmV+CFpT6BgiX8sSqxkQOtY81u6eVSuPH6CkDRomLwuilcE4xbK1HVcuvz
	 O5uHwYsp0YHdYfu6nDAU1sYYWzrox86ovWv3JFHAXbvWH3UCZUb5B9fwwSQQhMVgxb
	 P/bpu2cQ1D5aK/UwKE6H9njes+Id3aCtiqRJeXX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardulsb08@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.6 87/88] bpf: test_run: Fix ctx leak in bpf_prog_test_run_xdp error path
Date: Thu, 15 Jan 2026 17:49:10 +0100
Message-ID: <20260115164149.464437793@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1214,7 +1214,7 @@ int bpf_prog_test_run_xdp(struct bpf_pro
 		goto free_ctx;
 
 	if (kattr->test.data_size_in - meta_sz < ETH_HLEN)
-		return -EINVAL;
+		goto free_ctx;
 
 	data = bpf_test_init(kattr, linear_sz, max_linear_sz, headroom, tailroom);
 	if (IS_ERR(data)) {


