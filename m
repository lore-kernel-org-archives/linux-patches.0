Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AAB3922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BA0C433EF;
	Wed,  7 Jun 2023 20:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171581;
	bh=hi5dmpvzZ6hPDaZM340f1LPKK0RprWO/fz+DCnQsZiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBcUbSsvEuyr/Rs0fLRdqxmoKCa01JyCKThAd7e/8RvUUIUXpQf0slgXa8481UpJ2
	 LcEGc3S5a11SWyT7F9uEUWy5ll1LVvqa2wN00UahFVulWslS9VCiwKdNTRe+YVzWIB
	 2Pbu0bO/UxVBHt/8cAD+c43frONxDe2i9y+nClZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/159] media: ttusb-dec: fix memory leak in ttusb_dec_exit_dvb()
Date: Wed,  7 Jun 2023 22:16:15 +0200
Message-ID: <20230607200906.039447683@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 517a281338322ff8293f988771c98aaa7205e457 ]

Since dvb_frontend_detach() is not called in ttusb_dec_exit_dvb(),
which is called when the device is disconnected, dvb_frontend_free()
is not finally called.

This causes a memory leak just by repeatedly plugging and
unplugging the device.

Fix this issue by adding dvb_frontend_detach() to ttusb_dec_exit_dvb().

Link: https://lore.kernel.org/linux-media/20221117045925.14297-5-imv4bel@gmail.com
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 38822cedd93a9..c4474d4c44e28 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -1544,8 +1544,7 @@ static void ttusb_dec_exit_dvb(struct ttusb_dec *dec)
 	dvb_dmx_release(&dec->demux);
 	if (dec->fe) {
 		dvb_unregister_frontend(dec->fe);
-		if (dec->fe->ops.release)
-			dec->fe->ops.release(dec->fe);
+		dvb_frontend_detach(dec->fe);
 	}
 	dvb_unregister_adapter(&dec->adapter);
 }
-- 
2.39.2



