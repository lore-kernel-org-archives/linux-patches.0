Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6A31AC893;
	Thu, 15 Aug 2024 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732763; cv=none; b=r2KvSXg12cX8ZCZHQrzAH3+NCHBhadn97MFszbpxdtXDhvvOS2vCHXu4I4UlIkVKojnCBpuqxlCVz9tnkgtv38llpcd8FMJOSmsVKdgy2YKX41psvOtThS0+A76obzMIdu8/wbB5zaQjF4q7HFrlakyAIADB+YpQQRSibUV77mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732763; c=relaxed/simple;
	bh=3r2e4UFhFtjdrUR3y7nBNCQR5mCZge7Hn/tKUV2P1sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKDQzzfZ9T5zxyw2/ojWydXra/wiUIvxin8o6sX1gGwMpeowXpnvBDi1b6iF5MXBsZGD0i/pqZNNxQZPDCu6nSHOXHM/Mqa+7G5GWYYLKzNsa1jX8gOwHw6D+8tfJfIqmWolbHtwGXJOHv7fRT96uOTeEA8X+h/9ohj97G4UnFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OD5JboiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OD5JboiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EC1C4AF0D;
	Thu, 15 Aug 2024 14:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732762;
	bh=3r2e4UFhFtjdrUR3y7nBNCQR5mCZge7Hn/tKUV2P1sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OD5JboiDSQo0mCIH9T1JCvVJvBNwJ19ZhBUVgcOJa++EF359hHPNnYPjc3iYgS5xZ
	 EF+YFuA71fK9bvcNHEOqn2RfOTwkBw8GVY3dk2PMiAHwJ+MjU2rp/qDz03bErDPnx7
	 CEZP8HBeMxUxgyuW5v6W/EtrxyeQ0DCasBfymS60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/352] x86/mm: Fix pti_clone_pgtable() alignment assumption
Date: Thu, 15 Aug 2024 15:25:17 +0200
Message-ID: <20240815131929.140086739@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 41e71dbb0e0a0fe214545fe64af031303a08524c ]

Guenter reported dodgy crashes on an i386-nosmp build using GCC-11
that had the form of endless traps until entry stack exhaust and then
#DF from the stack guard.

It turned out that pti_clone_pgtable() had alignment assumptions on
the start address, notably it hard assumes start is PMD aligned. This
is true on x86_64, but very much not true on i386.

These assumptions can cause the end condition to malfunction, leading
to a 'short' clone. Guess what happens when the user mapping has a
short copy of the entry text?

Use the correct increment form for addr to avoid alignment
assumptions.

Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32 bit")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20240731163105.GG33588@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pti.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index 1aab92930569a..59c13fdb8da0f 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -374,14 +374,14 @@ pti_clone_pgtable(unsigned long start, unsigned long end,
 			 */
 			*target_pmd = *pmd;
 
-			addr += PMD_SIZE;
+			addr = round_up(addr + 1, PMD_SIZE);
 
 		} else if (level == PTI_CLONE_PTE) {
 
 			/* Walk the page-table down to the pte level */
 			pte = pte_offset_kernel(pmd, addr);
 			if (pte_none(*pte)) {
-				addr += PAGE_SIZE;
+				addr = round_up(addr + 1, PAGE_SIZE);
 				continue;
 			}
 
@@ -401,7 +401,7 @@ pti_clone_pgtable(unsigned long start, unsigned long end,
 			/* Clone the PTE */
 			*target_pte = *pte;
 
-			addr += PAGE_SIZE;
+			addr = round_up(addr + 1, PAGE_SIZE);
 
 		} else {
 			BUG();
-- 
2.43.0



