Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2157D418A2D;
	Fri,  4 Sep 2026 06:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502255; cv=none; b=U0yoILBaLF7zSSN5nQ0et29zYcY8iQy2eZ+MYkg7bPWqS8sttdpzLME0ZiIug4kwWvFfVJvct1kI/BtEt75AoMz+iqMVt3qs2PPrENaFd8ACEDB87Wa5WLXyTqw8KcVBeCrV9Zt9ndKP3+2yBRthnGBohPD2ifsD08o1PRIG7r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502255; c=relaxed/simple;
	bh=a/maIbPlTK1JRWuN62zTSHE96Yb2ubcDjIqdr34u7hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAzgZlAqhdhKjnq9O5NpknPmY8byy6RoUYmysA1g2JgEoqvQsebiY7BgqfkJdxgxyLlhl/zLKc9UDNlE5GbtdHWQspb/oNOSTgqu72poB+6XY0iBXE6vzQzx5N1qyZr6fGwt0wkyv5dWT8463uB18mf+Q8UdIFwaVRMAUHgu6WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJ4Dnr9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJ4Dnr9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B6B1F00A3D;
	Fri,  4 Sep 2026 06:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502254;
	bh=lEtCeu1kAPd9UeV51z/uuPmPvBORPnNIIbM7A9Jrdgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJ4Dnr9RWVekzIgx6+M9yCpfPBS1sDO1m83QYcFPm4SwA1RLjS/pMGVDsJKMQOiKD
	 zETgE+kVnj/uerO8vdORMzYkI7XwLwJPGz2UuA9hBE5QydQh8FvVz5jd0hoi+erj3h
	 NJi29s+ic+Dng4G/MEEEqQuf6rKS1b/ztpLHgtAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 144/403] fbdev: omapfb: panel-dsi-cm: initialize lock before registering display
Date: Fri,  4 Sep 2026 06:59:07 +0200
Message-ID: <20260904045738.121440149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit f8e43fe0f22b7137ce456e6fe3581d3098174f74 upstream.

dsicm_probe() registers the display before initializing ddata->lock.
Once omapdss_register_display() publishes the display, another consumer
can reach a dsicm callback that takes this mutex while it is still
uninitialized.

Initialize the mutex before registering the display so the published
callbacks always see a valid lock.

Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
@@ -1151,14 +1151,14 @@ static int dsicm_probe(struct platform_d
 	dssdev->caps = OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE |
 		OMAP_DSS_DISPLAY_CAP_TEAR_ELIM;
 
+	mutex_init(&ddata->lock);
+
 	r = omapdss_register_display(dssdev);
 	if (r) {
 		dev_err(dev, "Failed to register panel\n");
 		goto err_reg;
 	}
 
-	mutex_init(&ddata->lock);
-
 	atomic_set(&ddata->do_update, 0);
 
 	ddata->reset_gpio = devm_gpiod_get(&pdev->dev, "reset", GPIOD_OUT_LOW);


