Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C885934104B;
	Sat, 30 May 2026 17:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160633; cv=none; b=SjsVMbNuBHjaJBWmQFHgdgglFJkJLGRvfpIXP27P+bD9cW8U4cYcmz+NRBEh66PqQrb0iwvo6lokFsckiV/8Ig+1bNIMBWEYOLw3YgAom9tSl+gAEdRlLgm8jJuPmwYGxILMKd4YlYTlTx85mFSiA11rSmFp/4gHkEoiSMUFrSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160633; c=relaxed/simple;
	bh=1GPp4Rl1+4kE7EZ7pi8DtLP3W1e92Dfl+zsbNy0eEJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyB9zOGqc5NYKBXinQunxQBtbbWLISUSonNeWl2d9YZxuX2IAJ4A0rQftbznqj0CJK6OncMc67No9KD5TqbHV0NOVpt6ysGUwEYqn4lWuXip2D4J2tkswgbf0/jeRjH23gK/jfjYOJ5xLKUsMj8tqouKy0Y+OFwwXhNBtNHXpZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbBApIHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbBApIHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D34C1F00893;
	Sat, 30 May 2026 17:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160632;
	bh=aBoh1qMi4KxEsaJnsIH1AC1OBkvRzO6kRbMJK6uGcI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbBApIHDCbraaZHEcCd+FeS334DeJ1UXTPfz/EWzQKqIZNbAFgds9VhtsBr1oeOXo
	 Sq6MYy4/H4gI53t2f/pIttSzYaciiRCY5Do+IAFCcnAeWqnxPFQ3VcS2iJLMkQPQQ5
	 Qsbe4KdWGv8b3q+mNOfUK0pWYLxUXxHqG5zLh0Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyou Yang <wenyou.yang@atmel.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 390/969] regulator: act8945a: fix OF node reference imbalance
Date: Sat, 30 May 2026 17:58:34 +0200
Message-ID: <20260530160311.074822688@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


