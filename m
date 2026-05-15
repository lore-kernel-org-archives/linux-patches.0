Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E953F44CD;
	Fri, 15 May 2026 16:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861910; cv=none; b=ir/iPjEMoPoKddjP4T7LggNE6OEk432aBGA0QzyP2by2JEh2fe/ic54DsXVH1CveCDk7NjslepS3Whj6ntfCHpYLhZXptDG9VPRlZJtTZEgNBpqK5ehkRICLjSxM/WD1E0Wrme0p6/U0/Zd0fKjDTk0T9pYzYvG2ElmyZEmgwPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861910; c=relaxed/simple;
	bh=QPxocKEEBg5sKVpoF0aXmv1XmjxV8jeoKjFJv0EQbos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXq1BVGL2bCXqy4dUp66sLwm7Dm90FAskK4yRGeHDygOhXnJSOhVw7PgqQ2Tzc4x+JBxNZ95fzf6pkN8r8va+viX7ORNjg2THIjcFq1xhNAbeSHsvucVAVhwJFnvRvev6x1om+yLSfKYP7Vuhqy4vqOy+anV6ETFAtfP+XYMe/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bB0eRld1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB0eRld1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C10DC2BCB0;
	Fri, 15 May 2026 16:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861910;
	bh=QPxocKEEBg5sKVpoF0aXmv1XmjxV8jeoKjFJv0EQbos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bB0eRld1F4wCb7luvO8zbL1xUBr+DaWvFBh1zN6KLjUNaBsZg/GIzqWJQx7VaMhnp
	 nnl+YDNkYzvIn3enJbaysj0f7NJK9QzFnkE27isspwXxlgAxINhghz7k4ghJNu9/R3
	 Chn4vI/U41ffG+Ysc+DDVReNUz/Hps+Q2QbJb04s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 036/188] regulator: bd9571mwv: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:33 +0200
Message-ID: <20260515154658.091437780@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


