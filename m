Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFCF23BD1B;
	Fri,  4 Sep 2026 05:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499059; cv=none; b=dMnu+GgzsPkP10AC62suikJBUZvADKi38Poze3QX1umJL47q+CE64yGdCFV/Ho0kYxZ7biDtENTdv1oqmrZdThc+RbsEymE2rNRyD8y4B7YI8Yzt2JzpLiOkssvIxavY8ZmdHzo7nuiXGJmqsUtDMvgpp4ndP7J7ok2c5d7Bvd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499059; c=relaxed/simple;
	bh=/Yoe7FzvzjhR9pUkNjmk0qQ2ZFFPPB7VztrFGpU7CZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2mwCZRAsiSlB9lK852FFgTtd2/g2E/lviKufM4q1fbck22Mg7klAdJH4dqNBAz7j7Kkf8nR88kr1cbeE6DgdEGOirwSHQy0B7hkSHghx0qFQSnT6QHmG25OAYezr3UZKlS3bciGee5hd+WH7Gak3/R5R0aAi1nJfSXZvHc0GBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yF2XvktB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yF2XvktB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7063E1F00A3E;
	Fri,  4 Sep 2026 05:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499058;
	bh=qxE7LlfryNdL0HjY5RcpimifOp6s1ejsBEsbKmW/+3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yF2XvktBbFnLp0xnecTFwix25ey7wPqLxBtlnUzLgv7D3LfWIn/sPBMQ6pqZAFrmB
	 Qsg8QP4db1JWTvUAz5q3Tu97bkUkIyWAMzQnQn2Wz9VUnnUTrzcMcGfC/89Xkz1Yh1
	 Xk3LNH/L1wSJBj0fcaarDy+FdmkGRdTd5koRoHQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.2 283/713] fbdev: omapfb: panel-dsi-cm: initialize lock before registering display
Date: Fri,  4 Sep 2026 06:54:11 +0200
Message-ID: <20260904045810.183631108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1150,14 +1150,14 @@ static int dsicm_probe(struct platform_d
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


