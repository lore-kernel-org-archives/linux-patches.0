Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE512FE56A;
	Tue, 21 Jul 2026 18:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658302; cv=none; b=FEYHwXSruOnv/1phWX5RGGCJ4cHGxGvsqGLCSBZcgdZI6i/qSt543fLPWG9UbRqHVain7oMDep+LLUBxMI6zzE8La8yHNuUFn4Zo+/At9Jtwp/zA7Mq6beGiv3WAMjRtFPhuLze2hwJB+WgIqarH9NMgQfBAQv3/rj8DkFpiTg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658302; c=relaxed/simple;
	bh=AAAVbIANxkDAlOL6+K1chmJ5brYLPCHTIb7xWSl7/tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjX2Wgfu3sVjUdInXp5/5hLowTBMm5RqzdxySSsw5npCjulRSSiGa1Cde8Oi08Opode8S/jL8gndqbywtv4DPowJ1jayOmNb4W7pwAYfKd4d+93G3kMWwcVWHRj6ClcwTFYXOaggce5pE4j1h0pQHaYaHVOX3O6mdowGW/eVdjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUl29l9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUl29l9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19381F000E9;
	Tue, 21 Jul 2026 18:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658301;
	bh=RyTz+/5XmNfPkHt2hJ626VfYamGr/9gZTL/v3Atkgw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUl29l9qXhtAtUt5VxrPox6wAWJX1X9a1CYUOg79FbUWZSsYDxgSrwovjftpdzsjX
	 JY1KLZQwh/7r/zo31Q3ndJv/HzwidrPZ5OI1DlDgGjO6RRkKwiXl/p5LuAfv1rIiIG
	 vWL+oh09c4x79VTuuqmNykAGjFYg3QZ7eMOHSf7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harman Kalra <hkalra@marvell.com>,
	Nitin Shetty J <nshettyj@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1092/1611] octeontx2-af: fix VF bringup affecting PF promiscuous state
Date: Tue, 21 Jul 2026 17:20:08 +0200
Message-ID: <20260721152539.979876083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index c9c65ac69ead86..3563cfc679049c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4539,7 +4539,7 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 		rvu_npc_install_allmulti_entry(rvu, pcifunc, nixlf,
 					       pfvf->rx_chan_base);
 	} else {
-		if (!nix_rx_multicast)
+		if (!nix_rx_multicast && !is_vf(pcifunc))
 			rvu_npc_enable_allmulti_entry(rvu, pcifunc, nixlf, false);
 	}
 
@@ -4549,7 +4549,7 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 					      pfvf->rx_chan_base,
 					      pfvf->rx_chan_cnt);
 	else
-		if (!nix_rx_multicast)
+		if (!nix_rx_multicast && !is_vf(pcifunc))
 			rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf, false);
 
 	return 0;
-- 
2.53.0



