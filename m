Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381DC56468;
	Tue, 23 Jan 2024 01:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974020; cv=none; b=i1+O95ZYHt8u0kVzhTLDF3D8ocdrJqINKqTuf/PkmCP4pE11BF65hMK1srQVM59QvkWx3J2AOJJw5k8Z3BRyCwQKX3QRBb9wWkiEfLqIUF7H62vRYHMYeFgJuAZUM1WH3KXRFOgxiv6qDEc/RRIh/7YG58LnA7yYWPJFOxaoTiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974020; c=relaxed/simple;
	bh=2L/n4EdP6brAZ7vTLr4K2mFNfr1UakdUTQT47y83MsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVallhYgow0MinAcIZ7PWASHgbCa4+Wmy/bXYzVz+TDjsvAVxQ2NDB8vT92AMlVD4osEa/plwNdNiyF+Bu5rWMRNDv9tswBHqJ40zwGueNQh6/8mgqnpvlMgVu/1hrgo86qpmAj2zonbUw7x6e35+0Om6MpxEbGcQ3SWrww8ndc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a59W5zH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a59W5zH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C895DC43390;
	Tue, 23 Jan 2024 01:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974019;
	bh=2L/n4EdP6brAZ7vTLr4K2mFNfr1UakdUTQT47y83MsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a59W5zH6t4KEoOnV5Ovpaoez/2juOir0SGabYICW+YLPGRRqiA3+jnYQjhtAxRys2
	 aj17HxwIsWTeB86pOnokcVvaMJFcL8wWzXr2GRtIZeTZlo8V9OwMx+qS946/F6Aqz/
	 zpzsv32E5lGiROSm+n+9zoubuzpTInIuxu90U7SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/374] bpf: enforce precision of R0 on callback return
Date: Mon, 22 Jan 2024 15:56:24 -0800
Message-ID: <20240122235749.096196952@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5d8f352faebd..7318a5d44859 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6244,6 +6244,13 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
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



