Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE65413225;
	Tue, 31 Mar 2026 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975735; cv=none; b=AMUiR5sCEh3Lb6o7c4VCDiDsrpS2QIZl9P0PfNVpJjBtzRuYgyXY/BrJPI5WdCzussdJBlXTE/AzVNo8299Gndrih0mp/h6HcJDj3B08VETsYu9Gwjuj+3qFXM5iPEx5NXEl3vPL5vxHIVika3lBAq78VFcOXGCLCh/08DRfzF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975735; c=relaxed/simple;
	bh=VVRwsXkNoCsrDRA9EhyV9gD75E5oVnJEaCkpU5yyNHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt4ja6ib0puXHVv3XQrQREImo/nVKD519RMf7vWpXDyIAhOVntN5cvpLcmhYdow7/IX1+WNmgoOfP5jtglN0LH7wwRRH9s8vRZVhMvZN+rxKnt2HXb5SN2X7w38Nxo++aUZNU8DzVwn7rk4vyfMM2v6mw/M1lsvIS72CqH1d+Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8DShD1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8DShD1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8D7C19423;
	Tue, 31 Mar 2026 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975735;
	bh=VVRwsXkNoCsrDRA9EhyV9gD75E5oVnJEaCkpU5yyNHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8DShD1Kh9+lMFLucfWyYXp6x4s/ujpBvWHTC9smytUnMtRkm1AcfHQll03tmY+ZM
	 D5xa5Ay4/8RxUmBlh4rHUyWVhVMez7lkDvXwLQyBpSm2BvhIWFpx9oj6fCGmrK13jy
	 7eFNJg8BiUiNEVkk8+BPq3G5LZc+KzdaZf6HH0Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Heib <mheib@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/244] ionic: fix persistent MAC address override on PF
Date: Tue, 31 Mar 2026 18:20:15 +0200
Message-ID: <20260331161744.088877752@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d6bea71528057..8119281b26d07 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1718,13 +1718,18 @@ static int ionic_set_mac_address(struct net_device *netdev, void *sa)
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



