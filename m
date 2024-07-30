Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886E318E04D;
	Tue, 30 Jul 2024 16:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356107; cv=none; b=TgL2tn1fBIdTwMwBHbEbLO7MHr+ot08wAOP10atkYNg27fp6PdjyIo9AFbcrsY5gjtkDkBX9CeF+3PFxBfNwD99txSftDiCAb08PjGGBRel7BgN5RbTro2BkzhKscXBiAkB8D7AdGCsOE+hdpxK9mWk3babxY4natjgmL8lxA0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356107; c=relaxed/simple;
	bh=NGQQkWLQgaDqVs3tMK062Ekk7/PFaZo6oN32C5n279s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=to0UTtND+cr9LvKHSdLYTwAFLecScsGv8sTz4Kyj5PqPuFw3VNL6HhOJ/Np9K7kc/8W8guNGNaZ6hjG0efdnZvViKED3FNbwqM5WAUpFRN/4g0mocJXxvuwqc2Ry6w6ebR/FFyW71tfKWqhjJBhpb0uMrjbbj0IFEt+eLkRXWX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otK7y7uE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otK7y7uE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0BBC4AF0C;
	Tue, 30 Jul 2024 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356107;
	bh=NGQQkWLQgaDqVs3tMK062Ekk7/PFaZo6oN32C5n279s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otK7y7uEfeGdnmugTpOJrijF7dXnF5bhHdDHuQfM+ul7UVb2iXR1d41lke0X75jTe
	 8dM5usTdOn2auaqGlj1317fHU6YG3EAw5Rljv6ppu8jEsqIAL85kSsFPT153xP6GpK
	 7hFpDiQoJQMtsmeGQ7DdqqznajQYkHdoT1A1fXkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/440] media: imon: Fix race getting ictx->lock
Date: Tue, 30 Jul 2024 17:46:11 +0200
Message-ID: <20240730151621.272861149@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 24147897507cd3a7d63745d1518a638bf4132238 ]

Lets fix a race between mutex_is_lock() and mutex_lock().

<-mutex is not locked
if (!mutex_is_locked(&ictx->lock)) {
	unlock = true; <- mutex is locked externaly
	mutex_lock(&ictx->lock);
}

Let's use mutex_trylock() that does mutex_is_lock() and mutex_lock()
atomically.

Fix the following cocci warning:
drivers/media/rc/imon.c:1167:1-7: preceding lock on line 1153

Fixes: 23ef710e1a6c ("[media] imon: add conditional locking in change_protocol")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/imon.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 5719dda6e0f0e..e5590a708f1c5 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1148,10 +1148,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 
 	memcpy(ictx->usb_tx_buf, &ir_proto_packet, sizeof(ir_proto_packet));
 
-	if (!mutex_is_locked(&ictx->lock)) {
-		unlock = true;
-		mutex_lock(&ictx->lock);
-	}
+	unlock = mutex_trylock(&ictx->lock);
 
 	retval = send_packet(ictx);
 	if (retval)
-- 
2.43.0



