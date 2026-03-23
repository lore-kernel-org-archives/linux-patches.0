Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711FE3B7B83;
	Mon, 23 Mar 2026 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278908; cv=none; b=FOFg5sM76JSdlnx3v9569eGIVdQ4y9IpbFePiFMmyuiCgn5Z5nRYfLpKZ3T7676no31q7pasaT3kyGpbSAVjU8l3k/0lhpReOPafkt0naQKpVxp+x26FAfZKTKtKzqHjFlXjaZKwenS2iTYw0uFBo7Rg/Xwq20jLY+fBZcUjZHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278908; c=relaxed/simple;
	bh=Ek6J78bQdF6tvH4psKo1n+4JVR7Ebz8QKjneSrYqT78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIo49yY/WmVKMVihmwNMTxvjcNuGb3xYUuAevGpnXsiNaLSle7RfdvQYxDNHEh8q3npkBkJ4LeZRO0P08dAqehqAmAYaX+9OzZp0PJaLYW+9BjIHDnY/66JcBPr3Fl/uoJQIUubxJfIy6l2CQVw42fw4lY66GQKw65wmfsySyxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqgaS7Uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqgaS7Uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4E5C2BCB8;
	Mon, 23 Mar 2026 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278908;
	bh=Ek6J78bQdF6tvH4psKo1n+4JVR7Ebz8QKjneSrYqT78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqgaS7Uz7XXZOQh9XSdvvNwlyJqz4nsYX63hDHDv5jtsXw3v2SZI8FdDFj5QddQNh
	 A0qDimStZxA4V071UEAvkBaHtIdphtbFpOKGCf+4tbcHoTeyJ8ZzN6mxBtlkJOkojv
	 IS/UzPJNDgzD3csxmeiQUcwqiztYE2XtihvVDmYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 455/567] LoongArch: Give more information if kmem access failed
Date: Mon, 23 Mar 2026 14:46:15 +0100
Message-ID: <20260323134545.238411310@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit a47f0754bdd01f971c9715acdbdd3a07515c8f83 upstream.

If memory access such as copy_{from, to}_kernel_nofault() failed, its
users do not know what happened, so it is very useful to print the
exception code for such cases. Furthermore, it is better to print the
caller function to know where is the entry.

Here are the low level call chains:

  copy_from_kernel_nofault()
    copy_from_kernel_nofault_loop()
      __get_kernel_nofault()

  copy_to_kernel_nofault()
    copy_to_kernel_nofault_loop()
      __put_kernel_nofault()

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/uaccess.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/loongarch/include/asm/uaccess.h
+++ b/arch/loongarch/include/asm/uaccess.h
@@ -196,8 +196,13 @@ do {									\
 									\
 	__get_kernel_common(*((type *)(dst)), sizeof(type),		\
 			    (__force type *)(src));			\
-	if (unlikely(__gu_err))						\
+	if (unlikely(__gu_err))	{					\
+		pr_info("%s: memory access failed, ecode 0x%x\n",	\
+			__func__, read_csr_excode());			\
+		pr_info("%s: the caller is %pS\n",			\
+			__func__, __builtin_return_address(0));		\
 		goto err_label;						\
+	}								\
 } while (0)
 
 #define __put_kernel_nofault(dst, src, type, err_label)			\
@@ -207,8 +212,13 @@ do {									\
 									\
 	__pu_val = *(__force type *)(src);				\
 	__put_kernel_common(((type *)(dst)), sizeof(type));		\
-	if (unlikely(__pu_err))						\
+	if (unlikely(__pu_err))	{					\
+		pr_info("%s: memory access failed, ecode 0x%x\n",	\
+			__func__, read_csr_excode());			\
+		pr_info("%s: the caller is %pS\n",			\
+			__func__, __builtin_return_address(0));		\
 		goto err_label;						\
+	}								\
 } while (0)
 
 extern unsigned long __copy_user(void *to, const void *from, __kernel_size_t n);


