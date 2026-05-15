Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B286303CB0;
	Fri, 15 May 2026 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861057; cv=none; b=jnLrIsViogwQLTwzRSQkMQXd6Z+Vq1UdtB95vZOI5CZUHB2bzp0z9yLzJZL7RfXEy3QJa7izTQfkBdjaLIfyii5vnKKuijIQIn1TAWHhsrsIP3ikVXalfvI4uQ9EAaGlpphkzX/oGsjgGObSbz++k5GdTvHvtw4lZqSAG9uwXVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861057; c=relaxed/simple;
	bh=d8JTca40XlKLcz9f4FPwf/DjCAuFfsiWbiMdJti9r5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zr5WxH0nHLB4KJS+eBsjbpvJxPDHvxjC35gVRtIJ4cTOj1jYZ5wrVZ64vm5Fu6/i2nVJP1XClPAJJdQtmbBYt3YPoqamelf/E/nM5ML0dhcB+wCp/A70aC4P4YbgZj2qdwtcIwysPz/fQTRmSqHyYi143fPxYocyuGbOc4S0ZAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSLPKQdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSLPKQdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11734C2BCB0;
	Fri, 15 May 2026 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861057;
	bh=d8JTca40XlKLcz9f4FPwf/DjCAuFfsiWbiMdJti9r5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSLPKQdnFOQDjjl4kmUelWIXgZWu82ja3x2hEn2gyNJtdnr8rXrFZOQqlAGAVe1ba
	 Dd3MT64F1N4/6D67ljFTMHTte74uNwUF8obe6e13yN0uTPv1R/702U8QsE9n8uawud
	 Tvf5/bV8vH0NJ+zxM2KgyNGiP9pYpXV6FWByjnBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Tao Lyu <tao.lyu@epfl.ch>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/474] bpf: Dont mark STACK_INVALID as STACK_MISC in mark_stack_slot_misc
Date: Fri, 15 May 2026 17:44:51 +0200
Message-ID: <20260515154718.961670050@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 69772f509e084ec6bca12dbcdeeeff41b0103774 ]

Inside mark_stack_slot_misc, we should not upgrade STACK_INVALID to
STACK_MISC when allow_ptr_leaks is false, since invalid contents
shouldn't be read unless the program has the relevant capabilities.
The relaxation only makes sense when env->allow_ptr_leaks is true.

However, such conversion in privileged mode becomes unnecessary, as
invalid slots can be read without being upgraded to STACK_MISC.

Currently, the condition is inverted (i.e. checking for true instead of
false), simply remove it to restore correct behavior.

Fixes: eaf18febd6eb ("bpf: preserve STACK_ZERO slots on partial reg spills")
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Reported-by: Tao Lyu <tao.lyu@epfl.ch>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241204044757.1483141-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f6040169ef749..b7fd3995538bf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1350,14 +1350,17 @@ static bool is_spilled_scalar_reg(const struct bpf_stack_state *stack)
 /* Mark stack slot as STACK_MISC, unless it is already STACK_INVALID, in which
  * case they are equivalent, or it's STACK_ZERO, in which case we preserve
  * more precise STACK_ZERO.
- * Note, in uprivileged mode leaving STACK_INVALID is wrong, so we take
- * env->allow_ptr_leaks into account and force STACK_MISC, if necessary.
+ * Regardless of allow_ptr_leaks setting (i.e., privileged or unprivileged
+ * mode), we won't promote STACK_INVALID to STACK_MISC. In privileged case it is
+ * unnecessary as both are considered equivalent when loading data and pruning,
+ * in case of unprivileged mode it will be incorrect to allow reads of invalid
+ * slots.
  */
 static void mark_stack_slot_misc(struct bpf_verifier_env *env, u8 *stype)
 {
 	if (*stype == STACK_ZERO)
 		return;
-	if (env->allow_ptr_leaks && *stype == STACK_INVALID)
+	if (*stype == STACK_INVALID)
 		return;
 	*stype = STACK_MISC;
 }
-- 
2.53.0



