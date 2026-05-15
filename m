Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE183B9D91;
	Fri, 15 May 2026 16:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862398; cv=none; b=QgswuuUYXjXJYIMZEKsrDV7b/6ry6ia1wDULDgRS2+Id4e3u+hRnp8EveksPHmIDq1bvTr2xBE3cXAqQ/NN4sYNf+mZSf8uOu2C47vN/EfoGDf29fBudM+YPFxFXte9r7t2wo9KgdrjbVNPCcVcFHr4p1Enwkk4LATQaJsvWsx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862398; c=relaxed/simple;
	bh=soDnStTKUZRr3t9o03srUQgon//BsViH05Kz05oR2ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb+rpWPWaEcQ+LIA2uevbjLcZ91i6ozW96k3XaVtJ/bmxbejLvsjGSD0QCg/xeEzQo0Jw/D3/05qSyIHbe2YEDbKaKbGR+DJO1oQCpUDChBNqbLeeXQ1JxySbCZXAumOVLnBzbqMDO6NXXhsa/nMO04iKwR6zfyEodcrgCLneW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2ExR161; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2ExR161"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C03C2BCC7;
	Fri, 15 May 2026 16:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862398;
	bh=soDnStTKUZRr3t9o03srUQgon//BsViH05Kz05oR2ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2ExR161IToNojKYKULdtd/A2TfbhTf+E2z3YimoLcDzS4BJtJnulpqDcRMsgThMd
	 oAZcD9r+E6SeoRQCaczJ93d3LUoA4NAEAt5dwCOxajiqTBWYUhYeGTVHmp7qXjSMIY
	 TepGxSZRKX/XV8sSVX417PXclcds+YATodmoTNyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 032/201] regulator: mt6357: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:30 +0200
Message-ID: <20260515154659.228245849@linuxfoundation.org>
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

commit 2f38e96c273e15f5e9f5d1fc2c0cbba703751602 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: dafc7cde23dc ("regulator: add mt6357 regulator")
Cc: stable@vger.kernel.org	# 6.2
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-5-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/mt6357-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/mt6357-regulator.c
+++ b/drivers/regulator/mt6357-regulator.c
@@ -410,7 +410,7 @@ static int mt6357_regulator_probe(struct
 	struct regulator_dev *rdev;
 	int i;
 
-	pdev->dev.of_node = pdev->dev.parent->of_node;
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 
 	for (i = 0; i < MT6357_MAX_REGULATOR; i++) {
 		config.dev = &pdev->dev;


