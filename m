Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47268319601;
	Tue, 13 Oct 2026 12:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895118; cv=none; b=FxNrhFHLLdoQLeJVMYd2nBXhIucBHJx7djc0C/XiG0N0WHJBGpI0OPuZ3k7NrxLbVCdT4C7gSYquEBGCm/upvWuG/OnrOyZTsJf3z1Qk7GFGV5cFfMDfp1LJ+xicrYs0LKwEHshxQLcv3K6SkSXJVQLUishZxXZxZKfAcALXXN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895118; c=relaxed/simple;
	bh=MwY7CPybkmrxZ4rwRnYvufj2kI1+0av3M/6eVfGdDlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G627uoDjir/2eJPWSyKexOOzKeliWJU65ysmCv/bdJUHAcxL6PVTrpDb3GpNjKOJ3EvNFLlXW8+qsUd3umZ7h/r8cLZLLPjJ7Elz/ooO4NS+oaK4a/32Tu/3UsWmOLJEWGwiSxCkD+9CVXneM3c3sSUvLuEI++ocZ+P+MXJ5FtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqaWH7Cn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqaWH7Cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C641F000FF;
	Tue, 13 Oct 2026 12:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895117;
	bh=cMWMGlSmKWcZDcCgKjmPfpMR4PowEv85Cq0s7WWln+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqaWH7Cn/VaEZHSeukB4m3iRm8gHANRCfcO8Fg/R0vH2SmFv2kJtgZb7H1Ulcv8sn
	 0goHeXSWD9bVpfoEWGMir4OYHWBxtz6R7A1ytFWnUiBBY9GK7cXQHH69Ne8U673lwQ
	 S7mf3WOvH9q5HCG5IqrQQfcm2SFvg07MgnermoRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.12 166/497] serial: 8250_bcm7271: fix use-after-free in brcmuart_remove()
Date: Tue, 13 Oct 2026 13:35:33 +0200
Message-ID: <20261013112911.830620048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1124,8 +1124,8 @@ static void brcmuart_remove(struct platf
 	struct brcmuart_priv *priv = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(priv->debugfs_dir);
-	hrtimer_cancel(&priv->hrt);
 	serial8250_unregister_port(priv->line);
+	hrtimer_cancel(&priv->hrt);
 	brcmuart_free_bufs(&pdev->dev, priv);
 	if (priv->dma_enabled)
 		brcmuart_arbitration(priv, 0);


