Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446F5881E;
	Tue,  8 Jul 2025 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992256; cv=none; b=sPtw4aajo2Y4evjTAfBCdZ3IR+mJM4nkaWTTkMET2YZarG3vCpXRRGP6AtrAkTOc985E6hOofQ2ykCJIKmjFg4CG323YQ2+2k3RniNs97UX7glVB3Ix4zdOShPEuoVkIho67yeA4jf7RrdTHjNX2lHajC1l1k9TZOi8WyIZiSPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992256; c=relaxed/simple;
	bh=wTbi3bEfoorzezTPww3DydNKMLa1iBcasl8H/wPuLHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqGmIniT6Hd2hAzD+ZZwsAuNsCppjVEdjA9DqnpehqP3VwYZ/XaheCHXX/4V6ynLdv/w1mlyjj0cValqMl0xYb2+biKy6k7bAY67VDlZeRt8dshKWyduQBll0eiWBNbndnjd27fP2Pr6TRMz1+nK0MUt70gAJLA/Gg43nIC1Ovg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuEh4BVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuEh4BVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AAFC4CEED;
	Tue,  8 Jul 2025 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992256;
	bh=wTbi3bEfoorzezTPww3DydNKMLa1iBcasl8H/wPuLHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuEh4BVn5poxG4gDyJ+wHagVPkGncBBo3pINiLURSbecv5frDzQAFiCxkA9wnU8yd
	 4lGud2Vjy9BqUsN7k47qhAXKjST1bj0AUtxXlDUuKVabL8qr0F4CtO93lhUqzrfHTR
	 TTBb3whglLqlqKLNQ5PmZl56BrAEM4ATFuyyv1GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 013/132] regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods
Date: Tue,  8 Jul 2025 18:22:04 +0200
Message-ID: <20250708162231.125472327@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

From: Manivannan Sadhasivam <mani@kernel.org>

commit c9764fd88bc744592b0604ccb6b6fc1a5f76b4e3 upstream.

drvdata::gpiods is supposed to hold an array of 'gpio_desc' pointers. But
the memory is allocated for only one pointer. This will lead to
out-of-bounds access later in the code if 'config::ngpios' is > 1. So
fix the code to allocate enough memory to hold 'config::ngpios' of GPIO
descriptors.

While at it, also move the check for memory allocation failure to be below
the allocation to make it more readable.

Cc: stable@vger.kernel.org # 5.0
Fixes: d6cd33ad7102 ("regulator: gpio: Convert to use descriptors")
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250703103549.16558-1-mani@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/gpio-regulator.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -260,8 +260,10 @@ static int gpio_regulator_probe(struct p
 		return -ENOMEM;
 	}
 
-	drvdata->gpiods = devm_kzalloc(dev, sizeof(struct gpio_desc *),
-				       GFP_KERNEL);
+	drvdata->gpiods = devm_kcalloc(dev, config->ngpios,
+				       sizeof(struct gpio_desc *), GFP_KERNEL);
+	if (!drvdata->gpiods)
+		return -ENOMEM;
 
 	if (config->input_supply) {
 		drvdata->desc.supply_name = devm_kstrdup(&pdev->dev,
@@ -274,8 +276,6 @@ static int gpio_regulator_probe(struct p
 		}
 	}
 
-	if (!drvdata->gpiods)
-		return -ENOMEM;
 	for (i = 0; i < config->ngpios; i++) {
 		drvdata->gpiods[i] = devm_gpiod_get_index(dev,
 							  NULL,


