Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25652690D5;
	Sat, 30 May 2026 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160636; cv=none; b=jv8E+U09stVmnXBzEXpW7nMg4DnBy7SqW0iY/oFmCbIdL5RIYKaBHJ4/nMrY4pnzOiUL/C+ZjEThYQlhLCSp+c5UlNm93H7TW7ymRRaneAdlDExXcXXv5L5SjeKo8wgGHP7hZ0NqXwsZfgxuAY9BaAfnAPo9B8mEzJJCn2T9ROY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160636; c=relaxed/simple;
	bh=rOhqd24pIyFbt12ez3lJyTaFWBjK+UyaCeSaOCpRxRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auIiN7FE7wXVGf5eqznYiVyluv9Ul6JCxfSWq2H/hlohZwp0GovZKon9ShNv/JIsex8mskE9hEnxAv/EKvWf3Q8JmsAS8yzkIQJ100NwGuMCU48zmUx1D1AQAIROeH1hDxEio69ZQ2RFy8ommr8m3qonwv95rrTtr4/Ll1kIc34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrRKZxzk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrRKZxzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5F01F00893;
	Sat, 30 May 2026 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160635;
	bh=3Wyr3LEmuYBcKhi3NjDFOWppHd3Uy5gQrq22Yu2r1H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrRKZxzk8VPqQdD9+P7B0gArUAL/20cHQNN5bQhr0Qwn2KDIPRObAJghoXdH8D/Jx
	 5kKWAc388wZ70EntsvY81rhSgzMiVRHt88IZtNrZG0XSDBCfsAUuz1aDggiT1xh3+c
	 XjsxGJHSJMsLIjxLvDW9s/U/1TSXLFjvZAh8od/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 391/969] regulator: bd9571mwv: fix OF node reference imbalance
Date: Sat, 30 May 2026 17:58:35 +0200
Message-ID: <20260530160311.098856052@linuxfoundation.org>
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
 


