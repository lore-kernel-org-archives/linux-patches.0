Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886E43B5315
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301140; cv=none; b=sy3hGX7BSjbpvJswVX9GjciK9LymwBlTZlIIZtPRIJwzW2PlIcQXP78rc1UgYhQczNv0VSQTsOwRjv7kFZQE347DwXhKCaMarmXZDysfoHFy0Gt6SX0KiOK23dFk021v+xQpomv+8VIkB+A38lraUVJKuyXFaU7bl9/k/PETRbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301140; c=relaxed/simple;
	bh=+OCkzWvvZslLw7jixUYG+u0VUbpJMsjVT/+U6lvVJfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQzJsnDocGwrGIm4onmUYI7GSHILBcm95GCHUDEIvD37vQJyuoso7NEhnWqHazMckJcYqnDl8JwbbiJXENotSM6WsbaH1U50HivVOLZGOPWvaKN5YMUjrdcNGueGIL+MFksk2MbeCAdMDerXWj5EXroce2qj5RTPWda93iIjodU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ufoXQULB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufoXQULB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C44C2BC9E;
	Sat, 28 Feb 2026 17:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301140;
	bh=+OCkzWvvZslLw7jixUYG+u0VUbpJMsjVT/+U6lvVJfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufoXQULBiBzsS25PEIbKHgTmu+n9Qr/w5i9hDgDvgTI4+ClZXWj+1fvP7rLOnqR/K
	 eGyVsLdybP8oIKWK8n/hidbvZWm4Gzcv138I2T6d2IiQ6Lpb9VAQQSFGAatwCIuDbM
	 smq1RruIKurAp7nRdWLMzWBXdSBhHE8d/f5DvjfQbM7WHJmZaSSmQg8UbBYQ4hw3H4
	 bZdwLo+KuMdJlthajF2SsmHY3JimVCErPHqVEWZTFb3t5p2YOz9V6hFVwUufWpwQsA
	 gdESOijoDjTpxR2lDlqu1VAywapeVB3WrREHrF1nUZ5SCnUyuYtT7AeyDbsnlcO5d1
	 I2BOhQnjpisRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/752] um: Preserve errno within signal handler
Date: Sat, 28 Feb 2026 12:40:12 -0500
Message-ID: <20260228174750.1542406-301-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit f68b2d5a907b53eed99cf2efcaaae116df73c298 ]

We rely on errno to determine whether a syscall has failed, so we
need to ensure that accessing errno is async-signal-safe. Currently,
we preserve the errno in sig_handler_common(), but it doesn't cover
every possible case. Let's do it in hard_handler() instead, which
is the signal handler we actually register.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20260106001228.1531146-2-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/signal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 11f07f4982700..bebeb6b4bee8b 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -35,7 +35,6 @@ void (*sig_info[NSIG])(int, struct siginfo *, struct uml_pt_regs *, void *mc) =
 static void sig_handler_common(int sig, struct siginfo *si, mcontext_t *mc)
 {
 	struct uml_pt_regs r;
-	int save_errno = errno;
 
 	r.is_user = 0;
 	if (sig == SIGSEGV) {
@@ -49,8 +48,6 @@ static void sig_handler_common(int sig, struct siginfo *si, mcontext_t *mc)
 		unblock_signals_trace();
 
 	(*sig_info[sig])(sig, si, &r, mc);
-
-	errno = save_errno;
 }
 
 /*
@@ -201,8 +198,11 @@ static void hard_handler(int sig, siginfo_t *si, void *p)
 {
 	ucontext_t *uc = p;
 	mcontext_t *mc = &uc->uc_mcontext;
+	int save_errno = errno;
 
 	(*handlers[sig])(sig, (struct siginfo *)si, mc);
+
+	errno = save_errno;
 }
 
 void set_handler(int sig)
-- 
2.51.0

