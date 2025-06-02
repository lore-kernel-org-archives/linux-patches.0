Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4341DED64;
	Mon,  2 Jun 2025 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875992; cv=none; b=XShE9adJoz2y2MTk72TMPkWg2X+DGWR9xvMrc3RqG6u539UfwuoVBiSXdUE03bMH7IpvFxrEsPirhVPolTqcwylaKF0xw+zkM+xxqj18rJb2ur9fzIVsj+BMSNX7HusQMx+HTKlsQiGD98xECQu/Oe54bUWl8XSeiRf1HAEPRjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875992; c=relaxed/simple;
	bh=JMViJRJjPulqXkMoI7km5VlMnkTZv4HdW7N58bWaJ14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsmoPgBUBP+HUBcLm1dfatdxKHxwY5pt1w8OB+tcfIoHWmc/8Ys4QP3h3Us8h9vZ1UCy5z/5z2D2wD82fDyO5+m+Pn4iQ1q/BGesZVAPMniiWBUa6txRbLHxPAWiKKC/WaizLmwhcRNYRCyK2MVwdfAmDRnZF+v80nILT4y1OLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bueCCX+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bueCCX+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0620C4CEEB;
	Mon,  2 Jun 2025 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875992;
	bh=JMViJRJjPulqXkMoI7km5VlMnkTZv4HdW7N58bWaJ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bueCCX+lv8iih37zOSh6B4el3I+KSkTUR4K4N7eML5JtOTrZr+1oDZzrSXj1HE4KG
	 fad7njpDLFrbleTXrjTeT8ayumTHg/j0kOdWz2NwpPfOkMYRu0H3LOdDjq87W3ArFd
	 uj7kukBF7I70xHgkvWZSqm5MXD7QLG2aLXmpTtRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin@sipsolutions.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/207] um: Store full CSGSFS and SS register from mcontext
Date: Mon,  2 Jun 2025 15:46:49 +0200
Message-ID: <20250602134300.212997780@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



