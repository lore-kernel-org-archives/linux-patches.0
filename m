Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A1F23394D;
	Sat, 17 Oct 2026 17:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256591; cv=none; b=GUQhKJ+c7gM84HyOnnuR0wkzi5n2J4PoIvtviLxTDNiyiIwEdlmiKQxCdvg3XirQyZEVgcRL51bvUI0uI/2b5nOn25oy/Qpa6qq8WgPvC0Do2U/6lFcwZv3/7y8xey5fGazUSP+YNc2vq1cmLc//LyusGpEYlPrOpwqEAZBfit8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256591; c=relaxed/simple;
	bh=MgJ6SxrpaWpMOPsQu7DWnKqefOeOduCSfxSzOy0+BtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgtQHUFLz5XIeeO1yA2GKn6Vewy4Y+GC+GH1B/dVfp+iUu4SAcAu0UruSOaHlkMDoZiirpYMHTt+TNgZRmuNF5YFHFrsjoUzKEOXNqMoFLU7VbvK70gL//DzTp1v65gyq3wz+9XEFft93ULmmF4q3DE6M+lbfXQGxynpi6BU87E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1sPVmlq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1sPVmlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB7E1F000C4;
	Sat, 17 Oct 2026 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256590;
	bh=XTE5lscN6Zqh+ROaT3lx8C2nbNi6+e2lpqAlLnj1/6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1sPVmlq8CYCt97qds4oYUlO5AnjsOUMXVjv04vHHwKw6+3Q7CRi80Dz5pRTcROoI
	 g4OMAF0W78ooXe9JQ512gnPeumJzUJYgYEivoefWo2LnqYV6lCtDnOGPYxCC+RTJAb
	 BVKXosrYqzBAHv4JC+Je+1H51U9QPKQrO04Pg5Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.6 0285/1674] serial: 8250_bcm7271: fix use-after-free in brcmuart_remove()
Date: Sat, 17 Oct 2026 17:42:37 +0200
Message-ID: <20261017160438.431161847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 189b9dc8c96ec9486482f27c1372b04a7152175e upstream.

brcmuart_handle_irq() starts priv->hrt to work around a receive-timeout
quirk of the 8250 core when hardware flow control is enabled; the timer
callback brcmuart_hrtimer_func() dereferences priv.

brcmuart_remove() cancels the hrtimer before it unregisters the port, so
a receive-timeout interrupt that arrives in between re-arms the timer.
After devm frees priv, the callback runs on freed memory.

Unregister the port before cancelling the hrtimer.
serial8250_unregister_port() shuts the port down and frees its IRQ, so
brcmuart_handle_irq() can no longer restart the timer, and the final
hrtimer_cancel() drains any timer that was armed before or during the
unregister.

This issue was found by an in-house static analysis tool.

Fixes: 41a469482de2 ("serial: 8250: Add new 8250-core based Broadcom STB driver")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260909084002.686911-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -1153,8 +1153,8 @@ static int brcmuart_remove(struct platfo
 	struct brcmuart_priv *priv = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(priv->debugfs_dir);
-	hrtimer_cancel(&priv->hrt);
 	serial8250_unregister_port(priv->line);
+	hrtimer_cancel(&priv->hrt);
 	brcmuart_free_bufs(&pdev->dev, priv);
 	clk_disable_unprepare(priv->baud_mux_clk);
 	if (priv->dma_enabled)


