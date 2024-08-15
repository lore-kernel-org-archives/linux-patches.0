Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDFE1A00E7;
	Thu, 15 Aug 2024 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732084; cv=none; b=BOYMWgx7b9XpDx/7aHSI3FYSfheybjk4z8hs24DcTt171jdCBJwoymXxVv+rLK+I+THKnRWptCbQzHtqP5/eknNY8b2sfRpaL5D6YfQK1v/LSE9tPmzPGBNdAC0WV1qeDQFP2DwsJ0pHWVOLUVVl0roUIQRAD3S/Cg+aed9eGJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732084; c=relaxed/simple;
	bh=5MILrqzmaqr/Wo3L2VIX0LVaQZe4kEcCLZ5L0bvG0FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNPNEwjjzOJeYwBZHuwouoKrOAlnvhkkz6RWGGn8xYUL7EGJQaw5x7KWNjFq8DizCukB4klkEnXXrpcvV7qsxp+CVtne5uhEVsdwJnme3AuQ8Uxu/n+zvm5oEqleqEB2XmjSuJhoJlGI6OE8NcDN164UTTM+PTTfkTNwMUfsB4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjAsrkWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjAsrkWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE6AC32786;
	Thu, 15 Aug 2024 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732084;
	bh=5MILrqzmaqr/Wo3L2VIX0LVaQZe4kEcCLZ5L0bvG0FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjAsrkWeSIrxAvZiHg58FRH86Av4xANlnFF9SFwhPhQHel2Ch6GdVAZPyMZL5deqT
	 w6tjJBaMD1dyiBHU/Bel1QWv7ekS1XSDHxUOjmsp6lm2iAXw44U7QQikZiR10d48TF
	 HZ4DnCgkzVV+Gg6ZLecVkD6Vk9qze5U0cv9naO7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/352] media: imon: Fix race getting ictx->lock
Date: Thu, 15 Aug 2024 15:22:15 +0200
Message-ID: <20240815131921.909198306@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 253a1d1a840a0..cd4995e74b977 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1153,10 +1153,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 
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



