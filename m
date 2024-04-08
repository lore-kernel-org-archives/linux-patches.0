Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6587C092;
	Mon,  8 Apr 2024 13:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583978; cv=none; b=kmHy+SH7RR23ZUdzuRar8Ezxg6S3juBVkv4Ny4Ncj69qb2Ei1LyWa4t986W9KjkpuGRyH85P+JCgfFbXhL/2BUFvXrwh+jZ/T5N9oioLGfqQI9Mbl3qmjA+5h16oce8bSBVUifndO7ZkoOUebbRyJt9b7ZhPyJbyTArR1V89y6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583978; c=relaxed/simple;
	bh=T4996eeippnpCifAlxMWQ2+lkfbwGcmrawYEsuN19Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtOgXIOpXjzLkH5qSRLRM7a1OVrIsJXlob//WkIib4e/stqVOuXR8ny6/TgIGxGGOJecs+yNbHR+jtB/k2lTuMBlFArg25L11PqoE0oyzqjgGAikWbDU8LL5IF8R84/ncidQxuNGO1omYaDEhrHDJu8xN1M2DcGu9aKgdg4JHwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qx0VNV5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qx0VNV5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E967FC433C7;
	Mon,  8 Apr 2024 13:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583978;
	bh=T4996eeippnpCifAlxMWQ2+lkfbwGcmrawYEsuN19Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qx0VNV5cnSVZ/2ivZx9/cVwAFd0J4+bwYc7tDCeY40INQaCScxQ8h4rZCj7V7e+Ke
	 uYKANwk9f9rnhdoy7IfHBnU50VusCzPCKv6Re1GXKc0g+DSz6Ysafx0btFqac4LbNO
	 jNcPykJ2fUjohekKOIkSIyhHDWxbVEERBxK5ikOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.8 241/273] riscv: Fix spurious errors from __get/put_kernel_nofault
Date: Mon,  8 Apr 2024 14:58:36 +0200
Message-ID: <20240408125316.918309300@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

commit d080a08b06b6266cc3e0e86c5acfd80db937cb6b upstream.

These macros did not initialize __kr_err, so they could fail even if
the access did not fault.

Cc: stable@vger.kernel.org
Fixes: d464118cdc41 ("riscv: implement __get_kernel_nofault and __put_user_nofault")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20240312022030.320789-1-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -319,7 +319,7 @@ unsigned long __must_check clear_user(vo
 
 #define __get_kernel_nofault(dst, src, type, err_label)			\
 do {									\
-	long __kr_err;							\
+	long __kr_err = 0;						\
 									\
 	__get_user_nocheck(*((type *)(dst)), (type *)(src), __kr_err);	\
 	if (unlikely(__kr_err))						\
@@ -328,7 +328,7 @@ do {									\
 
 #define __put_kernel_nofault(dst, src, type, err_label)			\
 do {									\
-	long __kr_err;							\
+	long __kr_err = 0;						\
 									\
 	__put_user_nocheck(*((type *)(src)), (type *)(dst), __kr_err);	\
 	if (unlikely(__kr_err))						\


