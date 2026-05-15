Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5308A3FF1A2;
	Fri, 15 May 2026 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860374; cv=none; b=cPKdvDHj00DWYDmDjaaCjkYQyL8yV2oBGflzZNsxUdtdyc+t6uTu9IZYDl96A5DYRyUnGGIjLk5hoZj2Upy1b/B5mLThVJ4EMYNg0bC79B6QH8L9zmw+q2yDqEbpRfhYQtze//1gL5Uz52hWARpMR4AyaJj2PwT7rwW50kTYGvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860374; c=relaxed/simple;
	bh=s2R2qzcEwbheMrHbS3ifN96gsTX+6L1WT7bT2FK4Kmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5MIXJ2/Ys8dr91iJQwZUpY03nbSbqfZAC4uZBqy2pLMHpNbklFhcgeA6bV4+9Q2LTTUg4jmyJ8npeU61UTTFUS9a/wJwZ/PIm15KLrMsu/TcKBNLUIZafXmPz4KN9Geh0IcUfyQg9qsPm6jfHTGQtgDy0QVgCTuuSJatlcrBYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnTFp5PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnTFp5PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3662C2BCB0;
	Fri, 15 May 2026 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860374;
	bh=s2R2qzcEwbheMrHbS3ifN96gsTX+6L1WT7bT2FK4Kmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnTFp5PUarzpeD8JkD/8sgxcEyVtDkoJO9eovhbf9mru3APQSSFCT+07PVKh4O7B/
	 j1918BFI2nf6rZo7OhG7FSLdaiCzs76st4QI1I6wQ8AHdOsLSXDOm6h9jIVORfaumq
	 W+b3JNJBx4EHh3y1dtQ16BlW0+udr/nswD+gvsKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyou Yang <wenyou.yang@atmel.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 022/144] regulator: act8945a: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:28 +0200
Message-ID: <20260515154654.013886782@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


