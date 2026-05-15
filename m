Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AAE3F9279;
	Fri, 15 May 2026 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861892; cv=none; b=HQ0bL5GvGvbkGOv8TGIgNSROjtsYY0pWQuMpb6/yP9Iav0wwfPe4Hj/nQGDMuSvgP2OiL7fdtf+I1Jmh2eu8VztXSCY3rQXokZKn/XLlaB4o5nUQkDL2n0KiGYDbZUl6byqVuiAPD4aITHzknP55+9a0wEe3qDIJ7sZiP17TF9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861892; c=relaxed/simple;
	bh=RaMzKmXhjeMzZR31KhBO5udwM+JQfm6DoNFOk04XYeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnmmP/UtnphAPmgalLQjeWmSjFFZ21J3bhWBF3HjBApJJG3yYaV4wcLjb292+dUSjBvgpoMFP6tI130ttaAHu3r7KzOqDQiXS4Xa8uNwjrfzUkbHxYw2vyKbriDHb1ytfQXhZJI/EN3LWsMszDYj8fAZdrL4iHX//i5OQBUXRMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEnufQRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEnufQRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B94C2BCB0;
	Fri, 15 May 2026 16:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861892;
	bh=RaMzKmXhjeMzZR31KhBO5udwM+JQfm6DoNFOk04XYeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEnufQRAVFZeT3avcoYBIWA4x6P2KNEkfoA5Ld2wCtnz8yjYJR+YvFOua7POelh87
	 ox8UbGVakoPjLK2zFA+wwlDntHAxW7GNylGV+y2NHPyd91rlv3EKlZjEhZPS+TgB8M
	 Dudow5cyBFQTADaLSIjdupFDLNOTK8p8QzqzK9pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 029/188] regulator: bq257xx: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:26 +0200
Message-ID: <20260515154657.940147782@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 7ea07bc030d8d6395524dec22ff3267441a28c0d upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 981dd162b635 ("regulator: bq257xx: Add bq257xx boost regulator driver")
Cc: stable@vger.kernel.org	# 6.18
Cc: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/bq257xx-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/regulator/bq257xx-regulator.c
+++ b/drivers/regulator/bq257xx-regulator.c
@@ -142,8 +142,7 @@ static int bq257xx_regulator_probe(struc
 	struct device_node *np = dev->of_node;
 	struct regulator_config cfg = {};
 
-	pdev->dev.of_node = pdev->dev.parent->of_node;
-	pdev->dev.of_node_reused = true;
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(struct bq257xx_reg_data), GFP_KERNEL);
 	if (!pdata)


