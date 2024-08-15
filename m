Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8934D1AC432;
	Thu, 15 Aug 2024 14:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731195; cv=none; b=o/K5MRd7mFDVZMvCzQqJaB736TBRDoZJ1O1bFZFMmQorcgDM3ag00sA6NNl2p1Tl5SB3Y63gnxCUQFdPZ5ieg0zPvZAKvPiPLpbzarH70zll9lilA5dwKjNHAPKEYsLlq7LEot3TXFEG8sMn0OUZ3Vjx/BF4v0zND35tJm7p3GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731195; c=relaxed/simple;
	bh=v68AnRE94YeJ5QQiZB2f5EfcEV95UKgFHVTnlHRKdLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4talEhGLbdAEe407Zw+83Zz6AasXqRFE8FEQ9P9RTvue+QHCkX2hm9VRnpAtf7qZMVb/ajaN9/oRu7nSd9evYXpsEoCA4LSXBdIubldWBsdUQdMhxQX5PxaCVaS8oOw9OOjhdSecb4+DTj52UQTUYa1KanLORWCP7zWUsht3q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kF62PDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kF62PDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81F1C32786;
	Thu, 15 Aug 2024 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731195;
	bh=v68AnRE94YeJ5QQiZB2f5EfcEV95UKgFHVTnlHRKdLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kF62PDuSIQ8PcecNGsQ7bJzFzc+lyvh5hnqnu3kF5Dqz94EzmZ+TErQlDLQO7qj2
	 6tWfYjiMbVlGSfPOv50dlteeosyuemC0N8FdcFnsT5h7QVz1iG4RUemhsg7nXrQHZ5
	 SEx6i+h8IV3f8ELfWvRrrgyHY0EveoI2WUkKzbCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/259] media: imon: Fix race getting ictx->lock
Date: Thu, 15 Aug 2024 15:23:05 +0200
Message-ID: <20240815131904.817130323@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d8401ef9b0a79..38f6dd12d8706 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1117,10 +1117,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 
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



