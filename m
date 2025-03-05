Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3517E1C863D;
	Wed,  5 Mar 2025 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197751; cv=none; b=FxuXXAOkg7NSAD/IZrfEJ0mz2mceNXaVS4BpebD3fgK0o6wXC6SZy1GXNuZDHgl3z2Xk74y/HD4SE8qiMRdR/kJ2nuNTNlgdbIvPnl8qvVRX7P5p/Yfsf7n1quKsqHApSiNtIi6Cc/f5xcwFx+hF0v6fMKtsCwDCD1dZOrlmj0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197751; c=relaxed/simple;
	bh=KJfkzv60GgrPAagb56WoMAlzS2oj6BkP56DDn24AYFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaKtQaUaYKFUjswAjFq9658+YyiNHgAk5cxucfcPhNGLqBnpuhfY0areHJW297KvERPK1LWYKC2HXIBY5ACcHsnowdzN4mawIkM4jSBA1d9z5C+wr1pGs7osL5FDcBU4FsM4LKpANQiq42Y7YpeN4yfxKCNm0k1r5RiBr+c0qmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knsnuDZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knsnuDZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9BBC4CED1;
	Wed,  5 Mar 2025 18:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197751;
	bh=KJfkzv60GgrPAagb56WoMAlzS2oj6BkP56DDn24AYFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knsnuDZnQvQyk9LK5yxWTxcOyV47+noKX40Q0vH6viGwsP3rfiFffEn7cu2Cb0g4i
	 zV7qy7b3MC+CNmReHSPPe893ccHhJyNjuqoHBzt7NmZpogzXXOW/E+2ssZSxQN8ptL
	 n0rZlujpWjgmWmWdtH11E9MonP8A1559BRQVzMbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Zong Li <zong.li@sifive.com>,
	Andy Chiu <AndybnAC@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 088/142] riscv: signal: fix signal frame size
Date: Wed,  5 Mar 2025 18:48:27 +0100
Message-ID: <20250305174503.870325443@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

commit aa49bc2ca8524186ceb0811c23a7f00c3dea6987 upstream.

The signal context of certain RISC-V extensions will be appended after
struct __riscv_extra_ext_header, which already includes an empty context
header. Therefore, there is no need to preserve a separate hdr for the
END of signal context.

Fixes: 8ee0b41898fa ("riscv: signal: Add sigcontext save/restore for vector")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Andy Chiu <AndybnAC@gmail.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241220083926.19453-2-yongxuan.wang@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/signal.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -211,12 +211,6 @@ static size_t get_rt_frame_size(bool cal
 		if (cal_all || riscv_v_vstate_query(task_pt_regs(current)))
 			total_context_size += riscv_v_sc_size;
 	}
-	/*
-	 * Preserved a __riscv_ctx_hdr for END signal context header if an
-	 * extension uses __riscv_extra_ext_header
-	 */
-	if (total_context_size)
-		total_context_size += sizeof(struct __riscv_ctx_hdr);
 
 	frame_size += total_context_size;
 


