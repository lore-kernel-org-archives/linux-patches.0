Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031872;
	b=ZyS24CZKTlTy3Gs/H451Xjq9oLVclDKfYOolwhbMZA1BuyVX19UKucp3K7pghLHC73Za
	 62N8vo867NZOM/Ygs5aIZ2XLDnutqDB6+rbGEcJevZp5w8tssqOAAABK9aDgjBa72WldV
	 bdallGEiWZCQ7JeGPeeVHARN8mv/Xmn2fLQEizrhodfxgQEHcJB+9UUw4lTDM71mggfwQ
	 7ROp9eQJqrolhPrJ+XvfFoAL9Lc+nMtzeFzxQjb6HtpA/w1kByuaazRph9AjUC6TAG+7M
	 u1DLW5r5ONylJY4JsSSLZUYF97unqBvfryJY0IRyZONmVxbS1X5aZX8Unii6oqnR93A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zy+t0tYctK+NJgT52hEdFk6rwGHgi6jLQaQhBZrAsPU=;
	b=NMYqlGTsaeh6WkG54erD5uG3fuD2pRtwxOlyT1vo5tHZMNL0TwiRjhI+RxJrMFNPRk3I
	 w+gjxeMrIZ6kVO/gBXN4HYelMe3IMAEWOkeajRAwXA/kMKZZdn9CclJJjVRoMm9n4wgpb
	 pCelsFsTBgY6Ohgs98dzFQY4lvyhCB3+6S/az0hFw3d3SLOYWg/ZToy0unuQH6HQzUEEh
	 IAY0Kvzmjlz70lzj1tBWPHlretR/rkBDItiqnVv73wn280y5uw9KkS6i8WT7UaRUHG2yw
	 ndMCEF7GypRFHdlIODPe+jK1Y422ugNAqgjX6qsxv45exz6EjpuuZgsx1EtofzQOgNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ap0Ng9cr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F63606A31C;
	Wed, 18 Nov 2026 19:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ap0Ng9cr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FA81F000C4;
	Wed, 18 Nov 2026 19:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031871;
	bh=zy+t0tYctK+NJgT52hEdFk6rwGHgi6jLQaQhBZrAsPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ap0Ng9crP39kQep1bzn8UAB9LpdumftrTGwK0M9T/LdQX3/1zIszeATDyyKNlKR3B
	 /jZxEoxTRMxVevM09no1Rp2ZXZiurQiQpa5djcqonneTaew9NWRI2zKM9HQQHhAbNY
	 j/8IhmLngWcsLlNOTn7XHDsBRuy0hJyEAznZOydc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atul Akella <atul.akella@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1211/1756] rpmsg: virtio: fix error handling in TX buffer wait
Date: Wed, 18 Nov 2026 15:55:38 +0100
Message-ID: <20261118150058.018839349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d333bafd26340..357f22f70433a 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -535,10 +535,13 @@ static int rpmsg_send_offchannel_raw(struct rpmsg_device *rpdev,
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



