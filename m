Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CF23F9290;
	Fri, 15 May 2026 16:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862438; cv=none; b=ml8q4+oV9okAFRG+GHeqFKh/CVlrjDU3pIElvDEgQStiLClRRM9PZVcx6vh2+f9AYkXJSEuFBdDr1bofxauO7HGHepvJ/wwlZD0RK6ik8i0c7Th6phM7917+RUHddcVKn+u/Z39Gh6PL95VPoVw9LS56joBUNcWkWpwigeczll4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862438; c=relaxed/simple;
	bh=PZEBP/GPt6jt9Ris99zLBEeZgJHHTfmGIkv9+8Qpegc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJoqhinRc7d4AThe88B0kNvzz1oJehqXQ8nGpykMDqebUWUogYTHDz2vNkGUO76EmslrEIrjRnRaV7KiAdXj41O99hbJmYpxX5YK3DIc+IEnqKYzu4nujSE+WLBQZW45d2L+3vEIc4xDxdwCwi++7gpj7+y4jPXpWpYq0HJMr5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbhlDwl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbhlDwl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D33FC2BCB0;
	Fri, 15 May 2026 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862437;
	bh=PZEBP/GPt6jt9Ris99zLBEeZgJHHTfmGIkv9+8Qpegc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbhlDwl9IoefICasuHfc3AilCx6DqBpKvRbimsxyRx3ngA1ciyrqLvQUfkKqcdQF5
	 ICuTgG/1SrGkjuLyJ+lVyKLtoPpbBUREDlmrrDIBOBX2VMjoX0onyiFFLcrj5xcuZw
	 tLit2S4BOaLHvw4MGOakx/oEjLFdjKyI6kmXxdvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 049/201] regulator: bd9571mwv: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:47 +0200
Message-ID: <20260515154659.596643153@linuxfoundation.org>
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
@@ -287,8 +287,9 @@ static int bd9571mwv_regulator_probe(str
 
 	platform_set_drvdata(pdev, bdreg);
 
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
+
 	config.dev = &pdev->dev;
-	config.dev->of_node = pdev->dev.parent->of_node;
 	config.driver_data = bdreg;
 	config.regmap = bdreg->regmap;
 


