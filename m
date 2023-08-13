Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071189443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4A3C433C7;
	Sun, 13 Aug 2023 21:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961722;
	bh=gDtTrRTXDaqvO08Q5dDjx0g3LOuNedSXkJiI9XSqb74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PduX5yzmb9nVHyyszhWB2H5hHOwheczXhy7+bB19PpNuM/AxGmtzNvd0lcw1aMM1f
	 +A26AhOW5gUx/B7YjlMewaPr1ripE8iWQmpGRyeCfsGbrkRlwLEIcQfJ4c0I03XvN0
	 5c9gitQvUYv3P50ny93MNyHu+dRFh53ZcVkF8kxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 01/33] sparc: fix up arch_cpu_finalize_init() build breakage.
Date: Sun, 13 Aug 2023 23:18:55 +0200
Message-ID: <20230813211703.973125098@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211703.915807095@linuxfoundation.org>
References: <20230813211703.915807095@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In commit b698b5d11a16 ("sparc/cpu: Switch to arch_cpu_finalize_init()") the
check for ARCH_HAS_CPU_FINALIZE_INIT was backported incorrectly to the SPARC
config option, not SPARC32.  This causes build problems for the sparc64 arch:

	sparc64-linux-ld: init/main.o: in function `start_kernel':
	main.c:(.init.text+0x77c): undefined reference to `arch_cpu_finalize_init'

Fix this up by putting the option in the correct place.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/252c7673-53ee-4c4b-e5ef-5bb2c0416154@roeck-us.net
Fixes: b698b5d11a16 ("sparc/cpu: Switch to arch_cpu_finalize_init()")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -12,7 +12,6 @@ config 64BIT
 config SPARC
 	bool
 	default y
-	select ARCH_HAS_CPU_FINALIZE_INIT if !SMP
 	select ARCH_MIGHT_HAVE_PC_PARPORT if SPARC64 && PCI
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select OF
@@ -51,6 +50,7 @@ config SPARC
 
 config SPARC32
 	def_bool !64BIT
+	select ARCH_HAS_CPU_FINALIZE_INIT if !SMP
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select DMA_NONCOHERENT_OPS
 	select GENERIC_ATOMIC64


