Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6956612C549;
	Tue, 30 Apr 2024 10:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474358; cv=none; b=g4Vf0nvB4GYGhxmmcfVxnfo8VC67VOdHGk7K2MZECYfsWE0AIZqVZ5pdhn+xJLm9WsqO37Qz7DEP1tzpQHUFMZyf0W3M7YwRQ5zRHwfih/7IW60jo1tfOOktu6jAmRFq6bSnX0bckOiGQ8h9EQIa6H7G0ex69Ms++ZLB11a5qGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474358; c=relaxed/simple;
	bh=CnhEU1qekt1b4tzVYBfRJfwByvCJcPzSyJrWCJDmjvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGkzKJbAh9UM7pCDq7WxKKwoY3Jt04ldQW/ZAexJhL8xCsqO1bklLkkHFUitAN/ak6d9NEcbBVTJBQtMs/AEyjnETkMJuInx+da98nOrZhr3+3zSWlTyn0TUGg2SGOoqg2fWMrCNiSiG8DuMh3/WbZGuevYRur2EqqDkBHm4dBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvwcIhvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvwcIhvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31EEC2BBFC;
	Tue, 30 Apr 2024 10:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474358;
	bh=CnhEU1qekt1b4tzVYBfRJfwByvCJcPzSyJrWCJDmjvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvwcIhvm1LiF26ZfuuIeaF2IZIty7cuTN43+1dEadePYVeCt4m65WMRcyNppZKENJ
	 ws4fWb2F3MXGfmcjojkK/XJ/WIGBCMYkboUsoKy9L3jTH+23tHg3YeBlthkWqvfSqM
	 N+E54ECv1v4Sb+Ya9LzdnbcuxQ8Jt0Mf+6Mw17vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.8 133/228] x86/cpu: Fix check for RDPKRU in __show_regs()
Date: Tue, 30 Apr 2024 12:38:31 +0200
Message-ID: <20240430103107.641207462@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 


