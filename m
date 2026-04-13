Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DCC282F1B;
	Mon, 13 Apr 2026 16:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096540; cv=none; b=fJVlcCYaeGGvazr8/f6JzT2zWtq3pVr20q2RzgWVkRnKIeWi7VhIxvtAswrtCZWmk+nDV79bwgy68x6xpoKARTKCQclUrbYtegTenBh/Nu1sQvjhf6WoVGNf3fRbijnj3Eu1yGa3NdcuSAZ6j9mw+1/+bOysh0rw6dFIWIpu08Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096540; c=relaxed/simple;
	bh=K3esEV8O1w0tVOPx1Q0o32sQ4qz1nML+/2lzPcx7frE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hELxC32CnhzsAw6RqmE892Af7poAM7AlP0RWpRntdH5nIQMttqd+Cbd+NnVlLStjY1HTCqe8SJxC1s7GWGGToymURiVKQGBZTfcSTX6JMU+jYReiLgVsymE7yN9SsKxZqQbybaw6PSWvaUpxftxXVt3ElZydZKt+273Wffi12fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENLxbq5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENLxbq5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6631DC2BCAF;
	Mon, 13 Apr 2026 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096539;
	bh=K3esEV8O1w0tVOPx1Q0o32sQ4qz1nML+/2lzPcx7frE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENLxbq5PnQAWyOrneRwRcm+xwjwe8gZZTe1eUu9fDIW1X31AGtwVCX7pvQQzOYcu5
	 N//cX75BNGCOun01TKRIAbw89VJ7WBdAvFCAt5UzLxFpX0u3pnnwUs3jWSF1PjGnHX
	 R5LaSNEx0stanwB+bBDBBocRIKIzSVMOUI+7cRI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 51/83] mmc: vub300: fix NULL-deref on disconnect
Date: Mon, 13 Apr 2026 18:00:19 +0200
Message-ID: <20260413155732.922410700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit dff34ef879c5e73298443956a8b391311ba78d57 upstream.

Make sure to deregister the controller before dropping the reference to
the driver data on disconnect to avoid NULL-pointer dereferences or
use-after-free.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2365,8 +2365,8 @@ static void vub300_disconnect(struct usb
 			usb_set_intfdata(interface, NULL);
 			/* prevent more I/O from starting */
 			vub300->interface = NULL;
-			kref_put(&vub300->kref, vub300_delete);
 			mmc_remove_host(mmc);
+			kref_put(&vub300->kref, vub300_delete);
 			pr_info("USB vub300 remote SDIO host controller[%d]"
 				" now disconnected", ifnum);
 			return;


