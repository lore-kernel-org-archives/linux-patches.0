Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77022EF652;
	Sat, 30 May 2026 18:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166072; cv=none; b=T9Th1+Ogdp9y+CVwsdRGs6FQ3lJ+WEKwRBrueHb6C3IO1VlEe4s+f9jB21iqosUj8LVjaYzuEnm5hmeYZl4vA3ysKSERXEeOniNO2a1eF2zn6g93FXQG5YxRDWeZaUDzfAmjZjXrMekrELF35s+CM+5PWhfuwNkyfFJZxHmEEoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166072; c=relaxed/simple;
	bh=7ojm7HnMdf+sJCzqqelNBnuMELXLOuRWKFPbbPCdxrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NamZH7/rVmRH1deBXHNjUO2OD2SUYifpZZyljEVJpdphhwJw2VG7bvUbrDa1pefj6us4fkUipYqWX0+RfG+Ry8h9cGVAb9wZ3PkiwBUuBYHk9V+Zv+0f93swI1/pjEELOmgqk4x1+s2m2dEMzF3Msq/vmyd+hqBIfHrFxvRV5CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciSCVTSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciSCVTSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196301F00893;
	Sat, 30 May 2026 18:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166071;
	bh=4bgGnr3usrXphT+ZCCpW4AhThykwMB54Z4/OW6cOCvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciSCVTSdWCcCwnZSsOlBeThJUPOcmPb+7iguA4/mDi4Ug0UVejXGYDw4r/aIpZZlo
	 0jVwYi2m+szjcuY2yMuJqNlnsSklvtKI3SXjRy9U8VPji80ZgKNNcN9pebr12NI9Hq
	 TmOV01slEur/VTDxc97/B1Gkhph6F8N8S2Y/d6dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 265/589] regulator: max77650: fix OF node reference imbalance
Date: Sat, 30 May 2026 18:02:26 +0200
Message-ID: <20260530160231.959659313@linuxfoundation.org>
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

commit 2edaf5f7ada0ab5c9ec1f0836bd19779a8d85262 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: bcc61f1c44fd ("regulator: max77650: add regulator support")
Cc: stable@vger.kernel.org	# 5.1
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max77650-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max77650-regulator.c
+++ b/drivers/regulator/max77650-regulator.c
@@ -339,7 +339,7 @@ static int max77650_regulator_probe(stru
 	parent = dev->parent;
 
 	if (!dev->of_node)
-		dev->of_node = parent->of_node;
+		device_set_of_node_from_dev(dev, parent);
 
 	rdescs = devm_kcalloc(dev, MAX77650_REGULATOR_NUM_REGULATORS,
 			      sizeof(*rdescs), GFP_KERNEL);


