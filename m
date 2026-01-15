Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490A42C028F;
	Thu, 15 Jan 2026 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496569; cv=none; b=UUomTNhYBxh6NodsbTJI+J63z815PipIF1qYD5T/WSrCUHQgA3bn40XDHfAbBIZUPLCGwbaCN9O0sV2cTr95+PlrbmCUw3SnhOJA/LdOlcq1RDNY+nSbkdfPogwkY+OiasQH57URU0ECMsg4Dy+0hqoWGUCXcHQAOsAmywUi2Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496569; c=relaxed/simple;
	bh=74hBhalu1RK9MSRMGeiuxIHp+TcqW9d+yQ/ShBSSwIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmX3pwOhwGGSdlZXYRQ1Iie14TFufQBT9KVNYk4S5d5V5z8je6mHPCjN4sPk/qCLSyumcS30UOCXa6hdpC/h/V/JGqyztt1GmeN6GFfZVuYn0GTXIkSWku5qtxLLo2e8HDFNCmmiAUJbkD1ssr6FmcRaCrdGqTI5RqFKbwz2r5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACXZYgXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACXZYgXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA813C116D0;
	Thu, 15 Jan 2026 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496569;
	bh=74hBhalu1RK9MSRMGeiuxIHp+TcqW9d+yQ/ShBSSwIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACXZYgXQ/JyX/Zt50DoHkO0BAgMI3dwU2xSQ7n6GoG3STOx/Q17KmEKJNRCpu2m6C
	 lsK0E6ji8PzeZHWJIXzsGSJoXp+BfZWLX5s+IqKxNUX4Jy/f9VNGeYXnW8g31ltdH6
	 7EMRaM4IBi1HI6P1vwkzo9kfW8glKCkkiH0dd9qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li85200@gmail.com>,
	Guo Ren <guoren@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/119] csky: fix csky_cmpxchg_fixup not working
Date: Thu, 15 Jan 2026 17:47:26 +0100
Message-ID: <20260115164153.085385266@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yang Li <yang.li85200@gmail.com>

[ Upstream commit 809ef03d6d21d5fea016bbf6babeec462e37e68c ]

In the csky_cmpxchg_fixup function, it is incorrect to use the global
variable csky_cmpxchg_stw to determine the address where the exception
occurred.The global variable csky_cmpxchg_stw stores the opcode at the
time of the exception, while &csky_cmpxchg_stw shows the address where
the exception occurred.

Signed-off-by: Yang Li <yang.li85200@gmail.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/mm/fault.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/csky/mm/fault.c b/arch/csky/mm/fault.c
index a885518ce1dd2..5226bc08c3360 100644
--- a/arch/csky/mm/fault.c
+++ b/arch/csky/mm/fault.c
@@ -45,8 +45,8 @@ static inline void csky_cmpxchg_fixup(struct pt_regs *regs)
 	if (trap_no(regs) != VEC_TLBMODIFIED)
 		return;
 
-	if (instruction_pointer(regs) == csky_cmpxchg_stw)
-		instruction_pointer_set(regs, csky_cmpxchg_ldw);
+	if (instruction_pointer(regs) == (unsigned long)&csky_cmpxchg_stw)
+		instruction_pointer_set(regs, (unsigned long)&csky_cmpxchg_ldw);
 	return;
 }
 #endif
-- 
2.51.0



