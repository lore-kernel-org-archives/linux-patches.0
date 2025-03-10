Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A50232395;
	Mon, 10 Mar 2025 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626501; cv=none; b=T/sId2xxNPfY2Ue2D7VUByWi9guOZmagXvL4j8UCQnVG2RWLtK0BzEm+RIZ8jPFZH6EQycPvi0Q5VPB2Mrg+Wahj8hPd/auQbCCZWUDSmMjPJ0ZtN2U0+nChG/MrBqofye9ftGeEaDPqjFnIYl+r7wSxG/iJ5Yb//zC48ibmiIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626501; c=relaxed/simple;
	bh=xtWhock9YDlDBOc63q+3pEBnVKgVePN5D4+Yymsoo7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgh7Vhdt6/yTqp1b8iDmtinS4iuHbf9oM4mLl3EdQhhn8pmslP4tj62Y9zOSF6hDELW3V7srK764VfER4gXjphZ4mStZNuDA7Y4JaUwlf1qO/DIT55H+pXbI5fKDaBxeCBa/hA3vPvoB/fLn+Qjunwyocg2ZZbeZzeBIpkPP39k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1SuIgMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1SuIgMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12609C4CEE5;
	Mon, 10 Mar 2025 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626500;
	bh=xtWhock9YDlDBOc63q+3pEBnVKgVePN5D4+Yymsoo7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1SuIgMX46q/4n2Cv2ONdlJFjjxHEuPiKG8NAHvbQraz/8jvr5xUhYBFrKOY/IYN1
	 MtgqCYmo8b8irtCNRZ7xrPd/q/dVMBtMqf1wxlbehMtsc6loKEtXTNeEtGuPniZwi1
	 JiLugeUBxgXG+knyqei17jxi38oT8bNm6jldMIKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 014/207] LoongArch: Set max_pfn with the PFN of the last page
Date: Mon, 10 Mar 2025 18:03:27 +0100
Message-ID: <20250310170448.334836262@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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
@@ -387,6 +387,9 @@ static void __init check_kernel_sections
  */
 static void __init arch_mem_init(char **cmdline_p)
 {
+	/* Recalculate max_low_pfn for "mem=xxx" */
+	max_pfn = max_low_pfn = PHYS_PFN(memblock_end_of_DRAM());
+
 	if (usermem)
 		pr_info("User-defined physical RAM map overwrite\n");
 


