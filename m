Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F6C3B95E0;
	Tue, 21 Jul 2026 21:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668588; cv=none; b=ez9qkc0545MCWdZLRHObvYh4nEXXsSdYyMhTn7lgKe07khUkHWPBieebGYpnVHvKPiKmSFdfxrquTv0udrhhZTwh2fOEkYVue75r48FZxs2Vlz4KvyxFfFEl8PcKBR8/1D73EyoONvfVcycA+W3b+/IIIlneE2FzVLTlw+IfkNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668588; c=relaxed/simple;
	bh=Dk1KbnsyV/iretd+29Kdbq7xc+z+a9T/El5WPjohq+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ7xtxjnLghKbFxe/Mraspc1beHXuLvGstZFRRpWgguYHBjOP44qskoeYRx/Issy5SVJFrRaIQ6Y3g5qb6y5mfLk8k0WhrfEyAZErWBoapup4xFZNbv82nAswGKLpfX+MEN/R1Vg0eQiQIZL66WKccJo2Fd57ECf97yaEPSsRyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxRPMqYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxRPMqYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FB41F000E9;
	Tue, 21 Jul 2026 21:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668586;
	bh=1dXKLiqyybNV63cTT+9NLxAlik4juylFSBM3ONtGOzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IxRPMqYh/AIFen1Tb3SkNrFtq50t31A05rrIWLT3QA2PUh04H5G8k9QUVd/FYNYE4
	 UKTGG996Bab4L8P/VjSobWDVh0TvIvTNsGKXhMPyJgEXI3IqvoA5PxbdpJNHTBlVlf
	 xhEedqmwxNJI9Jood2AtT7mCuq2Xbba3FXxL/8L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 0195/1067] usb: typec: ucsi: ccg: Fix use-after-free of ucsi on remove
Date: Tue, 21 Jul 2026 17:13:16 +0200
Message-ID: <20260721152428.956895876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 1f0bdc2884b67de337215079bba166df0cdf4ac5 upstream.

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
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -1435,8 +1435,8 @@ static void ucsi_ccg_remove(struct i2c_c
 	cancel_work_sync(&uc->work);
 	pm_runtime_disable(uc->dev);
 	ucsi_unregister(uc->ucsi);
-	ucsi_destroy(uc->ucsi);
 	free_irq(uc->irq, uc);
+	ucsi_destroy(uc->ucsi);
 }
 
 static const struct i2c_device_id ucsi_ccg_device_id[] = {


