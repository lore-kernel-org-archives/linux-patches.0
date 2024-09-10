Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1843119E80F;
	Tue, 10 Sep 2024 10:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963110; cv=none; b=uGxWXHonMbtQHSLCLCH06OTlXNAQ2BZlQYU+arl0iWGBQSUe36faqtsM+EJ/AT1k13r4bxcwg6XAO2VoBQoB+y8NW7beBRU4gZhQwyC+C5aDDqFxBm0YRs1Caxa+1ptsw9NYVZflxuhL28rurCueLfJOoh9LYsruXtfpmuSkJy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963110; c=relaxed/simple;
	bh=jCElq4Dg1bTLdDjFN66NfanFsSARB+WP82RTPerkUmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRze/4JsYDSv3G/aR044NyjR3IB22F6QS/bYJZxw/4h2/YzwIpfdF5VBVLghNFn9vuXpbEjs45QVN2PyYduc/WItMSR8H0EuMSiNY1ADvF+Dq2ocJZmTTyDLSs1Hf7XfWTd47+gZ76/3eiz8WiVzFjBxH9w1T2MTHYosvcjkmVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYYjYf7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYYjYf7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B78C4CEC3;
	Tue, 10 Sep 2024 10:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963110;
	bh=jCElq4Dg1bTLdDjFN66NfanFsSARB+WP82RTPerkUmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYYjYf7gXYee087ko3gkaCWrC5oz71JIiyGPE8NMynVuz0HndA5AyZOCGtpzKZGbk
	 tSuOLo5SITVpv0+IWV5sxkZulFVHcsFjhq8yRicdrtV6x20OSxrv1aswrhRJ2Yilkf
	 Sa/0jjeSbNjxajP1LaliBwLJy8QpxPUqnF6LrWFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	"yang.zhang" <yang.zhang@hexintek.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/192] riscv: set trap vector earlier
Date: Tue, 10 Sep 2024 11:32:16 +0200
Message-ID: <20240910092602.617994109@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yang.zhang <yang.zhang@hexintek.com>

[ Upstream commit 6ad8735994b854b23c824dd6b1dd2126e893a3b4 ]

The exception vector of the booting hart is not set before enabling
the mmu and then still points to the value of the previous firmware,
typically _start. That makes it hard to debug setup_vm() when bad
things happen. So fix that by setting the exception vector earlier.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: yang.zhang <yang.zhang@hexintek.com>
Link: https://lore.kernel.org/r/20240508022445.6131-1-gaoshanliukou@163.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/head.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 4bf6c449d78b..1a017ad53343 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -307,6 +307,9 @@ clear_bss_done:
 #else
 	mv a0, s1
 #endif /* CONFIG_BUILTIN_DTB */
+	/* Set trap vector to spin forever to help debug */
+	la a3, .Lsecondary_park
+	csrw CSR_TVEC, a3
 	call setup_vm
 #ifdef CONFIG_MMU
 	la a0, early_pg_dir
-- 
2.43.0



