Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CFE3EFFD9;
	Fri, 15 May 2026 16:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862464; cv=none; b=LHxndiuawdl2VT6ZCChEqgTg0r1TTAO9/kdNS2ByM1nRFD8JGmh4H7/PbRmNSd02eZoCho9z+Hp9jhsA6NSh5Eub5SXRL7LJAhndL096AqTxkVMxw9YUlGMC243LUnRb9yRg2u7JL4hj7g9HOvCR4WYyQzsQvNCXnYebInV+UrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862464; c=relaxed/simple;
	bh=GV69Wxv6tTRH72kgwWYDeInNt8e6/gXCFJSBmUgQGYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipkl5CylSa25JQyG86UEOC2dpjLhnCUrX4nNN2ctPhmt5SDzijpPXvVYmxIo0T0LyR6a9sSMEJPo7XemszSHDSGE3Wm8X5Aawt7Kg8QJd1P9PeZ/UmekYRH46kpVlvA2D3JQwVXQNukkCUSup7rXIBMkft5bRBCianMB05dTr2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpLQnzNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpLQnzNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FDFC2BCB0;
	Fri, 15 May 2026 16:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862464;
	bh=GV69Wxv6tTRH72kgwWYDeInNt8e6/gXCFJSBmUgQGYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpLQnzNrE5WZenQMw/S4pU4y3nPkWF0um4/osS02zMe4PMbcgj44xDQRDliYUJeQ2
	 4wySU/08xNMTP0sQPwhwOyii3UuthzxNrcsP8qPWv/P1aVLvrd0S/Hye7ESxvNUuR8
	 8VUhkrOxLxGYA59JmcPH6/xj9QiPtPLNV1lY7GTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 041/201] regulator: rk808: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:39 +0200
Message-ID: <20260515154659.423392844@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 65290b24d8a5f0b8cd065201e653db824c4a4da6 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 647e57351f8e ("regulator: rk808: reduce 'struct rk808' usage")
Cc: stable@vger.kernel.org	# 6.2
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/rk808-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -2114,8 +2114,7 @@ static int rk808_regulator_probe(struct
 	struct regmap *regmap;
 	int ret, i, nregulators;
 
-	pdev->dev.of_node = pdev->dev.parent->of_node;
-	pdev->dev.of_node_reused = true;
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 
 	regmap = dev_get_regmap(pdev->dev.parent, NULL);
 	if (!regmap)


