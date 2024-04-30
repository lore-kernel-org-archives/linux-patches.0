Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038AB12B176;
	Tue, 30 Apr 2024 11:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475007; cv=none; b=ibgAOAn1FXyTj1iHVLZXwWd24UoloHzfBpk/bbWw4t42FPtLOf+9iQNoBTMedn5ge0cd4BH4Q4MvtT1ecg2xISFJc3lowy9rgqDCPSz8kxcUnDmeznsnyuAq0jO5olCYTiZ9IhAkBxWsKEVO04UnXNhp7dR6Hi412bfcaJhoJmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475007; c=relaxed/simple;
	bh=tkqhhWF1+LrerAqg1B1hT/lEKAgcggYekJ6kRffMYqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnjOojov07rEHoyM97MvAXr5va5iJatfEy8bKCY8pAXuuYutf7Rt97rIl0kvUx0xtMHA5JvwO7NgeDzNMsWNUKluqjuA/m8N7O3TutM9lhayZaWqO7RfhSWuwKRElcC7gSOHvAFbyYQ2XVUgj9DoaG+4YMcYsKEZSAhci3/YGUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smwQLbSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smwQLbSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3CCC2BBFC;
	Tue, 30 Apr 2024 11:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475006;
	bh=tkqhhWF1+LrerAqg1B1hT/lEKAgcggYekJ6kRffMYqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smwQLbSJ/GHCNOPl4D6+L2KpJHEAZqzdhpngKXGguErjovu2Id8HhiGw/ianh/t8m
	 TOsNOa3imMXg2/bH7GEuH2OqqmfASL+USFDlTZG6Vhg2eofWqrN67WN7xgd7x64Bll
	 jw4wH4ZG+4M+qzDZmxyGDAnRbsgI+Oo/MILanlJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erwan Velu <e.velu@criteo.com>,
	Simon Horman <horms@kernel.org>,
	Tony Brelinski <tony.brelinski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/138] i40e: Report MFS in decimal base instead of hex
Date: Tue, 30 Apr 2024 12:39:48 +0200
Message-ID: <20240430103052.445878949@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

From: Erwan Velu <e.velu@criteo.com>

[ Upstream commit ef3c313119ea448c22da10366faa26b5b4b1a18e ]

If the MFS is set below the default (0x2600), a warning message is
reported like the following :

	MFS for port 1 has been set below the default: 600

This message is a bit confusing as the number shown here (600) is in
fact an hexa number: 0x600 = 1536

Without any explicit "0x" prefix, this message is read like the MFS is
set to 600 bytes.

MFS, as per MTUs, are usually expressed in decimal base.

This commit reports both current and default MFS values in decimal
so it's less confusing for end-users.

A typical warning message looks like the following :

	MFS for port 1 (1536) has been set below the default (9728)

Signed-off-by: Erwan Velu <e.velu@criteo.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Fixes: 3a2c6ced90e1 ("i40e: Add a check to see if MFS is set")
Link: https://lore.kernel.org/r/20240423182723.740401-3-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d01338a9bbaf4..35a903f6df215 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15488,8 +15488,8 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	val = (rd32(&pf->hw, I40E_PRTGL_SAH) &
 	       I40E_PRTGL_SAH_MFS_MASK) >> I40E_PRTGL_SAH_MFS_SHIFT;
 	if (val < MAX_FRAME_SIZE_DEFAULT)
-		dev_warn(&pdev->dev, "MFS for port %x has been set below the default: %x\n",
-			 pf->hw.port, val);
+		dev_warn(&pdev->dev, "MFS for port %x (%d) has been set below the default (%d)\n",
+			 pf->hw.port, val, MAX_FRAME_SIZE_DEFAULT);
 
 	/* Add a filter to drop all Flow control frames from any VSI from being
 	 * transmitted. By doing so we stop a malicious VF from sending out
-- 
2.43.0



