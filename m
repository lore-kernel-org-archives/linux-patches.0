Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706102EBDC0;
	Tue, 17 Jun 2025 15:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174301; cv=none; b=DnrqaY9qJNpd1ZE6q+qT5OxhIBfFzN/jKzfmjPvwiEuEhM1QVoE+YkKaCk1H0p6FG5CTqDqwEVyJqLTArmgcWwzzuTl2v4rxEWv+ajypRiDnWt69hhiIOztlmakU9RA5ua6rtlC1IuYyI7IluR+Ddy+zgEI/OCyCSk0Pl57SDD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174301; c=relaxed/simple;
	bh=sm/2wmXVIYpcxmpzI3f36yNaEn5Jm35Z78O/BqIIHAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxQU5Nd5xNiENMS8BQE1UvoB2wMYaT7ADJlTIm4Gs5vgCbSdnvjjjSjE4YP3G8eheM4IkA5M6LPZxVRKKbPI5wH96ZrdiHBZPPMCm6cpujgFt9LFuAh4LcSdVLdSSJ0jj/+/7B5m+RfzkHIHxaIiRWv0Zb8VJuCVy7/l/+1f3rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeP48ihh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeP48ihh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F36C4CEE3;
	Tue, 17 Jun 2025 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174301;
	bh=sm/2wmXVIYpcxmpzI3f36yNaEn5Jm35Z78O/BqIIHAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeP48ihhNQTh2qMHmBAedawODVfHQD6qzXPKc38nAfvuLPCsnC3Px0nfWBWDJFVpJ
	 VsF0UWz7NajY0GahiUqFnvYbLX+mzFlCYzKfXw4ht2Y98LrLOEmqwXax+5OlONg6yJ
	 d92rchFmg8nwycomRGJ5zTOMIwX6QFMagZdFRUdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/356] powerpc/crash: Fix non-smp kexec preparation
Date: Tue, 17 Jun 2025 17:22:21 +0200
Message-ID: <20250617152339.288559834@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ef5c2d25ec397..61552bbb1ea8a 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -356,7 +356,10 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
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



