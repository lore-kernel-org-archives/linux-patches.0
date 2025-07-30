Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9486B255F5C;
	Wed, 30 Jul 2025 09:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869171; cv=none; b=Jtj96843Y//TtfEurQ23qSNpgupRkRao/OE+0V5VWMfI1xIXz7g/5iv7S/RDiWfo3wvXQqo2+BMccPk+ZNIh/b2NVfQpoXRC8SAwEmVjKPRzS/JUuPaznJlRwDOUxi/onJPe7wXV/m04vcWSQlTy8zNRAvPKb0l/AKkxUTWoLug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869171; c=relaxed/simple;
	bh=aWLeVLPL/3MwD9WupB8EKqrc4BRC3xIwndWrVNx3550=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wg0kCCZ8252ue+9F/Y3T8Ns6eJ+B7HeKRlnrw258tEPfXmufT6ZZRZ/A/ZSJ9WqHEhhRribvm7q2HUUgYDeR0XYaSoMwb2TaJFJVkyVCwUblqAnFNVwgwwe1ji9bbcIY6SjMbzHeTfwr22FWZukpx6Z9ncGLmqOQ1PNHpg8hpew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgCl2nmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgCl2nmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFCFC4CEF5;
	Wed, 30 Jul 2025 09:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869171;
	bh=aWLeVLPL/3MwD9WupB8EKqrc4BRC3xIwndWrVNx3550=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgCl2nmQbwrsklyHdLq2LuMZaoLa5yl4rLgbdhDAEPm+Z+fqERT60aPhBQ/qTyr3T
	 6dvYrkzGzKyXI9vMK51QNkVsoNMRS6f1QodyMo6+RYr4JVB7U7gJMcAMmms1ZArz8B
	 L2kOXaj+zdo84w4NDT93uu0fjc2ZpEOGNEOILgAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Landley <rob@landley.net>,
	Martin Wetterwald <martin@wetterwald.eu>,
	Nathan Chancellor <nathan@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.15 54/92] ARM: 9450/1: Fix allowing linker DCE with binutils < 2.36
Date: Wed, 30 Jul 2025 11:36:02 +0200
Message-ID: <20250730093232.841134980@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 53e7e1fb81cc8ba2da1cb31f8917ef397caafe91 upstream.

Commit e7607f7d6d81 ("ARM: 9443/1: Require linker to support KEEP within
OVERLAY for DCE") accidentally broke the binutils version restriction
that was added in commit 0d437918fb64 ("ARM: 9414/1: Fix build issue
with LD_DEAD_CODE_DATA_ELIMINATION"), reintroducing the segmentation
fault addressed by that workaround.

Restore the binutils version dependency by using
CONFIG_LD_CAN_USE_KEEP_IN_OVERLAY as an additional condition to ensure
that CONFIG_HAVE_LD_DEAD_CODE_DATA_ELIMINATION is only enabled with
binutils >= 2.36 and ld.lld >= 21.0.0.

Closes: https://lore.kernel.org/6739da7d-e555-407a-b5cb-e5681da71056@landley.net/
Closes: https://lore.kernel.org/CAFERDQ0zPoya5ZQfpbeuKVZEo_fKsonLf6tJbp32QnSGAtbi+Q@mail.gmail.com/

Cc: stable@vger.kernel.org
Fixes: e7607f7d6d81 ("ARM: 9443/1: Require linker to support KEEP within OVERLAY for DCE")
Reported-by: Rob Landley <rob@landley.net>
Tested-by: Rob Landley <rob@landley.net>
Reported-by: Martin Wetterwald <martin@wetterwald.eu>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -121,7 +121,7 @@ config ARM
 	select HAVE_KERNEL_XZ
 	select HAVE_KPROBES if !XIP_KERNEL && !CPU_ENDIAN_BE32 && !CPU_V7M
 	select HAVE_KRETPROBES if HAVE_KPROBES
-	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if (LD_VERSION >= 23600 || LD_CAN_USE_KEEP_IN_OVERLAY)
+	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if (LD_VERSION >= 23600 || LD_IS_LLD) && LD_CAN_USE_KEEP_IN_OVERLAY
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_OPTPROBES if !THUMB2_KERNEL


