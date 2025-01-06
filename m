Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7BB7082A;
	Mon,  6 Jan 2025 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178238; cv=none; b=NwKLexGHauoXObpVIgLpf+yvZn3sdaIPkC22rLXS1ZJ2dKBivPPtH0sdaFfZgdUv7i8k8/2mbDjQkOOeldovblU0MY/qIqHcsbsiM4hspKst5ABc6OVQ86vmvzZXzu0tpq8DnsQfVQeWaX7wsF157UxoATx/Y497qryk0X+dVc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178238; c=relaxed/simple;
	bh=w1wF2ycml1Fb84syq4TTe8oFmarW5v4bpR1QZhcYmHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+IIBbJbyWNFezuY/fS2RRQ6GUet/prrdkeGWIffy4yyhKWcl+UtbvLxHjBKd+0BGFSQooPDsvBt7lLB4VcuY8wNriXvNQlMI6aOQH9bNPGrc6f4X8AGlWTpIKRgIigpW1BsvL4c21zD532QK7aRcjiBKIhl9ns6JBWVHg9VZIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0iiNrld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0iiNrld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86966C4CED2;
	Mon,  6 Jan 2025 15:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178237;
	bh=w1wF2ycml1Fb84syq4TTe8oFmarW5v4bpR1QZhcYmHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0iiNrldEqhAv8ZZxencq19TWveK6L163iwdo+JEjUDGo31XQjBr7mow8Hxjn10/O
	 wBWXoxHGFuffatUab0T5sVgQCdofnLEjOK9FLvOc+MRWlZs6HdVCB3gHya9WnEtMlG
	 rWZzidIfU5Uw3HzP+eXaZ+YeeSOoB3qKCAkLB1RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 050/138] phy: core: Fix an OF node refcount leakage in _of_phy_get()
Date: Mon,  6 Jan 2025 16:16:14 +0100
Message-ID: <20250106151135.130411100@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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


