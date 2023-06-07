Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7440039234
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA93C433EF;
	Wed,  7 Jun 2023 20:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169124;
	bh=IxDhtpyDUegf/FfkyjsBsGiprobcaU9JFRQbV95QVNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6MXvff4+7cOSjxVUbirGimsXcFYVCIlijVJyz/e01GKmn6ruHmhwrICvmQnN529U
	 Rafn6fJ6wgo0YWm0Lu/UpaPgeGB3iGqf+XVAXWWvCm4qcw0DlwpvpNyc9/LpkcMU15
	 3Xx0GhCAzEDiq9gcFRdpghgPd7rUtVfoleT/mBG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/61] media: dvb-usb: dw2102: fix uninit-value in su3000_read_mac_address
Date: Wed,  7 Jun 2023 22:15:37 +0200
Message-ID: <20230607200843.147463249@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit a3fd1ef27aa686d871cefe207bd6168c4b0cd29e ]

In su3000_read_mac_address, if i2c_transfer fails to execute two
messages, array mac address will not be initialized. Without handling
such error, later in function dvb_usb_adapter_dvb_init, proposed_mac
is accessed before initialization.

Fix this error by returning a negative value if message execution fails.

Link: https://lore.kernel.org/linux-media/20230328124416.560889-1-harperchen1110@gmail.com
Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dw2102.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 98770a95721b9..2c9c4432a0e65 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -951,7 +951,7 @@ static int su3000_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
 	for (i = 0; i < 6; i++) {
 		obuf[1] = 0xf0 + i;
 		if (i2c_transfer(&d->i2c_adap, msg, 2) != 2)
-			break;
+			return -1;
 		else
 			mac[i] = ibuf[0];
 	}
-- 
2.39.2



