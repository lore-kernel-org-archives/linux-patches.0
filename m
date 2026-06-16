Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26FC466B4C;
	Tue, 16 Jun 2026 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626058; cv=none; b=h/8UkyBSaqMo8BunC1zgr+U/9Txb51Msy02Ti+QqHXgC0Ff8hKtiE4W2f3B+UFwI6gVsTbsCn6c/dVnsxoB3KvpPcYx1mj9+UgBP9vC1kACyfZMt33vZyA+Kt981UtHJbO0GCK9NRQrpJ/J5hCW7qB1IIwG3OxaSJHH8GyhZERM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626058; c=relaxed/simple;
	bh=G7+gKCh5R5XxY6Fy1REdwWSMimFwqI8QiwXUarmJb0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cefaJZJHLszvuNkpdjDKI/r7U+oJhSNCCSboWc3W1hONcAwkb03bDWO8EXpMD7tdZXKviV2sBia7Qqq2pL7UnF1y5zPMCWjooVxtUlT6LgfwkYzrITfk5DN4A1MkwtYk5OG/C5OyZWTXTQAPk7jjiq4Aa2UOctCV1SIJSEVd/Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McnMkGFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McnMkGFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F0B1F000E9;
	Tue, 16 Jun 2026 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626056;
	bh=NnsomVzyB0hJHK+r2IQnL1jNxVObh0Q7x8OXrjkf4nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McnMkGFwV74WQF47lac+dD66aS6IZmdjMEHTWoJ2mjQC+GbA1Vq3j/HcZ/eYZdrK0
	 dsHZWYZDNTpixQf8B/zmedG/0sIButSmdDzxJZgknFu1PACbTbYt426IArwnjc+Whc
	 67tDOQQmXmv865oLSU8hGwiHqewvcB6UDdgGPxQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 258/325] mmc: dw_mmc-rockchip: Add missing private data for very old controllers
Date: Tue, 16 Jun 2026 20:30:54 +0530
Message-ID: <20260616145111.434612416@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
@@ -434,6 +434,22 @@ static int dw_mci_common_parse_dt(struct
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
@@ -507,6 +523,7 @@ static int dw_mci_rockchip_init(struct d
 
 static const struct dw_mci_drv_data rk2928_drv_data = {
 	.init			= dw_mci_rockchip_init,
+	.parse_dt		= dw_mci_rk2928_parse_dt,
 };
 
 static const struct dw_mci_drv_data rk3288_drv_data = {


