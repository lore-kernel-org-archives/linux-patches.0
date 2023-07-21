Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A42200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5304C433C8;
	Fri, 21 Jul 2023 19:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966236;
	bh=tOFIa/fxNLcAu6h6GuVST2YWjk38g77k1sRQ6RyZxeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHG7FMZ99TJqSz4ZM6Jkbe7/s5hY55w9hxEFhTi4PspJds0bCPqRtxulwnlN5b306
	 9qQRBLJd+j5PP2f/oMn/fkAkbUq+CP0Z+0kOlJIMZSLKDO9VqI/S8x3Cu1QwbPOz85
	 uRNbJks8y1rfA4hEWK8ZAGXm79yI0eJGFV2u+fgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/532] media: usb: Check az6007_read() return value
Date: Fri, 21 Jul 2023 18:02:56 +0200
Message-ID: <20230721160629.109537437@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit fdaca63186f59fc664b346c45b76576624b48e57 ]

If az6007_read() returns error, there is no sence to continue.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 3af2f4f15a61 ("[media] az6007: Change the az6007 read/write routine parameter")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/az6007.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 62ee09f28a0bc..7524c90f5da61 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -202,7 +202,8 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 	unsigned code;
 	enum rc_proto proto;
 
-	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
+	if (az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10) < 0)
+		return -EIO;
 
 	if (st->data[1] == 0x44)
 		return 0;
-- 
2.39.2



