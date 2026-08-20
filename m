Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3088B380FCE;
	Thu, 20 Aug 2026 15:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239198; cv=none; b=TN/P+GjQBETnWUjwHVNHMAL6ErPTOa5yENfU4qp2s3xeJ8GNXsVkwbNujf2bzpQBV04JUWJ4yiJBMp1BJlqwomgqN7sy4Bg7h72sKbXveL+FGi8liUTzYSNBoWPfYgjY1oOF9sMUQkNrn79cJe7G6rK+9XrOOJq95tVM8Luc/3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239198; c=relaxed/simple;
	bh=eXHP1KfAprlepgmdbEwtuPGRsHEFlHTztdOaI4eZRSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJ6AbQWjnifN5oBNpiXvM1c7JXFZxyEaOZrokw/nzM9O1DUzr1t5CoK0xbmPOHFGlPSr6Jgbq8LtE6g6bTfzY/JO+NXgOwNuEp3aMFxNAptmhiTK4tWsXED9NmkB3yazuk0tg/1vd0OrRgwT2yx4nSPShx/EVmSrtmL1+eSyS8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrA1Rsgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrA1Rsgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8641F000E9;
	Thu, 20 Aug 2026 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239197;
	bh=FpcGIzkz4mJ3x7gElThiOWH3njBWDwi7d0B945G6Y+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrA1Rsgy5RHvb7Ylo9KaNaBBRAlI5BoOgbvj84wEGMVGF1Kx2gqXRQKPrmHlR6NWH
	 s5WlfChMrNvbOqCvOqwhhjKDw2X+S0ngoaMeqoI8FP2zNgZK2BbHfLpo9JvO8Q8fsF
	 qfdt0vLhbM9WAvw5pBLbs1ys0odEwN8z0ascD+ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 183/217] eth: bnxt: cancel IRQ notifier before freeing affinity mask
Date: Thu, 20 Aug 2026 16:55:51 +0200
Message-ID: <20260820145243.235932021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 02ed85473374d..76d6f5979ed2d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11728,14 +11728,14 @@ static void bnxt_free_irq(struct bnxt *bp)
 
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



