Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFD82FDC5C;
	Tue, 26 Aug 2025 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217253; cv=none; b=du1cuuH9DYP5rsTEUxPaLVvbQhjWaymyVY3n3bBR8RS7XDOh4av2C2LSQ8gejzGi0NVYNsEZuf4DLGMJfJxjSL0KfgJy3GBz6He9cXt2aaW8eIyRqlUHfwas+aptHmuuLj+AgnssGAqSWg/7d1GjRId/mf469GMwP6MFZ0MRpV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217253; c=relaxed/simple;
	bh=EuZ5LTwGmQ/gtS4/7WSrMofJYlrNXMCK5rk5ObdbTkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myLdOmRzY1oWA4M8dEo0zac/TTaf8LuEcImhypy4ia4GQODQlmjv2yKDpRyqJMd8Bl+kQUgAOb9GzgHdzTnIsb+M3eScwpEdcFMSjKk6apraC++FiKJzHMc76hq6dQ7U/5xxYJ2tLmW9hbgEnV996DuDqdpMK87k+/tC3NtvdxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qa1cdNV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qa1cdNV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A151C4CEF1;
	Tue, 26 Aug 2025 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217252;
	bh=EuZ5LTwGmQ/gtS4/7WSrMofJYlrNXMCK5rk5ObdbTkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qa1cdNV12Xn0axaStZDcYNvtvOlpH0tUvafxKB4iywP8kOXr4CMg18xLgxKJxRepp
	 jKc/fyZjlbvnq5h7kNjqmcx78xOwxM4GufCEV6ktYZ9TqPYaPnK/v3cq2mCG87GpQR
	 ad4BkADiy0O5C2GE/cU/vWveQLp8xRvEAa773yDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/523] usb: phy: mxs: disconnect line when USB charger is attached
Date: Tue, 26 Aug 2025 13:04:44 +0200
Message-ID: <20250826110926.394869368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 87ed257acb0934e08644568df6495988631afd4c ]

For mxs PHY, if there is a vbus but the bus is not enumerated, we need
to force the dp/dm as SE0 from the controller side. If not, there is
possible USB wakeup due to unstable dp/dm, since there is possible no
pull on dp/dm, such as there is a USB charger on the port.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230627110353.1879477-3-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-mxs-usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
index e3cddcac3252..214db28f3c15 100644
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -394,6 +394,7 @@ static bool mxs_phy_is_otg_host(struct mxs_phy *mxs_phy)
 static void mxs_phy_disconnect_line(struct mxs_phy *mxs_phy, bool on)
 {
 	bool vbus_is_on = false;
+	enum usb_phy_events last_event = mxs_phy->phy.last_event;
 
 	/* If the SoCs don't need to disconnect line without vbus, quit */
 	if (!(mxs_phy->data->flags & MXS_PHY_DISCONNECT_LINE_WITHOUT_VBUS))
@@ -405,7 +406,8 @@ static void mxs_phy_disconnect_line(struct mxs_phy *mxs_phy, bool on)
 
 	vbus_is_on = mxs_phy_get_vbus_status(mxs_phy);
 
-	if (on && !vbus_is_on && !mxs_phy_is_otg_host(mxs_phy))
+	if (on && ((!vbus_is_on && !mxs_phy_is_otg_host(mxs_phy))
+		|| (last_event == USB_EVENT_VBUS)))
 		__mxs_phy_disconnect_line(mxs_phy, true);
 	else
 		__mxs_phy_disconnect_line(mxs_phy, false);
-- 
2.39.5



