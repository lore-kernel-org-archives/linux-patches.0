Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA622D978B;
	Tue, 10 Mar 2026 11:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141105; cv=none; b=jgcTvjZkSgbYAz3n0Npex7mrPVwdevaBHihKBqxiDVnTZC+8sRxbe/mZ0oIyNiWAvaaWwZisQn+8Tps/kHly6gWDiGXDQeiDBse2mhr33stvh6TWvycUN6Z7uam4R/0n5U4oCyj6FiCH+HQ19AdXbn65wFO/kSmOKJIBEuZWkXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141105; c=relaxed/simple;
	bh=loa4KGtsbbdAggZqj8t69i7gUUINTpkviaDfq0KkdNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyrpiazF36M7b4IqXENAqoD6Ao15Q3/UocM3nVTmqdXzHa6kg2ZJcI1awJbZ0AhVIaJ5Mqdh/7pBUob8mk+Q02TKeKPh1lk3tlA6q6ciIxxOpoEQIP5HREILeJIrpO00WjzJqAAZGSxGvxr8bWODzkFMXYNwfvHfBekXkBFepI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UEfY0H47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UEfY0H47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BE2C2BC86;
	Tue, 10 Mar 2026 11:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141105;
	bh=loa4KGtsbbdAggZqj8t69i7gUUINTpkviaDfq0KkdNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEfY0H47L20Ubcko0CAJVZgNNPwfuwDAB56y0t/cEjUzRJMYu5piw62HIuQOlRlv1
	 WyO74SIFAFfNKelVwivSpNOFYlX75F4MrcAPaLv2qlJVP3vaBvRGhnvWhiItgBz3S7
	 V3stvz4LjHId6bZnLIaFMKWyrGxekQpTskPgDLmOW/wgwLsEFCelOIE9H4i0mbpsNj
	 Ret1o+vwiZRiHFk9EJE4Qq1Ha/OCIbwJKbEe3n6O5j6t/j9eINDwoXibGfmUc7wMvr
	 xrGK1LCvrl5yK8SwIonB5A5Ca7+st1rlwxDQTkyzhwsY0/6IIx0aR3aVaXPSP0JI4p
	 icUD8X43cdfoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	stable@kernel.org
Subject: [PATCH 6.19 107/311] can: ems_usb: ems_usb_read_bulk_callback(): check the proper length of a message
Date: Tue, 10 Mar 2026 07:02:34 -0400
Message-ID: <3217b4ef2caf6fcf267a08cb018bb141f36fa228.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 38a01c9700b0dcafe97dfa9dc7531bf4a245deff upstream.

When looking at the data in a USB urb, the actual_length is the size of
the buffer passed to the driver, not the transfer_buffer_length which is
set by the driver as the max size of the buffer.

When parsing the messages in ems_usb_read_bulk_callback() properly check
the size both at the beginning of parsing the message to make sure it is
big enough for the expected structure, and at the end of the message to
make sure we don't overflow past the end of the buffer for the next
message.

Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022316-answering-strainer-a5db@gregkh
Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ems_usb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 4c219a5b139bb..9b25dda7c1838 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -445,6 +445,11 @@ static void ems_usb_read_bulk_callback(struct urb *urb)
 		start = CPC_HEADER_SIZE;
 
 		while (msg_count) {
+			if (start + CPC_MSG_HEADER_LEN > urb->actual_length) {
+				netdev_err(netdev, "format error\n");
+				break;
+			}
+
 			msg = (struct ems_cpc_msg *)&ibuf[start];
 
 			switch (msg->type) {
@@ -474,7 +479,7 @@ static void ems_usb_read_bulk_callback(struct urb *urb)
 			start += CPC_MSG_HEADER_LEN + msg->length;
 			msg_count--;
 
-			if (start > urb->transfer_buffer_length) {
+			if (start > urb->actual_length) {
 				netdev_err(netdev, "format error\n");
 				break;
 			}
-- 
2.51.0

