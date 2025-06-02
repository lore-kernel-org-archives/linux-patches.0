Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057832AE9A;
	Mon,  2 Jun 2025 14:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874815; cv=none; b=XAfL4KcsDjDMvFv4JVuPz4QfKvYTqfP/rH5fNr/MpUxGaM0iyHYP++ivSUSK05CChucj0/BFwKywh134+o7pPRrl5Db/QMkBip/QWSaKvRqdAxIU4Nsw6DjX5oZCifFZO0pUkaRHvGV2Ffb4mSP2UnMrxeZMoEF3JzqpHOxbywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874815; c=relaxed/simple;
	bh=kYS0A7lSf8NNjaFiTtAUQkUbDO1XAuGvIYBgm5MlpHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9msFjEIBmWqJS4IXBwSt2vzWZqK+Fbco/7ub50cul0JWgbIHzhkc7irGW/WSR8E3ksbzOKNzRuHLxiJhUlqn48UhMniC0t4+GVm4SQqsvR1wbMjv9pdePQQUzZplcpyeE+dUEWzfmX6FBTZd3ct2IGl0MdvAkIlZFLO4nF/3n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvH6UO2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvH6UO2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E66C4CEEB;
	Mon,  2 Jun 2025 14:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874814;
	bh=kYS0A7lSf8NNjaFiTtAUQkUbDO1XAuGvIYBgm5MlpHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvH6UO2zPVOTtF/mb1QT67TToYLU6AiVNQN1Q4z0upXpOcjXoIhvXUjk/QwMMngkn
	 jmDAQX8bqJ4sZmbnJzOunS96/rMPbIF7gbouLdXxOaag6PkN3IEAQyNzoxpheleU84
	 uUKUM/5GD1aKHwuTzXiYssDFmiS242NJWZEr2Qgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin@sipsolutions.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/204] um: Store full CSGSFS and SS register from mcontext
Date: Mon,  2 Jun 2025 15:47:16 +0200
Message-ID: <20250602134259.709240231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



