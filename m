Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4B119CC3D;
	Thu,  3 Jul 2025 15:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555777; cv=none; b=amupS93GkfOwc/LWiLKz+VDV3LJfAxtNwS2z5WMEaaUHIKz3z0TivR8/4Sge9gP0/Sth/AL3eeJsQMn5/0YlfAreTYjwRStnwQKOhE5qmPg9UaeQBCp3vbC8g1Ir3TFxmsyrHnwDTFzusz9jlIcp4O8noarreCGTzjmk5N6JJ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555777; c=relaxed/simple;
	bh=eaj3XyGavALgBMTx011StPpKnjPzWUDOd6ky9S8/FJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faR4SfVQ1UTtUHQwYMXWeCVxy1bNmuxJMTtXLcaz4ULZ4ZfTxR2Zug0E8ZrNtz9E130U4pGh5oZ4s7m7QMVprLyIU8CT/IWe7Elap5ZXz9RZCoIU4pTu5foYAYi+cOAd4NIk1YOCSwHfn3JczFrmBg3nGgFhjC/0JOvBYHe0pQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4xteiOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4xteiOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68904C4CEE3;
	Thu,  3 Jul 2025 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555776;
	bh=eaj3XyGavALgBMTx011StPpKnjPzWUDOd6ky9S8/FJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4xteiOw3Qjt8SVkarHQFvz+W12cIJXUlz9P+Xdim2unMLk8xS/g+iGoY8wBpufVy
	 tEt9Et7ZtMAKpUHpgxnueHJULj0WNNKzoeJMKRYWzoEqGdXZsIbbhVKgicmFBExSiv
	 4UekhqUTWpkhcvTc70PlJfpgdJnW8oCmPijOIcwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.6 118/139] drm/bridge: cdns-dsi: Fix phy de-init and flag it so
Date: Thu,  3 Jul 2025 16:43:01 +0200
Message-ID: <20250703143945.801637089@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aradhya Bhatia <a-bhatia1@ti.com>

commit fd2611c13f69cbbc6b81d9fc7502abf4f7031d21 upstream.

The driver code doesn't have a Phy de-initialization path as yet, and so
it does not clear the phy_initialized flag while suspending. This is a
problem because after resume the driver looks at this flag to determine
if a Phy re-initialization is required or not. It is in fact required
because the hardware is resuming from a suspend, but the driver does not
carry out any re-initialization causing the D-Phy to not work at all.

Call the counterparts of phy_init() and phy_power_on(), that are
phy_exit() and phy_power_off(), from _bridge_post_disable(), and clear
the flags so that the Phy can be initialized again when required.

Fixes: fced5a364dee ("drm/bridge: cdns: Convert to phy framework")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Link: https://lore.kernel.org/r/20250329113925.68204-3-aradhya.bhatia@linux.dev
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -681,6 +681,11 @@ static void cdns_dsi_bridge_post_disable
 	struct cdns_dsi_input *input = bridge_to_cdns_dsi_input(bridge);
 	struct cdns_dsi *dsi = input_to_dsi(input);
 
+	dsi->phy_initialized = false;
+	dsi->link_initialized = false;
+	phy_power_off(dsi->dphy);
+	phy_exit(dsi->dphy);
+
 	pm_runtime_put(dsi->base.dev);
 }
 
@@ -1153,7 +1158,6 @@ static int __maybe_unused cdns_dsi_suspe
 	clk_disable_unprepare(dsi->dsi_sys_clk);
 	clk_disable_unprepare(dsi->dsi_p_clk);
 	reset_control_assert(dsi->dsi_p_rst);
-	dsi->link_initialized = false;
 	return 0;
 }
 


