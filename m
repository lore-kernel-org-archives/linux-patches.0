Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210979;
	b=WDvxT4djBqfM71ItWfxhsupw2nBqrkUSdVGPmQi6QDU4IVfcKhFuyL+tuhOwxKlAPnbq
	 fvOAbISOuM6CbHxjrdvf7QzhvYxlxMox37t64id4p1/O3M/DNkZqc53EV0s+elgiL7rXU
	 o0fxIwoHIYCLQ7iI33k0cr2TZhBqN54ZduOgQI+EqinM3Xt40PBmNZZU4x5G8Yf5K77+b
	 FGuVXHRy9Q5s1OR6t/DU3L/+O4pzIFaBVQC9i8nNnKwtZZTG4nYwKZAm0Oc4/rJmnT8eb
	 fvjNkubXqYmkDfg/Ee3P+MQjZTTpYOJtZMcMvrmxKNv4qdngY8gosbP9akTkOq1H7OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wz7YeS12uyH2PVEy0he3rGGcxUUhh+YirIEe5vUT5HU=;
	b=o6qso5L0DDyxo6ULW/LpeJo+Lhu9fGR0ITwJ/egFug19kUGJQGg0xhDIbeT/ishD4KuW
	 F/m0G5pPk3VibxFi46E1jcjawVrEh6H/ULFoOc0NbuIlJgia4areyhsS27BMsd8vkE9DZ
	 ijzJ3VsYRK/BXuE7Gc7F0Ddy+NF3EbNv0rsGZYGgGl8OppRED8mFqUEtpqA+ubC5IfQe6
	 Qp1mVA77b6yH0P0BDbIRmJlNBqUdRQrj8pUGS5wN6uhuo+OEXLiERHKHQI5Yp4aL9Msi7
	 OpkY/0NaP0nxyKJLESxUWusyovm2R/GptmLbseGNjrOfIXrcyjJIEAwrsrE60024cZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9Z1xa44;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6460606A321;
	Wed, 28 Oct 2026 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9Z1xa44
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DD01F031E7;
	Wed, 28 Oct 2026 18:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210978;
	bh=wz7YeS12uyH2PVEy0he3rGGcxUUhh+YirIEe5vUT5HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9Z1xa447VjcxDyUMSioPNWkTrXb9/5lErqO3FlT1te6EGNf/64n3z0uxWmZJxIta
	 eYdhPIsTEFkE1XAMpfQXQFIP7XTaGN/9Tyx273Xj5gE0XjuCQV7meYEb7k4jMkwRy8
	 nNFoLk2t4Wvx5G6p5ruDxz5RAUaWbaUTSSSsRRlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sicong Huang <congei42@163.com>,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 214/571] usb: cdns3: fix use-after-free in cdns3_gadget_exit()
Date: Wed, 28 Oct 2026 17:56:01 +0100
Message-ID: <20261028170013.080502903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit ebe9b68c396792c15d0ac690d592e449e74ed804 upstream.

cdns3_gadget_start() arms two works on system_freezable_wq:
pending_status_wq for the deferred ep0 status stage and aligned_buf_wq
for realigned request buffers. Both handlers use the cdns3_device the
works are embedded in, and cdns3_pending_setup_status_handler() also
calls the ep0 request completion.

cdns3_gadget_exit() does not wait for these works. It frees all
endpoints and aligned buffers and drops the last reference to the
gadget device, which frees priv_dev, so a work queued before the exit
can run after the free.

Fix this by waiting for both works after the gadget driver is unbound
and the IRQ is freed, when no new work can be queued, and before the
endpoints and buffers are released.

This issue was found by an in-house static analysis tool.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Reported-by: Sicong Huang <congei42@163.com>
Closes: https://lore.kernel.org/linux-usb/7f5719b.8700.18f67b324d3.Coremail.congei42@163.com/
Suggested-by: Sicong Huang <congei42@163.com>
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260909095655.694527-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -3265,6 +3265,10 @@ static void cdns3_gadget_exit(struct cdn
 	usb_del_gadget(&priv_dev->gadget);
 	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
 
+	/* The works can still be queued until the IRQ is freed. */
+	cancel_work_sync(&priv_dev->pending_status_wq);
+	cancel_work_sync(&priv_dev->aligned_buf_wq);
+
 	cdns3_free_all_eps(priv_dev);
 
 	while (!list_empty(&priv_dev->aligned_buf_list)) {


