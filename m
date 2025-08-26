Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B47611187;
	Tue, 26 Aug 2025 12:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212565; cv=none; b=txO6gaxExS5PeRcs/57jB6valR2QwkMbNkBwM3ODkr3ngeYu1QG9rqr8GGgYH7GBTHoUH5wjRCGHdts40w4gajGtzRWXWBuVKBjnpEH6PGIHxaYoVp0F2+RL1XY0yXyRs/6RR3wHmO3+zRtERgfS372VfNU17pgd+XMulhVx5Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212565; c=relaxed/simple;
	bh=0q1HZL5oVhpzfQjTf/aAvb4aQF2JYwxEp35NBux3dJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WosE/CL/0TDguJL/SwhBk1K4dpWrr6yW6HgG5zJ/tuDtShhsYHgW9HD6kMJQCeJme53HwvvbSckdeYL5DDLb0QHFynfyNdYdC5JENpeCSiTRPBAh5q0zQKa3sor/mJSLTTyVohgIhonOf4u6aNpuQgXkJx69LgPBzrOttc6Dh/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSOtAxBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSOtAxBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E02C4CEF4;
	Tue, 26 Aug 2025 12:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212564;
	bh=0q1HZL5oVhpzfQjTf/aAvb4aQF2JYwxEp35NBux3dJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSOtAxBbhl0gGdGXWEwkbJojeG5TzeAGqPu4TAW4Joiam42M6BeBejcjo6jDexV4t
	 uq09yg10nqZMPfKG16ThQi9pnc2v8cZ2nLage4CwAcsdEB4hVK94YFqPlBjXKURwyp
	 YpH73cO/wkQeUwJc2qywgY94P3LccD6Q9oAG3fz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 018/587] net: ti: icss-iep: fix device and OF node leaks at probe
Date: Tue, 26 Aug 2025 13:02:47 +0200
Message-ID: <20250826110953.418046467@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
@@ -702,11 +702,17 @@ struct icss_iep *icss_iep_get_idx(struct
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
 
@@ -715,21 +721,28 @@ struct icss_iep *icss_iep_get_idx(struct
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
 


