Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D699230BCC;
	Tue,  6 Jan 2026 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722271; cv=none; b=Z6dLxGz26SPzKEnTq2RTHZu6sXFkiJ+8i1fUOXAH2IdnYXwFrstRby6vBGKmEaRPPmJodjLoV5pxDUe5kxj3Nqm0+YKL1lNUQPDWzdzeJ7ohSOk8urDPM/Sn8x/SDgRJzAfqZglMgnBSmI1zjkdr3AQothKNfGwi0YrBV2YBN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722271; c=relaxed/simple;
	bh=S0qG4aZhjSDVmQeFbyviEQL9YYpyQ/7aZ1GPPFVrUyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDngav9pIX1BABrRAHI1jjGBCxMMtOG90P8R7BFoewdshNCkSFidernEQXpsu86sFZ2Rza8sa1Bx6tqDDQYB7vEcu1RZi16pUPS3xpV68u83TmTTxDT9RYBZtaF5pp5u572LhZOeNuoo7TIccZv4tRnsn28JtvAskyRUFtIWRgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPZmhkRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPZmhkRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19B8C116C6;
	Tue,  6 Jan 2026 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722271;
	bh=S0qG4aZhjSDVmQeFbyviEQL9YYpyQ/7aZ1GPPFVrUyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPZmhkRR54g0qkA5xTqzd41hPLryal3XHZCcIV26/16keKOR+Z1PdcenUpS2hRL8c
	 6u+Jm3Ej+1jfqEBxjFbQct6r3xJdXJ7ojbtILJkEqOqn/GF/MRyylRyGU2JuE92s+6
	 a8DFwDgTKpimxleUVbsuL4320KatfSKGPpRqLNAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 197/312] LoongArch: Use unsigned long for _end and _text
Date: Tue,  6 Jan 2026 18:04:31 +0100
Message-ID: <20260106170554.951583325@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit a258a3cb1895e3acf5f2fe245d17426e894bc935 upstream.

It is better to use unsigned long rather than long for _end and _text to
calculate the kernel length.

Cc: stable@vger.kernel.org # v6.3+
Fixes: e5f02b51fa0c ("LoongArch: Add support for kernel address space layout randomization (KASLR)")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/relocate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -183,7 +183,7 @@ static inline void __init *determine_rel
 	if (kaslr_disabled())
 		return destination;
 
-	kernel_length = (long)_end - (long)_text;
+	kernel_length = (unsigned long)_end - (unsigned long)_text;
 
 	random_offset = get_random_boot() << 16;
 	random_offset &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1);
@@ -232,7 +232,7 @@ unsigned long __init relocate_kernel(voi
 	early_memunmap(cmdline, COMMAND_LINE_SIZE);
 
 	if (random_offset) {
-		kernel_length = (long)(_end) - (long)(_text);
+		kernel_length = (unsigned long)(_end) - (unsigned long)(_text);
 
 		/* Copy the kernel to it's new location */
 		memcpy(location_new, _text, kernel_length);


