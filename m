Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC183E49E7;
	Tue, 21 Jul 2026 17:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653918; cv=none; b=j34zrq1NYebUuYJATihQo9sk5O84Lv88owTIEfo0MyCVqaKOXNVpuNoDX+2CeugWwycKVN+rNQuWKfm5R7Ell7Do9ecttCS9qeICT5dKhHX+8pxGzTaDlJGCt7DDp+kprdpATBHxEfigRl9tbTVzFarZ4n7xGy8KOcbflkwNiQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653918; c=relaxed/simple;
	bh=zwaqucOkjvBPaOv7efJmKsWB/aqfLDzq1UQs27bbmFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjCIBj6rs4KSAuP3nI3r69Hi172eNo+/pJbPxq3rH1MT2aK2QMmBHcIm/tKJrU/PxHZj2cmhfOn/XMRaDciUL+ispSk1Om8Bd4M7D6v9d9SmbuS5gfX9tcxutljnzeB63SNyLTed9nGiUizqDGn9yxL7dr3vLVzs+ppxbTh3ToQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgxoCkOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgxoCkOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0EB1F000E9;
	Tue, 21 Jul 2026 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653917;
	bh=jQUG3qr7JGi7708WHnePzu712dTGsl854J86QPQnBnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgxoCkOj9jhg3oZCf0LnKRyqsdE8T6DMQSkh2kZ7fMeufOAeD6XdYOcMCbiUE6uJt
	 tzM1EXU4PcrneWRHz0gxyN8I7I/dq06S4+XdTU48G7Ks/IDp84HJ01RDX4aCo6noNR
	 bvHKllMCgXjObsj+2F75TgsDHl3RZZYd66YJ9uvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harman Kalra <hkalra@marvell.com>,
	Nitin Shetty J <nshettyj@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1507/2077] octeontx2-af: fix VF bringup affecting PF promiscuous state
Date: Tue, 21 Jul 2026 17:19:40 +0200
Message-ID: <20260721152628.330395178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Harman Kalra <hkalra@marvell.com>

[ Upstream commit fabb881df322da25442f98d23f5fa371e3c78ec4 ]

Mbox handling of nix_set_rx_mode for a VF with promiscuous and
all_multi flags set to false causes deletion of the PF's promiscuous
and allmulti MCAM rules. This occurs because the APIs that
enable/disable these rules operate only on the PF, even when the
mbox request is made via a VF interface.

Guard both rvu_npc_enable_allmulti_entry() and
rvu_npc_enable_promisc_entry() disable paths with an is_vf() check so
that a VF bringing up or tearing down its interface cannot inadvertently
clear the PF's MCAM rules.

Fixes: 967db3529eca ("octeontx2-af: add support for multicast/promisc packet replication feature")
Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Nitin Shetty J <nshettyj@marvell.com>
Link: https://patch.msgid.link/20260702045616.3002773-2-nshettyj@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index f977734ae712c6..f4c066aff3716e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4548,7 +4548,7 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 		rvu_npc_install_allmulti_entry(rvu, pcifunc, nixlf,
 					       pfvf->rx_chan_base);
 	} else {
-		if (!nix_rx_multicast)
+		if (!nix_rx_multicast && !is_vf(pcifunc))
 			rvu_npc_enable_allmulti_entry(rvu, pcifunc, nixlf, false);
 	}
 
@@ -4558,7 +4558,7 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 					      pfvf->rx_chan_base,
 					      pfvf->rx_chan_cnt);
 	else
-		if (!nix_rx_multicast)
+		if (!nix_rx_multicast && !is_vf(pcifunc))
 			rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf, false);
 
 	return 0;
-- 
2.53.0



