Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A6C27FB12;
	Tue, 12 Aug 2025 18:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023546; cv=none; b=HyQ21GwtHhgAKwHw9T1sb7drD+WRiDVPKSoT89wWCZbp/0BrqEthx2+KtkdwR9jZvewbJYRW561UirpDo9fgzoDFxol6vNgzWP1qLzCUYfaRKXoRWnHfw2G2Gq+Zoz1KZit74gcCR+zW34VQX93i/SmITpZWvFDiWz7m4v7xsfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023546; c=relaxed/simple;
	bh=lr5f4MEJP5DN/i3Gvrx7+GKpeoCRWbUitm6Sf/RKXjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2YqM93v8fC5LDq5IL1nYf7lpjjaLX7rSO2k1oN6CTE6DGFynF+B+hxhI30UXGLQXjNDFYei5kOUBzLCqeKfJSjAtHwW4cPqZoXlx0uQ47JguV8TsO27CmznTEXWFb+JHY6+PS8Vq3XcAXW5GnCazERFiVw9+KQbo3eT970LUTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7eCTJOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7eCTJOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6851AC4CEF7;
	Tue, 12 Aug 2025 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023545;
	bh=lr5f4MEJP5DN/i3Gvrx7+GKpeoCRWbUitm6Sf/RKXjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7eCTJOiIh5+3N5dRxFATvzzd4SEQZWb5WCd3K1P5FPSCIRvfAQvdptEp38k13MDD
	 su/ir/M+CHIkiLBOAalaUxiT07SAb+NBNnkPDvc5qUmihld1FiqS5s+71j9g9ldV2d
	 wj2l6A44NpcEeYZDYcKIdL/rdedFMchsMuMkcrN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Baoquan He <bhe@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 112/627] kexec_core: Fix error code path in the KEXEC_JUMP flow
Date: Tue, 12 Aug 2025 19:26:47 +0200
Message-ID: <20250812173423.573843423@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 996afb6efd1a345736f9a888e4d6c7d4f3752aa5 ]

If dpm_suspend_start() fails, dpm_resume_end() must be called to
recover devices whose suspend callbacks have been called, but this
does not happen in the KEXEC_JUMP flow's error path due to a confused
goto target label.

Address this by using the correct target label in the goto statement in
question and drop the Resume_console label that is not used any more.

Fixes: 2965faa5e03d ("kexec: split kexec_load syscall from kexec core code")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/2396879.ElGaqSPkdT@rjwysocki.net
[ rjw: Drop unused label and amend the changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 3a9a9f240dbc..554369595298 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1080,7 +1080,7 @@ int kernel_kexec(void)
 		console_suspend_all();
 		error = dpm_suspend_start(PMSG_FREEZE);
 		if (error)
-			goto Resume_console;
+			goto Resume_devices;
 		/*
 		 * dpm_suspend_end() must be called after dpm_suspend_start()
 		 * to complete the transition, like in the hibernation flows
@@ -1135,7 +1135,6 @@ int kernel_kexec(void)
 		dpm_resume_start(PMSG_RESTORE);
  Resume_devices:
 		dpm_resume_end(PMSG_RESTORE);
- Resume_console:
 		pm_restore_gfp_mask();
 		console_resume_all();
 		thaw_processes();
-- 
2.39.5



