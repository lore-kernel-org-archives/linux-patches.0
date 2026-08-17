Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83655427FB2;
	Mon, 17 Aug 2026 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976273; cv=none; b=qkY4PzoNeqC25CJBkhAhHpNERDix0VhrPTOt8trbyklrTrZFghSim/7ca1JDv38J8oNo4p7OQ9TlEC7D2BkidOfydmUVbiHk3aw5O6oeeBrED/f42k8AdsQ3u+lWabnI7CdWGn4IG0n3H1Lz3zJPMCAMGpbjBS5d+fgY1kU8hpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976273; c=relaxed/simple;
	bh=PORun8/rizgWfN1mi1waHmcMyN7rgaIksfzMg/vze6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzY6gfWQQ/oRnwqfY7/++/wqRKaM5i0DZjydN1kGXsN0pbV/ReG5Eoq9ot8zS/5nV7Bkf1gZux+e8sWlmuoHybG3tatFGWXZX868fmwrnSpzVUUZv5vhCXeBcVvXZ0iDs5RNQrrMkrR4H2u3AtXlb3jO9Nf9ltP2hqGTs3W3qkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQNjX5Uj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQNjX5Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBC51F000E9;
	Mon, 17 Aug 2026 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976272;
	bh=tNO9hvbxYKR2k0q0mp9w60F5mQsU8EgWd94ipN94oU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQNjX5Uj4Cppk3ql0Yuq24M4/W9+6zmwCzQNAPt0CyAE5Uwqqly/MVBCNL43pHmwg
	 oH/P/uGCwT/vyehDS8aSHXbJQOLSO0eMdLeYbRzEjnl87pyDJsHzihosMHmN11Zqu2
	 tIS7EXd1MWi3ryBX40DUwAeSEQo7zvPMIjmGmgHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Daniel Wade <danjwade95@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 315/389] bpf: Preserve pointer state for commuted arithmetic
Date: Mon, 17 Aug 2026 15:32:34 +0200
Message-ID: <20260817132551.267984417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit a4c6f804b44c5c790269b25e0e61cf4e9f117c86 ]

When scalar += pointer is handled in adjust_ptr_min_max_vals(), the
destination register inherits the pointer state from the source pointer.
Copying only selected fields is fragile because pointer provenance is
tracked by several bpf_reg_state fields.

Use the caller's temporary offset register to preserve the scalar operand
while replacing the destination with the full pointer state. This preserves
the frame number for PTR_TO_STACK registers and keeps parent identity
fields consistent.

Fixes: f4d7e40a5b71 ("bpf: introduce function calls (verification)")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Tested-by: Daniel Wade <danjwade95@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://patch.msgid.link/20260729-c3-035-public-bpf-v4-v4-2-8ee297e2346b@mails.tsinghua.edu.cn
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 058c05e7f144c..9866599171782 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6301,11 +6301,12 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		break;
 	}
 
-	/* In case of 'scalar += pointer', dst_reg inherits pointer type and id.
-	 * The id may be overwritten later if we create a new variable offset.
+	/* For 'scalar += pointer', dst_reg inherits the complete pointer
+	 * register state. Individual fields may be adjusted later by pointer
+	 * arithmetic. Callers guarantee that below does not overwrite off_reg.
 	 */
-	dst_reg->type = ptr_reg->type;
-	dst_reg->id = ptr_reg->id;
+	if (dst_reg != ptr_reg)
+		*dst_reg = *ptr_reg;
 
 	if (!check_reg_sane_offset(env, off_reg, ptr_reg->type) ||
 	    !check_reg_sane_offset(env, ptr_reg, ptr_reg->type))
@@ -6373,7 +6374,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		}
 		break;
 	case BPF_SUB:
-		if (dst_reg == off_reg) {
+		if (dst_reg != ptr_reg) {
 			/* scalar -= pointer.  Creates an unknown scalar */
 			verbose(env, "R%d tried to subtract pointer from scalar\n",
 				dst);
@@ -7232,8 +7233,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 				err = mark_chain_precision(env, insn->dst_reg);
 				if (err)
 					return err;
-				return adjust_ptr_min_max_vals(env, insn,
-							       src_reg, dst_reg);
+				off_reg = *dst_reg;
+				return adjust_ptr_min_max_vals(env, insn, src_reg, &off_reg);
 			}
 		} else if (ptr_reg) {
 			/* pointer += scalar */
-- 
2.53.0



