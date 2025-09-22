Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AC017A2EA;
	Mon, 22 Sep 2025 19:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569521; cv=none; b=iR/XdnJDlEx244Pcf954u5ZTAFQijLA8NQPC/UiY0efgKzl3+5QgXeevvULGWoAy5PfPVzPoJVlRuMTLfrYHiJqswlQbQXUSbyQk7M1Mp+yoaMtuah1xMppKUudFowvGSUPpWv/EqiiW8+JcFMd2zu4DZdyHUC7p+66HtWY5Krs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569521; c=relaxed/simple;
	bh=pgPdMd11a+1F+nMT65s+HVrTnzTLQNXWRLnwY2Zl71o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iv2WWf/buZwS3wy0roowbeMVkGI1IjN3DLGYWWKwpwYMKuIhmtEvtsU2IarHfqSQUG2jgjpz9+tR6NK3n4Wy7jhJjwhT4kiryUMc/IJ0FjjechUBJn4f6WIzx9r7EPAnFGty62HLroJqNIuiSL8GFk79m36Cc/GJKy9xiETmyEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWZoWfjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWZoWfjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21879C4CEF0;
	Mon, 22 Sep 2025 19:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569521;
	bh=pgPdMd11a+1F+nMT65s+HVrTnzTLQNXWRLnwY2Zl71o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWZoWfjUDylo1juG+tsqmKlu2TkuLv/LA9/aP6xp8k2/ZDSspNRrz2zCagn9uf8oy
	 lYpbdrIqggC4XiGXajFTPqwGv/i7bYY0oCQnrhDWjIaAzEgewnp4NVo89YIhxldgvK
	 kcBhwm/sQ2CsdmmxOHkm16ZNI5ZzgoPgOv6S9Q/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Xi Ruoyao <xry111@xry111.site>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 25/61] LoongArch: Align ACPI structures if ARCH_STRICT_ALIGN enabled
Date: Mon, 22 Sep 2025 21:29:18 +0200
Message-ID: <20250922192404.244952599@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit a9d13433fe17be0e867e51e71a1acd2731fbef8d upstream.

ARCH_STRICT_ALIGN is used for hardware without UAL, now it only control
the -mstrict-align flag. However, ACPI structures are packed by default
so will cause unaligned accesses.

To avoid this, define ACPI_MISALIGNMENT_NOT_SUPPORTED in asm/acenv.h to
align ACPI structures if ARCH_STRICT_ALIGN enabled.

Cc: stable@vger.kernel.org
Reported-by: Binbin Zhou <zhoubinbin@loongson.cn>
Suggested-by: Xi Ruoyao <xry111@xry111.site>
Suggested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/acenv.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/loongarch/include/asm/acenv.h
+++ b/arch/loongarch/include/asm/acenv.h
@@ -10,9 +10,8 @@
 #ifndef _ASM_LOONGARCH_ACENV_H
 #define _ASM_LOONGARCH_ACENV_H
 
-/*
- * This header is required by ACPI core, but we have nothing to fill in
- * right now. Will be updated later when needed.
- */
+#ifdef CONFIG_ARCH_STRICT_ALIGN
+#define ACPI_MISALIGNMENT_NOT_SUPPORTED
+#endif /* CONFIG_ARCH_STRICT_ALIGN */
 
 #endif /* _ASM_LOONGARCH_ACENV_H */


