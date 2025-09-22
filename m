Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB0A2F0C52;
	Mon, 22 Sep 2025 19:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569941; cv=none; b=VZJWb4gr9KLvFy++TliiE+2aTrWRS2sJ6u2QzX/vGbdu2Ipp5f9T5NJpJgTUsve8Py3RCBj+G9UQq5nUYPANYp++/ql9qUxKaCzuhiPgnA4b2RKyaDP7YoxCpOkVP7gvk3W4mQWRzC3jAbvZUWboy4Qx/fLy/wVGgtlH8sEG9Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569941; c=relaxed/simple;
	bh=1jty8S9YkvmHXl6nL/JCHBPIjIYzwihWhdzy38nC0do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlwMgrEDG/AQo//TzSzws9xR/t61q1ztk/pGvVL2klHGlmPiZ9lbp34a4Hrt2eg2RMFRTNK/KuWnwMNCTNVo5KkAUbJPt0yYveiVR4bun/YKliyxrEqOfltTw0M2FWPlodwUZo+2KXSvwNF3ed8ckB8skWQ6FwW4RqimKLr6NpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vN8Ipcbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vN8Ipcbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0940DC4CEF0;
	Mon, 22 Sep 2025 19:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569941;
	bh=1jty8S9YkvmHXl6nL/JCHBPIjIYzwihWhdzy38nC0do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vN8IpcbpXiXgVAPq2kyKm2j1ojO8ytJhigituCpiXwtXhmlh/zotN20iE/XUUvTtW
	 ZRkdFXQpu35hlC13B0WAC99b+cODZpX7U60B+trJymicSYj2JQAUUFlJ5CyjOErRAM
	 FnlebK1rlIg2RAQ7i8jPqHHg/M7W4cCT1GLdYVVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Xi Ruoyao <xry111@xry111.site>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 049/105] LoongArch: Align ACPI structures if ARCH_STRICT_ALIGN enabled
Date: Mon, 22 Sep 2025 21:29:32 +0200
Message-ID: <20250922192410.201780057@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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


