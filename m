Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546A144CAEA;
	Tue, 16 Jun 2026 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624290; cv=none; b=id2VRWjaPNDKE9poLUKyG4v8Ss0nJZQeD2cykg/mt5pj96DwG6E5zFY0M0pEd1COKICgo6KbUf61X85/5NgKSUDPRoRGMILBCLC4AMlJ0zvUPQO/8qdmkaqTeJu084j8F1gCMjmfJ0HC5XztuQVV3R+NzVuWJn/ZdqBUNtB47rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624290; c=relaxed/simple;
	bh=8iIKaGT5VrGcohwg8KrrwCxbTNIYj5BQFZ8E34R3xiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu1kIf+Q3gMZnmsJkOnOFHZiPewNbZQJ2leJioknY+ij2n1sCj13QZITbp+BK64fcFRiXcKwUUwZALUlpNHgG565tHnABw4nih/rNq/vjejmOBFyf4EWIM+shouQV8X+uEZowY9k1Oe5t+cX+NgkU0V2aond9CWC/bp1iba3KWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYmk+hi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYmk+hi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE0A1F000E9;
	Tue, 16 Jun 2026 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624289;
	bh=XFRt2PJaDjWcxzjaIn4P4pyXgLTbdomxRVWA3BE3Ggg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XYmk+hi1urEfRjkiXDMQ2tKuk4axX3aN7ZgAvrgBpE058JebCuOhnPXo7iCJ4y0CR
	 6Fe0BqrGG4Fg55h1mXyUwxQLcrCyObdbTSK8RqZ3H4oMhIOhNjbYaQRRRA4iT8lURJ
	 T568P5U2rDdR1n7dDx4zs4EUZT0VxdHLWxPMyXJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.0 308/378] mmc: dw_mmc-rockchip: Add missing private data for very old controllers
Date: Tue, 16 Jun 2026 20:28:59 +0530
Message-ID: <20260616145126.407643763@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

commit 1e9a4850afa0ceb63984fb1a9f3e86d0fc4fd18f upstream.

The really old controllers (rk2928, rk3066, rk3188) do not support UHS
speeds at all, and thus never handled phase data.

For that reason it never had a parse_dt callback and no driver private
data at all.

Commit ff6f0286c896 ("mmc: dw_mmc-rockchip: Add memory clock auto-gating
support") makes the private data sort of mandatory, because the init
function checks whether phases are configured internally or through the
clock controller.

This results in the old SoCs then experiencing NULL-pointer dereferences
when they try to access that private-data struct.

While we could have if (priv) conditionals in all places, it's way less
cluttery to just give the old types their private-data struct.

Fixes: ff6f0286c896 ("mmc: dw_mmc-rockchip: Add memory clock auto-gating support")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc-rockchip.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -433,6 +433,22 @@ static int dw_mci_common_parse_dt(struct
 	return 0;
 }
 
+static int dw_mci_rk2928_parse_dt(struct dw_mci *host)
+{
+	struct dw_mci_rockchip_priv_data *priv;
+	int err;
+
+	err = dw_mci_common_parse_dt(host);
+	if (err)
+		return err;
+
+	priv = host->priv;
+
+	priv->internal_phase = false;
+
+	return 0;
+}
+
 static int dw_mci_rk3288_parse_dt(struct dw_mci *host)
 {
 	struct dw_mci_rockchip_priv_data *priv;
@@ -506,6 +522,7 @@ static int dw_mci_rockchip_init(struct d
 
 static const struct dw_mci_drv_data rk2928_drv_data = {
 	.init			= dw_mci_rockchip_init,
+	.parse_dt		= dw_mci_rk2928_parse_dt,
 };
 
 static const struct dw_mci_drv_data rk3288_drv_data = {


