Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019887;
	b=XpVYPUTnfe0EQHz0VG7qnX385HaLV6gmRcZdgKO44IoD/c7etwvRRUSf3vESWjay1nxM
	 JJxSL7CB+uHTQhSo8GddhCVzn4GIo6X5jj93Z6W4TQHScU4iTVytMz4q+P9+fuKu2BIBI
	 tyoC1UOabwGDCgvdUv/wTg9Y16pkSw7E5HXlPmDTsX7Ij4TZG6HWeBIkL5ZTviN6sXgEW
	 6js+FyoPLpE5g45DtqXCE2Om/JNsuyLHtEeZM3q/fO+j2jMf3fHOdnii448HbMUux1KxH
	 m7UT2WMiC4n5K83X5JRC1+kg6GpfcMWpA0P/oHl1q7tNRpC9UgfKTzBolcRaZGii9zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JgYlkZYsjWPclZd7ZSdX5G2b/4mFcfPytoFJXc9R/94=;
	b=dd+N1JaH0AyUEvjmVGOgNVBbSlG+VnCba9tixzhLfrmTsIPLfDHJOMYLeeVFIzo6fUp3
	 uXYgympgwi0EPeqVWwN1U+RQISJIKXKSkjXk2H5GRDoR2rbYezp79lD2NDf67u5Ikz/mN
	 5wsPHWqkbds+hkYZwnAGSOiQSPx+L2Qhj2Lpei8X3yf4J1s9lDx6dFDUDrYqVEItLJnAd
	 qaE8sUu/i6junMhvf26HR66sCjsDo8nYyGJUlbTeHx+Vsp2uBnMjOkHCAeHEKFLTo8MvK
	 HhSiU77lCbkcKmvdVnVLnP5RMSMzRAZBJSYgH+ac9rG9BJnyYHq2rhKBwyaJwmGQkag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDwscmGn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB14F606A320;
	Wed, 18 Nov 2026 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cDwscmGn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456951F000C5;
	Wed, 18 Nov 2026 16:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019886;
	bh=JgYlkZYsjWPclZd7ZSdX5G2b/4mFcfPytoFJXc9R/94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDwscmGnOnVsDkDlJPcRXW4vsyJCc3VS8AHTW69tVlqnE6bHadUF1z561tgkpMbUa
	 MyZJMp6RehgHNHvRF9ZZBGnvoYBWQYYJuT0QImRSS2qOAfv1ljSqanDAObCmxmGsAB
	 0P6AuLCFTOgbBruM4oDyfewSLA3E9BsKRJoL8GbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1756/2651] s390/uprobes: Fix off-by-one bug in emulated PER handling
Date: Wed, 18 Nov 2026 15:49:56 +0100
Message-ID: <20261118150350.694273962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c624f3361e438..b2b8a377ced6b 100644
--- a/arch/s390/kernel/uprobes.c
+++ b/arch/s390/kernel/uprobes.c
@@ -241,7 +241,7 @@ static void sim_stor_event(struct pt_regs *regs, void *addr, int len)
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



