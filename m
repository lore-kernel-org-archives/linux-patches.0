Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697FE18871F;
	Wed,  4 Feb 2026 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217882; cv=none; b=Wbi3YgpPyu9Ji878fqRJ+HHDpI1fhXx+wM5nyLq4Q2GcXXzMziELhXCo9pGxRKA7/fdtl1meXKlOcXNQ1FoqGIPTVrXeyJBagYgLx1jSAzopBKH3hmoEU6ae1yLVcfUPrBObaKT49CALu0dUsu9TOVLzXAwBnlpd1Z89SQ7QNq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217882; c=relaxed/simple;
	bh=G1LYZO2WTUn+ihbNUw1VdwTTlIShiGK5q2h/S07OGOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmkUlM9/qXpI2H5w+mDYY8JWJWbjWYUkYqryNbRcFGhxDbCxnfxbcU7LZalJBm5vq1ykgTOp4KzhQfzHsFxM3RBM4jD7iK+hnnK9aZ42+oqytVthtoUN5xGTKlqQAE87mBkVZIIJQacywXhapUWo/53ArEOTNeJDt4xuFO7ef2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yG5zegeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yG5zegeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE32C116C6;
	Wed,  4 Feb 2026 15:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217882;
	bh=G1LYZO2WTUn+ihbNUw1VdwTTlIShiGK5q2h/S07OGOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yG5zegeDu7wecKeyMV/d4dicY3rQ8v9y4U2yy4+eAXKZmrDKNdjcqONJPaI9+LAyJ
	 0Yym5IMdV//8ewKUXdsIVk37d64IOtYsgSCDf/0BYsskEjjvbLNQE5QFjzzTDSX2Me
	 28r5LrQEaJFZU9TH6yp6xJQbChGvOkGtDfm1/Uno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/280] be2net: Fix NULL pointer dereference in be_cmd_get_mac_from_list
Date: Wed,  4 Feb 2026 15:38:41 +0100
Message-ID: <20260204143914.923836534@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

[ Upstream commit 8215794403d264739cc676668087512950b2ff31 ]

When the parameter pmac_id_valid argument of be_cmd_get_mac_from_list() is
set to false, the driver may request the PMAC_ID from the firmware of the
network card, and this function will store that PMAC_ID at the provided
address pmac_id. This is the contract of this function.

However, there is a location within the driver where both
pmac_id_valid == false and pmac_id == NULL are being passed. This could
result in dereferencing a NULL pointer.

To resolve this issue, it is necessary to pass the address of a stub
variable to the function.

Fixes: 95046b927a54 ("be2net: refactor MAC-addr setup code")
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Link: https://patch.msgid.link/20260120113734.20193-1-a.vatoropin@crpt.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index e764d2be4948a..12c48ad9a32d6 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -3796,6 +3796,7 @@ int be_cmd_get_perm_mac(struct be_adapter *adapter, u8 *mac)
 {
 	int status;
 	bool pmac_valid = false;
+	u32 pmac_id;
 
 	eth_zero_addr(mac);
 
@@ -3808,7 +3809,7 @@ int be_cmd_get_perm_mac(struct be_adapter *adapter, u8 *mac)
 						       adapter->if_handle, 0);
 	} else {
 		status = be_cmd_get_mac_from_list(adapter, mac, &pmac_valid,
-						  NULL, adapter->if_handle, 0);
+						  &pmac_id, adapter->if_handle, 0);
 	}
 
 	return status;
-- 
2.51.0



