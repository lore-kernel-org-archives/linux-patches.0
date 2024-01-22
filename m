Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D9C12F5A7;
	Tue, 23 Jan 2024 00:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969023; cv=none; b=SGCA7gxvsQM5nGyRZ3yVgldUf/iD/VWVyBMmYwf6Ni/tz3qYskyz9vW7wgQ8A9j0ZIrreEKGU6pAVrOVOjwhwCJealQm4QVAlvWnmWphra6rUBqCv/rFOVaDUz41PtNbMVc+l3jB0xBG5akmIuy1AxnL8DSZ+NyT9B34F1W6tYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969023; c=relaxed/simple;
	bh=oOBI5bI83M/lJA7o8l2vS6Tlz3lNyEeDk5/S+V8C0DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1xt6KqmNRgcAJZb3qBQJqaTRc7SiWTRV0jdwPLB0lIMxC3fylB2OtHDKRi+XujDpfQWGgbWsPc/DK8NdRpSNRD9Np0etJrRgcbfVAKxhLPtMioTDlQZDqeCYZLAvsrr6kBm1Vdvn565S6uwFiT9z7B4V7ubON8N/3I9N/XTsEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGg7GhLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGg7GhLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF39EC433C7;
	Tue, 23 Jan 2024 00:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969022;
	bh=oOBI5bI83M/lJA7o8l2vS6Tlz3lNyEeDk5/S+V8C0DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGg7GhLgbvsaMNccLzIqJLkSIzGz6QLWitehhqW8VZmr7a+bo+VN3UGaJnS2bZOIJ
	 F8DqHWkra7Trk+Jx5gxRGiWDLFgk73CUN+PDm3Vz0Kumd8bmssS5ImEYzVe8fGZKJO
	 375jgem5mpqNofs5wUJGvPFaeUrYxCZDH4TmFt/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/194] serial: 8250: omap: Dont skip resource freeing if pm_runtime_resume_and_get() failed
Date: Mon, 22 Jan 2024 15:58:16 -0800
Message-ID: <20240122235726.325619621@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a2db055278a1..6bb8bbaa4fdb 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1278,7 +1278,7 @@ static int omap8250_remove(struct platform_device *pdev)
 
 	err = pm_runtime_resume_and_get(&pdev->dev);
 	if (err)
-		return err;
+		dev_err(&pdev->dev, "Failed to resume hardware\n");
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
-- 
2.43.0



