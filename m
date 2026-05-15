Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569E34C0429;
	Fri, 15 May 2026 16:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862544; cv=none; b=Y/USyQ6+Tk+TzL2WZ9vZrZEaekJnov2ghjvsKWvegTha8kWC8z6nJoibNVWZXPE1Ksbw6U0dtwoijgDE1/2n262RXIGbxdWGmXFgSwGLLjVrKT6zLNc0p0PslYeOvOKJbFsfQVrP7C1c8Bo9Ta8qS9/DYNcA6k4+ATpcLYcQCdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862544; c=relaxed/simple;
	bh=gMqqiIuS6t0q2z+6eXXn7dh9cO9j25Zv5vNUfAXFyL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsAUWOsaDV7ezf1vnY5Opqotqy3DkzLKoRiSmW4r5jh0K+ovH5yjBKWR/sTEoZhyfba0BXHD3XsKjbMw2xy3HSQF2oI1ojlZfzyRT/UQN1ps9Fec1h/gQ4gf0tslNCMAATUH4bNd5j4DlHfB1eWN9nBYzRxmRJxtZuoCkkFlGdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebritOtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebritOtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F2CC2BCB0;
	Fri, 15 May 2026 16:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862544;
	bh=gMqqiIuS6t0q2z+6eXXn7dh9cO9j25Zv5vNUfAXFyL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebritOtNCcG+d8p5puvdkCFes5cLUm564qmD/GaEPGbadkQCCjlytNGec4AlxWH7B
	 d7jLiDtgZtzd9Tle0LjTBdbrwQqeQ5Gb3RbWpDhNPLmFIRBf6mnmU4DuaK/B5ocJ12
	 cDAUZ9daOVZ8nq97yrJZRow6OsQvbkO9Jyiurhqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyou Yang <wenyou.yang@atmel.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 047/201] regulator: act8945a: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:45 +0200
Message-ID: <20260515154659.553847329@linuxfoundation.org>
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


