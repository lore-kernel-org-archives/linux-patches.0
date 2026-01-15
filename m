Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFF425228D;
	Thu, 15 Jan 2026 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495989; cv=none; b=Yg/wZSnAxahLnofoW4VDNKqWPtNB4cnQsPrvkLh4s4WuHEH4YBoKFR+eTL03elkQb75MZVC7DPD4SN9n5qiN9y6RZ32EcPdoKjKkjNLqzZLGYQ9SkNruk67nNP+TBG3rE/KJp/FvLGo7vD7Dd4Oa4T7J4nTapToPIn0qcgXVdTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495989; c=relaxed/simple;
	bh=rabq/P7hLVApFcw5uL572C50JYrWbyVST1Jzokm+/A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBpQm7gFmMPurL7kbhKAaTSmj9MeUgoBYfW7mag1ABDqigZmA4W4pjpG3bLD+lXLgafXl1SiD+ufNa2++QEOfRBwBYdybVGCJo4rmwUuw3LPpeuUHHbEFKujQZrDCHuXhtzut8lY984+8UvnPOAmhvdskdck3VD+mBi+V2Yj8es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izqNzz0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izqNzz0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1F4C116D0;
	Thu, 15 Jan 2026 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495989;
	bh=rabq/P7hLVApFcw5uL572C50JYrWbyVST1Jzokm+/A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izqNzz0/IJ07uznTe7ihAaIq7y9TkOkck7vOpIcw3HCAVauFGQIniFo9U94ZMTrqN
	 AEQ+54JSOqEjznkGsW7AdVNkb8N5HK3sZJ+ciRAsHv2ItA2rDR3odjF7dP1Pw+quz6
	 SYbnffiqv2VsPM22v6P9kR/01xYzPeaXhC+o/GnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 007/181] atm: Fix dma_free_coherent() size
Date: Thu, 15 Jan 2026 17:45:44 +0100
Message-ID: <20260115164202.581790020@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 4d984b0574ff708e66152763fbfdef24ea40933f upstream.

The size of the buffer is not the same when alloc'd with
dma_alloc_coherent() in he_init_tpdrq() and freed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260107090141.80900-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/he.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1587,7 +1587,8 @@ he_stop(struct he_dev *he_dev)
 				  he_dev->tbrq_base, he_dev->tbrq_phys);
 
 	if (he_dev->tpdrq_base)
-		dma_free_coherent(&he_dev->pci_dev->dev, CONFIG_TBRQ_SIZE * sizeof(struct he_tbrq),
+		dma_free_coherent(&he_dev->pci_dev->dev,
+				  CONFIG_TPDRQ_SIZE * sizeof(struct he_tpdrq),
 				  he_dev->tpdrq_base, he_dev->tpdrq_phys);
 
 	dma_pool_destroy(he_dev->tpd_pool);


