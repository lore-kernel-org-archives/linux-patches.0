Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAB460266;
	Tue, 23 Jan 2024 01:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974671; cv=none; b=QeXELFu3GIBwzhm+6eHsZmxiYgICGdfYJzaa1plnPqXy0uPzDDVByo1LW5sscmluXL4TfYP3fLHJI4winTr9C4OZoN9CofrlMIfzb2z3bl0Jm/rpIx1MXd64G415ihiG1EN4QyLtbIvv5dOgEt2fTLrri6KQeK8r+hBoac62ue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974671; c=relaxed/simple;
	bh=EaCkgWEwg3IRk1B98bx2L+xCc4sSo59GpXcAuMalEl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=co6uihzrRlwzHrx2YZFc5bhOy1sfVM0rLqy8/+jVbUJ1wXof/pc2XSx/POp4ilskULzMqzUIa3BCLsUU6URsgUBc+I5Ajy7golyxvdUQgyN9W7W7L5HL5Phocwvg/3883HMIDAvirXTcmfSMT8HlrgRTR/Z/qulik4+lAYe0OaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBkVJd8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBkVJd8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A041BC433C7;
	Tue, 23 Jan 2024 01:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974670;
	bh=EaCkgWEwg3IRk1B98bx2L+xCc4sSo59GpXcAuMalEl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBkVJd8+TEhGMIqONvIK+eTUvG6LrSrW3ZVyJ7Znzd45woKDLHpG0wlQ0zo4lkAro
	 PNpBqLRcGV3O4nRnWwCbFPYzCEZngjoNFzt/HBxcSt1dN2W0dDPVNpfQ1Ka65/zffi
	 JtY6N0CTYGIGZ70jMOKKOSC9YM9ZE4AJI1W6SM2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/583] bpf: enforce precision of R0 on callback return
Date: Mon, 22 Jan 2024 15:52:34 -0800
Message-ID: <20240122235815.323688313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 824531d4c262..2deae0db03e8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9284,6 +9284,13 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
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



