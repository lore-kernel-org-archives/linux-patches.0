Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79146168CB
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D364DC433EF;
	Mon,  8 May 2023 11:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545803;
	bh=YENT9jDGQ1qse5MmEH34CKNiF6TjxgBAcSPpfEMymFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQ6hK35GJek0KI02/96nCXkqLmCYM014frcYlECNstY9F5sFzTro8GexBbmNJIR9q
	 DMV9fzw3SxBjYx6J/cU//YQq/30c9W2oXMrD7wb4NnORvoTtuABPqmGhJPj4fM9X9O
	 ZT3koZKdQhZPoWQuJcrtNOW356qJksFfDtFfL614=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/371] x86/apic: Fix atomic update of offset in reserve_eilvt_offset()
Date: Mon,  8 May 2023 11:45:31 +0200
Message-Id: <20230508094817.199175138@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit f96fb2df3eb31ede1b34b0521560967310267750 ]

The detection of atomic update failure in reserve_eilvt_offset() is
not correct. The value returned by atomic_cmpxchg() should be compared
to the old value from the location to be updated.

If these two are the same, then atomic update succeeded and
"eilvt_offsets[offset]" location is updated to "new" in an atomic way.

Otherwise, the atomic update failed and it should be retried with the
value from "eilvt_offsets[offset]" - exactly what atomic_try_cmpxchg()
does in a correct and more optimal way.

Fixes: a68c439b1966c ("apic, x86: Check if EILVT APIC registers are available (AMD only)")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230227160917.107820-1-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ed7d9cf71f68d..4df7d694369a5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -412,10 +412,9 @@ static unsigned int reserve_eilvt_offset(int offset, unsigned int new)
 		if (vector && !eilvt_entry_is_changeable(vector, new))
 			/* may not change if vectors are different */
 			return rsvd;
-		rsvd = atomic_cmpxchg(&eilvt_offsets[offset], rsvd, new);
-	} while (rsvd != new);
+	} while (!atomic_try_cmpxchg(&eilvt_offsets[offset], &rsvd, new));
 
-	rsvd &= ~APIC_EILVT_MASKED;
+	rsvd = new & ~APIC_EILVT_MASKED;
 	if (rsvd && rsvd != vector)
 		pr_info("LVT offset %d assigned for vector 0x%02x\n",
 			offset, rsvd);
-- 
2.39.2



