Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7697C62A00;
	Tue, 23 Jan 2024 01:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974974; cv=none; b=jKLz61ha4NVrV1C6duU2BUGcc9SEFXC6SxgGElDNQoEG5c7jBsdeUIDxkrWZYA/fx0JA9ExLGQ0ouGew/rx6qqdFE6EGZUNJmL10OuxaWWKME2NbvgND30hIdMAyDv9LSAopVg0dN/GQhdPSu1q5yz59FnLleMHPMMl9ELLEadU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974974; c=relaxed/simple;
	bh=m8w1lHjG7Yd5A9DQuk8VVbhlFEIEiHnlqcRoaTWZcPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2whmHKgPtjP/nQktoKmfit6SYcZUgwmD+l6DbHrARXeuvG5txZJjVP6+uylY3r4NmHvjke9d0sjGa5eUVpzJ5n6j4PW/JqR81aDdOOHOlE5KaS0XGJsnkduqG9eR8sE5tPvvBUstFbBPA52p3wmfA9mINSuuVTO7OIIrd2Hs00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6LiAjos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6LiAjos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFB6C433F1;
	Tue, 23 Jan 2024 01:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974973;
	bh=m8w1lHjG7Yd5A9DQuk8VVbhlFEIEiHnlqcRoaTWZcPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6LiAjos77Cz3a6DU+ZR3ZCwqnxQYlkwbtQtiEzis/VXrPP2CxQoJ7RkACPe/+CJD
	 V+bL3zyLt5iLpgJh5aK/I3NOa4wUltGCGrviDZ6wv5/uZo7SD4ce5TW1a3pPB2L9uk
	 c0BiMVHpq0YckM7fNmXnPZLDY+Pop+s//+LA9Aq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/374] serial: 8250: omap: Dont skip resource freeing if pm_runtime_resume_and_get() failed
Date: Mon, 22 Jan 2024 15:59:19 -0800
Message-ID: <20240122235755.340325799@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 20e0703f1def..770c4cabdf9b 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1492,7 +1492,7 @@ static int omap8250_remove(struct platform_device *pdev)
 
 	err = pm_runtime_resume_and_get(&pdev->dev);
 	if (err)
-		return err;
+		dev_err(&pdev->dev, "Failed to resume hardware\n");
 
 	serial8250_unregister_port(priv->line);
 	priv->line = -ENODEV;
-- 
2.43.0



