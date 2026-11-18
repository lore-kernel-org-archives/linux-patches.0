Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039679;
	b=ffV0XOGWJow1Nez6Hv3D1QOWWU4om4FW2Dodsq7pIWjIi/SjcnGkxEM7C9Hu1xL1J28/
	 s9QpHLEmOOgY6nt0Y+Ubkeik9zbH730/oAaYRv6dKqxpYfDC9GuFt6RDCXozHalRNbKw7
	 0uXA7ZVbSUatkXP+jhNPY4nHET+PSPwzbiq6Mw4rI+3ApONRI6xNDKFi+BgYb9oKh/hY/
	 3HeczrVpr8nI/O5pQPdE3NHWinb+P8B0M6/tlT9XmZ/iT2ltg+bzlrDIiZbWt0OHPf7tL
	 B7cKPbSrMRdkWb5IlO+7ZhF2oAoMYy9INQ58ntScvYNCHdUCHb25xpzb5g5jBS/w/CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rKex5XJOhMRtU+5JHVMJgvpJR+3of2q+GpiVdW+ajhE=;
	b=bQ+lnCQMdQAonjval4X2U4vyGiBi93RkethloUS5hdSDmZkbCzc7hKtqlQZePOWo8w+Y
	 jrIOv7hCSzOz5YIVaveGeLB68tXUATFyn6taX1AuaDtDQheLjzTh0BS34SxWxN0JmSHls
	 l0BR0bgQN7fMsJ7jzdif/EQHpxuurHa96RoUsnuj7iPdCps26V3+uyLkvuKYD/quz8Rod
	 rU+us+m0sXLHmI0sjf/01Cjhnn2MfPPGTvtUmVfsuDhy9dPWOl+0lIsZXyqVYptRN8zDW
	 xQM6pV7+V8on2duj+540Ctl4J+WwdUVlxT/Rxl2JA/cerb+IN5Xl64hUMpfpGh41JfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YIHFSEX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690D5606A335;
	Wed, 18 Nov 2026 22:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YIHFSEX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA881F000C7;
	Wed, 18 Nov 2026 22:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039679;
	bh=rKex5XJOhMRtU+5JHVMJgvpJR+3of2q+GpiVdW+ajhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YIHFSEX6eEt2ZqMcyoM0sgFbX6sY8eg6GsE7imhN/NDdgX0jZSR2E7H8WV74CrNT/
	 6E6Ddiz9K7P+tnDigEc0koYzYb1tpB8xH9SdmVEp2GxveTDouE53dvFkSp71LmtMjP
	 js0jKvqU3z4Kok1i4zhSjPoY62rCkzZqpY0+nVYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arka@arkamondal.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2145/3318] usb-storage: alauda: do not do DMA from the stack
Date: Wed, 18 Nov 2026 15:46:07 +0100
Message-ID: <20261118150426.397095581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arka@arkamondal.net>

[ Upstream commit ec67dacb75ebd11fbe6d727e6f37c0ef5e3d3431 ]

alauda_check_status2(), alauda_get_redu_data(), alauda_erase_block(),
alauda_read_block_raw() and alauda_write_block() build their commands in
stack arrays and pass them to usb_stor_bulk_transfer_buf().
alauda_check_status2() and alauda_erase_block() also read the reply back
into a stack array.

usb_stor_msg_common() sets URB_NO_TRANSFER_DMA_MAP only when the buffer
is us->iobuf. Every other buffer reaches usb_hcd_map_urb_for_dma(),
which has warned and returned -EAGAIN for a buffer on the stack since
commit 4568136620c6 ("usb: core: Check URB setup_packet and
transfer_buffer sanity"). On a host controller that uses DMA, all of
these commands fail.

Use us->iobuf, as alauda_reset_media() in this driver and the other
usb-storage subdrivers already do. The command is sent before the reply
is read, so both can use it; sddr09_read_status() does the same.

Fixes: e80b0fade09e ("[PATCH] USB Storage: add alauda support")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217862
Signed-off-by: Arka Mondal <arka@arkamondal.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260901065831.43567-2-arka@arkamondal.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/alauda.c | 70 ++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 40d34cc28344a..46039016ab82c 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -500,11 +500,14 @@ static int alauda_check_media(struct us_data *us)
 static int alauda_check_status2(struct us_data *us)
 {
 	int rc;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_GET_STATUS2,
-		0, 0, 0, 0, 3, 0, MEDIA_PORT(us)
-	};
-	unsigned char data[3];
+	unsigned char *command = us->iobuf;
+	unsigned char *data = us->iobuf;
+
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_GET_STATUS2;
+	command[6] = 3;
+	command[8] = MEDIA_PORT(us);
 
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
@@ -530,10 +533,15 @@ static int alauda_check_status2(struct us_data *us)
 static int alauda_get_redu_data(struct us_data *us, u16 pba, unsigned char *data)
 {
 	int rc;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_GET_REDU_DATA,
-		PBA_HI(pba), PBA_ZONE(pba), 0, PBA_LO(pba), 0, 0, MEDIA_PORT(us)
-	};
+	unsigned char *command = us->iobuf;
+
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_GET_REDU_DATA;
+	command[2] = PBA_HI(pba);
+	command[3] = PBA_ZONE(pba);
+	command[5] = PBA_LO(pba);
+	command[8] = MEDIA_PORT(us);
 
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
@@ -702,14 +710,20 @@ static void alauda_ensure_map_for_zone(struct us_data *us, unsigned int zone)
 static int alauda_erase_block(struct us_data *us, u16 pba)
 {
 	int rc;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_ERASE_BLOCK, PBA_HI(pba),
-		PBA_ZONE(pba), 0, PBA_LO(pba), 0x02, 0, MEDIA_PORT(us)
-	};
-	unsigned char buf[2];
+	unsigned char *command = us->iobuf;
+	unsigned char *buf = us->iobuf;
 
 	usb_stor_dbg(us, "Erasing PBA %d\n", pba);
 
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_ERASE_BLOCK;
+	command[2] = PBA_HI(pba);
+	command[3] = PBA_ZONE(pba);
+	command[5] = PBA_LO(pba);
+	command[6] = 0x02;
+	command[8] = MEDIA_PORT(us);
+
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
 	if (rc != USB_STOR_XFER_GOOD)
@@ -732,13 +746,19 @@ static int alauda_read_block_raw(struct us_data *us, u16 pba,
 		unsigned int page, unsigned int pages, unsigned char *data)
 {
 	int rc;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_READ_BLOCK, PBA_HI(pba),
-		PBA_ZONE(pba), 0, PBA_LO(pba) + page, pages, 0, MEDIA_PORT(us)
-	};
+	unsigned char *command = us->iobuf;
 
 	usb_stor_dbg(us, "pba %d page %d count %d\n", pba, page, pages);
 
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_READ_BLOCK;
+	command[2] = PBA_HI(pba);
+	command[3] = PBA_ZONE(pba);
+	command[5] = PBA_LO(pba) + page;
+	command[6] = pages;
+	command[8] = MEDIA_PORT(us);
+
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
 	if (rc != USB_STOR_XFER_GOOD)
@@ -783,13 +803,19 @@ static int alauda_write_block(struct us_data *us, u16 pba, unsigned char *data)
 {
 	int rc;
 	struct alauda_info *info = (struct alauda_info *) us->extra;
-	unsigned char command[] = {
-		ALAUDA_BULK_CMD, ALAUDA_BULK_WRITE_BLOCK, PBA_HI(pba),
-		PBA_ZONE(pba), 0, PBA_LO(pba), 32, 0, MEDIA_PORT(us)
-	};
+	unsigned char *command = us->iobuf;
 
 	usb_stor_dbg(us, "pba %d\n", pba);
 
+	memset(command, 0, 9);
+	command[0] = ALAUDA_BULK_CMD;
+	command[1] = ALAUDA_BULK_WRITE_BLOCK;
+	command[2] = PBA_HI(pba);
+	command[3] = PBA_ZONE(pba);
+	command[5] = PBA_LO(pba);
+	command[6] = 32;
+	command[8] = MEDIA_PORT(us);
+
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
 	if (rc != USB_STOR_XFER_GOOD)
-- 
2.53.0



