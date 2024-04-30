Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4F812D1EA;
	Tue, 30 Apr 2024 11:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475493; cv=none; b=XL7mSJecJ6b/EhIwWBdlCSUdevLRACPCuC9iQi31a0sUUZo5ksIEtmxLAC7/GDfivtAMZXLdtp5mK7DlJ++B2A1pCv5QXCxdPUWOh8cBB7eaofYBl5POea29I185Xl1/7zj6HLfDnoul4bdTGmneZld+gSqfvHJrUVoMV/zSV6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475493; c=relaxed/simple;
	bh=g/jyeQPePLLuHIhKdAHn4qTCz02jDrUFjOsUfGPgvro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsbrYpHedOqoSZyrTHf2SQIE3K1eeAacJjI+zalIZnMAe+XJo9lJOwAburyPjQveV/Tr3/6QOUw8fBQ8Nxu1FGft1TUoY12e6Uia/ncrAVQ0OR/GAiDxdBQVY325fpyzDLtBDI52q9PeSkF3LYWSASsJDd4S/vOdA1psjJZiuuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RslYPGeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RslYPGeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9E6C2BBFC;
	Tue, 30 Apr 2024 11:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475493;
	bh=g/jyeQPePLLuHIhKdAHn4qTCz02jDrUFjOsUfGPgvro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RslYPGeRu57m33shbuvMpCTz9/7II315oWDFNqEfwmbooNC8Zq/eBN3XDNcR8xGJh
	 CLMFPRBhNkKhnWqoeV0/SL9rD4PPxt7A9wRU0n79U0Xwyo0ZPfZ4E4O9PZUJe2IUjZ
	 fLwBN2FyiHDdJH6snIFmc15lm6I5nlqq7+GIEPhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 111/186] x86/cpu: Fix check for RDPKRU in __show_regs()
Date: Tue, 30 Apr 2024 12:39:23 +0200
Message-ID: <20240430103101.255954766@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -138,7 +138,7 @@ void __show_regs(struct pt_regs *regs, e
 		       log_lvl, d3, d6, d7);
 	}
 
-	if (cpu_feature_enabled(X86_FEATURE_OSPKE))
+	if (cr4 & X86_CR4_PKE)
 		printk("%sPKRU: %08x\n", log_lvl, read_pkru());
 }
 


