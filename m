Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9095046D0A1;
	Tue, 21 Jul 2026 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655270; cv=none; b=V/AhcIbIGF99sq2+d8lPzZQRq7ujhzMsw+FNi/FNVfY6dxrniE+px6UcTM9n9fE8GPwYY6iHKwOLtqeAHY/6Ln7Abm+ASmZ53UhHW1xowJ2SIrxWWFXC2p6H1G9NadCmJVwVZii2568Wzt60jlLQapxBcLGGe3H5jGien5+KVPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655270; c=relaxed/simple;
	bh=c0lqODmb9YE2gmQgeIC6IMr/Md6MNp95PW5Lz5Kb2Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvD+znwdWaWahn5yHs4aafrwqktr4axSmXzE+NANa5GECYLj2dg6DURCKhKRc4MGEEC5K4uOD29BbYWgRFYxbuzROaAgmy/BgmOKlAj/6j932grA+yEzXEa8+H5Nm6dDIZVXXCH8aevNrJ09keQ/iA4DCjlJFEyxMqGylWf6bPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGIEOUaL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGIEOUaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CE01F000E9;
	Tue, 21 Jul 2026 17:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655269;
	bh=96ong9l3mFr4J/L1Lh36WsYCAXyIs8hfgYLccFV08wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGIEOUaLdfXEnOSnxx1snc/38XSeBxbjB3ufQtdqnXNUxR+wHE9PRfqLfTl9RP7So
	 JbN+bYIoUSqJeJWJQGwq3cor++4o8YxPM2E5HvaZdCW4UKav472O+NeZnlyzXfIprW
	 rONzSH/rEJAUcxredF3/c1XbQZgV4D3wRYeWGJx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 7.1 2019/2077] reset: sunxi: fix memory region leak on ioremap failure
Date: Tue, 21 Jul 2026 17:28:12 +0200
Message-ID: <20260721152640.322248933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


