Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2871339A9;
	Tue, 23 Jan 2024 00:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969301; cv=none; b=YiM9LtikGwpSUe3jmX+8PfgooQs6wcnWo5slIf4GC/BH3Jp6vhyVQrId0YXjF2WRHyNx0fTLlKpyJUBWbV3rTARoUhXV7rkK40ZZAOa6UGghMlJgUK9Z1ij/+q/dQ2sl98v4sYV8wyxbOLBTUx6ABeTlkpbujRt7Yu6Qg3RNAgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969301; c=relaxed/simple;
	bh=qtemqpwavAEfT34To54KPe9EsXcnCmwIYc1RDfXwx0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTB28LzqJ1My3QWczEBjQeflJ1KOhfVVJBwfAwfjr0qE7To0wRoa7i+2ys5JPEUfiV8EUgG9K+yZ5IR3uFe587hNYCEK9Oh/TuO8Big/oWmx4VUmnxoOpdwBjSie+LAQQ2lHcQdaTqTMRJLV7GxYAUyKQ/w2+ebzTB/bnoPrm4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfUutdSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfUutdSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD37C43399;
	Tue, 23 Jan 2024 00:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969300;
	bh=qtemqpwavAEfT34To54KPe9EsXcnCmwIYc1RDfXwx0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfUutdSCHkBGiJPhH9xtjCFUBFVA9duOO2exDOFCYUNaCChKsaH6FV18XPc84fXAZ
	 31jDT6sBI7LWWPhkcOyvchlDAchSP6QBPsZiTv/yfYu9Sf7wcAbOqhu/jr6aUdg1+Y
	 alNuiu2MmWSQoyrtW7i3i59DBVviEUS7ClDnakjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 134/641] bpf: fix check for attempt to corrupt spilled pointer
Date: Mon, 22 Jan 2024 15:50:38 -0800
Message-ID: <20240122235822.242868048@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit ab125ed3ec1c10ccc36bc98c7a4256ad114a3dae ]

When register is spilled onto a stack as a 1/2/4-byte register, we set
slot_type[BPF_REG_SIZE - 1] (plus potentially few more below it,
depending on actual spill size). So to check if some stack slot has
spilled register we need to consult slot_type[7], not slot_type[0].

To avoid the need to remember and double-check this in the future, just
use is_spilled_reg() helper.

Fixes: 27113c59b6d0 ("bpf: Check the other end of slot_type for STACK_SPILL")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231205184248.1502704-4-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4d59b200e898..c4fbfe499475 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4676,7 +4676,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	 * so it's aligned access and [off, off + size) are within stack limits
 	 */
 	if (!env->allow_ptr_leaks &&
-	    state->stack[spi].slot_type[0] == STACK_SPILL &&
+	    is_spilled_reg(&state->stack[spi]) &&
 	    size != BPF_REG_SIZE) {
 		verbose(env, "attempt to corrupt spilled pointer on stack\n");
 		return -EACCES;
-- 
2.43.0



