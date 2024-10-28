Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA61A18A922;
	Mon, 28 Oct 2024 06:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098173; cv=none; b=p2bfdt/aGi68/oDPmOx4PYSNrWMD8h+CDZNS/zPvaUUso0HO92B0e3o3rlCDnqrm3k2tWPX6Uv/Hp9DNgDoyqsq+uax50im0Z5N3zJp0nbZzn8hAfb4IdpubaUB7SA3/XWaTOxNWNgsw4ifp6dIAHTCerzgl/GN1Nar4PhdVhJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098173; c=relaxed/simple;
	bh=vwAgkZ8rce5mx1WY6ZR8TjV013tyt2vQb+XOD7dv5oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e88+rIisivYz992T+MKQdj48oHl93uqRdqGXs9Q+LH/PBrE35tSXm6yMMDK1auAmHnnvgmm7fXDDd8K7AC4ZR67fVNPLY0v+gtT043f2/FxGWdIvi8VqxsCz9mBE1VvvIahkqAY8FZq/UGCZNHNtZycTmQv2i68bODahWTcXF7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=On66wbKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="On66wbKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48731C4CEC3;
	Mon, 28 Oct 2024 06:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098173;
	bh=vwAgkZ8rce5mx1WY6ZR8TjV013tyt2vQb+XOD7dv5oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=On66wbKUg1NyJXqWmcCQl/v6nL9WFEOhfbXOeHNsHbpknWltJvv8cQcSmM2jz+huU
	 Vms6Ce5A25TW/yvQYEpQ5FRPycLPix7xTi2eGxcTzsqwfyswSfwau4bNVTvGj9B9WC
	 +D2pzvVvZeWAmwwipaAVq8g4xk18rOa0/EPiM5M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathaniel Theis <nathaniel.theis@nccgroup.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 110/261] bpf: Fix print_reg_states constant scalar dump
Date: Mon, 28 Oct 2024 07:24:12 +0100
Message-ID: <20241028062314.786054346@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3e9e708757ca3b7eb65a820031d62fea1a265709 ]

print_reg_state() should not consider adding reg->off to reg->var_off.value
when dumping scalars. Scalars can be produced with reg->off != 0 through
BPF_ADD_CONST, and thus as-is this can skew the register log dump.

Fixes: 98d7ca374ba4 ("bpf: Track delta between "linked" registers.")
Reported-by: Nathaniel Theis <nathaniel.theis@nccgroup.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241016134913.32249-2-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/log.c b/kernel/bpf/log.c
index 5aebfc3051e3a..4a858fdb6476f 100644
--- a/kernel/bpf/log.c
+++ b/kernel/bpf/log.c
@@ -688,8 +688,7 @@ static void print_reg_state(struct bpf_verifier_env *env,
 	if (t == SCALAR_VALUE && reg->precise)
 		verbose(env, "P");
 	if (t == SCALAR_VALUE && tnum_is_const(reg->var_off)) {
-		/* reg->off should be 0 for SCALAR_VALUE */
-		verbose_snum(env, reg->var_off.value + reg->off);
+		verbose_snum(env, reg->var_off.value);
 		return;
 	}
 
-- 
2.43.0



