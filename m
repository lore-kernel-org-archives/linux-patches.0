Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FEC6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7A4C433F1;
	Mon, 16 Jan 2023 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888974;
	bh=g2OdSkJ7CtElp7CkAJWGPqxBw7YHK7JjH7rFr2hKfo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSPfgLKly5RHT7j2+DDSWNJtA80kSOvbH+jPWgvnsNQgJ5A7D8YFPEmuBZmIk8ThC
	 7XTGrUHhLiLWiQzVjKxUbS1yZMm47VcR68Km9/htd/rOi/IceLJuXfPl6EDssrZS19
	 U4MFloKPkQUKfLx0MhySkCkvtNVd11WeDGHRHYao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 180/338] usb: storage: Add check for kcalloc
Date: Mon, 16 Jan 2023 16:50:53 +0100
Message-Id: <20230116154828.756350088@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit c35ca10f53c51eeb610d3f8fbc6dd6d511b58a58 ]

As kcalloc may return NULL pointer, the return value should
be checked and return error if fails as same as the ones in
alauda_read_map.

Fixes: e80b0fade09e ("[PATCH] USB Storage: add alauda support")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20221208110058.12983-1-jiasheng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/alauda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 878b4b8761f5..3dbd60540372 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -450,6 +450,8 @@ static int alauda_init_media(struct us_data *us)
 		+ MEDIA_INFO(us).blockshift + MEDIA_INFO(us).pageshift);
 	MEDIA_INFO(us).pba_to_lba = kcalloc(num_zones, sizeof(u16*), GFP_NOIO);
 	MEDIA_INFO(us).lba_to_pba = kcalloc(num_zones, sizeof(u16*), GFP_NOIO);
+	if (MEDIA_INFO(us).pba_to_lba == NULL || MEDIA_INFO(us).lba_to_pba == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 
 	if (alauda_reset_media(us) != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
-- 
2.35.1



