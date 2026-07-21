Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F77415F10;
	Tue, 21 Jul 2026 22:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674792; cv=none; b=gmcnL8Qp5owhkO94TqNaZ1ryQzf8eixi2frRUK6bsRXdUvACPoBwJS4Q47/mcDWl/+C8yVrgTSr+HaUiLOQKNAywro9O0UBrk0GTAutY7w/AtwcSBg3VuvxdAl9NJG2eYQS74CYNZM8zdO5emITU1xEKoM0D0xkXAWwqYmd2Ip8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674792; c=relaxed/simple;
	bh=EReSY9QvO6aygSnLm1eK30Ut+kHcgSSblDUYOR1eAF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4AhceqCU/0Mxlj+2WLFbNv0GcNX9zFnA/XZbcec3d/ESCrUA7f0RnMDWgMcz+j5T1K3BUFNYWUbHfAE9XmI+6hlz+/OeAFecSCpNnT5QcWiq+lhUcoPzI3Usa/w7p70gcB4h7wy0GvcXRvNdQkJeIqorS8jPF/iaNPshMQsEy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3Bj8C2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3Bj8C2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5331F000E9;
	Tue, 21 Jul 2026 22:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674790;
	bh=wyCYZmWjVFm73Ta5CTmIjdZtWjBTidgU75YwXRSnGjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3Bj8C2wKOzaYUxh7hd4kQfGlE7RzrJU95oV32t92x2VL46kJx4t3sp77a2VOY122
	 dSARA7mIAAy/R1IHwi7VkHZt4s2AfltF8pUbehIn3OSVCFltifNUy4E9DDdqnYC91g
	 MTrAPZZj82tGfBoDKmMqvg7O/tThg/p+pbYUyyc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 672/699] usb: typec: ucsi: ccg: Fix use-after-free of ucsi on remove
Date: Tue, 21 Jul 2026 17:27:11 +0200
Message-ID: <20260721152410.927206762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 1f0bdc2884b67de337215079bba166df0cdf4ac5 ]

The threaded IRQ handler ccg_irq_handler() calls ucsi_notify_common(),
which on a connector-change event calls ucsi_connector_change() and
schedules connector work.  In ucsi_ccg_remove(), ucsi_destroy() frees
uc->ucsi (kfree) before free_irq() is called, so a handler invocation
already in flight may access the freed object after ucsi_destroy().

  CPU 0 (remove)            | CPU 1 (threaded IRQ)
    ucsi_destroy(uc->ucsi)  |   ccg_irq_handler()
      kfree(ucsi) // FREE   |     ucsi_notify_common(uc->ucsi) // USE

Move free_irq() before ucsi_destroy() in the remove path.  It is kept
after ucsi_unregister(): ucsi_unregister() cancels connector work whose
handler issues GET_CONNECTOR_STATUS through ucsi_send_command_common(),
which waits for a completion that is signalled from the IRQ handler, so
the IRQ must stay active until that work has been cancelled.

The probe error path already orders free_irq() before ucsi_destroy().

This bug was found by static analysis.

Fixes: e32fd989ac1c ("usb: typec: ucsi: ccg: Move to the new API")
Cc: stable <stable@kernel.org>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260616132011.103279-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -1418,8 +1418,8 @@ static int ucsi_ccg_remove(struct i2c_cl
 	cancel_work_sync(&uc->work);
 	pm_runtime_disable(uc->dev);
 	ucsi_unregister(uc->ucsi);
-	ucsi_destroy(uc->ucsi);
 	free_irq(uc->irq, uc);
+	ucsi_destroy(uc->ucsi);
 
 	return 0;
 }


