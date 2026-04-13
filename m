Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CEB225A38;
	Mon, 13 Apr 2026 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097917; cv=none; b=A10GnFFBE9Mtm8czZjE98PGWVFFHKqD0j3oAa5+M+Q52LsF4FH57vcS3k+d0Tm/j6l+k7f8zcDQtk8C31bWYQtajlmc7RlUWQYZuIjAZsubxLapfG0ErgT6umslCoqPSSOMyGqXptJ1BuOTmIXEK9WjioDdYYUQflYT16don/pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097917; c=relaxed/simple;
	bh=BUng4L1k9NktEzFstwiJlsAuoiTRxVoiFvLAIqq5b3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWgreNgqevOmiMTBAInSxR8WCEI6PwM0ojxN6aP0LaJObub0S7QG3MR8JB5sqHSBdcE+QyYKEUGj00cUWmBvZ+uTGnIDWFbMjeWfCGuOv+lbxl2KJqR6FUocdDkhyI9KE+ncifzqiKv8PuFr3gqkF9fMUq3mNlqyvt93yvTy6B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYfaQQ01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYfaQQ01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F8FC2BCAF;
	Mon, 13 Apr 2026 16:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097916;
	bh=BUng4L1k9NktEzFstwiJlsAuoiTRxVoiFvLAIqq5b3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYfaQQ01IZGeV31+Kstn3xtzKUcsMDC5KW9o2ZStfkHbrhdDPHfpNtgXb6ZgakE63
	 Nk10XdpQasUgafX+mmxCAEUowCvAe4+TmtQyXNdfTu35its1wW9aLAXnbzXiTJALDz
	 4OUPMwsBHj//81n+0SOjcNIFkKT3mzD5KDAvkmSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Heib <mheib@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 322/570] ionic: fix persistent MAC address override on PF
Date: Mon, 13 Apr 2026 17:57:33 +0200
Message-ID: <20260413155842.558030599@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammad Heib <mheib@redhat.com>

[ Upstream commit cbcb3cfcdc436d6f91a3d95ecfa9c831abe14aed ]

The use of IONIC_CMD_LIF_SETATTR in the MAC address update path causes
the ionic firmware to update the LIF's identity in its persistent state.
Since the firmware state is maintained across host warm boots and driver
reloads, any MAC change on the Physical Function (PF) becomes "sticky.

This is problematic because it causes ethtool -P to report the
user-configured MAC as the permanent factory address, which breaks
system management tools that rely on a stable hardware identity.

While Virtual Functions (VFs) need this hardware-level programming to
properly handle MAC assignments in guest environments, the PF should
maintain standard transient behavior. This patch gates the
ionic_program_mac call using is_virtfn so that PF MAC changes remain
local to the netdev filters and do not overwrite the firmware's
permanent identity block.

Fixes: 19058be7c48c ("ionic: VF initial random MAC address if no assigned mac")
Signed-off-by: Mohammad Heib <mheib@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Link: https://patch.msgid.link/20260317170806.35390-1-mheib@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index cdc3c55fab6ac..0e44e616c6da1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1763,13 +1763,18 @@ static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 	if (ether_addr_equal(netdev->dev_addr, mac))
 		return 0;
 
-	err = ionic_program_mac(lif, mac);
-	if (err < 0)
-		return err;
+	/* Only program macs for virtual functions to avoid losing the permanent
+	 * Mac across warm reset/reboot.
+	 */
+	if (lif->ionic->pdev->is_virtfn) {
+		err = ionic_program_mac(lif, mac);
+		if (err < 0)
+			return err;
 
-	if (err > 0)
-		netdev_dbg(netdev, "%s: SET and GET ATTR Mac are not equal-due to old FW running\n",
-			   __func__);
+		if (err > 0)
+			netdev_dbg(netdev, "%s: SET and GET ATTR Mac are not equal-due to old FW running\n",
+				   __func__);
+	}
 
 	err = eth_prepare_mac_addr_change(netdev, addr);
 	if (err)
-- 
2.51.0



