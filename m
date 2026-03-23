Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E9235957;
	Mon, 23 Mar 2026 15:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279330; cv=none; b=FUQXbUHlkG1qn75LumRv80oLEOvVbf50XIYnxxTHU2wFHaajHIDLBb/WVAI04vyg+6l5Pl/RIwUTd9DromYqxOJNtqqInjT7iTTpZhust7D3drA3jdxomwmSQuUHs4qiW1SwfdCV4zLGSVGd9fDxFZ7+sh2SDKElXzKYPuO52TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279330; c=relaxed/simple;
	bh=vqoU2wyiKzkQumlydqRe39P2RQfWLMqsBBFth0p+Fto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLt2xBBKuupOdP8cxTmbM4qx3/p2dMZO6+2z6uoMiV0VLnsNZ1OaFr0tWHCGkBNFuWQ8xd7yRbqOGlIRbuILQGHGVYRC1Y6zkoBN2RBksujRlsmksWzziVivusSJqgSWf4D7RwnZ4tFB9xaKBIapD6nppTHMOUg4LwbKqQhxYJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnMiNMgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnMiNMgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E09C4CEF7;
	Mon, 23 Mar 2026 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279329;
	bh=vqoU2wyiKzkQumlydqRe39P2RQfWLMqsBBFth0p+Fto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnMiNMgwEClpW9LO4bqBjQzz+DTa2evPLchmRtmrYibsLB7p8wE1KOwo+gAQ16BCz
	 1t0IYXWEOWY1bTEzIVHqyzz+w2Ac2A1a/N8rbydcyXRXLgSF0kKUh5FZJN1+OAeb7S
	 Moze2TSQ+b9lSMsxX2MJRG/5N8SlhQU70JhMnePk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Anas Iqbal <mohd.abd.6602@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 547/567] net: dsa: bcm_sf2: fix missing clk_disable_unprepare() in error paths
Date: Mon, 23 Mar 2026 14:47:47 +0100
Message-ID: <20260323134547.541440906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Anas Iqbal <mohd.abd.6602@gmail.com>

[ Upstream commit b48731849609cbd8c53785a48976850b443153fd ]

Smatch reports:
drivers/net/dsa/bcm_sf2.c:997 bcm_sf2_sw_resume() warn:
'priv->clk' from clk_prepare_enable() not released on lines: 983,990.

The clock enabled by clk_prepare_enable() in bcm_sf2_sw_resume()
is not released if bcm_sf2_sw_rst() or bcm_sf2_cfp_resume() fails.

Add the missing clk_disable_unprepare() calls in the error paths
to properly release the clock resource.

Fixes: e9ec5c3bd238 ("net: dsa: bcm_sf2: request and handle clocks")
Reviewed-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Anas Iqbal <mohd.abd.6602@gmail.com>
Link: https://patch.msgid.link/20260318084212.1287-1-mohd.abd.6602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 257df16768750..7defcfd1c213f 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -971,15 +971,19 @@ static int bcm_sf2_sw_resume(struct dsa_switch *ds)
 	ret = bcm_sf2_sw_rst(priv);
 	if (ret) {
 		pr_err("%s: failed to software reset switch\n", __func__);
+		if (!priv->wol_ports_mask)
+			clk_disable_unprepare(priv->clk);
 		return ret;
 	}
 
 	bcm_sf2_crossbar_setup(priv);
 
 	ret = bcm_sf2_cfp_resume(ds);
-	if (ret)
+	if (ret) {
+		if (!priv->wol_ports_mask)
+			clk_disable_unprepare(priv->clk);
 		return ret;
-
+	}
 	if (priv->hw_params.num_gphy == 1)
 		bcm_sf2_gphy_enable_set(ds, true);
 
-- 
2.51.0



