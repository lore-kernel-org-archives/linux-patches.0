Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C3E266591;
	Wed, 30 Jul 2025 09:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868658; cv=none; b=ITSDv5kE+mTylD5H4K6sqTT21Wkr1t7kzlrjwM9vET5L2vK2XojaAX5KnDH2BSI2SINL0Kg61mOELxaZBwt/M9XmCIqHD8JBfa1iQLqMNZOakq1ghjP61bY8EtpUwSvIOit4Sq5LACYmCI0EsE0uueCoZAmbn1tN5wGGwOd1T5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868658; c=relaxed/simple;
	bh=TuTbnI+maS747vZSfMV5VwtwnFmlPY/HDxbwY4Y0b84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqlyZqIzl0f8v+TgS2Fasdnyw0qEX7uy8TaLQ6EYXVSxkmR4yLFbc1BEaN0wXr0Tdww5epvOCMppwDfx4p69S3ozzjxbBO/14AH9AuncRtu/hNyo/CK3Oy20W19ymIPZGldNGFzEANF9vRU/mu0B52rl/Kln87TEBmtz1ECvjRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiFUUv1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiFUUv1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1957C4CEE7;
	Wed, 30 Jul 2025 09:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868658;
	bh=TuTbnI+maS747vZSfMV5VwtwnFmlPY/HDxbwY4Y0b84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiFUUv1TQzD6bQGPYLF4akN35KrxqQaaOEAYwobdRxfJYHGcmdIik+Wll6fi9Alj4
	 l61Q0DLo5VQ91jEgwJzX+urSds8zSp6XT1Q/stwi2v6dLrUw0pgG0zj5cPb1tBGNlC
	 v7hKtPE9T3270s+RvvBt+vYcSxull05tcwyYXA/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Landley <rob@landley.net>,
	Martin Wetterwald <martin@wetterwald.eu>,
	Nathan Chancellor <nathan@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.12 044/117] ARM: 9450/1: Fix allowing linker DCE with binutils < 2.36
Date: Wed, 30 Jul 2025 11:35:13 +0200
Message-ID: <20250730093235.273942496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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
@@ -118,7 +118,7 @@ config ARM
 	select HAVE_KERNEL_XZ
 	select HAVE_KPROBES if !XIP_KERNEL && !CPU_ENDIAN_BE32 && !CPU_V7M
 	select HAVE_KRETPROBES if HAVE_KPROBES
-	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if (LD_VERSION >= 23600 || LD_CAN_USE_KEEP_IN_OVERLAY)
+	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if (LD_VERSION >= 23600 || LD_IS_LLD) && LD_CAN_USE_KEEP_IN_OVERLAY
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_OPTPROBES if !THUMB2_KERNEL


