Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDAC36A01B;
	Tue,  6 Jan 2026 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722375; cv=none; b=FwqRXD+ceyrc90YKp/yVm5iOQs8GHBqJJ6yDHKgmKtF/0BId2xz9L5u5cT18+n1/UYpMdCVj89nlKttPY2FUQzNMwj7XF6HBWQTwjbNfkkmwwm7giBB6srm9vIbgx9wPBhhoZwpb1bcmSDhrrogfEGPgbRtW1meox+FYv+qx/IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722375; c=relaxed/simple;
	bh=6DHn/Ry/HvxKA3GaTkY2tfNp8JRDS/J/WuFdBQJyDxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1TLr/y32Mafs/Nrij/YKhdeQO6216mOtND2maxPIO/zKB2wk3zEi205T/r3GeE30t9EetoWOiNh4BMnAGq4oQS3lv7eSnJHIe4E/jLrWSkb5ujXAmy7HlBv/NQRVZGTA7Gjw7WbUnKWygyr1IAy2fdV1IiY+/9VmPgRvEnTzTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzSaix36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzSaix36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23985C116C6;
	Tue,  6 Jan 2026 17:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722374;
	bh=6DHn/Ry/HvxKA3GaTkY2tfNp8JRDS/J/WuFdBQJyDxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzSaix36N6I9o/NkEyGG96y/erK1iVfMmEflb6ZIcBoKf3he6F7egZkx+B1udmybL
	 cXE74wdS9z8uj0LDQMb7zgzKKjVG3g1JBbrBh8O7KErb+pUL1gP7WEenZnL5YCer12
	 9Na0tja2PALzf8/w6/5nP5uqarlkCF/OJ3EmgQk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 246/312] LoongArch: BPF: Zero-extend bpf_tail_call() index
Date: Tue,  6 Jan 2026 18:05:20 +0100
Message-ID: <20260106170556.749777939@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -280,6 +280,8 @@ static int emit_bpf_tail_call(struct jit
 	 *	 goto out;
 	 */
 	tc_ninsn = insn ? ctx->offset[insn+1] - ctx->offset[insn] : ctx->offset[0];
+	emit_zext_32(ctx, a2, true);
+
 	off = offsetof(struct bpf_array, map.max_entries);
 	emit_insn(ctx, ldwu, t1, a1, off);
 	/* bgeu $a2, $t1, jmp_offset */


