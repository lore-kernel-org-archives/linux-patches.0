Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3D83F23D9;
	Wed, 20 May 2026 16:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294820; cv=none; b=utrXDGf+pOk6z0wE2BpHJG9sQB4FvGpk/mVAHi49w2PDwyZIpHEQLZ5XP7thPaQS2859en0nAQIKWRoXALNXe9B6uFFP0e/epQ0Oasr+U4zPg+uVTYmglDVIlAezzwUUocAlvwQGTy9gf1wA6XPfZL8CV72r2TFWyVT8YpVSlkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294820; c=relaxed/simple;
	bh=KAmfhLdTesoKwy6AtHi7LV2hMMLV5K3N8PqiMkwKwS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0OVOv5GpF0txRc6PbKd3oOK83hoVGOcN2hWLdqU4Zvn6CMY9YT6UiHfPlqB30gLDUY2S/YD/0AK2yMxegmFLcWMXn8OO0ISzSUUx8R2AaGNeCtHEM2qHPwoaRpjYNQkK7RFr1VRqVUM0LJiPyYfUuBaWOXWKm2F0kVdaYaKW0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqNnRcBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqNnRcBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F08B1F000E9;
	Wed, 20 May 2026 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294818;
	bh=RoYlrdDlbyCWiIS/Z+dfPnb1bTcm8AcUdBjJ9j0z2bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqNnRcBJmJiLVyijXRhqHXrgpPSFgO8ry/1UCprg/AHnTzNe13jSaKg/UCKHhs8lK
	 2MK/52h7OvXaO8RZ7S5+8QIGZBh/Ri92ZtMnpmJ7OXtYFFATf9PWXOXzcB7U4n+NGA
	 Y+exHrNalGZxgA0wnHFRtBqv6S9hUp7wNfBV0fBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0167/1146] bpf: Propagate error from visit_tailcall_insn
Date: Wed, 20 May 2026 18:06:57 +0200
Message-ID: <20260520162152.069758235@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 6bd96e40f31dde8f8cd79772b4df0f171cf8a915 ]

Commit e40f5a6bf88a ("bpf: correct stack liveness for tail calls") added
visit_tailcall_insn() but did not check its return value.

Fixes: e40f5a6bf88a ("bpf: correct stack liveness for tail calls")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260408191242.526279-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0507df13fe2d6..2949cdc7565f7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18894,8 +18894,11 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 				mark_subprog_might_sleep(env, t);
 			if (bpf_helper_changes_pkt_data(insn->imm))
 				mark_subprog_changes_pkt_data(env, t);
-			if (insn->imm == BPF_FUNC_tail_call)
-				visit_tailcall_insn(env, t);
+			if (insn->imm == BPF_FUNC_tail_call) {
+				ret = visit_tailcall_insn(env, t);
+				if (ret)
+					return ret;
+			}
 		} else if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
 			struct bpf_kfunc_call_arg_meta meta;
 
-- 
2.53.0



