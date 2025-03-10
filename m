Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232FD232786;
	Mon, 10 Mar 2025 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627925; cv=none; b=nIjM6tqhlrSiwDvmQSqVnyFWM0ySTxK27kjEAgv9mRKlQz2kGPWCDelJ3y+kMa3P5n9BzeaMA62y0gak9hHN+7e4LwJ7Lb1wfVAVOH6sDl7IG2dxAqPIcBG4KjJv+rSqt+FCsbvunINW1VW8wTh7k5DjE8D3dQia21JJcXkrs1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627925; c=relaxed/simple;
	bh=FuYoNzOTqsOMaxo4FrreZBI3oXly7uiq82r/q9zLTaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQWoVtLTIIUblwyhc15GDDwK0UqflYTE2smxEpHXqG/dFLQHqJNUwUL2LOVbWxNA804utN6rq/26NSXQj75/PDjSLR/1EIszc8/NS/urLu9qjA2VP5YRAtbGQBNQlb+4RPdwzSr/PkvVTObetcigXK7JUrxkDTKBewndHNW7jPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mm9VMiPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mm9VMiPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5EEC4CEE5;
	Mon, 10 Mar 2025 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627925;
	bh=FuYoNzOTqsOMaxo4FrreZBI3oXly7uiq82r/q9zLTaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mm9VMiPxuUuETbn6xadeaF/Y82fIW1gU5Yd7Vj3yIND0FAZZhXGHnpHYsuLo3ytuk
	 MkH/qOf1tSByFsQsd2BwXD27INQEJvoMNC/42ro/Fbi1mj39XS6I7R3j6BuwwV0jG7
	 9ocrqP3ira6GQiJxzTNVLiB2ddb3NG0XeBOo/8Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 027/145] LoongArch: Set max_pfn with the PFN of the last page
Date: Mon, 10 Mar 2025 18:05:21 +0100
Message-ID: <20250310170435.833493470@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit c8477bb0a8e7f6b2e47952b403c5cb67a6929e55 upstream.

The current max_pfn equals to zero. In this case, it causes user cannot
get some page information through /proc filesystem such as kpagecount.
The following message is displayed by stress-ng test suite with command
"stress-ng --verbose --physpage 1 -t 1".

 # stress-ng --verbose --physpage 1 -t 1
 stress-ng: error: [1691] physpage: cannot read page count for address 0x134ac000 in /proc/kpagecount, errno=22 (Invalid argument)
 stress-ng: error: [1691] physpage: cannot read page count for address 0x7ffff207c3a8 in /proc/kpagecount, errno=22 (Invalid argument)
 stress-ng: error: [1691] physpage: cannot read page count for address 0x134b0000 in /proc/kpagecount, errno=22 (Invalid argument)
 ...

After applying this patch, the kernel can pass the test.

 # stress-ng --verbose --physpage 1 -t 1
 stress-ng: debug: [1701] physpage: [1701] started (instance 0 on CPU 3)
 stress-ng: debug: [1701] physpage: [1701] exited (instance 0 on CPU 3)
 stress-ng: debug: [1700] physpage: [1701] terminated (success)

Cc: stable@vger.kernel.org  # 6.8+
Fixes: ff6c3d81f2e8 ("NUMA: optimize detection of memory with no node id assigned by firmware")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/setup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -400,6 +400,9 @@ static void __init check_kernel_sections
  */
 static void __init arch_mem_init(char **cmdline_p)
 {
+	/* Recalculate max_low_pfn for "mem=xxx" */
+	max_pfn = max_low_pfn = PHYS_PFN(memblock_end_of_DRAM());
+
 	if (usermem)
 		pr_info("User-defined physical RAM map overwrite\n");
 


