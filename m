Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209011;
	b=0K/17MpgYuh/VZNdalfcDAN9OU4Ze85BZ95VuEVvCHUoSPJsCuuamdLHm/JOCFbZYPdb
	 0o8/8EHNFNMctoMyh7bTxsIGJunG/VNvXBtEMbyLiDAwOovye3NsN81N/S2HEpLxcs1kz
	 RVvpzDi32Y6AlNv5wmbp2EOV2+U40G3NTXgEed6JAFcfWsoY39gDhU3j8fvdrBYxhQr7i
	 YBZ/clKcTaXbwuLO5syBD89mRxtP9wvWeDkF/QYiKOc+83uyWrlgeY8z+NhPjAlfmShsn
	 Hfz9DJ1cK0RlSTrxSX5TYQy9SyVuvPvva95xQoeYMuXX93gJRCEAvKzHJ3JLy7Kv+Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oXfcEMnLStUlivGtbwHkGQQv1LEdeK6BsY5Ep5lESB4=;
	b=w7pGRNfcY6ikVmcWL8NdgWQylk51SjHX+ZvDzgJIQ4s+a/l0uk+e3uItXP8LGjnHxbmN
	 VFjPl0sw/fcW0o+BBCDyJR+hVyVi6HfvFZasP+Zh5QLWs8iSQavVjEhVodigUhXJDhIs9
	 8rsgTDqGZhK1SY4NBf36DDZsUt1laX62/LZLY825jLEShe4oqmSDqYdbvl4xWfx2Q+fio
	 nEnyD0mLVaB3uU8tczOK0i4H3jJdgGzCMdJWDBEEV6EWmknQK9tqGnO6ryzAAAyh9j4uc
	 Vrdvdstg0sWPz+v36m+c+XNZRWekyEuqrASxh6eSYuQ50t3lP2r65O43eMfWGks7M8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZK7Ocyxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BF2606A31A;
	Wed, 28 Oct 2026 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZK7Ocyxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682981F01825;
	Wed, 28 Oct 2026 17:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209010;
	bh=oXfcEMnLStUlivGtbwHkGQQv1LEdeK6BsY5Ep5lESB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZK7OcyxjzjAvmWyWPulz6N5pKNZM2WKbD+MOIoDrWrwGM8062BSwDpo7nGeoMfc8t
	 al7ti6gh3ei6pGFFYdKqflPP2uhYNRflF6whZVRboNrwrOtWNlBTG7nTY8zL0RkuvG
	 lGx0QMwow4j/Zkru1DMkv8Ryg2rc3TbUtkaZjgcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sicong Huang <congei42@163.com>,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/516] usb: cdns3: fix use-after-free in cdns3_gadget_exit()
Date: Wed, 28 Oct 2026 17:57:16 +0100
Message-ID: <20261028170010.218852369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit ebe9b68c396792c15d0ac690d592e449e74ed804 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index a64302acdfe6d..d0378ecd0c981 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -3254,6 +3254,10 @@ void cdns3_gadget_exit(struct cdns3 *cdns)
 	usb_del_gadget(&priv_dev->gadget);
 	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
 
+	/* The works can still be queued until the IRQ is freed. */
+	cancel_work_sync(&priv_dev->pending_status_wq);
+	cancel_work_sync(&priv_dev->aligned_buf_wq);
+
 	cdns3_free_all_eps(priv_dev);
 
 	while (!list_empty(&priv_dev->aligned_buf_list)) {
-- 
2.53.0



