Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E03A194A45;
	Tue, 27 May 2025 16:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364664; cv=none; b=HcQah6T1FlPyRWIsPcQZ39MM4drckWCvV6leN5/XUAs/dBqcMM/8J4/yH34iCDPj7PwjxFblq7QdcqXXgeK4ZAzemLnvN6F5t9kUOeOLKCa/DqZQr9WDiGNX7zBVSlTQT9Pfj7uV/LyEQQ3bn49R1OY3zIuiyxFVG0x3qlCLgs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364664; c=relaxed/simple;
	bh=4MY6SDPruyB9NRPy1Svr/ER0BDwHCgVd50MaX9ELhqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXYpXn5KcTWS5xSH+vSFutTdD3LHskszQ4AkMWPxB88Bv9B/ozSQ3XS2cPLIgfRyVC+7B2fpZaqe4ow3a4KbSZKQJt4drQrLPz8kzb0cFxL0HR2deViNXwUdhnvYM/7KpjA0GdgmpwoAphUo5o1UGGBXEcENIYZFOIZpNOsOYuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oqa6gPKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oqa6gPKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A57C4CEE9;
	Tue, 27 May 2025 16:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364664;
	bh=4MY6SDPruyB9NRPy1Svr/ER0BDwHCgVd50MaX9ELhqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oqa6gPKGsibbcxFzfDszbsWHTJ7ALw9psp3rEpJQhOdUzETivA6vuTFBTs6DlNY1v
	 2z3WkyNuEANtwz9WhsRitQfjwlszwJ5kj43Cgp73D1vtRCcNuHwMMPu1PMElkNwp+C
	 s+J0EJXOL7eOTiO1Y82LKPkDszymcI2AjW0CQluQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin@sipsolutions.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/626] um: Store full CSGSFS and SS register from mcontext
Date: Tue, 27 May 2025 18:20:21 +0200
Message-ID: <20250527162450.228947500@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Benjamin Berg <benjamin@sipsolutions.net>

[ Upstream commit cef721e0d53d2b64f2ba177c63a0dfdd7c0daf17 ]

Doing this allows using registers as retrieved from an mcontext to be
pushed to a process using PTRACE_SETREGS.

It is not entirely clear to me why CSGSFS was masked. Doing so creates
issues when using the mcontext as process state in seccomp and simply
copying the register appears to work perfectly fine for ptrace.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Link: https://patch.msgid.link/20250224181827.647129-2-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/os-Linux/mcontext.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/um/os-Linux/mcontext.c b/arch/x86/um/os-Linux/mcontext.c
index e80ab7d281177..1b0d95328b2c7 100644
--- a/arch/x86/um/os-Linux/mcontext.c
+++ b/arch/x86/um/os-Linux/mcontext.c
@@ -27,7 +27,6 @@ void get_regs_from_mc(struct uml_pt_regs *regs, mcontext_t *mc)
 	COPY(RIP);
 	COPY2(EFLAGS, EFL);
 	COPY2(CS, CSGSFS);
-	regs->gp[CS / sizeof(unsigned long)] &= 0xffff;
-	regs->gp[CS / sizeof(unsigned long)] |= 3;
+	regs->gp[SS / sizeof(unsigned long)] = mc->gregs[REG_CSGSFS] >> 48;
 #endif
 }
-- 
2.39.5



