Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A560A34FF4E;
	Fri, 21 Nov 2025 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733483; cv=none; b=i9oswLl1k3s7SYLIRAF9kJhVWx7z7T2fwt5Y13Bw2YI5g0omLKybNoczP4M917WQfEEh8ZTBWpbweHvOt3NElmnPwmjWqoLArZ0+ekYLmbGcu+hZhC0JkfSMPfNpLAf/uGtsnyS5iqpEKxkk2OsqE2oAEPEn7Of/rlqXGdVQASU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733483; c=relaxed/simple;
	bh=4VwISEVh/2yIm4CHK7hs5r//CYRzGy+gKKGq0Ux/DeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frtRcn2I2Gnwl7er+im+TTEEpaw3y4lP+ce7D0groTPcZfns3zldjIy3S8fmq1D6tnvG0QXR94QBK23iL6cR0qZaeciF8RgDwlsGe4U39+n9mLFoFue5A00c9vdWytTgGzAhpoU0xZwJkDNcmFB0Dfr5psHc4tMoR1TuRT/12UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejm3sxE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejm3sxE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA15C4CEF1;
	Fri, 21 Nov 2025 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733483;
	bh=4VwISEVh/2yIm4CHK7hs5r//CYRzGy+gKKGq0Ux/DeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejm3sxE1iaPUpQCz28b7VLM6SeEOA8v0HOPJzfPMRuO+ATUDubEoNsQ3+3+dBPX/W
	 6iQpVyac3nKLJ+TZzIi1PToH9xiYlcjxorV77eH8BIr2RMS5pq4C4ZOr0M96b/byLZ
	 kT54GZRliyq/HbsFJv85Ij0mnRdnHMpnwwiyJAFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 483/529] LoongArch: Use physical addresses for CSR_MERRENTRY/CSR_TLBRENTRY
Date: Fri, 21 Nov 2025 14:13:02 +0100
Message-ID: <20251121130248.194476296@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 4e67526840fc55917581b90f6a4b65849a616dd8 upstream.

Now we use virtual addresses to fill CSR_MERRENTRY/CSR_TLBRENTRY, but
hardware hope physical addresses. Now it works well because the high
bits are ignored above PA_BITS (48 bits), but explicitly use physical
addresses can avoid potential bugs. So fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/traps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -1097,8 +1097,8 @@ static void configure_exception_vector(v
 	tlbrentry = (unsigned long)exception_handlers + 80*VECSIZE;
 
 	csr_write64(eentry, LOONGARCH_CSR_EENTRY);
-	csr_write64(eentry, LOONGARCH_CSR_MERRENTRY);
-	csr_write64(tlbrentry, LOONGARCH_CSR_TLBRENTRY);
+	csr_write64(__pa(eentry), LOONGARCH_CSR_MERRENTRY);
+	csr_write64(__pa(tlbrentry), LOONGARCH_CSR_TLBRENTRY);
 }
 
 void per_cpu_trap_init(int cpu)


