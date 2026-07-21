Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665F03B995D;
	Tue, 21 Jul 2026 20:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666976; cv=none; b=Y+TRfH1SbMaaGgRaZjKdtLlXDhWcmiP8L+1oQFi+Q+VglTGXRp9st2fENdbsdbKYR/f5qckTjI1/ahMkrh1t7jYMhaVc/yfz5KQgbV44pp+yHz6CMeHXB4ZZJIGENrUopYMp4BnZ7YqzDseGxxag3CIR40BqJfX2UtQSdkYzHF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666976; c=relaxed/simple;
	bh=KkFp//VI6tAU+euIza73u0NkFv7QQ2bQVWpgeUy45HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbaOMTFxzbRDKGCHw7UAlUkQwKBvkWIwM8JGERDKOWAKPG8WVn3dtESOvbYlF5zK5DcH3yRoEIbjY/UgVg4KfPfEZ9G2S81mtgkzaF8BeVp6pQrKIIJEFnyY8oAUyt6Plsz0zyoEBO++TpW3wx5rwwiDnzP0WOFuSJf8jxLvcYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmBJUKBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmBJUKBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970151F000E9;
	Tue, 21 Jul 2026 20:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666975;
	bh=hPdW7LZXNlCcktYcu2KN3n0CkNZ+QeaTJ1Y5CszTiaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmBJUKBZCnV1RV3PES00z4gGPLzKYz4tAAEAzTiazZWU3YxcqguA8Rgz7kpjsGnyU
	 oHdLtbPf3LymCxWhhUz/8wJUQHnmO4goUp0k14aoWdQI4OmtRZgpLL+XKxRtUdgZY3
	 5M9Uoibc/KvafkZNUrUH4Um2aR4BUTMfSMUq+a/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harman Kalra <hkalra@marvell.com>,
	Nitin Shetty J <nshettyj@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0887/1266] octeontx2-af: fix VF bringup affecting PF promiscuous state
Date: Tue, 21 Jul 2026 17:22:04 +0200
Message-ID: <20260721152501.698415119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0703b0d8df783e..095c339166b515 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4121,7 +4121,7 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 		rvu_npc_install_allmulti_entry(rvu, pcifunc, nixlf,
 					       pfvf->rx_chan_base);
 	} else {
-		if (!nix_rx_multicast)
+		if (!nix_rx_multicast && !is_vf(pcifunc))
 			rvu_npc_enable_allmulti_entry(rvu, pcifunc, nixlf, false);
 	}
 
@@ -4131,7 +4131,7 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 					      pfvf->rx_chan_base,
 					      pfvf->rx_chan_cnt);
 	else
-		if (!nix_rx_multicast)
+		if (!nix_rx_multicast && !is_vf(pcifunc))
 			rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf, false);
 
 	return 0;
-- 
2.53.0



