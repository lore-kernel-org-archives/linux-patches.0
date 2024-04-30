Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810028801;
	Tue, 30 Apr 2024 11:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475899; cv=none; b=OENESs1Xa6F0ntw12bMtWbLfQO2GOPvy7zQ8sdto1XuyYzBpbAMakqisNI5osZeOXe7k0SSK/coc0TS7fK5QGvANBaibrj3KTxlrlsDvHDRn8W5aMruWOSOnqV1M7230J9s1+YDUsxx80nCwooJrtZih83ZRes3YwoTFRcC2bBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475899; c=relaxed/simple;
	bh=MJByaQLO9ThzVfG8Qu+Zf6i520tvZ9d611LOwJ+pD9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y24grwsOLxEXyDUcDmWy3EKUS6xN00pSqaZqKYDfdh1MtEcequCACMu43V9Jn4gELpJ4u3TFQzzs+tLlFIxdBX5HoKpAW6SbXWT/pO/G8pKp1aDB37H31gkDjtoGBcKjZiHxS32t/00e1G+l9PuoVytHOfe2UbQ8Q2marNVMsQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fp4N618h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fp4N618h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CABC2BBFC;
	Tue, 30 Apr 2024 11:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475899;
	bh=MJByaQLO9ThzVfG8Qu+Zf6i520tvZ9d611LOwJ+pD9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fp4N618hR6S2/bBFJYtgSMK2J2v1pkGff/D+U0YLfD2t8FH/vk7kSLFz37lXLOU7a
	 QB6CRjQDjJJAcof6uKkyY3INArklY15GEoefVH1jvF2bsmFBg0EL2Mb9XTgtGC1LEG
	 y82e88k0mj57qeOV2lMOWIEeLAIrfi+AIErm8ULo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 52/80] x86/cpu: Fix check for RDPKRU in __show_regs()
Date: Tue, 30 Apr 2024 12:40:24 +0200
Message-ID: <20240430103044.954452437@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Kaplan <david.kaplan@amd.com>

commit b53c6bd5d271d023857174b8fd3e32f98ae51372 upstream.

cpu_feature_enabled(X86_FEATURE_OSPKE) does not necessarily reflect
whether CR4.PKE is set on the CPU.  In particular, they may differ on
non-BSP CPUs before setup_pku() is executed.  In this scenario, RDPKRU
will #UD causing the system to hang.

Fix by checking CR4 for PKE enablement which is always correct for the
current CPU.

The scenario happens by inserting a WARN* before setup_pku() in
identiy_cpu() or some other diagnostic which would lead to calling
__show_regs().

  [ bp: Massage commit message. ]

Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240421191728.32239-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/process_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -137,7 +137,7 @@ void __show_regs(struct pt_regs *regs, e
 		       log_lvl, d3, d6, d7);
 	}
 
-	if (cpu_feature_enabled(X86_FEATURE_OSPKE))
+	if (cr4 & X86_CR4_PKE)
 		printk("%sPKRU: %08x\n", log_lvl, read_pkru());
 }
 


