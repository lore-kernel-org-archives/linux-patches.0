Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075143A16A0;
	Wed,  8 Apr 2026 18:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672657; cv=none; b=ryI0NeCEm8tSS28/4hx1ZlPa/yFn5tKSKHJXEsxn16P51uwLg5JySWg9IsEHXThim083wPPz5PFFI3zqB205IKzrbMpZvluQRx4CEK9Uutyz1dYexeG+FGXgrZB5CqBqjxhHj5mfAhPzJBonQWNtXr9X92385sv+3q9jKFUoEJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672657; c=relaxed/simple;
	bh=33O5G1TH9VUN+zh+aYfz1BYp18HZr2ofxhJ4CtufTtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fflCz1Dj5p6N+6s+3Et1FzC3YBjuVIDLehhETrc7B26uIjpW+x0hgE4tYKFKd9Tdy1fzVs4BIxa/jetC5ViVjduuyBW163hRJXiuZdgdWA62CezQz0eHhIMs0TCLgAmVlXZeiyF+LieZmlZbLLTxLtwwxdVpGDIgHR+lVZwwgMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfAswmJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfAswmJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A69C19421;
	Wed,  8 Apr 2026 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672656;
	bh=33O5G1TH9VUN+zh+aYfz1BYp18HZr2ofxhJ4CtufTtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfAswmJ49WIU/mb3o9P6hGSIJ3vpy55RyetjSbVGSRRmDya8nJC0WOtVdSjk4u/ge
	 rqUKdpDT3P7zOD7ph+Wq3lBx6pDIs+1GZr3sIBVfnE/VOrzURClV+sj6iwua7RJiOx
	 E49RtW3SiKYmuukRpbZj1SsjwTNv1Lr47aGjZRic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/160] bpf: reject direct access to nullable PTR_TO_BUF pointers
Date: Wed,  8 Apr 2026 20:02:31 +0200
Message-ID: <20260408175915.595697236@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Qi Tang <tpluszz77@gmail.com>

[ Upstream commit b0db1accbc7395657c2b79db59fa9fae0d6656f3 ]

check_mem_access() matches PTR_TO_BUF via base_type() which strips
PTR_MAYBE_NULL, allowing direct dereference without a null check.

Map iterator ctx->key and ctx->value are PTR_TO_BUF | PTR_MAYBE_NULL.
On stop callbacks these are NULL, causing a kernel NULL dereference.

Add a type_may_be_null() guard to the PTR_TO_BUF branch, matching the
existing PTR_TO_BTF_ID pattern.

Fixes: 20b2aff4bc15 ("bpf: Introduce MEM_RDONLY flag")
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260402092923.38357-2-tpluszz77@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e33cd755d6197..45eb795c8c045 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6912,7 +6912,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 	} else if (reg->type == CONST_PTR_TO_MAP) {
 		err = check_ptr_to_map_access(env, regs, regno, off, size, t,
 					      value_regno);
-	} else if (base_type(reg->type) == PTR_TO_BUF) {
+	} else if (base_type(reg->type) == PTR_TO_BUF &&
+		   !type_may_be_null(reg->type)) {
 		bool rdonly_mem = type_is_rdonly_mem(reg->type);
 		u32 *max_access;
 
-- 
2.53.0



