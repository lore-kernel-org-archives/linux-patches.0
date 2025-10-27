Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5262D7806;
	Mon, 27 Oct 2025 18:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590429; cv=none; b=FkeCUnxC+SW+P24nxnLasanqDtbA0v9EatZY5tSLBDuktmaAQEa+Kv5aI+GVv+8kREzY2aEKnZPlHUGGX2wIM/bjASf7UOM118eNQ4or/2bCqf0E+jCKDL0HtR+uzf/hQmjtxaeQEo7BdmGfzUGwap49Z4j7C1TNCcK8BMKgjr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590429; c=relaxed/simple;
	bh=ySga9qNmeaSd8anFD2lmPeTdeVz+ZKoPCXY88kS9m0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCXxVbWBHbS/HkpbGyBnohHohP+/gxM+oIgDJfy1fYINtgHImeuWIcTcPTXCPTpIX0ptf/rkBKR2djs4FnVK93rux1dn35YCm0FpViWsFlP3wZL/ThNCJB+bRDK1GYvTfJzgzRA67SH3L3pMu7x5MsuCtoIaNEX/ql7zIUWqMT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xo51DxJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xo51DxJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B73BC4CEF1;
	Mon, 27 Oct 2025 18:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590428;
	bh=ySga9qNmeaSd8anFD2lmPeTdeVz+ZKoPCXY88kS9m0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xo51DxJjFzjWREiHITfrrxL/ZKkacEg2PYMYPzgWhPpTRR+akoZAX+Xmpumdq2aLu
	 gJsbIp8mzysba9JcnAnTRJu2SmxM7ooKAle+9nlK4Xuylcx1NFRkJQI1FGq7+W1EQC
	 fV9VWLMVULlc6v1cPKdqCA4eatwf75Bmxc4f00P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/224] media: imon: grab lock earlier in imon_ir_change_protocol()
Date: Mon, 27 Oct 2025 19:32:35 +0100
Message-ID: <20251027183509.234949877@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 7019553ab850ce1d3f0e512e16d14ab153f91c04 ]

Move mutex_trylock() in imon_ir_change_protocol() to the beginning,
for memcpy() which modifies ictx->usb_tx_buf should be protected by
ictx->lock.

Also, verify at the beginning of send_packet() that ictx->lock is held
in case send_packet() is by error called from imon_ir_change_protocol()
when mutex_trylock() failed due to concurrent requests.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: fa0f61cc1d82 ("media: rc: fix races with imon_disconnect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/imon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -598,6 +598,8 @@ static int send_packet(struct imon_conte
 	int retval = 0;
 	struct usb_ctrlrequest *control_req = NULL;
 
+	lockdep_assert_held(&ictx->lock);
+
 	/* Check if we need to use control or interrupt urb */
 	if (!ictx->tx_control) {
 		pipe = usb_sndintpipe(ictx->usbdev_intf0,
@@ -1126,7 +1128,7 @@ static int imon_ir_change_protocol(struc
 	int retval;
 	struct imon_context *ictx = rc->priv;
 	struct device *dev = ictx->dev;
-	bool unlock = false;
+	const bool unlock = mutex_trylock(&ictx->lock);
 	unsigned char ir_proto_packet[] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
 
@@ -1153,8 +1155,6 @@ static int imon_ir_change_protocol(struc
 
 	memcpy(ictx->usb_tx_buf, &ir_proto_packet, sizeof(ir_proto_packet));
 
-	unlock = mutex_trylock(&ictx->lock);
-
 	retval = send_packet(ictx);
 	if (retval)
 		goto out;


