Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D99E41A8F;
	Sat, 30 May 2026 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166083; cv=none; b=ZKPfGfhFPCHlRe5EUmrxIcniyfEUVT+8ktalkyZdxl+xQ4gAK/bh4kZWA66pnLWgspNQrUAHkCb/A0Llrxkx6RY0g965lFEZoA96zGkXOBj/NPSVyc3RkVDq3VanVKisupQ6NfTukhZBEveMF/lenu4nK1TEH2VMcjwiXP7ffTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166083; c=relaxed/simple;
	bh=4jPYPN38eMO4x0+7jB8JaSjLjnY9SqZ5uL1ai1iV39Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/QJqAh7sesEzoDv14QplZVIpFlahF9fhDvz5zXN7CWfwmqTZ7umjfxhSJ5t/LYymqVnZ70FW4cF2GpipeluGOZ+zjKQP9+RlgHcy2vUN8aoLFr+RtE283j5l3iy6B3KVunSOHOt/2Sepi1PjvPpn6nIXci5NWp1vVDa9dpvei4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLvaGgc4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLvaGgc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D3F1F00893;
	Sat, 30 May 2026 18:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166082;
	bh=bc983a29zUuszsIYZvkdL5eIf/2N9p+qTOR8/K0WG6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLvaGgc4l/IC80gqGTohMF0b172fVxaxO8KcRP4XGZAVACcV8ER7iBb1RCleDyBlS
	 HM5X0ZLrjBOyvtWibpkK/pI9zuYuKPQ84MbPuDO65q8/Q0q6HQUFuwCkdyyPcLNlH6
	 sYrizUYOOyuEzsjPAVOh21/YNuKqAo5vWFrpW0S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyou Yang <wenyou.yang@atmel.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 268/589] regulator: act8945a: fix OF node reference imbalance
Date: Sat, 30 May 2026 18:02:29 +0200
Message-ID: <20260530160232.030395195@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 0d15ce31375ccef4162f960b34547a821b7619d2 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 38c09961048b ("regulator: act8945a: add regulator driver for ACT8945A")
Cc: stable@vger.kernel.org	# 4.6
Cc: Wenyou Yang <wenyou.yang@atmel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-7-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/act8945a-regulator.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/regulator/act8945a-regulator.c
+++ b/drivers/regulator/act8945a-regulator.c
@@ -302,8 +302,9 @@ static int act8945a_pmic_probe(struct pl
 		num_regulators = ARRAY_SIZE(act8945a_regulators);
 	}
 
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
+
 	config.dev = &pdev->dev;
-	config.dev->of_node = pdev->dev.parent->of_node;
 	config.driver_data = act8945a;
 	for (i = 0; i < num_regulators; i++) {
 		rdev = devm_regulator_register(&pdev->dev, &regulators[i],


