Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3B2519E00;
	Thu, 17 Sep 2026 17:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664664; cv=none; b=BP2L/kZQnRvOIQIHfHU+m4RV4gtpIjRNjGzd1UmK7p2taeWy23gPWdyRGF2ITu+aFPkWpBbvHExHCZTOH+QLnUIRLkpZQk9qQuAtuAcK9OaAxGr8jGVjZ75kIaZxlWElJbtc5MOVfdgJbYgKcXqsc4UnvDRe16p57Pr233KsO+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664664; c=relaxed/simple;
	bh=mbYs6RMnrhkCUKWTQ1Ul1Gm1x+PXMZJIgjGwwP+5Wo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amal6bZFu/Ng+5ee26yfV84OQe7gfWyApLK4x9JL8e5+ULq1quF4B/2mtQnQOsLRxqxJU7bd4Nvy5SaAO8Y1huQ66iesEVcjVPlP+SgfZJZrM/nx1gkaNcf7Cx0IZ2qHaW8GmQcIfmuoy6LHyW2S+gnPs+GqxzQEt+GU14TVqmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVvcHWio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVvcHWio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756661F000FF;
	Thu, 17 Sep 2026 17:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664663;
	bh=m5EVKTFBczL68CJ9JMxqSpOq1ZKNlvutP2ojrhWerLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVvcHWiognk1hk3pV9V8l4PpRxbCkH/AqfaJ8ECPWu26RV6Suf87b27oyR0G9J49g
	 XNqNL6SgBKZiP9wER5bkSLes1A4fepIShxtfwQ5k813Ork2ObK7aNVF++fhPu9RuPG
	 kHskY6txPUtgO/BxFV2J3AXH8HbIMEzoP5JI4vHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0448/1250] mailbox: imx: use devm_of_platform_populate()
Date: Thu, 17 Sep 2026 16:04:03 +0100
Message-ID: <20260917151604.140384377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 3e52f70434c97..445cd50c1b667 100644
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



