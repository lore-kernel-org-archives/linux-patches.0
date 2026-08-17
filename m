Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCBA4399F8;
	Mon, 17 Aug 2026 13:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973992; cv=none; b=b9cEmE1+7/UqJatK/k3Fx1GDFtmPApspIjY6TZEwZnV68jNGuDy7AU/eiXJP58F+jSGH/2k1ijmB5+YwR8o49Cw3pvnCU+xLyV/9/R3q8ktiFhs/raSvyrz8Hus5tbhOea/9xHa3weazD3RK65TPHMdd+7h5su/qNJUjeFi99B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973992; c=relaxed/simple;
	bh=07D0eV8nPWanvn3MNAIQjDSup5aTP98Dr7Nx5JaEQJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1RcaDly0VqB8Prz232B+OhagqGmMGXC+A1z2kfc893ipA3WADq/ptz004jALzsjmU4G/P3XHgzRm6/nz2e4kxgDbE1wPCPZKEAcuPl8RWCtwf9wKgN+vZ0TDmj3YfiVP8fngCdU0277qsnvWATBixSvcCzKFApU6jAU+akGQkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnCWTCUM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnCWTCUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F0F1F00A3D;
	Mon, 17 Aug 2026 13:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973991;
	bh=9nUVz+ZfB3A9EIKDZcJvh24qSdP52h+dIg22v4hcpjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnCWTCUMT/9fcME72SOCt4+ZTvLZYNGYHYWAbpCuNdKtJuW85gVJNTA+q3wU3DiFf
	 F17pSXToiv/8xdR2BgzpNhRmIFtE73ZEo4l5T8qDizx2Quh1+WbGB6+YNbfHRQQI6M
	 GUSgCyLDey7EVH3z7lFk1VJq2ZBt+YWUPSrHkUVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Daniel Wade <danjwade95@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 052/271] bpf: Preserve pointer state for commuted arithmetic
Date: Mon, 17 Aug 2026 15:29:37 +0200
Message-ID: <20260817132538.875133694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 523f00e609e2b..ab88988d483d2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13837,11 +13837,12 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		return -EACCES;
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
 
 	if (!check_reg_sane_offset_scalar(env, off_reg, ptr_reg->type) ||
 	    !check_reg_sane_offset_ptr(env, ptr_reg, ptr_reg->type))
@@ -13893,7 +13894,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		}
 		break;
 	case BPF_SUB:
-		if (dst_reg == off_reg) {
+		if (dst_reg != ptr_reg) {
 			/* scalar -= pointer.  Creates an unknown scalar */
 			verbose(env, "R%d tried to subtract pointer from scalar\n",
 				dst);
@@ -15137,8 +15138,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
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



