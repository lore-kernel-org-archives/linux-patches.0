Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3032C026F;
	Wed,  4 Feb 2026 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218912; cv=none; b=icQbhzELBT581evblJznZo1lEh2LjiaW5+RSrVVM8EsCVAqxyMg0I3w9WTOU/KDxfFS6j8Jzd9MNOSMhYI+821tR1lRNASkWNKLeDA2aeWcVN30uPEVfhvCyy7kZhNGadJ/7ArJm/RfOOxMlkyLe4VADHVYQ5zQ3vv00TiJhioc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218912; c=relaxed/simple;
	bh=c0EDH3lMPnlDYsOfwRuSrAh30yZmpDKKU5iCE+dwvhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4ivNxkt4lx2IRyMWfgWpoJsK+uaZyLn9WXgSgR32DBVIyJBcC0v/iOewUMgNNAlPeMUaS9VoBsSLLDkfg1X2zQrbZ+zJdNNh1GckTyNTjlyrVW1kyybnEnCYHkdgMyawbxBECEyvGsw4aS4IwGR7ztuuSfdOt0NWtm3FyDahzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKaYStxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKaYStxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946B9C116C6;
	Wed,  4 Feb 2026 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218912;
	bh=c0EDH3lMPnlDYsOfwRuSrAh30yZmpDKKU5iCE+dwvhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKaYStxmfgEnouPO0QgqzoSlvySBawRLL63f+hgiQgDOgBAAdFgIsWg7KvH8ELEcE
	 2UpJXs5fT1AvG4s23Lsn3SglurmYrSKBALsqbcdG+pKo4OuytQP0fzdKiP/hRGdW2b
	 0fpRmJ/ApT2VIkkS9DNX2JumHzQPqcabe5Ru4gj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damir Mansurov <damir.mansurov@oktetlabs.ru>,
	Ben Hutchings <ben@decadent.org.uk>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/122] sfc: fix deadlock in RSS config read
Date: Wed,  4 Feb 2026 15:39:53 +0100
Message-ID: <20260204143852.271444224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Edward Cree <ecree.xilinx@gmail.com>

[ Upstream commit 944c614b0a7afa5b87612c3fb557b95a50ad654c ]

Since cited commit, core locks the net_device's rss_lock when handling
 ethtool -x command, so driver's implementation should not lock it
 again.  Remove the latter.

Fixes: 040cef30b5e6 ("net: ethtool: move get_rxfh callback under the rss_lock")
Reported-by: Damir Mansurov <damir.mansurov@oktetlabs.ru>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1126015
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://patch.msgid.link/20260123161634.1215006-1-edward.cree@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/mcdi_filters.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 6ef96292909a2..3db589b90b68a 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -2182,12 +2182,7 @@ int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
 
 int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx)
 {
-	int rc;
-
-	mutex_lock(&efx->net_dev->ethtool->rss_lock);
-	rc = efx_mcdi_rx_pull_rss_context_config(efx, &efx->rss_context);
-	mutex_unlock(&efx->net_dev->ethtool->rss_lock);
-	return rc;
+	return efx_mcdi_rx_pull_rss_context_config(efx, &efx->rss_context);
 }
 
 void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx)
-- 
2.51.0



