Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B78E258CD9;
	Mon, 23 Mar 2026 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282901; cv=none; b=ED7zAp+vMQBKnt9k3rY7vB5LnKUTXAZIyaYjEygk9fA07KQH57IOYo+U/4T/m+zjYWGrjbhsxJ9rohLLRR8eT/2xq9RGmYDt+roqbe1+RTCz53qqMEKq4SB9X+eOKVJxWhjUw99o+ratfKgnf8RFSZb8PdZ4xI4YKhPplKbaAxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282901; c=relaxed/simple;
	bh=vDBsOZGF5t49lYMPhsj3Kcl4NI6bj8sxEb1SdS3ppJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kc4CMUh3QZIYZP/tQn0iojiS9+w36RDcgZ/QtVEXgtv8687Ssi0SChfJhtO5RGrLYZ/HgudMtOJMalNLEFkQ2d0JrDrw7BUcWlmRlkCXCAUvjjigGFQZj0b0lLU4t+jBqo4BToRDrWFL3A7u29h71rxzFPAjvnzpmy5ZPgAGC9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+z8xEYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+z8xEYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D266C4CEF7;
	Mon, 23 Mar 2026 16:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282901;
	bh=vDBsOZGF5t49lYMPhsj3Kcl4NI6bj8sxEb1SdS3ppJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+z8xEYkYDIwjCFToum69CPm4djei9Q+08Gm0kOVwbq6W3BCJCnEohdpwOoh10RuU
	 GNXuGxM0LnFlxIyvUnJcKrVIL37uRNo7tYEFhDniuZ5bx10Z2eIN7iY0D9jBIQzZUu
	 wokvtOpnRR/tEfemuu6wuZ1roaqFvoWR5lW/M1UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 284/481] LoongArch: Give more information if kmem access failed
Date: Mon, 23 Mar 2026 14:44:26 +0100
Message-ID: <20260323134532.035113623@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -209,8 +209,13 @@ do {									\
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
@@ -220,8 +225,13 @@ do {									\
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


