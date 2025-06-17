Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AC41E8332;
	Tue, 17 Jun 2025 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174395; cv=none; b=DjZlZRWgSt+P6/MnJ5nh3gQpRqOaHmw4HYdiFGxHYkHPNuAs/zAXa6V0SQhqYfwBOghrstZwkrh2pqB6RWd6zkArwxBbmCzocPJ+s4a2LYH9Er3vT8nfFydHnaAyuoOxNnc3NVrjPrDOXlxjIxQV8kb8lN28KxbOWjyuPlUR9K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174395; c=relaxed/simple;
	bh=I0EAIUuQym5vHxUPGX2yW2GyFnuka5ZxDMXYGw0LncE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtNd/P1UxEwpJRbhWt0w3C46mRayaljajTLmngbSrZ5Xlnj7+alBcGk23YymnJdv84pd0IgFzEUJZuFwB+X6kTnI7TkVJQG2WADdLOAdQ+tp0oDR2dhpaVK1QzbG1sgDhtvlyGw9DjaHQ9SmYnBBnoyPKzwFl96lvJ14t9LOHGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK9LkrXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK9LkrXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A6DC4CEE3;
	Tue, 17 Jun 2025 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174394;
	bh=I0EAIUuQym5vHxUPGX2yW2GyFnuka5ZxDMXYGw0LncE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK9LkrXwEen+ALIL5L6JE8ESc5t+OFzrPoeJEEMgJ2y2SDLSZ8ZbgQuhe9g+XLGBM
	 ReGJu5n0EKKZ9Z7In7tswjdilUs9efHjxzk4kTKuiL1Rq47mR1mtZxYXthRz542tFz
	 sqtDcQuAcqNDr9z+h3nQKFdMbq2QzFOnNbSlDT9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/512] powerpc/crash: Fix non-smp kexec preparation
Date: Tue, 17 Jun 2025 17:19:39 +0200
Message-ID: <20250617152420.064520481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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



