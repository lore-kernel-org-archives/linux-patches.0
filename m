Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CFB387373;
	Sat, 17 Oct 2026 16:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255013; cv=none; b=nRRlwsAokqyHuWcJ0MC+yDnWRZGA6UBxg/yTjb+CeszP0mA7v0yixHb1+JUxXiooTKzcWxjyIXSuhSuKGEUy1UvvUFtTx02jLVZGtGLfiNWnv6fiy2+xESvwVsDhFtfgYT/MnEqaK/0aQNLI9Q5cSfyg6oNUQAdp8CH8I9QTB78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255013; c=relaxed/simple;
	bh=+sFtyEUAkR1q5ACQt6o0CsWNoKfAoVDDqsaC6CK1AKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2lAf6e3o7tcM865sm4YSCcXXs5baAKMGUDjcLQKccZZRZ9+e8VaJhWGCsc8A5d9vHXTE3DGjBn/HXF0JrMhcpu/4qC9Xc8M0M/i/nbDUivwPJAKMAvXvaow1PMH6Qamm9HS0NgyZ8BkdD3wgHR2aHQxu3HSwcTsPtiqYMFsIq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9WWTCpc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9WWTCpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE46C1F000C4;
	Sat, 17 Oct 2026 16:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255012;
	bh=ruMoecG60Y7G6bGgu265fUGxIZZfVv7zvsbsC4h9vSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9WWTCpcYkl8hJcH+vPVRjOA1TCp8naSz7LujPKk16OyO9e87lgF/eZi0r7VQ4P6k
	 rdiSokC7PhP2kyKPmj+YXLU0FaIcmrsPKf+j8iT1yAdIKlV/O/vHg50CzbkPXlEgV3
	 UPKeny9HcTUVwpWZUXjZ5BSE2kDHvxqz3N/HMgbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ning Ding <dingning04@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 635/869] bpf: Compare iterator types during state pruning
Date: Sat, 17 Oct 2026 17:57:56 +0200
Message-ID: <20261017160053.304701494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Ning Ding <dingning04@gmail.com>

[ Upstream commit 83608e303b95d07afba1c15da0b5d9e513c2f15a ]

An iterator stack slot can be MEM_RCU or PTR_UNTRUSTED. These states
must not be equal, or the verifier can prune an unsafe path.

Compare the pointer type for STACK_ITER slots.

Fixes: dfab99df147b ("bpf: teach the verifier to enforce css_iter and task_iter in RCU CS")
Signed-off-by: Ning Ding <dingning04@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260811035955.132989-2-dingning04@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 752bc2d57d2bf..f0a10f6f09fb0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18053,7 +18053,8 @@ static bool stacksafe(struct bpf_verifier_env *env, struct bpf_func_state *old,
 			 * infinite loop check triggering, see
 			 * iter_active_depths_differ()
 			 */
-			if (old_reg->iter.btf != cur_reg->iter.btf ||
+			if (old_reg->type != cur_reg->type ||
+			    old_reg->iter.btf != cur_reg->iter.btf ||
 			    old_reg->iter.btf_id != cur_reg->iter.btf_id ||
 			    old_reg->iter.state != cur_reg->iter.state ||
 			    /* ignore {old_reg,cur_reg}->iter.depth, see above */
-- 
2.53.0



