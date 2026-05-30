Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95E021E098;
	Sat, 30 May 2026 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163906; cv=none; b=j4ryhjV1UL0QYmXtxgdg6tIAA5PfAbtjmDUi6H1pg6CajiaprO6vjY1I02R/XtQS+nI15QVANq6Tp5sp9Vj1clA+cCwtziuXOqq9jisshUpf2oxXQwS687afwsrFMoZsXPM7rHW7evX88x22bVHg8PoiG35uNX7dITey5IzX+qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163906; c=relaxed/simple;
	bh=fNiwnRPFRI9HmCKFU77wU0VOMA78Lmqr0NAuu15Ngis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwPoGTvvO2fUZwrUrpZv5uT2Iuyy449lV4KvfMtB9AVc4T/J+E1LUzcmQ6awBSerJnTXRD5iKr2+0kp85wUuJUoUeRbAvy2oUs7GHFm7WhYdKxujEKpZb+2l11FSxhfPVfn0afaspSejZqXiM5qAourGtuPPiokRIeixbJmvTLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0Mxkvtx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0Mxkvtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCE81F00893;
	Sat, 30 May 2026 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163905;
	bh=AUKYyCNm74aGtLh7YHQ5ByqOcPJ968ti1nTFK4hFH80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0MxkvtxfCQsrJR+3JaQYPZKQEc5WyCCljGjQ6I3f99boewe7GHFAozAeQeuLW24w
	 iXKJwbiISZGtF2cByEp4SstdfBWe88HtNNoBH2xhj0pR/CFCZowBYNILRK6+IWpolr
	 PvkXbC2vEwGPKpX36t24nwMlvwyqY3t/dlA30E8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 358/776] regulator: bd9571mwv: fix OF node reference imbalance
Date: Sat, 30 May 2026 18:01:12 +0200
Message-ID: <20260530160249.830137303@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 8498100ee1d00422b8c5b161b3e332278b92a59a upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: e85c5a153fe2 ("regulator: Add ROHM BD9571MWV-M PMIC regulator driver")
Cc: stable@vger.kernel.org	# 4.12
Cc: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-8-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/bd9571mwv-regulator.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/regulator/bd9571mwv-regulator.c
+++ b/drivers/regulator/bd9571mwv-regulator.c
@@ -288,8 +288,9 @@ static int bd9571mwv_regulator_probe(str
 
 	platform_set_drvdata(pdev, bdreg);
 
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
+
 	config.dev = &pdev->dev;
-	config.dev->of_node = pdev->dev.parent->of_node;
 	config.driver_data = bdreg;
 	config.regmap = bdreg->regmap;
 


