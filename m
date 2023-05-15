Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301E6DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D42C433EF;
	Mon, 15 May 2023 16:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168506;
	bh=JWcZRUPsvHMoRCqK0OHPT4P3khOIfs6j1H4OYS3Yq90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+1jT6ydRxXg0w1N55YHyWzyds0n8A0gHurZRUFTp89ZNujbvu0CgkTWFqoWKgUBR
	 jWsv3YKEVh/mbl6f/c2fSuquWPbFaS5e32uwn9R2KlUkJ3vUf6+EzncwiWAL7Srag2
	 bbsiZwBwLab8nxgmDIqN1mf1p09PEce4SExU6lPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 072/116] parisc: Fix argument pointer in real64_call_asm()
Date: Mon, 15 May 2023 18:26:09 +0200
Message-Id: <20230515161700.679804786@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 6e3220ba3323a2c24be834aebf5d6e9f89d0993f upstream.

Fix the argument pointer (ap) to point to real-mode memory
instead of virtual memory.

It's interesting that this issue hasn't shown up earlier, as this could
have happened with any 64-bit PDC ROM code.

I just noticed it because I suddenly faced a HPMC while trying to execute
the 64-bit STI ROM code of an Visualize-FXe graphics card for the STI
text console.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/real2.S |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/real2.S
+++ b/arch/parisc/kernel/real2.S
@@ -254,9 +254,6 @@ ENTRY_CFI(real64_call_asm)
 	/* save fn */
 	copy	%arg2, %r31
 
-	/* set up the new ap */
-	ldo	64(%arg1), %r29
-
 	/* load up the arg registers from the saved arg area */
 	/* 32-bit calling convention passes first 4 args in registers */
 	ldd	0*REG_SZ(%arg1), %arg0		/* note overwriting arg0 */
@@ -268,7 +265,9 @@ ENTRY_CFI(real64_call_asm)
 	ldd	7*REG_SZ(%arg1), %r19
 	ldd	1*REG_SZ(%arg1), %arg1		/* do this one last! */
 
+	/* set up real-mode stack and real-mode ap */
 	tophys_r1 %sp
+	ldo	-16(%sp), %r29			/* Reference param save area */
 
 	b,l	rfi_virt2real,%r2
 	nop


