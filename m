Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808AE340D91;
	Mon, 18 Aug 2025 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522950; cv=none; b=q4afFIelg6DFyz5xPAu5r5CC3+84s2OCrBkYEpuUfIkKKxQ6ziRe9JgZddULrgOUqrR1JC7WgJvjU8vGScsnqQAXs/de7SV26J5sEAXy0df+esnOzpRPdcTTytqwvxf8KwOCWy1b+F1bJuBRF+m8hxQ49iaAB3QHHnCIBexI++U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522950; c=relaxed/simple;
	bh=R0Xpn0QfpqFrf2hH+R/gwPfX+61fKpq9fZJDYPoUw6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBsyLq9cR3WMECnrs4ALZV5ueBILrjc04hlaPSyEPB4zIRNI10Jw9GUvYKfOjKIoMMgFJx9cjgK7BcWtQGjE0YDpWrgSsCOQge1GjMWx33xR57QsGVs3qVDElIiDv/BMjzgOxgs2S4FQ6OXNtFmSn6AOcBlp1U8rQFGBkA1wKa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVh+FNiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVh+FNiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3040C4CEF1;
	Mon, 18 Aug 2025 13:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522950;
	bh=R0Xpn0QfpqFrf2hH+R/gwPfX+61fKpq9fZJDYPoUw6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVh+FNiAcyTHgiapXu+8HHx0xjzspSRHIV5rb6+NSTUb51WanV8wNney2FnwFyFn1
	 nIgsVaoyL9+ECfBBXQHknq01xhvmxFSKTbrSK425+9I500Fz5lCbcA4W/3NSNlTmc0
	 rskcN+04kaRI+gB1fBmJSBI+Z8gm//pTScIV8KR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 025/515] net: ti: icss-iep: fix device and OF node leaks at probe
Date: Mon, 18 Aug 2025 14:40:11 +0200
Message-ID: <20250818124459.432075167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e05c54974a05ab19658433545d6ced88d9075cf0 upstream.

Make sure to drop the references to the IEP OF node and device taken by
of_parse_phandle() and of_find_device_by_node() when looking up IEP
devices during probe.

Drop the bogus additional reference taken on successful lookup so that
the device is released correctly by icss_iep_put().

Fixes: c1e0230eeaab ("net: ti: icss-iep: Add IEP driver")
Cc: stable@vger.kernel.org	# 6.6
Cc: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-6-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/icssg/icss_iep.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -685,11 +685,17 @@ struct icss_iep *icss_iep_get_idx(struct
 	struct platform_device *pdev;
 	struct device_node *iep_np;
 	struct icss_iep *iep;
+	int ret;
 
 	iep_np = of_parse_phandle(np, "ti,iep", idx);
-	if (!iep_np || !of_device_is_available(iep_np))
+	if (!iep_np)
 		return ERR_PTR(-ENODEV);
 
+	if (!of_device_is_available(iep_np)) {
+		of_node_put(iep_np);
+		return ERR_PTR(-ENODEV);
+	}
+
 	pdev = of_find_device_by_node(iep_np);
 	of_node_put(iep_np);
 
@@ -698,21 +704,28 @@ struct icss_iep *icss_iep_get_idx(struct
 		return ERR_PTR(-EPROBE_DEFER);
 
 	iep = platform_get_drvdata(pdev);
-	if (!iep)
-		return ERR_PTR(-EPROBE_DEFER);
+	if (!iep) {
+		ret = -EPROBE_DEFER;
+		goto err_put_pdev;
+	}
 
 	device_lock(iep->dev);
 	if (iep->client_np) {
 		device_unlock(iep->dev);
 		dev_err(iep->dev, "IEP is already acquired by %s",
 			iep->client_np->name);
-		return ERR_PTR(-EBUSY);
+		ret = -EBUSY;
+		goto err_put_pdev;
 	}
 	iep->client_np = np;
 	device_unlock(iep->dev);
-	get_device(iep->dev);
 
 	return iep;
+
+err_put_pdev:
+	put_device(&pdev->dev);
+
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(icss_iep_get_idx);
 


