Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D182F1FE3;
	Mon, 22 Sep 2025 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570263; cv=none; b=FJ/VQ8L20MMso0nA7Vtdf1h5CDHI/HWtDwPNS8GYu1qs1lIV02xJm121WfH6rI1tmQdGeWgEsJDXoaqI2ZO7nbaMN+GptsgagoN3uo/KfQMTQYoXUyCRDFEXM+EJQcweld7RkKDM1NSQi/nUMj6IzqtcHKL3oH+gX8lTFbaVtUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570263; c=relaxed/simple;
	bh=1BgTo53oJGiDG5m7ln1ns7Tl6bv69DWtV5vUpyLK/V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFlpQK0ETzLe0Ck6ox7csUE+goeCdw+HVzXUlXgdXofpPMuEeOAeT8kifW3weOdANKb/46+TWlT7x7PKjtipLtNVSUwhCDC00mvEY+o+odaku0+oWFIVYi0X80JUasQcMoqc4A7YkuGGZGGUupY+kk9s9Fxm66d5dqv4jEfz/Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfbM0mMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfbM0mMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9B8C4CEF0;
	Mon, 22 Sep 2025 19:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570262;
	bh=1BgTo53oJGiDG5m7ln1ns7Tl6bv69DWtV5vUpyLK/V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfbM0mMzUWdPjuyAWj4ZOnA2I9iOJYZaR7z3eE+mD6I69JdLFm4+sBBOH1Kfr9Z8A
	 MEXZN1nP1mB9VDXLqnFevpZU0Se89s5xuLJ2x5LZDX9ES86tflfdqm0viNUYdMXZ06
	 ZL+J94vTEHMRuxQimFKdKxPWnjA3rBXS/uS1USyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <202321181@mail.sdu.edu.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 068/149] LoongArch: vDSO: Check kcalloc() result in init_vdso()
Date: Mon, 22 Sep 2025 21:29:28 +0200
Message-ID: <20250922192414.602064969@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <202321181@mail.sdu.edu.cn>

commit ac398f570724c41e5e039d54e4075519f6af7408 upstream.

Add a NULL-pointer check after the kcalloc() call in init_vdso(). If
allocation fails, return -ENOMEM to prevent a possible dereference of
vdso_info.code_mapping.pages when it is NULL.

Cc: stable@vger.kernel.org
Fixes: 2ed119aef60d ("LoongArch: Set correct size for vDSO code mapping")
Signed-off-by: Guangshuo Li <202321181@mail.sdu.edu.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/vdso.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/kernel/vdso.c
+++ b/arch/loongarch/kernel/vdso.c
@@ -54,6 +54,9 @@ static int __init init_vdso(void)
 	vdso_info.code_mapping.pages =
 		kcalloc(vdso_info.size / PAGE_SIZE, sizeof(struct page *), GFP_KERNEL);
 
+	if (!vdso_info.code_mapping.pages)
+		return -ENOMEM;
+
 	pfn = __phys_to_pfn(__pa_symbol(vdso_info.vdso));
 	for (i = 0; i < vdso_info.size / PAGE_SIZE; i++)
 		vdso_info.code_mapping.pages[i] = pfn_to_page(pfn + i);


