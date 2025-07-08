Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E059E2DCC02;
	Tue,  8 Jul 2025 16:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992606; cv=none; b=SsuO929bJN6/6tcHfe/GyDQkAy/RilbWtvSJKpUA0ce3udlbqGXeTbFLQ3rqrjaHKmQL+7/xu5hyPO62aWHDZCloMWlJ4aPZfyB8ganXGuba7Z/nCCChWYt1QAafT9Snhz07BL2SbHN1XN0q6W5kRANS9Cr+V2C0kN4MgPqIAU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992606; c=relaxed/simple;
	bh=65O9HrTv4dMwulmE5T3ts4DWIMP9WjEQpoYVnz7s0RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8idh7P7bcyLQ/NlLwPOYcoPVnJCsoIGAfgTq+4qQLyLRiNUvXc1yGW9PFEFFPiVUGOgHLkvRETe06ijE95zNaMJ3EDe1i0R8EvX5xQwJTx0wABd0XrqNMX3fKIIEh/+rVpO7kA8TGcM1cFZ1HFGcIaJRboI9O63kWXUOSVAXN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmxKMs9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmxKMs9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC00C4CEED;
	Tue,  8 Jul 2025 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992605;
	bh=65O9HrTv4dMwulmE5T3ts4DWIMP9WjEQpoYVnz7s0RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmxKMs9hokwmRvdQRUMUF8AB/k6vatjmHtGYgn6270clH/wBJL58SLwV/T+4JZyqY
	 2Ars0kAz0alaQFmh7ThDx14pdMHakd9Ua3R+Ymqxfn4GvuwoA6MPURfYSEMDigGvTd
	 m3CKZ/XhHHgwRYGQEwLilYgYrjS/3vnc21fjo6Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 019/232] regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods
Date: Tue,  8 Jul 2025 18:20:15 +0200
Message-ID: <20250708162241.936416237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


