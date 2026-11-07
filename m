Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063485;
	b=grjWEt5vsDP+b06BHB7TUJ7i3HjfjmXmTYYcnBBvCi4UGpq3lqjTOmUzXKyJJs6YF+zY
	 nxk/X89yknC9Q/3Gl/Enjloqwp4QBkACdG+CLmTdM6jVu7FHXPxY5X8zRuVZ5QE8WncKy
	 4Dr8ZbpdotrC7uCoJa5SO6M55id/GbOiga+iXkdFjWIb1isaco+b5gSZiOhExm2sfV/XN
	 sDkwDWbaPoBTxFQdKX7R/qNSBolVeVCQ8FEdkjpCFD+M0yQZfhZuyhmba7XOxW5rSue4C
	 9YMBvfK/xa4dPINZkm3s2+3iAW3lz9RCXJ7Ylg8bieEHvxFmDmDI1RqS2yoU0RSVVYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FvFfh+ttCLhrWAoiLyj2i3wQScvclyBBGbuQwI4bwrI=;
	b=WwMjamjqVV4ohFL8Ann1aON09x2lTETLqjnvbVg1nC9MJDOIx3rtw5OJ04fpf5uwO2a3
	 Zqme4VrHcSoJy2J8dNu5Wd4WI5xMccOadeSB6XSgCP+KmSMTHgXD/LrNPWZhQZQ98jHOD
	 ig5zOhfS55n7+cIfxKcvgEYArDAnmfKJr9F1UNgOeL1EmjULRzNZqcBdmsUOeidExdP13
	 ug4H1ynBx9nap+5duaodVtfu//6cClPEb36dx+Fns1ADCB/Laqa8zMD2TdOfrqlanvCoC
	 ODS8xZRNhYdicANHdBS8Ok1kevnpR7eKEC6bC4Ii7LEvJK42T+beDhUCwa0blDYNCnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE6214u0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC63606A9EF;
	Sat,  7 Nov 2026 14:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE6214u0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226F01F008A7;
	Sat,  7 Nov 2026 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063484;
	bh=FvFfh+ttCLhrWAoiLyj2i3wQScvclyBBGbuQwI4bwrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vE6214u0mG8vn27FgRYaJ+aR8gQ9Yf+rqMYeF0wJIJqciv9tEg2YfIRQ7bj+TQ/wg
	 9fyN2Dp3YNA4WlLL6JmoNnyMX1xkkDnNwNAdFheE4CO7UnY56faZCCAhCwMW3qWsLx
	 zM3D+ppA12Z3cVRFF95Ps8Uxilt+kiHfee9FWbo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 631/869] alpha: invalidate the local context in flush_tlb_mm()
Date: Sat,  7 Nov 2026 08:55:13 -0500
Message-ID: <20261107134914.370348518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 721bb7a129771f0ff9cef1dd5abfc106ef65feba ]

flush_tlb_mm() has the same caller-CPU omission that was fixed in
flush_tlb_page(): when the target mm is not the calling CPU's active_mm
nothing happens locally, and smp_call_function() handles only the other
CPUs, so this CPU may later reuse the old ASN together with the
translations it still holds.

The active_mm test itself is left alone here. That path calls
flush_tlb_current(), which loads a fresh context through
__load_new_mm_context() rather than issuing a targeted tbi() against
whatever ASN happens to be loaded, so it does not depend on which context
is current.

The uniprocessor implementation in asm/tlbflush.h already has the missing
branch. Counted over a fork-heavy run, flush_tlb_mm() was entered with the
mm not this CPU's active_mm 2934 times, and 632 times while otherwise idle.

The proposed Alpha hugetlb support routes hugetlb invalidations through
flush_tlb_range(), which calls this function. Unmapping or migrating a
hugetlb folio from another context will also need this local invalidate.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-8-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index a5a42ae4a7d80..988e397b0b8a7 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -649,6 +649,9 @@ flush_tlb_mm(struct mm_struct *mm)
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	smp_call_function(ipi_flush_tlb_mm, mm, 1);
-- 
2.53.0



