Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56683909A6;
	Thu, 17 Sep 2026 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668191; cv=none; b=cxMy+Z6mjcTOweq4pGCqstEtc6enYo9ktlfh2qEdITT8ER1fC4x0L+6BvNqqv0AllAiLKXk8RjQbatouwzemsQn6O0bXNk5bJTwDbsboPBf29dBNNpQ2J42Y42QYzTpXuS8Ab7ENgJeLoMCvNwKKQYx5dBTzTcDr/c3ew1UWW5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668191; c=relaxed/simple;
	bh=eV54/EHFs8zNvqO7ZA1BDInz2B7JXp/CkB0ejGw4F4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISvMAy9qGUypF9CeH/9+m5POIQcBDy4QvoFqPJPRxEgMLSHDKnNqOmsH1+q0QSKeb9UTAyjAte0Wi5+/92bUt4w56uT2aP+kUcp2ahwLwgRZR2eLZ/njI9QxiQkcn6/ZeYolHGI6TRQe+4IHqBzcLjIFciF4IaeeVTwneWgZyVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8L2EF6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8L2EF6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FCC1F000FF;
	Thu, 17 Sep 2026 18:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668189;
	bh=PzlbtHWjdq4YxGqvfYIMjjLwYanB8dsYplNEoaZlTzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e8L2EF6fyqf1+hSblhC/0zvMBXc5bHIjvKSvrk0fhRcERzGfCqrY7JhJMl17f7L8f
	 /bJ3hjv8Fxcefd172M/l8WOAVyvDl7MZPF1OU+muh6BJCmhmimDoXR617Xvf0AQKUY
	 7yBPLK3TIdbfFT3gfiFpGA1Lofog/I3jjmsrtw6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0343/1102] mailbox: imx: use devm_of_platform_populate()
Date: Thu, 17 Sep 2026 16:04:46 +0100
Message-ID: <20260917151548.249917452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit dd1b321e8024fb01404fe163076c9010c5df8608 ]

The driver uses of_platform_populate() but does not remove the added
devices on removal. This can lead to "double devices" on module removal
followed by adding the module again.

Use devm_of_platform_populate() to remove the populated devices once the
parent device is removed.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index fa1b0c814c575..4409d9eb7a9fb 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -986,7 +986,7 @@ static int imx_mu_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_out;
 
-	of_platform_populate(dev->of_node, NULL, NULL, dev);
+	devm_of_platform_populate(dev);
 
 	return 0;
 
-- 
2.53.0



