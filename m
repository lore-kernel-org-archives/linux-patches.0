Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F65D2ECD0B;
	Tue, 17 Jun 2025 15:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174801; cv=none; b=agdLYg6NLDqUu4PT8+QEJoyFQq0ubqDxPXI9339wVaLnA5s1R1H/zpijvta/sBX3BpqeQPMH7UdtYfjcOQiWsfnuRyPRhZnm7G3lhEnbR2tC3UoHWBD42UZMog/KaohDS0e1jbRE/91DEUDTTennxbk5HmSnpwVb6EC7GR7a3wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174801; c=relaxed/simple;
	bh=wAmEkufnu1yeyn6AIKCCEwVof1Ild3phNg/EI1piaQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUg+sCg3RmGWdbJkYxHV2mberj4JXPFO9RSvLeJ6TfJAH3M3p9AhWJrCJ+8J+uQYEvE0VKtI1KcaSS1665i0ohAUOzEEFUVF0LrGGxy/iOWRkTt+O0YwrR9/2/N+vrSCX2Pjo/rGiRgEoiztu7KJSiiChOHUvDfdo36i8HakZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztN90uKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztN90uKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F6AC4CEE3;
	Tue, 17 Jun 2025 15:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174801;
	bh=wAmEkufnu1yeyn6AIKCCEwVof1Ild3phNg/EI1piaQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztN90uKS6PpGenCngCTDH0Et9Bdxwg5sJeo5+m/RNHzaCoKbJzLr8UEApO/Cmbm+W
	 ubHTq+Skj/BXEd06acvlIEPnicOLbwrfiqXb2Ul3RPtaMqh6nxmtZYt/9LeB1nfy+u
	 TcjoO/Thiz1WPHYkn3nJ1yU59pW6MeHFrNsod/aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 022/780] powerpc/crash: Fix non-smp kexec preparation
Date: Tue, 17 Jun 2025 17:15:30 +0200
Message-ID: <20250617152452.415988512@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 882b25af265de8e05c66f72b9a29f6047102958f ]

In non-smp configurations, crash_kexec_prepare is never called in
the crash shutdown path. One result of this is that the crashing_cpu
variable is never set, preventing crash_save_cpu from storing the
NT_PRSTATUS elf note in the core dump.

Fixes: c7255058b543 ("powerpc/crash: save cpu register data in crash_smp_send_stop()")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250211162054.857762-1-eajames@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/crash.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
index 9ac3266e49652..a325c1c02f96d 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -359,7 +359,10 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
 	if (TRAP(regs) == INTERRUPT_SYSTEM_RESET)
 		is_via_system_reset = 1;
 
-	crash_smp_send_stop();
+	if (IS_ENABLED(CONFIG_SMP))
+		crash_smp_send_stop();
+	else
+		crash_kexec_prepare();
 
 	crash_save_cpu(regs, crashing_cpu);
 
-- 
2.39.5



