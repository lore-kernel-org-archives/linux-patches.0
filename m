Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174592D0C94;
	Tue, 31 Mar 2026 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976433; cv=none; b=YJt/gDVeF82n+lN+efnbdFCdediwLLil2NwESeit3l0xcQGcijlx7yECluOnCZ/5EN3tKPcKt/2Q6IwlvMsbNWUmcwmvVlJc9oa+0Rzhax8Do9DG0RukisrWsCOWbcyhtFJ7ok22ZkGbVo+hNStHvyqUIl6bePUZyTCbPPjdi68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976433; c=relaxed/simple;
	bh=7KECGkyz9KnLSN1kBwVErKHRcnu274UR4HmYaRspQsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2Iqz3QT0yhAhVM8Hsv698nIlaft9PI199EzMTYcRT0ZHEhKerEoa2ykMXgbyLA8a1tabpeaSGzaiGiGg+rF62xT3o8CeBx/uqpR92IzjFlpJxAS2ZsLW73JoMu0H6XUp7iaUlNqflukhYfYTwqhhfUOIqPU5mRXgCz8zRs1Fps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Evn0q6EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Evn0q6EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC34C19423;
	Tue, 31 Mar 2026 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976433;
	bh=7KECGkyz9KnLSN1kBwVErKHRcnu274UR4HmYaRspQsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Evn0q6EHV9JSyRB/fhf8qL8RRAx8QN9q5hSjt3L7wd4jPR4a6tNGXxweiN40mZIR+
	 WlC7GqqTnq0ckA49zC2NzMfmpn5EcoM6k3h44HhX8tUzoRM4lmYX2lm/tLrjxpLRx1
	 R7i5uKWOEe1bdKeH/vcojOc6FODRQ+Lgs6wgV0F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Heib <mheib@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/309] ionic: fix persistent MAC address override on PF
Date: Tue, 31 Mar 2026 18:19:52 +0200
Message-ID: <20260331161756.764430342@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index b28966ae50c22..29a8a25a3ed08 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1719,13 +1719,18 @@ static int ionic_set_mac_address(struct net_device *netdev, void *sa)
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



