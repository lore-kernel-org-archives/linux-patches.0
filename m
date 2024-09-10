Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D157143880;
	Tue, 10 Sep 2024 10:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964129; cv=none; b=F31C9H5NoPa86UTi/TPoiQmuybVbZNxfMffAT3vkc2dnmafaNhX79ypS5WZyz6h7LQP4z6dArtMrFbl9jhvx8A7YST9K+/ZCbnPw3GXY7X2KJSsJSCgcZiLG44VoXWMrOjuLS/uYLEBHx1vS3n/6gfTHeusZ6rBTbozDdUYYWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964129; c=relaxed/simple;
	bh=9NarNk/SDvTNqFjRN9VmvCP6D/igQWU+M6oaQkWRfBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTOl5PAex4VjcM4uSgrn5ECx+99N/I659A0eXA9yMqoeLQxjgcCEvzQCEqiZ8GAiiipyg200SmaP0T/kq/9a1omS7rFw2x20LyqnBYWGiYJi5V4XsnhB/YhpHYwOC7JAEULuIs58dUQmkmg/9cjEhoJNaGR0Nn4xXjb+YIxnRJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkaLFNXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkaLFNXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65B5C4CEC3;
	Tue, 10 Sep 2024 10:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964129;
	bh=9NarNk/SDvTNqFjRN9VmvCP6D/igQWU+M6oaQkWRfBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkaLFNXR/yX/9FqTSgeCPT/XxRRIVpdiXg1ImwbzJiYuHnfBx9fa9FpZA7eDWxosW
	 5EAOvoC0LakK17atzN7ba08aA2ke5GqJSvZ83Insh3K2Cx2z3SUKObmUrpTlasEomI
	 1rHpQpPMK6MIy5QQicY43fNhQWiq/xffaaRRGvDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/269] riscv: kprobes: Use patch_text_nosync() for insn slots
Date: Tue, 10 Sep 2024 11:31:04 +0200
Message-ID: <20240910092610.938681545@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit b1756750a397f36ddc857989d31887c3f5081fb0 ]

These instructions are not yet visible to the rest of the system,
so there is no need to do the whole stop_machine() dance.

Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://lore.kernel.org/r/20240327160520.791322-4-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/kprobes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index 2f08c14a933d..fecbbcf40ac3 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -28,9 +28,8 @@ static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 
 	p->ainsn.api.restore = (unsigned long)p->addr + offset;
 
-	patch_text(p->ainsn.api.insn, &p->opcode, 1);
-	patch_text((void *)((unsigned long)(p->ainsn.api.insn) + offset),
-		   &insn, 1);
+	patch_text_nosync(p->ainsn.api.insn, &p->opcode, 1);
+	patch_text_nosync(p->ainsn.api.insn + offset, &insn, 1);
 }
 
 static void __kprobes arch_prepare_simulate(struct kprobe *p)
-- 
2.43.0



