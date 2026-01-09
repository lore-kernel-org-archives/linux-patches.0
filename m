Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6DB2F12D4;
	Fri,  9 Jan 2026 11:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959812; cv=none; b=OI84XCz6sU5URwotjnazuhX5DzgQDHCBiZYxgYJ69lwKy9+e1txhxpHNmg7P5thwNEwpR5jAog7QtT5bDvejqIQ2SaO1YTe2uxLQhKk0r0N+jxNpibNSZBbaNi5txI7luy9rbCV3Hudsc+TAJkW/WLaQkguCw/wQ/ogp6q0LXfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959812; c=relaxed/simple;
	bh=oov3pf3vwCcDVk//q1dBO49C6UUmKSns+j2Y+5pJyJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5BkgpW0DggVeMiRPU7sXyE5mVmaV9ZBNGQLyB740PdP/X8et1eyHUpwP/AEnaUd3HzIQdUUp0a1aATe1uLugPuLeKrXe07mnAGPNKVMeNyQwr9BvHLF/It4N1KCRGsyl8mwlk9x6MwpNN2EjOANdWmUhRTXmTREFHmsc1h7MNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLc2W7c3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLc2W7c3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAB8C4CEF1;
	Fri,  9 Jan 2026 11:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959812;
	bh=oov3pf3vwCcDVk//q1dBO49C6UUmKSns+j2Y+5pJyJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLc2W7c3LA52qpe5z2KKOF+o/pNQQYTt1iyEZ+F9pRfDW7icLJLRcXLrXJ+Z2+dDV
	 yXG97nE/8YdXL6FV1tK9hwqZQkBalkqt0lh7aA5wR5KZAQ2Lj2FHw9mZ6z/rbjz3Lo
	 wEkI+J1oxCprBUJxJgPUuqWkd1ko6SfIaelHaMsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/737] powerpc/32: Fix unpaired stwcx. on interrupt exit
Date: Fri,  9 Jan 2026 12:34:39 +0100
Message-ID: <20260109112139.266710559@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 10e1c77c3636d815db802ceef588522c2d2d947c ]

Commit b96bae3ae2cb ("powerpc/32: Replace ASM exception exit by C
exception exit from ppc64") erroneouly copied to powerpc/32 the logic
from powerpc/64 based on feature CPU_FTR_STCX_CHECKS_ADDRESS which is
always 0 on powerpc/32.

Re-instate the logic implemented by commit b64f87c16f3c ("[POWERPC]
Avoid unpaired stwcx. on some processors") which is based on
CPU_FTR_NEED_PAIRED_STWCX feature.

Fixes: b96bae3ae2cb ("powerpc/32: Replace ASM exception exit by C exception exit from ppc64")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/6040b5dbcf5cdaa1cd919fcf0790f12974ea6e5a.1757666244.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/entry_32.S | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 7eda33a24bb45..ba1670311bb04 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -269,10 +269,9 @@ interrupt_return:
 	mtspr	SPRN_SRR1,r12
 
 BEGIN_FTR_SECTION
+	lwarx   r0,0,r1
+END_FTR_SECTION_IFSET(CPU_FTR_NEED_PAIRED_STWCX)
 	stwcx.	r0,0,r1		/* to clear the reservation */
-FTR_SECTION_ELSE
-	lwarx	r0,0,r1
-ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 
 	lwz	r3,_CCR(r1)
 	lwz	r4,_LINK(r1)
@@ -315,10 +314,9 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	mtspr	SPRN_SRR1,r12
 
 BEGIN_FTR_SECTION
+	lwarx   r0,0,r1
+END_FTR_SECTION_IFSET(CPU_FTR_NEED_PAIRED_STWCX)
 	stwcx.	r0,0,r1		/* to clear the reservation */
-FTR_SECTION_ELSE
-	lwarx	r0,0,r1
-ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 
 	lwz	r3,_LINK(r1)
 	lwz	r4,_CTR(r1)
-- 
2.51.0



