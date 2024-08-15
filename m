Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEF81714A8;
	Thu, 15 Aug 2024 13:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729403; cv=none; b=U3eg+ejU/q2ggZRIPB1kzKyqekz7EEWfAfnr/FW278YqaWZ6mYZHnqndC4qqAmh6R3WNHYkBuJ9CkeCWCfAKwW0f23Yjvy3tD8bjotSTe/l5oKxMOzAPw1EqjWz/953RYg1+Tvr1PXR5VmlIg1F28ehISJnOnOke9BA8VjpsjR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729403; c=relaxed/simple;
	bh=zrT4qumGE1RCQPK8mb1E14HfdjP03BwBoYOpeNkvt5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsSc3ZjZkV7odIzkhJzZIwJhqNnxSsyHCj82OvCJINoWd0MWv8+caHlAuWk7jvCpkNLQeCIyHiklqWDb9AX6vWlhp0DFEUf2OyUUOnobJQcv0ZNXECG7H4pi0nAvU4Fne4MC63CXpw8JJCRTgMbQENRsmdAkdfaqqQsgkzYgSi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLt9RRX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLt9RRX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50660C32786;
	Thu, 15 Aug 2024 13:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729402;
	bh=zrT4qumGE1RCQPK8mb1E14HfdjP03BwBoYOpeNkvt5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLt9RRX3tzYjP9CStkRjrWpu7bPaaSCVqXQnHtJzyTy29iXBAD94/K0iONExp7C5o
	 lva8Eab8TJWL9B53ECNxsV689NewQysOIanKyXLUHLBDfWJVeZjzcgg64hPyFpK0XA
	 j1eLMu1+2lmYviNRytTm+je8JzwoacfWvYzSyeQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/484] media: imon: Fix race getting ictx->lock
Date: Thu, 15 Aug 2024 15:19:04 +0200
Message-ID: <20240815131944.608443671@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4e7c3d889d5ce..9faf8365afa71 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1150,10 +1150,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 
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



