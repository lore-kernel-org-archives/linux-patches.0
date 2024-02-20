Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC047151CEC;
	Tue, 20 Feb 2024 21:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465339; cv=none; b=L1neZXxKGplukxTaOSpEPBSFjzGb4RfSjxHjTN2kcOtTVlhxzOHqubgpf3WQ6j8oxFOtnkm/9RXYsh7ScBp+w0sdcmG7y3mewUZeEM3EcwieMzrf+A5zy3QmLsV7rEe5W87u6NXSGk5rq0jv0awM4R7e4l6rYN6aG0VKmAM99F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465339; c=relaxed/simple;
	bh=sP1lHfK6YBeDW4ncwCFcCvlN2iVxq4ttRd1BB8wguAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TARlRXCX3QcU2b2J+R2wVEkDFS1gITsJy7gPRDAtbd9wSQOy4ca2CMpx647m6yZHsPhTvQELpXD86GZCePiU5/HU2D8M5YpeyJv2ki8BC9baEpg2LW1VIhRYWZlAwwUF8nWPVBcymt+3qbR2eGMZsJQwm5Njxb4V0Ps0OKLmesM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zz2qZr73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zz2qZr73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35025C43394;
	Tue, 20 Feb 2024 21:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465339;
	bh=sP1lHfK6YBeDW4ncwCFcCvlN2iVxq4ttRd1BB8wguAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zz2qZr73BcCqheT3QNk8Weoz2HICXojvV/LnEOOyTXWq1HJJ8QHWzRqNKGBMa5+0p
	 imZlt8/p9cE8kfEqnpfdOVFpW+Hs2MCczDFSXpdL/9hgbXUNjor17tfdUIYzhEC8gz
	 OZikc4Vhs7lIAE26wTxLhD3epAiDMwqSw7gtUtXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.7 291/309] LoongArch: Fix earlycon parameter if KASAN enabled
Date: Tue, 20 Feb 2024 21:57:30 +0100
Message-ID: <20240220205642.208995789@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 639420e9f6cd9ca074732b17ac450d2518d5937f upstream.

The earlycon parameter is based on fixmap, and fixmap addresses are not
supposed to be shadowed by KASAN. So return the kasan_early_shadow_page
in kasan_mem_to_shadow() if the input address is above FIXADDR_START.
Otherwise earlycon cannot work after kasan_init().

Cc: stable@vger.kernel.org
Fixes: 5aa4ac64e6add3e ("LoongArch: Add KASAN (Kernel Address Sanitizer) support")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/kasan_init.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -44,6 +44,9 @@ void *kasan_mem_to_shadow(const void *ad
 		unsigned long xrange = (maddr >> XRANGE_SHIFT) & 0xffff;
 		unsigned long offset = 0;
 
+		if (maddr >= FIXADDR_START)
+			return (void *)(kasan_early_shadow_page);
+
 		maddr &= XRANGE_SHADOW_MASK;
 		switch (xrange) {
 		case XKPRANGE_CC_SEG:


