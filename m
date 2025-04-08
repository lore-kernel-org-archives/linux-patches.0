Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AB4268FEB;
	Tue,  8 Apr 2025 11:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112080; cv=none; b=rQ9qCNk4kryMH/GdKz8Fvhha6OC5bCwE5l9Ufoz3Hve2lkYjYmTKw7NQS4bQWG2kTiGZSNovPDXoOMkut5vr9/CczYoGoaPL+0z8ACzT/pSQ6KGtArZI4ch2cmvWicDqXRRhPT6nJEr9jTkfiTbQPBq3o/dawKUtMiMM3CUu3R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112080; c=relaxed/simple;
	bh=fgpgr6VBSY2AyNsqhptCLjji5GIAD66g1kPgVl3PKwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRcm5gnC6bhfzBfbPMWccwkTv9L3pbV9xN4UII7CY2vwbYSNuTtemXEwVaayVw8/asFzwt8sZVpeBzYhPbH1BkP6G1jt9oKvz1P1iJWrKv6F+59P+ykAV/LOxfn8sBwKYvyMM9W4q8B6ns9TV8cXU6fyeE4ZgF1oHqP16hj7Oa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6sPVkLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6sPVkLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1A0C4CEE7;
	Tue,  8 Apr 2025 11:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112080;
	bh=fgpgr6VBSY2AyNsqhptCLjji5GIAD66g1kPgVl3PKwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6sPVkLSFt1RnJyQCiVdpblYuH+ArhlW4p83+k6+A702FotH7IiJBpGLDnCriKvj9
	 5DcUtuvIdbONwH6X3UYb814rmJH3wlg2qBMFo5V1/QVE+gS27lDVScpzk0YpAax1Hz
	 hVpHdeT6QCuGI6IojaRnHyUTfZIhIubbQusA5xEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Li <vincent.mc.li@gmail.com>,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 667/731] LoongArch: BPF: Use move_addr() for BPF_PSEUDO_FUNC
Date: Tue,  8 Apr 2025 12:49:24 +0200
Message-ID: <20250408104929.781635558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 


