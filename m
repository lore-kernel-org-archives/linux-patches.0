Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766ED37325
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB876C433EF;
	Wed,  7 Jun 2023 20:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170958;
	bh=x0Icv/g0xIcvXRY8wx2l/wzuElB+eyDB7Lf2/sfWWEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UF3MNICH1dFHOysW+L8wtd9GsUeJWPMsbYFEYgJ2i9svq9jT8w6Pw1Mug+oqjIqML
	 nP7tR6it0Id4g02OoWyzdccaVurArb16/CkSzuwuU+JKMJf+GtA3V5gS/CnLJPm3jP
	 2u++AhjR6FJhsGrFDhLBYg5/d3ztA9iI5t1+TS9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YongSu Yoo <yongsuyoo0215@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/120] media: dvb_ca_en50221: fix a size write bug
Date: Wed,  7 Jun 2023 22:16:12 +0200
Message-ID: <20230607200902.658505246@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YongSu Yoo <yongsuyoo0215@gmail.com>

[ Upstream commit a4315e5be7020aac9b24a8151caf4bb85224cd0e ]

The function of "dvb_ca_en50221_write_data" at source/drivers/media
/dvb-core/dvb_ca_en50221.c is used for two cases.
The first case is for writing APDU data in the function of
"dvb_ca_en50221_io_write" at source/drivers/media/dvb-core/
dvb_ca_en50221.c.
The second case is for writing the host link buf size on the
Command Register in the function of "dvb_ca_en50221_link_init"
at source/drivers/media/dvb-core/dvb_ca_en50221.c.
In the second case, there exists a bug like following.
In the function of the "dvb_ca_en50221_link_init",
after a TV host calculates the host link buf_size,
the TV host writes the calculated host link buf_size on the
Size Register.
Accroding to the en50221 Spec (the page 60 of
https://dvb.org/wp-content/uploads/2020/02/En50221.V1.pdf),
before this writing operation, the "SW(CMDREG_SW)" flag in the
Command Register should be set. We can see this setting operation
in the function of the "dvb_ca_en50221_link_init" like below.
...
	if ((ret = ca->pub->write_cam_control(ca->pub, slot,
CTRLIF_COMMAND, IRQEN | CMDREG_SW)) != 0)
		return ret;
...
But, after that, the real writing operation is implemented using
the function of the "dvb_ca_en50221_write_data" in the function of
"dvb_ca_en50221_link_init", and the "dvb_ca_en50221_write_data"
includes the function of "ca->pub->write_cam_control",
and the function of the "ca->pub->write_cam_control" in the
function of the "dvb_ca_en50221_wrte_data" does not include
"CMDREG_SW" flag like below.
...
	if ((status = ca->pub->write_cam_control(ca->pub, slot,
CTRLIF_COMMAND, IRQEN | CMDREG_HC)) != 0)
...
In the above source code, we can see only the "IRQEN | CMDREG_HC",
but we cannot see the "CMDREG_SW".
The "CMDREG_SW" flag which was set in the function of the
"dvb_ca_en50221_link_init" was rollbacked by the follwoing function
of the "dvb_ca_en50221_write_data".
This is a bug. and this bug causes that the calculated host link buf_size
is not properly written in the CI module.
Through this patch, we fix this bug.

Link: https://lore.kernel.org/linux-media/20220818125027.1131-1-yongsuyoo0215@gmail.com
Signed-off-by: YongSu Yoo <yongsuyoo0215@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index fd476536d32ed..b1a7b5f8b9aa4 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -187,7 +187,7 @@ static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca);
 static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 				    u8 *ebuf, int ecount);
 static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
-				     u8 *ebuf, int ecount);
+				     u8 *ebuf, int ecount, int size_write_flag);
 
 /**
  * Safely find needle in haystack.
@@ -370,7 +370,7 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_FR, HZ / 10);
 	if (ret)
 		return ret;
-	ret = dvb_ca_en50221_write_data(ca, slot, buf, 2);
+	ret = dvb_ca_en50221_write_data(ca, slot, buf, 2, CMDREG_SW);
 	if (ret != 2)
 		return -EIO;
 	ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN);
@@ -778,11 +778,13 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
  * @buf: The data in this buffer is treated as a complete link-level packet to
  *	 be written.
  * @bytes_write: Size of ebuf.
+ * @size_write_flag: A flag on Command Register which says whether the link size
+ * information will be writen or not.
  *
  * return: Number of bytes written, or < 0 on error.
  */
 static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
-				     u8 *buf, int bytes_write)
+				     u8 *buf, int bytes_write, int size_write_flag)
 {
 	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int status;
@@ -817,7 +819,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot,
 
 	/* OK, set HC bit */
 	status = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND,
-					    IRQEN | CMDREG_HC);
+					    IRQEN | CMDREG_HC | size_write_flag);
 	if (status)
 		goto exit;
 
@@ -1505,7 +1507,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 
 			mutex_lock(&sl->slot_lock);
 			status = dvb_ca_en50221_write_data(ca, slot, fragbuf,
-							   fraglen + 2);
+							   fraglen + 2, 0);
 			mutex_unlock(&sl->slot_lock);
 			if (status == (fraglen + 2)) {
 				written = 1;
-- 
2.39.2



