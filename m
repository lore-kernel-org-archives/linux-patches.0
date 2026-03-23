Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDC33AE1BD;
	Mon, 23 Mar 2026 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273796; cv=none; b=ZKHXQYhX8KVR1Hpv4xgSrwl5wg/855BhInToZgxFhwHGHILTas1GvKOK1qsBS5IH++HK0jWZi87W1odIFm6SPwmdXBzNupzN0CL6aRO6Luth0g1tMB/23T6kK/ATF/cZu6l9Jv5MxU6u8YshQfQACQXBbykP1kNb/NdmVyX85qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273796; c=relaxed/simple;
	bh=j8BXj6I4jfR9mJW7zXVTMfxk87DPgCkBf19WzTpBo58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6qFmUTb0i1G5ySW96vA4/vsKlkvDlTLZseBXBTLPei05ETeVNOCKvURJaWsEQ7dNJw5nMQJlHKj3dqxis8KSWANYAG2CrjnMQeNA0R60PvOl5KR2OrGyJ3OSfyt6YvhyQQBiNmqHg64E2QxA4eWqnYB2KS2FvMdSOAe/7zOQNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eku0kHCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eku0kHCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D02C4CEF7;
	Mon, 23 Mar 2026 13:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273796;
	bh=j8BXj6I4jfR9mJW7zXVTMfxk87DPgCkBf19WzTpBo58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eku0kHCEvDj9fi3tT7T8Qe9ZTF3TLaqpCwhmkZeS1bSbFVx1M9vII7ahUD43f29o9
	 5HKc1FQTfNpVSyrNqBc5cWJjkL88/XiEp69fGBUxTVWM7rCgDd6SxN4bvIqbpDZf3H
	 CQOfCXkP88P/vHcEV+UCEoyvKYUUKLM2ww8yfEqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.19 012/220] LoongArch: Give more information if kmem access failed
Date: Mon, 23 Mar 2026 14:43:09 +0100
Message-ID: <20260323134504.967409577@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -253,8 +253,13 @@ do {									\
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
@@ -264,8 +269,13 @@ do {									\
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


