Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041543;
	b=KBo0y03466S/pVCEM7+s4kcmFS+3Ab+qTKzhKmLkNNLM9qkpYk8D1ZELlitLcH56PGUF
	 V4SIumgqFrTmK9afr6dMh5VcfBX8jK4Kgfw53g0ogtrlCpcwB80WLfcFQf90byAgJtuo3
	 mrAVDiJvDDTmDLEUcynofAKWv2dFX1AYPTETI6swnx+ts40gPTkcmxmoJHpShoxmu4GNs
	 zJZUX3L35jOr9FtuxQ2CB5SZqDDEMzQvqrCleHDya2qNOONHyaiLwANnRbChxtPmL9KDS
	 Ur0zCQLhET0eriWb7pXQ7z6yRASHHYCgREhAH3NTOm7Vko238LvPdCiPo3z46VaSKqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jR0Zakc8m/O208CGWu2UQ1+75Y7F5tWDweDKyzaod4k=;
	b=OF9z+egZvwzClBQF6Juki/NRYPjYrBQnMPU0MaesM78r46qLdLn5TeLH1M2VF57lG4hE
	 nQAEyoz/Ox20+dV0DAAcnZvrekwgYeY9u2fMlqepmWlITQgErsqF22njyQWSdGAtO97iv
	 reEiA9pMhG7X8FqEOv8ptsi5LKG5gz7uJMue9G1sbfjzQSYHIjk6HZkFlZ8MWojYCwwWH
	 63bmujk0KpaysBsyZ2dZsrKeoDHZTUfbyYdhlvrDbs2zYuBdJbzBv73CQ5tpDB0h4Rj2V
	 xfY9sH3wGZ6Qv7ibKNGYROHnN2PQm7ogFDrux2R/lBSH0ySMAbKJ6BeZeirTK2IGH/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AOG8rzZ+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87740606A32F;
	Wed, 18 Nov 2026 22:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AOG8rzZ+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13381F000C4;
	Wed, 18 Nov 2026 22:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041543;
	bh=jR0Zakc8m/O208CGWu2UQ1+75Y7F5tWDweDKyzaod4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AOG8rzZ+XIdKg3qrvNNlwBaHFkHnSDoVZWUhuKyzfk2X1708ixE+VVqBX1qmDI3Ai
	 poqenORFZc7dJ1niVDs/gm0QzeoZ6lSNQMZqBUJ9kAC9b/G4aK0RjbbCJ1KTDMGpqY
	 MIsTohvp2ns5i6K7TbI7a5MNp/y361S5Zyse0ruY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2810/3318] s390/uprobes: Fix off-by-one bug in emulated PER handling
Date: Wed, 18 Nov 2026 15:57:12 +0100
Message-ID: <20261118150444.965848681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b88345ef8bd9e..b8f09483c355f 100644
--- a/arch/s390/kernel/uprobes.c
+++ b/arch/s390/kernel/uprobes.c
@@ -248,7 +248,7 @@ static void sim_stor_event(struct pt_regs *regs, void *addr, int len)
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



