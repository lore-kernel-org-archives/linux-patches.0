Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7206630AD05;
	Thu, 16 Jul 2026 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211152; cv=none; b=DxzOhlfhP2A0xDhD2wdMIPBRm+PNuKMbr/2v4V1ry8cXGGj3zcGomWIOFv0fWMS0zO0BpK9c9ORsKXcBxAZtpY+xG4eMtIsoB80UA7RiRzjdTRuwE9kN7i7zyAssJoHTBdH33D4wG/cQqCSOb75e7ATVPkSxqh610bgBaOlpIss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211152; c=relaxed/simple;
	bh=sFlZs5pyt//pTRf48ds/PaqsNADa1GNV+3uZs/cuZxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJbmnNIKUD8bJge4to29QUh8RM11//Y2QW9PnsGAPuzZ+gvgUulx+/qQLEiVtOaIdlWSClGI9dCsSyATSS4DCx1L2fmBdiHZCFiAFEj6h1Sd6FSlZ3aYbxlAIGWztI0pJtmf1KhOc28TZiYJw5p5/zfwvbL/OZp0MAXSqAisvb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVmCRBTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVmCRBTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65911F00A3A;
	Thu, 16 Jul 2026 14:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211151;
	bh=orOXmd3H10CA2HUcte8m7xIeuw0xGouaHdIEcgNOGr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVmCRBThoZwdoaLVmrnFddCgp4qxTevdlYNUv+gIU/hPWYs7J2M2UxvPDL/9QAolB
	 HMeA9Ds7QoK3cfAU8FSTIXxhyFqe1jkVzNnA9L2VNsVpKo7glq+D1pFJ4yy5mpmLNh
	 k5n5Z6+H2wOKqtTx2Jk158q4NGcJhDN7bhN2mic4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 317/480] usb: typec: ucsi: ccg: Fix use-after-free of ucsi on remove
Date: Thu, 16 Jul 2026 15:31:04 +0200
Message-ID: <20260716133051.678417123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -1518,8 +1518,8 @@ static void ucsi_ccg_remove(struct i2c_c
 	cancel_work_sync(&uc->work);
 	pm_runtime_disable(uc->dev);
 	ucsi_unregister(uc->ucsi);
-	ucsi_destroy(uc->ucsi);
 	free_irq(uc->irq, uc);
+	ucsi_destroy(uc->ucsi);
 }
 
 static const struct of_device_id ucsi_ccg_of_match_table[] = {


