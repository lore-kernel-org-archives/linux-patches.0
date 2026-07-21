Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8724B415F13;
	Tue, 21 Jul 2026 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670432; cv=none; b=aztHkL0+pVh8JnWlqIXCGpRdHvXlkmIGI6jgtWcl0sqzBTWtoGQvaoFk5By+nZZ6cKrKXI2MgZp4kB1VBA7LzfHPPHQrt9perfNJTkcoGDBNT0oTYAhIM0m8NH0sm2KRNAN/L/5MCN3zFfUi1TIWk6JyKr1mIKnsuUFAbWvQdSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670432; c=relaxed/simple;
	bh=YW+F2rn3ElgipKFclYKpciJ9JZqr6cxYZlMmI7TFzkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjfJbpnjPntKuo1hAmjRllD4IM1RFUwqVNOSjEceL8+rmcwTZiGdlhc0qyQTvp5QMhjaK4fhAcIJw3QPxGqc/WnbFmN4ABNnYdajB/aUhGPi1OLYa9Zjv0j5qVWXFFYEmTHim7Y5msOWoU9wi/diRXJHfh3PYIbCQHxK6Ytjqb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RX3veHd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RX3veHd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8AD1F000E9;
	Tue, 21 Jul 2026 21:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670431;
	bh=wyZblZ/oPtRHKMGC1yx/EY/0Y50/Qx4bl2kjfT36zfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RX3veHd5POEaqTNMAAvWxZfdFN51R5IbkwGZGbWgHz416zE2v2mVicyB3vC1V5qOz
	 dKY3t4I3PdW+MLJaoaAC6u+l66Gd6+n+QbQJv5fByDuQrAfcg9e82uHCSmj3rkxrY/
	 UkAxFsi5hYyJBo+mXnAb+bttA+g4SLOUqB8veSvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 6.1 0928/1067] reset: sunxi: fix memory region leak on ioremap failure
Date: Tue, 21 Jul 2026 17:25:29 +0200
Message-ID: <20260721152445.291710651@linuxfoundation.org>
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

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit 1a8c89f8c112c75e84ff9a140f969e372aed0c9a upstream.

In sunxi_reset_init(), when ioremap() fails, the memory region obtained
via request_mem_region() is not released, leading to a resource leak.

Add an err_mem_region label to properly release the memory region before
freeing the data structure.

Fixes: 8f1ae77f4666 ("reset: Add Allwinner SoCs Reset Controller Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/reset-sunxi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/reset/reset-sunxi.c
+++ b/drivers/reset/reset-sunxi.c
@@ -44,7 +44,7 @@ static int sunxi_reset_init(struct devic
 	data->membase = ioremap(res.start, size);
 	if (!data->membase) {
 		ret = -ENOMEM;
-		goto err_alloc;
+		goto err_mem_region;
 	}
 
 	spin_lock_init(&data->lock);
@@ -57,6 +57,8 @@ static int sunxi_reset_init(struct devic
 
 	return reset_controller_register(&data->rcdev);
 
+err_mem_region:
+	release_mem_region(res.start, size);
 err_alloc:
 	kfree(data);
 	return ret;


