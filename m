Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6652590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF7DC433EF;
	Sun, 22 Jan 2023 15:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401094;
	bh=Jj2/P4Bt4IMQcorAyQkVqfbDCKCIIxYIQz+PahnZLGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMzR01X+CzGP/cPYCGPlEzmt5/GFOo3TAHXnfm55Ts5lKtq5y0gHp3myckfYEvy7b
	 p5vzgh634bPUDv49bwYZZvNSoa6bOWppBRONuT/5oDW98HgqDvgAaD4HEYKCgUaJWN
	 hOGUjYKPGe2Zg8JAwa29v5J9mUTs3ZkpbYD98Ae8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 6.1 108/193] usb: musb: fix error return code in omap2430_probe()
Date: Sun, 22 Jan 2023 16:03:57 +0100
Message-Id: <20230122150251.265092308@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

commit bd449ad8cee9d4b523abbdfa73e1a2a08333f331 upstream.

Before calling platform_get_resource() in omap2430_probe(), the 'ret' is
re-assgined to 0, it can't return an error code, if platform_get_resource
fails. Set the error code to -EINVAL to fix this.

Fixes: ffbe2feac59b ("usb: musb: omap2430: Fix probe regression for missing resources")
Cc: stable <stable@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221230081730.1655616-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 476f55d1fec3..44a21ec865fb 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -411,8 +411,10 @@ static int omap2430_probe(struct platform_device *pdev)
 		memset(musb_res, 0, sizeof(*musb_res) * ARRAY_SIZE(musb_res));
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		if (!res)
+		if (!res) {
+			ret = -EINVAL;
 			goto err2;
+		}
 
 		musb_res[i].start = res->start;
 		musb_res[i].end = res->end;
-- 
2.39.1



