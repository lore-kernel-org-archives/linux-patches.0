Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F0E126C13;
	Mon, 30 Dec 2024 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573489; cv=none; b=lKTKqK/5Dbtr3pGC88s6KXg0YmcEDWy95MG8hsGLQC4wFzcD4CuZTNCh8lHL0u4RsCm7eMaWzgWV/wBsa1ck5zg4l8gx6mwpNiFNCOTWVTFT8XhA3dSVAy2wa9LwEAEJAR+P4czdvG/bhQfy/Nztz+srHS8dillPfpCMw2hpmG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573489; c=relaxed/simple;
	bh=n0fXD71yr9wGPcqQx8/ec+KDmxHU6bSKmoHjhoDgyaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4lMBcfjY/WQierpaRBhdwG+Ec0auhXtFBpkhiPpSE/Y6Nqq30eeMePkoI+WoRnI6iWZgm3VMyQDPNu9oz5jp/N2iPq8wYoscXDPoiQS0fOrOiRn3WVLIu5iP0o07L4pxkIGNcxTlBsjTU9FbRdvVg7oi3wjl1mCfwxCOpdCk3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXQb2cuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXQb2cuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7148DC4CED0;
	Mon, 30 Dec 2024 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573488;
	bh=n0fXD71yr9wGPcqQx8/ec+KDmxHU6bSKmoHjhoDgyaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXQb2cuDM3dhVLYDUJrKoGhfygtsZOvluF4/qz6nH26OXnPY61cm+ri8zfJmd88hl
	 RIquMimJQ8IvOq5WKyvKN7GxhRNQaLh9Q1N0HTbiBg5VNHZs82+Z0HbZcdCzmmwC0M
	 Psmc4YJmiZBIoPAdmS+I+zqBAv7fUlTOLxKWozqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 11/60] phy: core: Fix an OF node refcount leakage in _of_phy_get()
Date: Mon, 30 Dec 2024 16:42:21 +0100
Message-ID: <20241230154207.714995265@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 5ebdc6be16c2000e37fcb8b4072d442d268ad492 upstream.

_of_phy_get() will directly return when suffers of_device_is_compatible()
error, but it forgets to decrease refcount of OF node @args.np before error
return, the refcount was increased by previous of_parse_phandle_with_args()
so causes the OF node's refcount leakage.

Fix by decreasing the refcount via of_node_put() before the error return.

Fixes: b7563e2796f8 ("phy: work around 'phys' references to usb-nop-xceiv devices")
Cc: stable@vger.kernel.org
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241213-phy_core_fix-v6-4-40ae28f5015a@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/phy-core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -575,8 +575,10 @@ static struct phy *_of_phy_get(struct de
 		return ERR_PTR(-ENODEV);
 
 	/* This phy type handled by the usb-phy subsystem for now */
-	if (of_device_is_compatible(args.np, "usb-nop-xceiv"))
-		return ERR_PTR(-ENODEV);
+	if (of_device_is_compatible(args.np, "usb-nop-xceiv")) {
+		phy = ERR_PTR(-ENODEV);
+		goto out_put_node;
+	}
 
 	mutex_lock(&phy_provider_mutex);
 	phy_provider = of_phy_provider_lookup(args.np);
@@ -598,6 +600,7 @@ out_put_module:
 
 out_unlock:
 	mutex_unlock(&phy_provider_mutex);
+out_put_node:
 	of_node_put(args.np);
 
 	return phy;


