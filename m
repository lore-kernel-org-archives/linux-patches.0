Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F08016423;
	Tue, 27 Feb 2024 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043077; cv=none; b=XXhn/fPvlHTOpyAnGPdWx+MWMyaIS3leKY9P4OJEqIia0q/6E6AQwbO6BXf2i561wF1yV3KgoEs9ouSsj4WRvlNcOTN9aMjjXtmeGMLdj8poPKDlgvMdOSJIWQolQsEnSrCkovssN8ynlKf37ykZclGSdqSthbfSkCHaZ1jgzt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043077; c=relaxed/simple;
	bh=1gzVs4t4zvp9xzxBth+EoiEzPPa3/9gMEaMOG5ORPOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjEl+e37iXPqHlla0+385GByDIjbRm4RTr5/R3LKtTJVOoxNRw/v+fVOK3/9kHoMk4PGA/KQDkktb8FO0fxvtIYJ/N+bSITYeyVnz8Et67VXCCJMTj5WNSVjuJDW7jFt3rUn1FFl50dRZPOmx7xl3DCvuaXcI7SJ+pZL75wfi60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7S/yesO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7S/yesO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47F0C43390;
	Tue, 27 Feb 2024 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043077;
	bh=1gzVs4t4zvp9xzxBth+EoiEzPPa3/9gMEaMOG5ORPOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7S/yesOtfSRih4qfmUaYvahUX1K3F7E5BxFHF9HzX0YziiBQfb1V3hKKzW6fzHUX
	 q4WjP+xqEbTbLFDeed44zU1CT4KbtriQFKWidwxQYIf9ccks7+kF5mfc6EIKdNbfr1
	 n4xVHrK8SVbScfmfDEXSpjb+N41tt6CQpoS1Gvwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/245] octeontx2-af: Consider the action set by PF
Date: Tue, 27 Feb 2024 14:26:54 +0100
Message-ID: <20240227131622.533118000@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 70b4f2a3b02fd..604aaa9b960e9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -436,6 +436,10 @@ static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
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



