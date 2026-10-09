Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD14E5322;
	Fri,  9 Oct 2026 14:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556189; cv=none; b=BUWYavci/WCUjywb2hnFpAK57LVyHVTzluW1W6CMejjO6tLJvvED1j+UlYeFyfg30u5XnL7TDxxp3KDE2a3ihK6OUKL6CTNm8+pwqcmNzDaLBZLB8CC5kffiaimD8LKXEUIV/MwMQzyaAYpxEwYVTdLxqGZJJTfbRNX+2fsl7yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556189; c=relaxed/simple;
	bh=ebcrYSztG4zZJ+gQWwUhBP8//xX8GiC/gT5/gzk5gho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgl6yVatxcMcAXSKfN0Z02fjWetTXQ2HTclGy6c4mAWRooEclaq1tGOxtZTzoCCjPQ5tMUPNt9DdsM+MTbSwKhvPlEkZCcamNDuTFjJlP2w0k1k+1+LZ5gQQxE0eLjiCBDP0ITfvJOEDZ9dpzgjCkNI0AEEVyuY1ziGBKG6sIrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNUsnHNM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNUsnHNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA781F00893;
	Fri,  9 Oct 2026 14:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556187;
	bh=O1JB8glq2LKF+4D4yi6lRuj/sd8Qcivqm3tXNI95sLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNUsnHNMoGodYPDuiA8MBJuD2jRznHbyzelQTQ416M1o6hGXkxyRPPbKyfe2WcxkA
	 2lSNfVCPm5zvx+9LMiRJD7zH4uOdNrRyR1oGi42K25jRJPZ44BgqTO5HG33Vs5z+Dd
	 PwsDCJv1Qo1wqHg0PbtWZr3Cb82kv1JrhXNZbCSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sicong Huang <congei42@163.com>,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.18 188/403] usb: cdns3: fix use-after-free in cdns3_gadget_exit()
Date: Fri,  9 Oct 2026 16:09:09 +0200
Message-ID: <20261009140956.520888261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -3270,6 +3270,10 @@ static void cdns3_gadget_exit(struct cdn
 	usb_del_gadget(&priv_dev->gadget);
 	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
 
+	/* The works can still be queued until the IRQ is freed. */
+	cancel_work_sync(&priv_dev->pending_status_wq);
+	cancel_work_sync(&priv_dev->aligned_buf_wq);
+
 	cdns3_free_all_eps(priv_dev);
 
 	while (!list_empty(&priv_dev->aligned_buf_list)) {


