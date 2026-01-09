Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841FF35BDD6;
	Fri,  9 Jan 2026 12:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962482; cv=none; b=dY8q1LJGqp1JS1R0GNSxmh/xPaXoFwOrm9Jl0YSAEJq1vEv6hzZchJixZ7Co06RAE/Thg2suTSPzjHC5sVxbLNUqCZYhwTmHClcACaobjyGn5RBVAb+7z7HTppglNBsBk9h0NBX4sbf4f4IIWYmLzPgwhwpotjURJYpc04Wlf8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962482; c=relaxed/simple;
	bh=3aDpk0rsv/2FNMZh7kuI6Pxr/JGX7M198hyhKtH7dBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i17VRy/qUEDpyaWhWN0mQvP3LXIKEA3jQzXsqUgpLrdtcdgrUDPAq6oSmjrP5xlUUga7LBUDM6HgJgV3kI2dWn9WdCO/1fammQSQec5Pm4ZyOjMdWkkiWxpXmtgiaQhTV656aR23p9KWUnoFChzKEPgWXhrDbgtwwkUTP/D+Iro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vamn08Ud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vamn08Ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5728C19421;
	Fri,  9 Jan 2026 12:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962482;
	bh=3aDpk0rsv/2FNMZh7kuI6Pxr/JGX7M198hyhKtH7dBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vamn08UdqoMjJaEDpIEfIYyjiOIarVuxLP/K8rpXuEsB41kjiqEVEjXZQgDgjaSsT
	 RzSAcpEkOmJVvloM5YIDdE9LjSryfaepVjDzhTSUgdmm2JChixS1yozSyhJ5oo00YI
	 MbpET+1KlnUAUql+dkH/vip0LPWGBDiwfivHeDog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.1 379/634] amba: tegra-ahb: Fix device leak on SMMU enable
Date: Fri,  9 Jan 2026 12:40:57 +0100
Message-ID: <20260109112131.790410489@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 500e1368e46928f4b2259612dcabb6999afae2a6 upstream.

Make sure to drop the reference taken to the AHB platform device when
looking up its driver data while enabling the SMMU.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: 89c788bab1f0 ("ARM: tegra: Add SMMU enabler in AHB")
Cc: stable@vger.kernel.org	# 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/amba/tegra-ahb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -144,6 +144,7 @@ int tegra_ahb_enable_smmu(struct device_
 	if (!dev)
 		return -EPROBE_DEFER;
 	ahb = dev_get_drvdata(dev);
+	put_device(dev);
 	val = gizmo_readl(ahb, AHB_ARBITRATION_XBAR_CTRL);
 	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE;
 	gizmo_writel(ahb, val, AHB_ARBITRATION_XBAR_CTRL);


