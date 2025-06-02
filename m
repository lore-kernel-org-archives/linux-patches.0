Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E673023237B;
	Mon,  2 Jun 2025 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876746; cv=none; b=H13seC31mBVAXyeWvza2qooFqtvBc2rwPGBELWXebJuTJiiuKZlUTvpVVp0bCGItSQpxerOCydwxHgNCU1RVA6CWHi9F+KHW0Y4OurXQQjG3lLiEuxXHBMnAkIKAB3nCyM64M9jDCxuh7IGDIBxwE13xVHxQ3KTENW4L+Yj5ZS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876746; c=relaxed/simple;
	bh=tsAvNxkpxthofBJgj7kL1a+TT1bCUn6477XND474fEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/XzJI0X2mN4V8WoZ65uJjnociLW819z8hpmPHrxbSQuuLqGibp5RrgGXQ6WAqVUDEBvgdQnN3kz14rvuVzvW+R/QuBbYiQydSorqCqC1oNiAOcsPUFRgsi/C8IWqVfIy/g43MhvYlYYS2EDynBQyXDlhI13/2wXttfzntC2WSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dn1a9G0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dn1a9G0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70670C4CEEB;
	Mon,  2 Jun 2025 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876745;
	bh=tsAvNxkpxthofBJgj7kL1a+TT1bCUn6477XND474fEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dn1a9G0ossrIpADNvkiE/2iBNUYwaK6wVBXhnlzbDmM5xFBlaEu9ZLu8TmLWse3xj
	 Syp71R2xIy45SAeqir/dSC43AJ1mEr4ntASo6svy4mG8UBWsm6dUlZnABKTJiSzXFu
	 XPa7vRMo87aoLhCaKX+rJ7siwGyKq9wy+K6zZMV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin@sipsolutions.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/325] um: Store full CSGSFS and SS register from mcontext
Date: Mon,  2 Jun 2025 15:45:36 +0200
Message-ID: <20250602134322.194419710@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 49c3744cac371..81b9d1f9f4e68 100644
--- a/arch/x86/um/os-Linux/mcontext.c
+++ b/arch/x86/um/os-Linux/mcontext.c
@@ -26,7 +26,6 @@ void get_regs_from_mc(struct uml_pt_regs *regs, mcontext_t *mc)
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



