Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C00131741;
	Tue, 23 Jan 2024 00:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969420; cv=none; b=iUvEfgy1N4usjAcrtVTkRo/Ope7Juve/+PCwk4yncl/xFHjwySrJeN5napSP2Acrx6UuqNdI4Su41aYwmtPCSaPSmMuQDpzd46N1sxxMdYQPATvd/dN7Bc5ol8BgrFSajSsqoMj9+ixT9zj1VcWcm8xljv6nOLB8gUgt1kHh6FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969420; c=relaxed/simple;
	bh=FC+ddltwdPhEoGWlL+Jiwwmf6eOG5zzdAnCR+elJXws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAwNiodVrRweOvoxLHeMYIxsGtZow78razn5A01oT4FwGg1Ydib+VdvXMHTisi6TDDxS2SzJIeK9AwEHyhrI7jAWmBEKRrCTMH8tdIhmnwgdOsH9NKxAod5O/WJUmYtZR5yE0pr58+63ND/+BdGqlIOmTCXyvOugMEmP6NwsfVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ir3oUwyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ir3oUwyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7326C433F1;
	Tue, 23 Jan 2024 00:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969419;
	bh=FC+ddltwdPhEoGWlL+Jiwwmf6eOG5zzdAnCR+elJXws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ir3oUwyiBcdYsmdCf/Cj046wHjA7iLjaghJ4DDRCQE9UbAz2+LIyEYLuuHnOyMSpp
	 iYr926DfgGDHJ0RABI5duX1HAqN4AJCFBIWzAJyk2EM5qKRq8wydLRR2dt+ugOefRC
	 rmetC6HRChaGx+uvXUkfRLbgS1/coiNcG1j/ghpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 234/641] s390/bpf: Fix gotol with large offsets
Date: Mon, 22 Jan 2024 15:52:18 -0800
Message-ID: <20240122235825.251983845@linuxfoundation.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit ecba66cb36e3428e9f0c2362b45e213ad43ba8d0 ]

The gotol implementation uses a wrong data type for the offset: it
should be s32, not s16.

Fixes: c690191e23d8 ("s390/bpf: Implement unconditional jump with 32-bit offset")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20240102193531.3169422-2-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index bf06b7283f0c..c7fbeedeb0a4 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -779,7 +779,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 				 int i, bool extra_pass, u32 stack_depth)
 {
 	struct bpf_insn *insn = &fp->insnsi[i];
-	s16 branch_oc_off = insn->off;
+	s32 branch_oc_off = insn->off;
 	u32 dst_reg = insn->dst_reg;
 	u32 src_reg = insn->src_reg;
 	int last, insn_count = 1;
-- 
2.43.0



