Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2D91F12F7;
	Tue,  3 Dec 2024 16:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242098; cv=none; b=R5+3v8zoZ9y9JiIjPLjnVs2qK+P16XxnJSfrzUDtrEQ7iO2aEpf0dDIoDsMh6IvfapFcmB6VEtIUZ8UMeUT3kWab1+iohSNbKFFJLT7/tKIBbViUd7fyYommTyBPgLpqDXo1Fi0T7UKw2QRV7yZfhDo/89i9pfYdvwrJAn0afvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242098; c=relaxed/simple;
	bh=7FQ82MbRvLK37NHaWaAJ94Prqk7Yvyb7bfEWslRSXTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CccNoQCGY1G6GIhWFfwy+YOkQvxwieIfSfoe75tWBJSq1v5zyTOpkF3uM6PJz6IozoU+grxsMadB2CLzNDCuAb4RDFX6RMXu4ZGXtBe6T9dLlSPOrb6b/Nh0sDc/GDajonNjzTaBhr/+5EHyTGdJZrl64PaW0xioetq8qx6LrAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mu06FOKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mu06FOKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A98C4CECF;
	Tue,  3 Dec 2024 16:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242098;
	bh=7FQ82MbRvLK37NHaWaAJ94Prqk7Yvyb7bfEWslRSXTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mu06FOKqCsXcsWe/0EvCx1yEzIJA56HThMKr2BSXmOxZfs7scDoZOBuW69U/eQRLa
	 Kp+ngbCKn/MRTZwVFZpYxL6UVdSEWEb3zRdjjMYf9M3nmw/1xSHWQLgMgR/0u20tHk
	 7R8dHkX1CTd5NAoygGzgNvvgI4fHIkSivvdcuuNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Panis <jpanis@baylibre.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 607/826] counter: ti-ecap-capture: Add check for clk_enable()
Date: Tue,  3 Dec 2024 15:45:34 +0100
Message-ID: <20241203144807.431579617@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 1437d9f1c56fce9c24e566508bce1d218dd5497a ]

Add check for the return value of clk_enable() in order to catch the
potential exception.

Fixes: 4e2f42aa00b6 ("counter: ti-ecap-capture: capture driver support for ECAP")
Reviewed-by: Julien Panis <jpanis@baylibre.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20241104194059.47924-1-jiashengjiangcool@gmail.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/ti-ecap-capture.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/counter/ti-ecap-capture.c b/drivers/counter/ti-ecap-capture.c
index 675447315cafb..b119aeede693e 100644
--- a/drivers/counter/ti-ecap-capture.c
+++ b/drivers/counter/ti-ecap-capture.c
@@ -574,8 +574,13 @@ static int ecap_cnt_resume(struct device *dev)
 {
 	struct counter_device *counter_dev = dev_get_drvdata(dev);
 	struct ecap_cnt_dev *ecap_dev = counter_priv(counter_dev);
+	int ret;
 
-	clk_enable(ecap_dev->clk);
+	ret = clk_enable(ecap_dev->clk);
+	if (ret) {
+		dev_err(dev, "Cannot enable clock %d\n", ret);
+		return ret;
+	}
 
 	ecap_cnt_capture_set_evmode(counter_dev, ecap_dev->pm_ctx.ev_mode);
 
-- 
2.43.0



