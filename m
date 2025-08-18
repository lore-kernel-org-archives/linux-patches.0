Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216CD234984;
	Mon, 18 Aug 2025 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524708; cv=none; b=UtivTNDUT+d41CLvCrDxt42G/ysVQ7VMoz+6bfPQWxsImilKDyHCAA0UT+2ITxf59hwtf+gNg52h9ABrM7OKayXCvNmWnOx/QSHlGsJtugSAbkVXN2/JkK3L4KzCzObCkrAdWKt1srnwj72cu7Vf/HzBwQY/YI1zgA3cQa2d8G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524708; c=relaxed/simple;
	bh=qX0UV+6I1+IcFNAN/l29pzOrtmN4SdVMGhRdyoTg4Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQM5+APlvD7F8lWzj78c9IDjfKU0vXdQkA9kDDuGrZ6D4lLAHDiXOb72h8yzQpRasJ1A4KQZYz/5bts6FtBOLbzBsa0YfKu+13RJgl+8G/FYCaA1OTUFyIbXKLvfE+93btPl0uOLIXWDuq4IOY5dJ9jp1naDFAFwRlI8v3d872M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8WjF/hx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8WjF/hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F378C4CEEB;
	Mon, 18 Aug 2025 13:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524708;
	bh=qX0UV+6I1+IcFNAN/l29pzOrtmN4SdVMGhRdyoTg4Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8WjF/hxU5bf941vAlinB0GDiEMbn2Sd+263OAvLpbDH3jRRxRZAv+0vl2i3owo63
	 wGPLkzGXRlnU/SIfWxMTwAEx1eNe82hE6MeKiTyokwSY28cncwuFjle/iNddqdTGmi
	 77wDHgu1zU3i6z66uQWlF9RLpCnH74OuMdZO6bpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 038/570] LoongArch: Make relocate_new_kernel_size be a .quad value
Date: Mon, 18 Aug 2025 14:40:25 +0200
Message-ID: <20250818124507.281496392@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit a1a81b5477196ca1290b367404a461e046e647d5 upstream.

Now relocate_new_kernel_size is a .long value, which means 32bit, so its
high 32bit is undefined. This causes memcpy((void *)reboot_code_buffer,
relocate_new_kernel, relocate_new_kernel_size) in machine_kexec_prepare()
access out of range memories in some cases, and then end up with an ADE
exception.

So make relocate_new_kernel_size be a .quad value, which means 64bit, to
avoid such errors.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/relocate_kernel.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/relocate_kernel.S
+++ b/arch/loongarch/kernel/relocate_kernel.S
@@ -109,4 +109,4 @@ SYM_CODE_END(kexec_smp_wait)
 relocate_new_kernel_end:
 
 	.section ".data"
-SYM_DATA(relocate_new_kernel_size, .long relocate_new_kernel_end - relocate_new_kernel)
+SYM_DATA(relocate_new_kernel_size, .quad relocate_new_kernel_end - relocate_new_kernel)


