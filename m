Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB345A0F8;
	Tue, 23 Jan 2024 00:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969932; cv=none; b=GPf9v2Omqose9Z8IzwxgydHvson1/Ax6GWBYns3N9KuCL5UWWDdnfIqMasvZn/k0ohoL6JUhjQFmjVXgExdB1DoaxlQMbFkN+LNpWhnY0vLrM7/ZEaPv0PFT/SNLgokQGxWaIZWixf+zocAIxHUUTEY2hRuIFWqwF24koalEqkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969932; c=relaxed/simple;
	bh=Bgv+9RVFEsm5sZFkpnyztISOBvKnN16srALZk4W301U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lIGvmy89y3AeolI+XUzoVRLtuoG2lhp02e8e0GDRptbA5JkeWRRWjzpJmJH3JZRNOpifulkCEBEQGr8vBJwiSjkkyuaAk0AZB8Iv1fK5LF8CtFuHBY38/n3rS82+nrCWwMLnsBxlynJUe8+rOGM0YZ5n0kNjDJKShn4SNEo9CaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nsuGiOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nsuGiOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC072C433C7;
	Tue, 23 Jan 2024 00:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969932;
	bh=Bgv+9RVFEsm5sZFkpnyztISOBvKnN16srALZk4W301U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nsuGiOSOgcOlP3QFOhC/teQ1WQP64dFRxQySmKSLTz/RoKebijdS0yTEfpaB/aiQ
	 CfUSufionJ/XVPE941/0W74rcRROITpy+50YsXTNqgzFrKjqYXBlyjUCqisNGp5Ctz
	 O58U+VRa9fXrPSCHcq0ZQWe14GUdE1tIISDGNh8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 505/641] serial: 8250: omap: Dont skip resource freeing if pm_runtime_resume_and_get() failed
Date: Mon, 22 Jan 2024 15:56:49 -0800
Message-ID: <20240122235833.873577989@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ad90d0358bd3b4554f243a425168fc7cebe7d04e ]

Returning an error code from .remove() makes the driver core emit the
little helpful error message:

	remove callback returned a non-zero value. This will be ignored.

and then remove the device anyhow. So all resources that were not freed
are leaked in this case. Skipping serial8250_unregister_port() has the
potential to keep enough of the UART around to trigger a use-after-free.

So replace the error return (and with it the little helpful error
message) by a more useful error message and continue to cleanup.

Fixes: e3f0c638f428 ("serial: 8250: omap: Fix unpaired pm_runtime_put_sync() in omap8250_remove()")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20231110152927.70601-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 578f35895b27..dd2be7a813c3 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1594,7 +1594,7 @@ static int omap8250_remove(struct platform_device *pdev)
 
 	err = pm_runtime_resume_and_get(&pdev->dev);
 	if (err)
-		return err;
+		dev_err(&pdev->dev, "Failed to resume hardware\n");
 
 	up = serial8250_get_port(priv->line);
 	omap_8250_shutdown(&up->port);
-- 
2.43.0



