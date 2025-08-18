Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43A7320CCC;
	Mon, 18 Aug 2025 12:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521469; cv=none; b=DdUvl8NT1dr25bhcuPnkHOlbwwzFslcEEcke3769TZ5GJ/SkseE5weFYrBaTERz9og/V+Tv/A4Vnd35W6jqklUTxRi/TLU/VwTPLmrBqUYqM4gp/4+gJNpA599Pi3ff9Kap8psfrY3btsl7gRDM8HG80tBGsgj1SkKjcvqHbLC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521469; c=relaxed/simple;
	bh=jEur6KgMpHpdIEF5RKPl4aJBWpC003sBMgHcWCa/q7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFLQj1BJnWgCA9ktZcVRMLEKvhyfzHuZP1qJlHqStJPui6HYmrSsepqoISDp4RYM+QPTD60l4jnTaYJ7YLCvb6PqPMjMo9V/8gk9kSys/aniQp56dHaMpC1GqUeGgZ4TH9zBkzW5sfZAQSd7F7wyG2z0Vw8+yUyCEIs2ZAdtZVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJc2akBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJc2akBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D280C113D0;
	Mon, 18 Aug 2025 12:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521468;
	bh=jEur6KgMpHpdIEF5RKPl4aJBWpC003sBMgHcWCa/q7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJc2akBH2m+7tv24FX2RbnMVqFCiBV+HjRO0BANSBTzwlgQM+uZRcbcuPT6cH/fJX
	 /ivbAycsOi8mkfOt2bVvpPrmoHZ/bywsYN3qpJD/prymb+KLopvU2Dbholz2uuBnSQ
	 ibOVZtO/wt/pIExwIO3/6WB0ayY8nDyLtNUNRLoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 029/444] LoongArch: Make relocate_new_kernel_size be a .quad value
Date: Mon, 18 Aug 2025 14:40:55 +0200
Message-ID: <20250818124450.022328591@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


