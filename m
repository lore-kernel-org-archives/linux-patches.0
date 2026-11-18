Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020193;
	b=F17EAlu99PaXhNn3FwGWJbLbt8bkJxdnHcmMfsethSLnSvOVCi6t6QSVvexRGPvK29a7
	 3oda7oVRAvnIt+Zj0nO8gI9gAkj3STVreE7ruuZ6PGKwgwF3rSTGjjtoayxa63i6RBE5D
	 gcr5fy3266k+5HBugvCw/XcVOJ9hUNldb1sgiS13829wq+olSE2Ze0cgw9sHiDY34P3ps
	 PYzX5unt2OC3qYmI20iRbrzprkIACTW30LLuFJVjGGyUmaa3bfV14HJ9WD0H5mFLufxED
	 xco9LAUcs3MFI6cHjK5smPN5h30nLk3DRfP90CQlTcSgCK29jlp2Sa5et/L9555ZtEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4TSXPoqivxjhMiYkxTAvUe4WYAbUjAmGfm7iXtulWQQ=;
	b=OsO9SJxdfGC1nEE0lehLkndhUWkPAJd/1FNhiAcjBXpRe9bwRoOg+69vawuz0+0llTN6
	 WdFsLTfVVRg/XXEmrl6uJOguhK04r0vW3cMAGc6BjpRRSZzaBGXEUPckEkyotVQmWIipR
	 O4hshw5PjxrPW3JyHZ6BEpa/j914BcT/M7n9NLH6EIRxK+bBNFEuarTQTUVrvtAXtUhxY
	 8y4aNuw3NCIZks0bxkboGXkJLdTnPyOSVCuIjMAehiIzJurGYFQJIVHLGDmVAZhOlxz90
	 0nSY4tXaq35Nnj5PzsOunSnTEHtbaO2/NziW9zHRnVXV68SmDbHTJvvX3R3qub4m2kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DCev/80V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D89C606A320;
	Wed, 18 Nov 2026 16:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCev/80V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DAE1F000C4;
	Wed, 18 Nov 2026 16:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020193;
	bh=4TSXPoqivxjhMiYkxTAvUe4WYAbUjAmGfm7iXtulWQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCev/80Vh8P8P3d2h0BOWkTzhICIXr0GyyD2MBlhvAdex9Mr44VwYeVCZha4YnRsS
	 ewv7tjy7zhPebtHwvYrHVhZMxsmZVbQKg6hISxDClKBBzb0TJmCz5TpnsaQ59fE9Zq
	 iycp0510huNQ8YGLcf1nCsvoajWsT7ryho4FyOUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atul Akella <atul.akella@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1863/2651] rpmsg: virtio: fix error handling in TX buffer wait
Date: Wed, 18 Nov 2026 15:51:43 +0100
Message-ID: <20261118150354.056000086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atul Akella <atul.akella@gmail.com>

[ Upstream commit 7dd4cffdf4c2a496ccf783303a03d687a2127baf ]

The TX buffer wait loop in rpmsg_send_offchannel_raw() ignores the
possibility of wait_event_interruptible_timeout() returning a
negative value, which happens when the wait is interrupted by a
signal. In that case the loop spins back around and re-arms the
wait instead of propagating the signal, which can stall a task
that is trying to be killed.

Separately, on a genuine timeout (return value 0) the function
returns -ERESTARTSYS, which is reserved for signal-interrupted
syscalls that the kernel may restart. A timeout is not a signal
and should not be treated as restartable; return -ETIMEDOUT
instead.

Handle both cases explicitly: return err directly when negative,
and return -ETIMEDOUT on timeout.

Fixes: bcabbccabffe ("rpmsg: add virtio-based remote processor messaging bus")
Signed-off-by: Atul Akella <atul.akella@gmail.com>
Link: https://lore.kernel.org/r/20261013160055.1362-1-atul.akella@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 1b8bb05924af7..a32772d6ccbc1 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -536,10 +536,13 @@ static int rpmsg_send_offchannel_raw(struct rpmsg_device *rpdev,
 					(msg = get_a_tx_buf(vrp)),
 					msecs_to_jiffies(15000));
 
+		if (err < 0)
+			return err;
+
 		/* timeout ? */
 		if (!err) {
 			dev_err(dev, "timeout waiting for a tx buffer\n");
-			return -ERESTARTSYS;
+			return -ETIMEDOUT;
 		}
 	}
 
-- 
2.53.0



