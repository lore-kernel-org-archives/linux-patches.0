Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0585F2874E6;
	Thu, 20 Aug 2026 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238568; cv=none; b=WTRAyxrJWlmC9hyvYIXJBbWtmAvmugATLD0oQIMITWwOuP1G7+aoSOGl7GOEi1J2PPhTQe7bKJo23q3pecBiUosUhnD16M0+Uy7dLzNx5TpnnZSJTZixbnKAU7GkzFCi01RQDbfx6EMNYb/LDGVsz5ng8O/DtkmdKxT57vcH+4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238568; c=relaxed/simple;
	bh=Q+91nfEu0iIL61qRNv7XHaFH+2U+91FrAjvS6sXk2Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo1/5QNFfcYdOUc7MrJ37zPymEuSRnrBW9nNrOWQV6WG2BPur/upQh9osd44YMtFSSOgqGUcyBLLmEfxnYRjwSqwVd/ldfRfqD+V57Hb+FRLA7vOENox2m4Ln0H8sCCGS6q2DtbmPHWie8/051U4XiePZXe2oxkvspGPD9B7fZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoO+Hkpp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoO+Hkpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282511F000E9;
	Thu, 20 Aug 2026 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238566;
	bh=MM00KySspAfWWoZrI7vR3LXnPI0u4R7pngl2d+uikbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YoO+Hkpp6yBYcmhLUljxdVTOS0nxpZ7WGsya2urhFZYEDGcJ7QawX7a1wpOAlHAB6
	 XhAekfo0ESJRXqdN1nBJmD6N/SniOlrUO5tJlrtXVwOEBsFm5fYv8w0yQif8R3fyjX
	 Fy/qVi0rW6nZPFNPpFYG1RyxW535aypnzV08ZJRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 193/228] eth: bnxt: cancel IRQ notifier before freeing affinity mask
Date: Thu, 20 Aug 2026 16:55:35 +0200
Message-ID: <20260820145250.583133976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c703f62c30f2db7f40ad575f0034636d8a401fac ]

bnxt_irq_affinity_notify() copies into irq->cpu_mask.
Cancel the notifier before freeing irq->cpu_mask.

Fixes: c214410c47d6 ("bnxt_en: Add TPH support in BNXT driver")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260803193135.2030368-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f0625c2fb2aa0..0ccf150eb9f42 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11874,14 +11874,14 @@ static void bnxt_free_irq(struct bnxt *bp)
 
 		irq = &bp->irq_tbl[map_idx];
 		if (irq->requested) {
+			bnxt_release_irq_notifier(irq);
+
 			if (irq->have_cpumask) {
 				irq_update_affinity_hint(irq->vector, NULL);
 				free_cpumask_var(irq->cpu_mask);
 				irq->have_cpumask = 0;
 			}
 
-			bnxt_release_irq_notifier(irq);
-
 			free_irq(irq->vector, bp->bnapi[i]);
 		}
 
-- 
2.53.0



