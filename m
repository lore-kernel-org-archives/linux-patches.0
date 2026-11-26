Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704346;
	b=uETO/fLgES9D/4OZHGMioj5+Rd1gPqlQHtaU7rf5UfKC8j5nucZ0fy8Cx0YnbJFnrtRq
	 hv6N6GdDJ5iqCNUVo5lAFXi0gHHv/UpGUqJk8KhqiPxPypxBZTxuJMyCGt2CQi5RJ8PWM
	 u9Y3YGR6puOO7FG7BxHiTyoN+/sH2BO/T5Byvn1zePmd6zkarAuggUjZO5ogpVtImtNN+
	 rpaTnHoMhHtfj9Ea4QH/5vSKobV3ar43RQsbS8TPH8lvMQQrZBuJFitsVo9j2cpCutKeW
	 APL+f9mB4DnmQal44ZA5bZu85rgmnklIpmiIFOGQbKV0t+fBnfd2vrLQGAKf4W+Ts9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vh4XLFQqpFY0R+MkhyWvn59t6zRXDTR3NlgjmntuZ2Y=;
	b=h5tS6laHtJu7BTOi5WuVhh3SbuYjz76AKJM5jHaFZe890XtmgSmc2u5h0lL5N4JLpVtT
	 fvWa227UEe5xiOMK47jZQE6iAUKwY28vHYLG5N758ZRhvUKPOv8l+CKMX4ffvbrIhnpa1
	 KerrRIxMHO1i6f/FSOSrXBNEB2qyCFYuNBv0zf8nPqL2mtZUpIha1/ZC35/FCTJE1OkmU
	 np3+IkCu6z4MOSOaI8wTJ2aX9fXudODHRVCeMD8KpkmFgwWjeMkCEqBhX/6F1fRas2kLm
	 rtNnggvhDbZaInQdN+nUIofkXDRZAiOhO9w8z2bPYkNHQAEG4IEMEY77i+PyYXsveCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taAPhHwO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F022606A31E;
	Thu, 26 Nov 2026 14:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taAPhHwO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1D91F000C4;
	Thu, 26 Nov 2026 14:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704346;
	bh=Vh4XLFQqpFY0R+MkhyWvn59t6zRXDTR3NlgjmntuZ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taAPhHwOrm+AWfecq9/0XuGTbohwcmA6KdqqPVrNim/uhGcrRLxnELsbtnLNFnprK
	 3GXjE94wrWEMrY4j7sryHR3mck16C3CPtbYCdyY6vkUfuE39+9gOreNayJ7XpOnlle
	 +ObAEryD7Q0rHiPh4Wq0MJWEzufyyMK3IO8Zb6Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/265] MIPS: Avoid dead code/data elimination when using recordmcount
Date: Thu, 26 Nov 2026 15:37:00 +0100
Message-ID: <20261126143611.319751032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 255d9dbd936f7db8b963e82429f6e57cd9d48999 ]

CONFIG_LD_DEAD_CODE_DATA_ELIMINATION builds with -ffunction-sections,
placing every function in its own section. recordmcount refuses to use
weak symbols as section bases, as a strong definition could override
them, so a weak function alone in its section, such as the generic
pcibios_fixup_bus() stub, breaks the build:

  Cannot find symbol for section 88: .text.pcibios_fixup_bus.
  drivers/pci/probe.o: failed

MIPS always records mcount locations with recordmcount, so this hits
any config with the function tracer and dead code elimination enabled,
e.g. malta_defconfig built with LLVM=1.

Only offer dead code elimination when recordmcount is not used, as
powerpc does since commit f8b2336f15f3 ("powerpc: Avoid dead code/data
elimination when using recordmcount"). In practice this makes it
unavailable together with the function tracer on MIPS.

Fixes: c0436b503591 ("MIPS: Enable dead code elimination")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 57839f63074f7..5156f13ce3047 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -72,7 +72,7 @@ config MIPS
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
+	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if !FTRACE_MCOUNT_USE_RECORDMCOUNT
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_OPROFILE
-- 
2.53.0



