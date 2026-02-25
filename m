Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D07126056D;
	Wed, 25 Feb 2026 01:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983718; cv=none; b=ulsp3XeLRgYjzlMtXJpbH37tY75qYsOvKwq3apKG1F+RDv/TFW85orrPHoEIsr/2rPPnguzst9hqxaf0QsLK+FhQ+RznP4CHZO3gfKtb8lZg9K6S2tDtY3ZKDdR08rzU1SSz+LQw8ebtjvVLqGHDnCz3Ftijq2u5zSqt5USj0RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983718; c=relaxed/simple;
	bh=lDcJ469ww7mQmPXqLBe1SGVrJTV74NnwWtwCRg0GBH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7ucuz2FtU8J1Z605FbT3JiVvLKyINMg9l+51UHznLBsrd221+lbxeqdwIoQl1TxaDFbG8tnJ4mo/fGR+mAnRDyuUrf98YRrk94DGIAyj5xOII+34HhqP0RfrPAKjFpYj/3sLUje2wgUucKYqmuaJUoy2Qvb7Vxq5T4A4vCYY1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ta4uZ4Jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ta4uZ4Jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61037C116D0;
	Wed, 25 Feb 2026 01:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983718;
	bh=lDcJ469ww7mQmPXqLBe1SGVrJTV74NnwWtwCRg0GBH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ta4uZ4JqPQv2J3War1aEwLNpDy5g/SXdBMzMeemHwJtv9Gji/YM5MZA0H/NZdGGa8
	 LkdK9CFZ8yljzWFOBG+LKjIaq82MVdKnfoHFDwdLBHCcQckaGsE9SDXDauqTyNlWyM
	 +KtJk+Bs5/9uijEAf302pqFj1WHt8JGjUUadHdNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nurminen <jani.nurminen@windriver.com>,
	Fredrik Markstrom <fredrik.markstrom@est.tech>,
	Ivar Holmqvist <ivar.holmqvist@est.tech>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/641] i3c: dw: Initialize spinlock to avoid upsetting lockdep
Date: Tue, 24 Feb 2026 17:15:42 -0800
Message-ID: <20260225012349.357234257@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Fredrik Markstrom <fredrik.markstrom@est.tech>

[ Upstream commit b58eaa4761ab02fc38c39d674a6bcdd55e00f388 ]

The devs_lock spinlock introduced when adding support for ibi:s was
never initialized.

Fixes: e389b1d72a624 ("i3c: dw: Add support for in-band interrupts")
Suggested-by: Jani Nurminen <jani.nurminen@windriver.com>
Signed-off-by: Fredrik Markstrom <fredrik.markstrom@est.tech>
Reviewed-by: Ivar Holmqvist <ivar.holmqvist@est.tech>
Link: https://patch.msgid.link/20260116-i3c_dw_initialize_spinlock-v3-1-cf707b6ed75f@est.tech
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 9ceedf09c3b6a..75f813d72f851 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1563,6 +1563,8 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	spin_lock_init(&master->xferqueue.lock);
 	INIT_LIST_HEAD(&master->xferqueue.list);
 
+	spin_lock_init(&master->devs_lock);
+
 	writel(INTR_ALL, master->regs + INTR_STATUS);
 	irq = platform_get_irq(pdev, 0);
 	ret = devm_request_irq(&pdev->dev, irq,
-- 
2.51.0



