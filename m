Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF1B1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CD4C433D2;
	Wed, 28 Dec 2022 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242914;
	bh=nSangEpkODi3Yx9RWnu5jrOUO/BKt9zYkLzqko56W7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srDWttq0GBFVip6esFDArG9GQ4onNC79idxwgpZZ96TkWtzsY1WOcamuLx+dkvi3a
	 uGDKc65JlErWmsVTmX7q5QYD8dJSeZch01nJVH/bb+G3imlHRp6fVPzFZibI1u14VV
	 E0aia7nrjui5QNeHUjYPA2vcVAW/bIWXZfw/gPso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0430/1146] wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()
Date: Wed, 28 Dec 2022 15:32:49 +0100
Message-Id: <20221228144341.862512545@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 895b3b06efc285c1245242e9638b9ae251dc13ec ]

urbs does not be freed in exception paths in __lf_x_usb_enable_rx().
That will trigger memory leak. To fix it, add kfree() for urbs within
"error" label. Compile tested only.

Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221119051900.1192401-1-william.xuanziyang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 39e54b3787d6..76d0a778636a 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -247,6 +247,7 @@ static int __lf_x_usb_enable_rx(struct plfxlc_usb *usb)
 		for (i = 0; i < RX_URBS_COUNT; i++)
 			free_rx_urb(urbs[i]);
 	}
+	kfree(urbs);
 	return r;
 }
 
-- 
2.35.1



