Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563D413B2B4;
	Tue, 27 Feb 2024 14:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043666; cv=none; b=UIIsx+nUyg3lHxHA1OMa4eOULGEV+2Xs/AFH3X96xDT4aFvWQ9zxv/YrzbbafeVjFT2w6a9+nPFdUkfi01UR5Gp0dSt2S0spyWlbgPAl/zrIqDR9OtMALeYfCqIk5301TtKCGzVAQ3BtgQnFLd8Ka7fif63ZzVjsV9Pl8/OGhDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043666; c=relaxed/simple;
	bh=zWxBq+om0JkHUCR44v+dp6+c8DIlwvP4ZrWy8vOGS2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/8H9GmFDOPzKXOl1WXJxdOXdye4fuHHK/+pfMdrlj/w8AF53eEKXw9ASQo+21ZiG/KMQM51lPyxWm7qr6BHazoDcId2tBcyzYVvK0BEiS/1eEJkL+lf89m5lvu6cbVDcljDELsj7GXz5beH3WVPgYKAeE7fgtylVKcJbw+qZzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCIla8Vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCIla8Vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC74C433F1;
	Tue, 27 Feb 2024 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043666;
	bh=zWxBq+om0JkHUCR44v+dp6+c8DIlwvP4ZrWy8vOGS2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCIla8Vf2Jxzq4S/XghNEVVY7vyVLnv9rfme6iQc8puGw6usUdDuZC8SxmG0rQYZo
	 ZIZ99Uvbc1sVMYG8vS8o6oGq4mxd91hj5ln5p+w8tu+ivM9rK5SWHqwxLeNTdqpLeK
	 FIRFQlsSVp0rOn3QgylOLGdWjD42FiYNvMrMVYWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/195] octeontx2-af: Consider the action set by PF
Date: Tue, 27 Feb 2024 14:27:04 +0100
Message-ID: <20240227131615.793411317@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 3b1ae9b71c2a97f848b00fb085a2bd29bddbe8d9 ]

AF reserves MCAM entries for each PF, VF present in the
system and populates the entry with DMAC and action with
default RSS so that basic packet I/O works. Since PF/VF is
not aware of the RSS action installed by AF, AF only fixup
the actions of the rules installed by PF/VF with corresponding
default RSS action. This worked well for rules installed by
PF/VF for features like RX VLAN offload and DMAC filters but
rules involving action like drop/forward to queue are also
getting modified by AF. Hence fix it by setting the default
RSS action only if requested by PF/VF.

Fixes: 967db3529eca ("octeontx2-af: add support for multicast/promisc packet replication feature")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 3784347b6fd88..55639c133dd02 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -437,6 +437,10 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
 			return;
 	}
 
+	/* AF modifies given action iff PF/VF has requested for it */
+	if ((entry->action & 0xFULL) != NIX_RX_ACTION_DEFAULT)
+		return;
+
 	/* copy VF default entry action to the VF mcam entry */
 	rx_action = npc_get_default_entry_action(rvu, mcam, blkaddr,
 						 target_func);
-- 
2.43.0



