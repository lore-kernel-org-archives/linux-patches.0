Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C961A619E;
	Tue, 30 Jul 2024 16:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357757; cv=none; b=BpqyA0mcp/kKGpzbp3xbvGpUl087nClwhRkVSQBoUoQjI5F/wXjKnwGSrGQPjRdX0APsDM1L/0VVRcQXFVr/5O3PxVaF64xui8J55aaLSUxM76gJWiJtP7S60+K2QZt8ihfhpyK/LYv/vVMxQJXmlC8iLoVVds5wl78fjtPL8yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357757; c=relaxed/simple;
	bh=cicX+gRhW8ZyJdNlu4vVr1n3KtiKd7Qlj7jTT7Ez334=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMcNHCllJV+V64n7cExlpjCwj5UZv6jLP9rkOixdqfECCgTaGnXNXV3s8D7kQtFXOX3BciHaE8viiaxRcMiMh23bO+jTkJQyU5SwJ3fVnQK0Xig/LgrnDOcnUMbLGDfACYuVMjUccsVK7gORMdSYXR4uzgrQYy8+f9sF23D4qN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbVMCICL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbVMCICL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C9CC32782;
	Tue, 30 Jul 2024 16:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357756;
	bh=cicX+gRhW8ZyJdNlu4vVr1n3KtiKd7Qlj7jTT7Ez334=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbVMCICLTApcKS/YNvFWRx/TT8cXD98N3qJl7BFYmTUBmXBMeCGjCH2cc9ShbMRby
	 bn851Bp7uvg+Xpac2Hm9m6n1j9UNAx/Y5B9eKQgBU8jHerMVBERlLIq50uuZyt+yk9
	 aGAB5nQa9KsB0Reea1NZw95zyCS0bEdlQGrsaY84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 289/809] media: imon: Fix race getting ictx->lock
Date: Tue, 30 Jul 2024 17:42:45 +0200
Message-ID: <20240730151736.006923969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0b55314a80827..8f1361bcce3a6 100644
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



