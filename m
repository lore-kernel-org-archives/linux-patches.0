Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA81C3B7B7B;
	Fri,  4 Sep 2026 05:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499132; cv=none; b=jWj8Hd6DEhba6ZSnOGO1wY1AfCh2WjFWOYSPEnrXRppTSNX+ao+HOiZoi22XAe8uuRdWsyKjC5jGcKbMxmPoi24eCJ4817oFjSJf68LVIWSU7BQhxrL/ufd3V67ORyMrSRqNe2qtxKmvqau0KmplCakWuEiyvSJvjN6YKIXh9CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499132; c=relaxed/simple;
	bh=bhumLwtWfAZCTEBydCggTupZT7Emt8hLGvHhOjsMZy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNtOqqGi81gCMgHB5ROKXSPLFD2UpGYGMmRLCjjX36ViRksnRn9Rmb3anP06O/CeGuYJsVuG+ZwsOrASUL2aWRYc0lpZvwXffZOtjSlZzMDfMRPgwcgDtvdNRkT2ue1rjCpHgAsNGn/eTsxy1+mJk6hhcvTrciL+KlQBZeXDYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NG6ODO4G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NG6ODO4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319B01F00A3E;
	Fri,  4 Sep 2026 05:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499131;
	bh=ePF5fq1Z29QwLnvxs5TusYWsm0m9vptuj5UCk4DK2Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NG6ODO4GK8QjsKKbofIm4Xcu2M0ltsKi0fQtn8+U157ZftrhJpTi/vpSlwFkzMs0W
	 6mvmTZ4S19TsA9MrwGCJ7rXiOnvB8zOcGVbOxQrqdZalGd1kCfGupj6QrvF+DSMAJi
	 5hCOPRzTNZoHYToGjJGDWBCM6M/q26JThXA6aJLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 7.2 307/713] ARM: 9477/1: Disable broken eBPF JIT on the Risc PC
Date: Fri,  4 Sep 2026 06:54:35 +0200
Message-ID: <20260904045810.719879102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit 7e8ee82e69fde9d589272ec5e6f702358903be1f upstream.

The eBPF JIT unconditionally generates ldrh/strh instructions, which do
not function correctly on the Risc PC because its bus is unable to
signal half-word accesses. Work around this issue by disabling the eBPF
JIT when building for ARMv3 (the Risc PC is the only currently
supported machine whose kernel is built for ARMv3).

Comments from Ethan Nelson-Moore:

 From LKML: https://lore.kernel.org/all/CAD++jL=0qYGoygUwGEXQL7C_ROnC7kfpRv8RA+H5tNWwYu+pQA@mail.gmail.com/

 The commit message has been updated slightly relative to the version on LKML to clarify that the Risc PC is not actually ARMv3.

Fixes: 39c13c204bb1 ("arm: eBPF JIT compiler")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -98,7 +98,7 @@ config ARM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE
 	select HAVE_ARM_SMCCC if CPU_V7
-	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
+	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32 && !CPU_32v3
 	select HAVE_CONTEXT_TRACKING_USER
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_BUILDTIME_MCOUNT_SORT


