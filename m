Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D91282F5;
	Mon,  6 Jan 2025 15:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179134; cv=none; b=PurEsvK6e/c//rzgDYsU/mk9G0ZpUETYwnLNQ9lPMYXsQfPwMoQcdVQO2XOdwObs4mI2qe0Tlo0P5ECLGY8vHtAVUtCj3VfP7dt/NHwZdCTqLHT8T94fOz60JYCxGiozGro7sojIYsDACyEYanXZ/IbF6Wq4rA4rgkjrkSpsn5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179134; c=relaxed/simple;
	bh=grKq3Jf4TYnbvXe4O/xOOPmmfQfKFIPxSU3IJVAj3N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VybCjIX4l3hU6OvxWKMtu66Iy+5HkFbzIJ/FTC8oyRF4JC3bpLvDJBaZgiHNKSHKxeyLj6IIDSnPTXwDhkUuAUZtdBS0QTNDmD45h89ap/73ZaIel7Vb0rI8/Ae8tv6Q1rGN5IZtXaYhTTFIurqLYaFFUiiPJjJkishQAkQ1xAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=db30Gj8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="db30Gj8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE11BC4CEDF;
	Mon,  6 Jan 2025 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179134;
	bh=grKq3Jf4TYnbvXe4O/xOOPmmfQfKFIPxSU3IJVAj3N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=db30Gj8dCTKxSPONpYmUuc1w3e6MepZoowkitnjaf0rChINE+oyQbeWeimHdHj1bL
	 ZVfxmbFis8eXMpyQU0+oCuLR/l+Rrawo3MGz0jvu9Iee4HEo6pwScuOJ6rvCvy67uX
	 t+gVwN1zUR27jyD/aM3mpP4dGGr8DEIPOiDUUFGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 37/93] phy: core: Fix an OF node refcount leakage in _of_phy_get()
Date: Mon,  6 Jan 2025 16:17:13 +0100
Message-ID: <20250106151130.103137061@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -507,8 +507,10 @@ static struct phy *_of_phy_get(struct de
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
@@ -530,6 +532,7 @@ out_put_module:
 
 out_unlock:
 	mutex_unlock(&phy_provider_mutex);
+out_put_node:
 	of_node_put(args.np);
 
 	return phy;


