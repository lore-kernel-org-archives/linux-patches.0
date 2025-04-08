Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F1A26A1A1;
	Tue,  8 Apr 2025 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115341; cv=none; b=e6EbLuzk+bB913PFEtep4HszGSShbjGQnvlz90AP96x5m2bFUkW2jcOdoY+CgQUlHvg3CE3v3kj22s7TUd6nOPe4afHwsMrIGYXAtSEkHX7aME+5IlLSHhKdkwVoNC9G9huvwl9dRv0xmNYuEW2YJEyKbsmW/0d2TJxKJUK2CTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115341; c=relaxed/simple;
	bh=VX6ZS8ZM+b/zqopzf1Td5pl50EEor8gKkvT0er1z8AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFKrwhxgN5yZGhfF+sdZzXH8Z13gQ2pZzJrjR+4MeUsP66iqWeff8DZQ3ndTdVQ8IS/uksvQ53vDGTJ8M+5K9hBIDuRF5sCCin76gmLwB9nkcVf//dn9yVTbIqHpTBy6u0Z9GV1GFZbmLD2kJTU9bLgzBfHTUveb3ZvxlzthDQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6gIbVYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6gIbVYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B3AC4CEE5;
	Tue,  8 Apr 2025 12:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115340;
	bh=VX6ZS8ZM+b/zqopzf1Td5pl50EEor8gKkvT0er1z8AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6gIbVYBtOchDanNeuVgj0TEu06Bxoz84ww7ncCR+DGs7EgkZ29goMjxPM7aWo/1e
	 bZ0IhtNYwH1YQvtPmKOTuMUEIFKMBsD9xeoQR9iAC3pVzhjK0QZ+emq9eRVRPUA3T+
	 U2cBJ2Ny71h5kxanl2BTVoLvWwBrsBmAxvxqrYUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 439/499] LoongArch: BPF: Use move_addr() for BPF_PSEUDO_FUNC
Date: Tue,  8 Apr 2025 12:50:51 +0200
Message-ID: <20250408104902.176793002@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengqi Chen <hengqi.chen@gmail.com>

commit 52266f1015a8b5aabec7d127f83d105f702b388e upstream.

Vincent reported that running XDP synproxy program on LoongArch results
in the following error:

    JIT doesn't support bpf-to-bpf calls

With dmesg:

    multi-func JIT bug 1391 != 1390

The root cause is that verifier will refill the imm with the correct
addresses of bpf_calls for BPF_PSEUDO_FUNC instructions and then run
the last pass of JIT. So we generate different JIT code for the same
instruction in two passes (one for placeholder and the other for the
real address). Let's use move_addr() instead.

See commit 64f50f6575721ef0 ("LoongArch, bpf: Use 4 instructions for
function address in JIT") for a similar fix.

Cc: stable@vger.kernel.org
Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Fixes: bb035ef0cc91 ("LoongArch: BPF: Support mixing bpf2bpf and tailcalls")
Reported-by: Vincent Li <vincent.mc.li@gmail.com>
Tested-by: Vincent Li <vincent.mc.li@gmail.com>
Closes: https://lore.kernel.org/loongarch/CAK3+h2yfM9FTNiXvEQBkvtuoJrvzmN4c_NZsFXqEk4Cj1tsBNA@mail.gmail.com/T/#u
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -935,7 +935,10 @@ static int build_insn(const struct bpf_i
 	{
 		const u64 imm64 = (u64)(insn + 1)->imm << 32 | (u32)insn->imm;
 
-		move_imm(ctx, dst, imm64, is32);
+		if (bpf_pseudo_func(insn))
+			move_addr(ctx, dst, imm64);
+		else
+			move_imm(ctx, dst, imm64, is32);
 		return 1;
 	}
 


