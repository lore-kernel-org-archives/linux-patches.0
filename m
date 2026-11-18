Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031685;
	b=K2Ri0FzZAwjaZoVY7gBhqIcT03HLSVVxmsRhJvuTDC6Z53Mx+iNzY9Aj+x+pAfdnG+Z8
	 B0CblbJwgmCBdFUdoPtRGaTQJES/gxVWyMsiXwc5bkRpABs44AX3XTHinX9VffG22LNd/
	 2dF97hJH7DiBlWiCKSj7IWwKrhWLStY00LesGdyMHLUWTCqQh/sROWPk0oLcw1qb3fJ2O
	 dBtZQHeEI35nmk6FjzaBTFtJir0POpPcKeYJewgkHrhO9VC0pxOVI3BWkl58ylWBue6t6
	 Ari6p1GnXRIrBYh2GC4Zc0o7lfzRqpdbaDJXHiI12/WwMKrMNTRfmwbFbH2bIiULCqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rs/Tl1ZH5PQOWsznoLmI54y7WShHIr4oI86tq+Ox6GU=;
	b=SlmI8Vkb+xbm+CvZzSjIl0lnu2AFA0pMDtZtScLOaFVUzjWPD0+X/q6LgoJmr//S5ypT
	 3A/rMvcNuOpdDZpOnv7iKAG4+HKTLU50aaw6LtO1k4jDEAOuhqe7S+CqGQFj97+Y8FJ+G
	 lQhPSmkfbcYt2bVaoEAReRB5wn9PqDREFPr3JIHamsa8f+Ly8tJGHIkTv4rA/nqVcmrCv
	 6BXnPRNpIPJmc/09BlVvuXfxqsbtKcirw1nNqqQwT1SPnCDWvtcn+H9BKx3Cet6F154K9
	 rrKjnfzu7KrRLv7b1lqfvao90ru+xcr2r8XzoG7v1Y7SK31C/QRyh3+Br8iZcRt64Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jH19WbeI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913BC606A31C;
	Wed, 18 Nov 2026 19:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jH19WbeI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24CF1F000C4;
	Wed, 18 Nov 2026 19:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031685;
	bh=rs/Tl1ZH5PQOWsznoLmI54y7WShHIr4oI86tq+Ox6GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jH19WbeI5cr5k71sIGx2FLwSGwg0X04D5jx18eMKr+q/IzqqIwa58C8tEY9wI74VT
	 uPZDRawFFNJJ0AFqG5K99AwbrayA+BMuohx/gqb2WGjOWiU+qHtiFmcl5uoEYgfzMS
	 lyGdPY1S4OakCVzWoUPwuXN7df8FxSRfJrSBcjA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1143/1756] s390/uprobes: Fix off-by-one bug in emulated PER handling
Date: Wed, 18 Nov 2026 15:54:30 +0100
Message-ID: <20261118150055.545676698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 2ba01cf7b2598571486425a0605f1434909b532d ]

The uprobes code emulates some instructions, and with that also
PER storage-alteration handling, in case a debugger is attached.

The PER storage-alteration handling contains an off-by-one bug, which
may lead to PER traps which should not happen. Adjust the comparison
in sim_stor_event() to fix that.

Fixes: 8d1a2427d8fc ("s390/uprobes: fix user space PER events")
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uprobes.c b/arch/s390/kernel/uprobes.c
index 5b0633ea8d93d..1d088c31cb610 100644
--- a/arch/s390/kernel/uprobes.c
+++ b/arch/s390/kernel/uprobes.c
@@ -247,7 +247,7 @@ static void sim_stor_event(struct pt_regs *regs, void *addr, int len)
 		return;
 	if (!(current->thread.per_user.control & PER_EVENT_STORE))
 		return;
-	if ((void *)current->thread.per_user.start > (addr + len))
+	if ((void *)current->thread.per_user.start > (addr + len - 1))
 		return;
 	if ((void *)current->thread.per_user.end < addr)
 		return;
-- 
2.53.0



