Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBDA3ACA5C;
	Mon, 23 Mar 2026 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273799; cv=none; b=bIXhTJFHg4kBmktQKpU5woaGJsZP77z5y6ndBouT7Vqau1qFpW6OslpMjecxAgCnTREJNIED/LtTPF1GXwa/tXojgRjzErrbBDKYmrlczBKEG3g0XpXltz544KwJR8AjuXI9EYC+R/g9NM9SH+U2W6i4UQvxVG0CW8orE+ZpIeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273799; c=relaxed/simple;
	bh=SZjYdjsZbBxNRwrZMmdExAxuL4taCotmXJcLSuWGG1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9oeD9KY3HfRm5EWCJ0/K3iYAHPvr4H+onwzDwRa0PcEyphdhb3FvE46qD/Mig498IURwYTFVPkOC11nfxZmXs9s+JFElbteyIYlLRGgwakwYUO8pHRaxRVKRxq7/50urEAQHH425R3ffJiuob42PD5mg9+PRjqD3T+3tXAcf7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7BVFfZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7BVFfZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169CBC4CEF7;
	Mon, 23 Mar 2026 13:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273799;
	bh=SZjYdjsZbBxNRwrZMmdExAxuL4taCotmXJcLSuWGG1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7BVFfZHoux3/P4nJzt94TTNddpBjXSaEBkVACa2wQH2UdJ6xMxE4C1IkqOi7vivD
	 /bMr6IqTytG12peoBfS3eYXoO3qezSN4TjeACcmMzwuG94Kwjjk4RfTGROnN2Icl2L
	 lsATr3xH16E/zUc98BtUZntiWzFf9eK/WOaIaSJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.19 013/220] LoongArch: No need to flush icache if text copy failed
Date: Mon, 23 Mar 2026 14:43:10 +0100
Message-ID: <20260323134504.996036612@linuxfoundation.org>
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

commit d3b8491961207ac967795c34375890407fd51a45 upstream.

If copy_to_kernel_nofault() failed, no need to flush icache and just
return immediately.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/inst.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/inst.c
+++ b/arch/loongarch/kernel/inst.c
@@ -246,13 +246,15 @@ static int text_copy_cb(void *data)
 
 	if (smp_processor_id() == copy->cpu) {
 		ret = copy_to_kernel_nofault(copy->dst, copy->src, copy->len);
-		if (ret)
+		if (ret) {
 			pr_err("%s: operation failed\n", __func__);
+			return ret;
+		}
 	}
 
 	flush_icache_range((unsigned long)copy->dst, (unsigned long)copy->dst + copy->len);
 
-	return ret;
+	return 0;
 }
 
 int larch_insn_text_copy(void *dst, void *src, size_t len)


