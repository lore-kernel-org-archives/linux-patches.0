Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8209325D1F7;
	Tue, 30 Sep 2025 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243850; cv=none; b=nNMWMYbAIaGy1tIELybFWXTWbXs+NJ33tuxfpjYMauFfuG50IVuOyC6DhEX0jH1amLgtWWpwKb8of3naAQ9TbOOauqr22FDHgV5/9THr4pDeyqTuiJp6u+RAHf2V2ZAXsoySpr2mViWCCx+rVqXDill+hXwCMvoXlLWjstyfQQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243850; c=relaxed/simple;
	bh=0JKZKlTCAX9VYORQzeT202ApgnbVXdMnshYm0uooCIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDFEa3kgxjHK2OQwCM+KsTdxDqfiELAO7FLghthULWrr+28QRafql9/c95QD65FlVFxZ1ayjr336DzTuEYSoPJyYw/VGCOXMqtPvkJ7R2XhKWjLSq91gofMFCt+W34PylR2TNYmEAdn/lEeDl2CCOrJK4wFMZPUzMKjmunr7szE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHqCdqrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHqCdqrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EA3C4CEF0;
	Tue, 30 Sep 2025 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243850;
	bh=0JKZKlTCAX9VYORQzeT202ApgnbVXdMnshYm0uooCIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHqCdqrCNOYTkWRSgSqXCsbJd/RXUlfjAl0cXIVV3QwDW1XG3a9Un1MA2our94wMo
	 c+9l34YpiooSpFMOSkMvQaAV0S/Kx1w5FqMveP5TE+Rj7ViswLrU0p3iz6M6QvUpZS
	 +OJP356yBrRao7LFg7WQq3eZhpJQ6YhzpE/twW2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 5.4 36/81] i40e: remove redundant memory barrier when cleaning Tx descs
Date: Tue, 30 Sep 2025 16:46:38 +0200
Message-ID: <20250930143821.186678683@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit e37084a26070c546ae7961ee135bbfb15fbe13fd ]

i40e has a feature which writes to memory location last descriptor
successfully sent. Memory barrier in i40e_clean_tx_irq() was used to
avoid forward-reading descriptor fields in case DD bit was not set.
Having mentioned feature in place implies that such situation will not
happen as we know in advance how many descriptors HW has dealt with.

Besides, this barrier placement was wrong. Idea is to have this
protection *after* reading DD bit from HW descriptor, not before.
Digging through git history showed me that indeed barrier was before DD
bit check, anyways the commit introducing i40e_get_head() should have
wiped it out altogether.

Also, there was one commit doing s/read_barrier_depends/smp_rmb when get
head feature was already in place, but it was only theoretical based on
ixgbe experiences, which is different in these terms as that driver has
to read DD bit from HW descriptor.

Fixes: 1943d8ba9507 ("i40e/i40evf: enable hardware feature head write back")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 6067c88668341..ff213cbe84ca8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -794,9 +794,6 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 		if (!eop_desc)
 			break;
 
-		/* prevent any other reads prior to eop_desc */
-		smp_rmb();
-
 		i40e_trace(clean_tx_irq, tx_ring, tx_desc, tx_buf);
 		/* we have caught up to head, no work left to do */
 		if (tx_head == tx_desc)
-- 
2.51.0



