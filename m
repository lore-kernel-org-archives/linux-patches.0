Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E73A14A4CF;
	Tue, 23 Jan 2024 00:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969233; cv=none; b=mC98aC2rs1DWIxL5E0Vl/RVuGVAZssFZWQX4JoEvLX27MarhB5lirqMcanJ1kj/IlWFDbvAl63lQL9DZhxvpEgFx3LMEZlqm6uXsQAI0yncdzOyBbc9qVtcFHWEQFa/TQFZRI6qbiEtgWI5w8tdyPzkhBnJGxcS1eMvADQ7lFAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969233; c=relaxed/simple;
	bh=toEF7pzim4e7Kd0CjGOIa+su3MGTHF+GmBGPyCOYV3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAJpCqH5cLdq71Qn5sc7Ll6sM0ELm0ARv6BETiDbZXyD4F50dXX9saSVsD1dEaMJhzXvzBalvt3INP4llgg9GI8diJNr4R7hE0w3T8gKfwUq6SrPn9w6jiyyss9pHg8qMX42KC7XWA/2JSvVD8LBfmVDvA439nkK7y3fcSE+aLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T89jTxeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T89jTxeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BB7C43394;
	Tue, 23 Jan 2024 00:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969233;
	bh=toEF7pzim4e7Kd0CjGOIa+su3MGTHF+GmBGPyCOYV3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T89jTxeQAZabALQ1+rMiyG0rUsIT34GXHmlHy/SI4tQtZit+cYF4iFaf4WQ7ySaCC
	 IyYpbEv49quPao/kF1jBqFUCOtf+z1WmLFGoWCOwxpMIufZICG4P3mnkZmB0zQjp3g
	 F1Eigp3vYtdYrv+j4S0LXfRzr1FJegBpIjezTQDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 116/641] bpf: enforce precision of R0 on callback return
Date: Mon, 22 Jan 2024 15:50:20 -0800
Message-ID: <20240122235821.676170159@linuxfoundation.org>
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

[ Upstream commit 0acd03a5bd188b0c501d285d938439618bd855c4 ]

Given verifier checks actual value, r0 has to be precise, so we need to
propagate precision properly. r0 also has to be marked as read,
otherwise subsequent state comparisons will ignore such register as
unimportant and precision won't really help here.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231202175705.885270-4-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index af2819d5c8ee..4d59b200e898 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9829,6 +9829,13 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 			verbose(env, "R0 not a scalar value\n");
 			return -EACCES;
 		}
+
+		/* we are going to rely on register's precise value */
+		err = mark_reg_read(env, r0, r0->parent, REG_LIVE_READ64);
+		err = err ?: mark_chain_precision(env, BPF_REG_0);
+		if (err)
+			return err;
+
 		if (!tnum_in(range, r0->var_off)) {
 			verbose_invalid_scalar(env, r0, &range, "callback return", "R0");
 			return -EINVAL;
-- 
2.43.0



