Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16484190666;
	Tue, 10 Sep 2024 09:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961532; cv=none; b=BHT0We028ZjzCKcExpfZlIGSAljc7+XSNrCc9rCAC9lww/nB1VmHLUYkcznujR9FEozvIRE28WxDYNWBgk+Bb9D6kxNRuAJhNy+Ps/DUVcvyOHew3qqmlcnwqhYBXznAyythtdf3hiqr9PV2txyEmKS4I21/TTfgFn1UXCa17L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961532; c=relaxed/simple;
	bh=cRvwcxWPWjDIhDUKzLPkGhLWmjo9VuohF7EDfJVOZtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKH473tR7Ca0Upm0QrBPZBR3jvnG2jooA+/Fm5sGfia8s5+K2jxHwOPDMUZsn+Z8wCEexWborXnIl4HZFsTDKs2RJ7qu+NAkZsgRWsTKD9139VnMWGvKMIoCPwMlGF9mSfebFhzdz0QH0n+XbsD3IivE+N7QvNWu3jqN8R0RmPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vb/5wUEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vb/5wUEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E39AC4CEC6;
	Tue, 10 Sep 2024 09:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961531;
	bh=cRvwcxWPWjDIhDUKzLPkGhLWmjo9VuohF7EDfJVOZtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vb/5wUEO5R6ruxePzN2JuyB+7dh8U5r47NDFWYOYTD3V3PJh+fpUWuiMwiojJg9Ci
	 sIg2sw+LD1ZCEjIJtCo//mqwfMsT0KT3HbG4hW2hq5MlrqTp/VefBp6ndNgFEnB6pj
	 t7vKdy4dv0661HRo/dP9dWWUK+aBq3FRCmtQDo/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <hffilwlqm@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 101/375] bpf, verifier: Correct tail_call_reachable for bpf prog
Date: Tue, 10 Sep 2024 11:28:18 +0200
Message-ID: <20240910092625.640330219@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <hffilwlqm@gmail.com>

[ Upstream commit 01793ed86b5d7df1e956520b5474940743eb7ed8 ]

It's confusing to inspect 'prog->aux->tail_call_reachable' with drgn[0],
when bpf prog has tail call but 'tail_call_reachable' is false.

This patch corrects 'tail_call_reachable' when bpf prog has tail call.

Signed-off-by: Leon Hwang <hffilwlqm@gmail.com>
Link: https://lore.kernel.org/r/20240610124224.34673-2-hffilwlqm@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 521bd7efae03..73f55f4b945e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2982,8 +2982,10 @@ static int check_subprogs(struct bpf_verifier_env *env)
 
 		if (code == (BPF_JMP | BPF_CALL) &&
 		    insn[i].src_reg == 0 &&
-		    insn[i].imm == BPF_FUNC_tail_call)
+		    insn[i].imm == BPF_FUNC_tail_call) {
 			subprog[cur_subprog].has_tail_call = true;
+			subprog[cur_subprog].tail_call_reachable = true;
+		}
 		if (BPF_CLASS(code) == BPF_LD &&
 		    (BPF_MODE(code) == BPF_ABS || BPF_MODE(code) == BPF_IND))
 			subprog[cur_subprog].has_ld_abs = true;
-- 
2.43.0



