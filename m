Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB4C26ED41;
	Fri,  9 Jan 2026 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961031; cv=none; b=iyDmQSpAca3IweltEnuVXDmWJa0OZlc99B4uTpmJc3yibLRAFKahQS/R8nfxaN9cMkjY/Dp01l0EJktUZ511jRDznXjud+ZkJeWR0G8Usk2zYZKk0yaWvavt6P4w4X5I8FSWBZeReLk3G/7yRiZlFbygucknOrC749in8ePdLgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961031; c=relaxed/simple;
	bh=0TyJw2vKOjYtm7KE68OidxcBSSuYEvqJZpOmrTSAPEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5VQTGqdKSfAFMve6YpLeFXPDDwKasthhw48Yn9pZU1v6xN2OG9XscHWFhZjfF7Ip2GCuZWnGSaoSj/J+xUeCwuFLXs0235to8EZ/Ff2BjI3wyZJnkGclYNP/pNyemeXodLH35NKIdTQJ+gpksAjSsLu6KG2/vqYw3G4WmXVCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTAXY5Qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTAXY5Qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C0FC4CEF1;
	Fri,  9 Jan 2026 12:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961030;
	bh=0TyJw2vKOjYtm7KE68OidxcBSSuYEvqJZpOmrTSAPEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTAXY5QqhEE6MdKToP1vAnfeZbI3vfpyrgVnuTsU37IvMyR8NsvSEiz9EFl45DYHs
	 Qs/v03fYLWgSO++QAl1ZEfZVTfrJ953Re2+qhOxCqgsiqMR6RMUzK+vZ7VjoEbKGjt
	 0np8n4KgzKJ1PoF4uvDU/ihuatLJQSDMeuzV3+pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 611/737] LoongArch: BPF: Zero-extend bpf_tail_call() index
Date: Fri,  9 Jan 2026 12:42:30 +0100
Message-ID: <20260109112156.990365764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

commit eb71f5c433e1c6dff089b315881dec40a88a7baf upstream.

The bpf_tail_call() index should be treated as a u32 value. Let's
zero-extend it to avoid calling wrong BPF progs. See similar fixes
for x86 [1]) and arm64 ([2]) for more details.

  [1]: https://github.com/torvalds/linux/commit/90caccdd8cc0215705f18b92771b449b01e2474a
  [2]: https://github.com/torvalds/linux/commit/16338a9b3ac30740d49f5dfed81bac0ffa53b9c7

Cc: stable@vger.kernel.org
Fixes: 5dc615520c4d ("LoongArch: Add BPF JIT support")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -226,6 +226,8 @@ static int emit_bpf_tail_call(struct jit
 	 *	 goto out;
 	 */
 	tc_ninsn = insn ? ctx->offset[insn+1] - ctx->offset[insn] : ctx->offset[0];
+	emit_zext_32(ctx, a2, true);
+
 	off = offsetof(struct bpf_array, map.max_entries);
 	emit_insn(ctx, ldwu, t1, a1, off);
 	/* bgeu $a2, $t1, jmp_offset */


